#include <printk.h>
#include <smp/smp.h>
#include <vfs/vfs.h>


struct file_system_type filesystem = {"filesystem", 0};
struct super_block *root_sb = NULL;
struct super_block *mount_fs(int8_t *name, struct pt_entry *entry, void *buf)
{
    struct file_system_type *p = NULL;
    color_printk(YELLOW, BLACK, "mount_fs %s\n", name);
    for (p = &filesystem; p; p = p->next)
    {
        if (!strcmp(p->name, name))
        {
            return p->read_superblock(entry, buf);
        }
    }
    return 0;
}

uint64_t register_filesystem(struct file_system_type *fs)
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

uint64_t unregister_filesystem(struct file_system_type *fs)
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
struct dir_entry *path_walk(int8_t *name, uint64_t flags)
{
    int8_t *tmpname = NULL;
    int32_t tmpnamelen = 0;
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
            color_printk(RED, WHITE, "can not find file or dir:%s\n", path->name);
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