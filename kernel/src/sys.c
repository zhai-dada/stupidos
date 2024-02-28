#include <errno.h>
#include <printk.h>
#include <stdint.h>
#include <vfs/vfs.h>
#include <disk/disk.h>
#include <lib.h>
#include <task.h>
#include <stackregs.h>
#include <vfs/fat32.h>
#include <sched.h>
#include <fcntl.h>
#include <stdio.h>
#include <keyboard.h>

uint64_t no_system_call(void)
{
    color_printk(YELLOW, BLACK, "no_system_call!\n");

    return -1;
}
uint64_t sys_printf(int8_t *string)
{
    color_printk(GREEN, BLACK, string);
    return 1;
}
int64_t sys_open(int8_t *filename, int32_t flags)
{
    int8_t *path = NULL;
    int64_t pathlen = 0;
    int64_t error = 0;
    struct dir_entry *dentry = NULL;
    struct file *filp = NULL;
    struct file **f = NULL;
    int32_t fd = -1;
    int32_t i = 0;

    color_printk(GREEN, BLACK, "sys_open\n");
    path = (int8_t *)kmalloc(PAGE_4K_SIZE, 0);
    if (path == NULL)
    {
        return -ENOMEM;
    }
    memset(path, 0, PAGE_4K_SIZE);
    pathlen = strnlen_user(filename, PAGE_4K_SIZE);
    if (pathlen <= 0)
    {
        kfree(path);
        return -EFAULT;
    }
    else if (pathlen >= PAGE_4K_SIZE)
    {
        kfree(path);
        return -ENAMETOOLONG;
    }
    strncpy_from_user(filename, path, pathlen);

    dentry = path_walk(path, 0);
    kfree(path);

    if (dentry != NULL)
    {
        color_printk(BLUE, WHITE, "Find\nDIR_FirstCluster:%#018lx\tDIR_FileSize:%#018lx\n", ((struct fat32_inode_info *)(dentry->dir_inode->private_index_info))->first_cluster, dentry->dir_inode->file_size);
    }
    else
    {
        color_printk(BLUE, WHITE, "Can`t find file\n");
    }
    if (dentry == NULL)
    {
        return -ENOENT;
    }
    if (dentry->dir_inode->attribute == FS_ATTR_DIR)
    {
        return -EISDIR;
    }
    filp = (struct file *)kmalloc(sizeof(struct file), 0);
    memset(filp, 0, sizeof(struct file));
    filp->dentry = dentry;
    filp->mode = flags;
    filp->f_ops = dentry->dir_inode->f_ops;
    if (filp->f_ops && filp->f_ops->open)
    {
        error = filp->f_ops->open(dentry->dir_inode, filp);
    }
    if (error != 1)
    {
        kfree(filp);
        return -EFAULT;
    }

    if (filp->mode & O_TRUNC)
    {
        filp->dentry->dir_inode->file_size = 0;
    }
    if (filp->mode & O_APPEND)
    {
        filp->position = filp->dentry->dir_inode->file_size;
    }

    f = current->filestruct;
    for (i = 0; i < TASK_FILE_MAX; i++)
    {
        if (f[i] == NULL)
        {
            fd = i;
            break;
        }
    }
    if (i == TASK_FILE_MAX)
    {
        kfree(filp);
        return -EMFILE;
    }
    f[fd] = filp;
    return fd;
}

uint64_t sys_close(int32_t fd)
{
    struct file *filp = NULL;
    color_printk(GREEN, BLACK, "sys_close:%d\n", fd);
    if (fd < 0 || fd >= TASK_FILE_MAX)
    {
        return -EBADF;
    }
    filp = current->filestruct[fd];
    if (filp->f_ops && filp->f_ops->close)
    {
        filp->f_ops->close(filp->dentry->dir_inode, filp);
    }
    kfree(filp);
    current->filestruct[fd] = NULL;
    return 0;
}
uint64_t sys_read(int32_t fd, void *buf, int64_t count)
{
    struct file *filp = NULL;
    uint64_t ret = 0;
    if (fd < 0 || fd >= TASK_FILE_MAX)
    {
        return -EBADF;
    }
    if (count < 0)
    {
        return -EINVAL;
    }
    filp = current->filestruct[fd];
    if (filp->f_ops && filp->f_ops->read)
    {
        ret = filp->f_ops->read(filp, buf, count, &filp->position);
    }
    return ret;
}

