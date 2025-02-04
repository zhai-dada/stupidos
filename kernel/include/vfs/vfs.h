#ifndef __VFS_H__
#define __VFS_H__

#include <lib.h>
#include <stdint.h>
#include <memory.h>
#include <mbr/mbr.h>
#include <mbr/gpt.h>

struct file_system_type
{
    s8 *name;
    s32 fs_flags;
    struct super_block *(*read_superblock)(struct pt_entry *entry, void *buf);
    struct file_system_type *next;
};

struct super_block_operations;
struct index_node_operations;
struct dir_entry_operations;
struct file_operations;

struct super_block
{
    struct dir_entry *root;
    struct super_block_operations *sb_ops;
    void *private_sb_info;
};

struct index_node
{
    u64 file_size;
    u64 blocks;
    u64 attribute;
    struct super_block *sb;
    struct file_operations *f_ops;
    struct index_node_operations *inode_ops;
    void *private_index_info;
};

#define FS_ATTR_FILE (1UL << 0)
#define FS_ATTR_DIR (1UL << 1)


struct dir_entry
{
    s8 *name;
    s32 name_length;
    list_t child_node;
    list_t subdirs_list;
    struct index_node *dir_inode;
    struct dir_entry *parent;
    struct dir_entry_operations *dir_ops;
};

struct file
{
    s64 position;
    u64 mode;
    struct dir_entry *dentry;
    struct file_operations *f_ops;
    void *private_data;
};

struct super_block_operations
{
    void (*write_superblock)(struct super_block *sb);
    void (*put_superblock)(struct super_block *sb);
    void (*write_inode)(struct index_node *inode);
};

struct index_node_operations
{
    s64 (*create)(struct index_node *inode, struct dir_entry *dentry, s32 mode);
    struct dir_entry *(*lookup)(struct index_node *parent_inode, struct dir_entry *dest_dentry);
    s64 (*mkdir)(struct index_node *inode, struct dir_entry *dentry, s32 mode);
    s64 (*rmdir)(struct index_node *inode, struct dir_entry *dentry);
    s64 (*rename)(struct index_node *old_inode, struct dir_entry *old_dentry, struct index_node *new_inode, struct dir_entry *new_dentry);
    s64 (*getattr)(struct dir_entry *dentry, u64 *attr);
    s64 (*setattr)(struct dir_entry *dentry, u64 *attr);
};

struct dir_entry_operations
{
    s64 (*compare)(struct dir_entry *parent_dentry, s8 *source_filename, s8 *destination_filename);
    s64 (*hash)(struct dir_entry *dentry, s8 *filename);
    s64 (*release)(struct dir_entry *dentry);
    s64 (*iput)(struct dir_entry *dentry, struct index_node *inode);
};

struct file_operations
{
    s64 (*open)(struct index_node *inode, struct file *filp);
    s64 (*close)(struct index_node *inode, struct file *filp);
    s64 (*read)(struct file *filp, s8 *buf, u64 count, s64 *position);
    s64 (*write)(struct file *filp, s8 *buf, u64 count, s64 *position);
    s64 (*lseek)(struct file *filp, s64 offset, s64 origin);
    s64 (*ioctl)(struct index_node *inode, struct file *filp, u64 cmd, u64 arg);
};
extern struct super_block *root_sb;

struct dir_entry *path_walk(s8 *name, u64 flags);
struct super_block *mount_fs(s8 *name, struct pt_entry *entry, void *buf);
u64 register_filesystem(struct file_system_type *fs);
u64 unregister_filesystem(struct file_system_type *fs);

struct dir_entry *my_mkdir(s8 *name, u64 flags);
struct dir_entry *my_create(s8 *name, u64 flags);
#endif