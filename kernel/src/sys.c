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
#include <task.h>
#include <serial.h>
#include <debug.h>
#include <sys.h>

u64 no_system_call(void)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "no_system_call!\n");
    return -1;
}
u64 sys_printf(s8 *string)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN, SERIAL_ATTR_BACK_BLACK, string);
    color_printk(GREEN, BLACK, string);
    return 1;
}
s64 sys_open(s8 *filename, s32 flags)
{
    s8 *path = NULL;
    s64 pathlen = 0;
    s64 error = 0;
    struct dir_entry *dentry = NULL;
    struct file *filp = NULL;
    struct file **f = NULL;
    s32 fd = -1;
    s32 i = 0;

    DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN, SERIAL_ATTR_BACK_BLACK, "sys_open\n");
    path = (s8 *)kmalloc(PAGE_4K_SIZE, 0);
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
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Find\nDIR_FirstCluster:%#018lx\tDIR_FileSize:%#018lx\n", ((struct fat32_inode_info *)(dentry->dir_inode->private_index_info))->first_cluster, dentry->dir_inode->file_size);
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Can`t find file\n");
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

u64 sys_close(s32 fd)
{
    struct file *filp = NULL;
    DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN, SERIAL_ATTR_BACK_BLACK, "sys_close:%d\n", fd);
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
u64 sys_read(s32 fd, void *buf, s64 count)
{
    struct file *filp = NULL;
    u64 ret = 0;
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

u64 sys_write(s32 fd, void *buf, s64 count)
{
    struct file *filp = NULL;
    u64 ret = 0;
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

u64 sys_lseek(s32 fd, s64 offset, s32 whence)
{
    struct file *filp = NULL;
    u64 ret = 0;

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

u64 sys_fork()
{
    struct stackregs *regs = (struct stackregs *)current->thread->rsp0 - 1;
    return do_fork(regs, 0, regs->rsp, 0);
}

u64 sys_vfork()
{
    struct stackregs *regs = (struct stackregs *)(current->thread->rsp0) - 1;
    return do_fork(regs, CLONE_VM | CLONE_FS | CLONE_SIGNAL, regs->rsp, 0);
}
u64 sys_brk(u64 brk)
{
    u64 new_brk = PAGE_2M_ALIGN(brk);
    if(new_brk == 0)
    {
        return current->mm->start_brk;
    }
    if(new_brk < current->mm->start_brk)
    {
        return 0;
    }
    new_brk = do_brk(current->mm->end_brk, new_brk - current->mm->end_brk);
    current->mm->end_brk = new_brk;
    return new_brk;
}
s64 sys_device_openkeyboard(s8 *filename, s32 flags)
{
    s8 *path = NULL;
    s64 pathlen = 0;
    s64 error = 0;
    struct dir_entry *dentry = NULL;
    struct file *filp = NULL;
    struct file **f = NULL;
    s32 fd = -1;
    s32 i = 0;

    path = (s8 *)kmalloc(PAGE_4K_SIZE, 0);
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
        DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN, SERIAL_ATTR_BACK_BLACK, "find\tfirstcluster:%#018lx\tfilesize:%#018lx\n", ((struct fat32_inode_info *)(dentry->dir_inode->private_index_info))->first_cluster, dentry->dir_inode->file_size);
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Can`t find file\n");
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
u64 sys_execve(void)
{
    u8* pathname = NULL;
    s64 pathlen = 0;
    s32 error = 0;
    struct stackregs *regs = (struct stackregs *)current->thread->rsp0 - 1;
    // DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "sys_execve\n");
    pathname = (u8 *)kmalloc(PAGE_4K_SIZE, 0);
    if(pathname == NULL)
    {
        return -ENOMEM;
    }
    memset(pathname, 0, PAGE_4K_SIZE);
    pathlen = strnlen_user((u8 *)regs->rdi, PAGE_4K_SIZE);
    if(pathlen < 0)
    {
        kfree(pathname);
        return -EFAULT;
    }
    else if(pathlen > PAGE_4K_SIZE)
    {
        kfree(pathname);
        return -ENAMETOOLONG;
    }
    strncpy_from_user((u8 *)regs->rdi, pathname, pathlen);
    error = do_execve(regs, pathname, (u8 **)regs->rsi, NULL);
    kfree(pathname);
    return error;
}
u64 sys_exit(s32 exitcode)
{
	// DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN,SERIAL_ATTR_BACK_BLACK,"sys_exit\n");
	return do_exit(exitcode);
}

u64 sys_wait4(u64 pid,s32 *status,s32 options,void *rusage)
{
	s64 retval = 0;
	struct task_struct *child = NULL;
	struct task_struct *tsk = NULL;
	// DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN,SERIAL_ATTR_BACK_BLACK,"sys_wait4\n");
	// for(tsk = current; tsk->next != current; tsk = tsk->next)
	for(tsk = &init_task_stack.task; tsk->next != &init_task_stack.task; tsk = tsk->next)
	{
		if(tsk->next->pid == pid)
		{
			child = tsk->next;
			break;
		}
	}
	if(child == NULL)
	{
        return -ECHILD;
    }
	if(options != 0)
	{
        return -EINVAL;
    }
	if(child->state == TASK_ZOMBIE)
	{
		copy_to_user(&child->exitcode,status,sizeof(s32));
		tsk->next = child->next;
		exit_mem(child);
		kfree(child);
		return retval;
	}
	interruptible_sleep_on(&current->childexit_wait);
	copy_to_user(&child->exitcode, status, sizeof(s32));
	tsk->next = child->next;
	exit_mem(child);
	kfree(child);
	return retval;
}

u64 sys_reboot(u64 cmd, void* arg)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_CYAN, SERIAL_ATTR_BACK_BLACK, "reboot\n");
    switch (cmd)
    {
    case SYSTEM_REBOOT:
        io_out8(0xcf9, 0x06); // 直接控制芯片组复位
        break;
    case SYSTEM_POWEROFF:
        break;
    default:
        break;
    }
    return 0;
}

u64 sys_chdir(s8* dirname)
{
    s8* path = NULL;
    s64 path_len = 0;
    struct dir_entry* dentry = NULL;
    path = (s8*)kmalloc(PAGE_4K_SIZE, 0);
    memset(path, 0, PAGE_4K_SIZE);
    path_len = strnlen_user(dirname, PAGE_4K_SIZE);
    if(path_len <= 0)
    {
        kfree(path);
        return -EFAULT;
    }
    else if(path_len >= PAGE_4K_SIZE)
    {
        kfree(path);
        return -ENAMETOOLONG;
    }
    strncpy_from_user(dirname, path, path_len);
    dentry = path_walk(path, 0);
    kfree(path);
    if(dentry == NULL)
    {
        return -ENOENT;
    }
    if(dentry->dir_inode->attribute != FS_ATTR_DIR)
    {
        return -ENOTDIR;
    }
    return 0;
}