uint64_t sys_write(int32_t fd, void *buf, int64_t count)
{
    struct file *filp = NULL;
    uint64_t ret = 0;
    if (fd < 0 || fd >= TASK_FILE_MAX)
    {
        return -EBADF;
    }
    if (count < 0)
    {
        return -EINVAL;
    }
    filp = current->filestruct[fd];
    if (filp->f_ops && filp->f_ops->write)
    {
        ret = filp->f_ops->write(filp, buf, count, &filp->position);
    }
    return ret;
}

uint64_t sys_lseek(int32_t fd, int64_t offset, int32_t whence)
{
    struct file *filp = NULL;
    uint64_t ret = 0;

    if (fd < 0 || fd >= TASK_FILE_MAX)
    {
        return -EBADF;
    }
    if (whence < 0 || whence >= SEEK_MAX)
    {
        return -EINVAL;
    }
    filp = current->filestruct[fd];
    if (filp->f_ops && filp->f_ops->lseek)
    {
        ret = filp->f_ops->lseek(filp, offset, whence);
    }
    return ret;
}

uint64_t sys_fork()
{
    struct stackregs *regs = (struct stackregs *)current->thread->rsp0 - 1;
    return do_fork(regs, 0, regs->rsp, 0);
}

uint64_t sys_vfork()
{
    struct stackregs *regs = (struct stackregs *)(current->thread->rsp0) - 1;
    return do_fork(regs, CLONE_VM | CLONE_FS | CLONE_SIGNAL, regs->rsp, 0);
}
uint64_t sys_brk(uint64_t brk)
{
    uint64_t new_brk = PAGE_2M_ALIGN(brk);
    if(new_brk == 0)
    {
        return current->mm->start_brk;
    }
    if(new_brk < current->mm->start_brk)
    {
        return 0; //free
    }
    new_brk = do_brk(current->mm->end_brk, new_brk - current->mm->end_brk);
    current->mm->end_brk = new_brk;
    return new_brk;
}
int64_t sys_device_openkeyboard(int8_t *filename, int32_t flags)
{
    int8_t *path = NULL;
    int64_t pathlen = 0;
    int64_t error = 0;
    struct dir_entry *dentry = NULL;
    struct file *filp = NULL;
    struct file **f = NULL;
    int32_t fd = -1;
    int32_t i = 0;

    path = (int8_t *)kmalloc(PAGE_4K_SIZE, 0);
    if (path == NULL)
    {
        return -ENOMEM;
    }
    memset(path, 0, PAGE_4K_SIZE);
    pathlen = strnlen_user(filename, PAGE_4K_SIZE);
    if (pathlen <= 0)
    {
        kfree(path);
        return -EFAULT;
    }
    else if (pathlen >= PAGE_4K_SIZE)
    {
        kfree(path);
        return -ENAMETOOLONG;
    }
    strncpy_from_user(filename, path, pathlen);

    dentry = path_walk(path, 0);
    kfree(path);

    if (dentry != NULL)
    {
        color_printk(GREEN, BLACK, "find\tfirstcluster:%#018lx\tfilesize:%#018lx\n", ((struct fat32_inode_info *)(dentry->dir_inode->private_index_info))->first_cluster, dentry->dir_inode->file_size);
    }
    else
    {
        color_printk(BLUE, WHITE, "Can`t find file\n");
    }
    if (dentry == NULL)
    {
        return -ENOENT;
    }
    if (dentry->dir_inode->attribute == FS_ATTR_DIR)
    {
        return -EISDIR;
    }
    filp = (struct file *)kmalloc(sizeof(struct file), 0);
    memset(filp, 0, sizeof(struct file));
    filp->dentry = dentry;
    filp->mode = flags;
    {
        filp->f_ops = &keyboard_fops;
    }
    if (filp->f_ops && filp->f_ops->open)
    {
        error = filp->f_ops->open(dentry->dir_inode, filp);
    }
    if (error != 1)
    {
        kfree(filp);
        return -EFAULT;
    }

    if (filp->mode & O_TRUNC)
    {
        filp->dentry->dir_inode->file_size = 0;
    }
    if (filp->mode & O_APPEND)
    {
        filp->position = filp->dentry->dir_inode->file_size;
    }

    f = current->filestruct;
    for (i = 0; i < TASK_FILE_MAX; i++)
    {
        if (f[i] == NULL)
        {
            fd = i;
            break;
        }
    }
    if (i == TASK_FILE_MAX)
    {
        kfree(filp);
        return -EMFILE;
    }
    f[fd] = filp;
    return fd;
}
