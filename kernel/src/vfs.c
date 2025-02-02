#include <printk.h>
#include <smp/smp.h>
#include <vfs/vfs.h>
#include <debug.h>

struct file_system_type filesystem = {"filesystem", 0};
struct super_block *root_sb = NULL;
struct super_block *mount_fs(s8 *name, struct pt_entry *entry, void *buf)
{
    struct file_system_type *p = NULL;
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "mount_fs %s\n", name);
    for (p = &filesystem; p; p = p->next)
    {
        if (!strcmp(p->name, name))
        {
            return p->read_superblock(entry, buf);
        }
    }
    return 0;
}

u64 register_filesystem(struct file_system_type *fs)
{
    struct file_system_type *p = NULL;

    for (p = &filesystem; p; p = p->next)
    {
        if (!strcmp(fs->name, p->name))
        {
            return 0;
        }
    }

    fs->next = filesystem.next;
    filesystem.next = fs;

    return 1;
}

u64 unregister_filesystem(struct file_system_type *fs)
{
    struct file_system_type *p = &filesystem;

    while (p->next)
    {
        if (p->next == fs)
        {
            p->next = p->next->next;
            fs->next = NULL;
            return 1;
        }
        else
        {
            p = p->next;
        }
    }
    return 0;
}
struct dir_entry *path_walk(s8 *name, u64 flags)
{
    s8 *tmpname = NULL;
    s32 tmpnamelen = 0;
    struct dir_entry *parent = root_sb->root;
    struct dir_entry *path = NULL;

    while (*name == '/')
    {
        name++;
    }
    if (!*name)
    {
        return parent;
    }

    for (;;)
    {
        tmpname = name;
        while (*name && (*name != '/'))
        {
            name++;
        }
        tmpnamelen = name - tmpname;

        path = (struct dir_entry *)kmalloc(sizeof(struct dir_entry), 0);
        memset(path, 0, sizeof(struct dir_entry));

        path->name = kmalloc(tmpnamelen + 1, 0);
        memset(path->name, 0, tmpnamelen + 1);
        memcpy(tmpname, path->name, tmpnamelen);
        path->name_length = tmpnamelen;

        if (parent->dir_inode->inode_ops->lookup(parent->dir_inode, path) == NULL)
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "can not find file or dir:%s\n", path->name);
            kfree(path->name);
            kfree(path);
            return NULL;
        }

        list_init(&path->child_node);
        list_init(&path->subdirs_list);
        path->parent = parent;
        list_add_behind(&parent->subdirs_list, &path->child_node);

        if (!*name)
        {
            goto last_c;
        }
        while (*name == '/')
        {
            name++;
        }
        if (!*name)
        {
            goto last_s;
        }
        parent = path;
    }

last_s:
last_c:

    if (flags & 1)
    {
        return parent;
    }
    return path;
}

struct dir_entry *my_create(s8 *name, u64 flags)
{
    struct dir_entry *parent = root_sb->root;
    struct dir_entry *path = NULL;

    // 检查目录是否已存在
    if (path_walk(name, 0) != NULL) {
        return NULL; // 目录已存在，返回 NULL
    }
    parent = path_walk("1234", 0);
    if(parent == NULL)
    {
        color_printk(RED, BLACK, "NULL\n");
    }
    // 分配目录项结构
    path = (struct dir_entry *)kmalloc(sizeof(struct dir_entry), 0);
    if (!path) {
        return NULL; // 内存分配失败
    }
    memset(path, 0, sizeof(struct dir_entry));

    // 分配目录名存储空间
    path->name = (s8 *)kmalloc(strlen(name) + 1, 0);
    if (!path->name)
    {
        kfree(path);
        return NULL;
    }
    memset(path->name, 0, strlen(name) + 1);
    memcpy(name, path->name, strlen(name));

    path->name_length = strlen(name);
    path->parent = parent;  // 设定父目录指针

    // 调用底层 inode_ops->mkdir 创建目录
    if (parent->dir_inode->inode_ops->create(parent->dir_inode, path, flags) < 0) {
        kfree(path->name);
        kfree(path);
        return NULL;
    }

    return path;
}


struct dir_entry *my_mkdir(s8 *name, u64 flags)
{
    struct dir_entry *parent = root_sb->root;
    struct dir_entry *path = NULL;

    // 检查目录是否已存在
    if (path_walk(name, 0) != NULL) {
        return NULL; // 目录已存在，返回 NULL
    }

    // 分配目录项结构
    path = (struct dir_entry *)kmalloc(sizeof(struct dir_entry), 0);
    if (!path) {
        return NULL; // 内存分配失败
    }
    memset(path, 0, sizeof(struct dir_entry));

    // 分配目录名存储空间
    path->name = (s8 *)kmalloc(strlen(name) + 1, 0);
    if (!path->name) {
        kfree(path);
        return NULL;
    }
    memset(path->name, 0, strlen(name) + 1);
    memcpy(name, path->name, strlen(name));

    path->name_length = strlen(name);
    path->parent = parent;  // 设定父目录指针

    // 调用底层 inode_ops->mkdir 创建目录
    if (parent->dir_inode->inode_ops->mkdir(parent->dir_inode, path, flags) < 0) {
        kfree(path->name);
        kfree(path);
        return NULL;
    }

    return path;
}
