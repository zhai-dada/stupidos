#ifndef __VFS_H__
#define __VFS_H__

#include <lib.h>
#include <stdint.h>
#include <memory.h>
#include <mbr/mbr.h>
#include <mbr/gpt.h>


struct file_system_type
{
    int8_t *name;
    int32_t fs_flags;
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
    uint64_t file_size;
    uint64_t blocks;
    uint64_t attribute;
    struct super_block *sb;
    struct file_operations *f_ops;
    struct index_node_operations *inode_ops;
    void *private_index_info;
};

#define FS_ATTR_FILE (1UL << 0)
#define FS_ATTR_DIR (1UL << 1)

#define	FS_ATTR_DEVICE_KEYBOARD	(1UL << 2)


struct dir_entry
{
    int8_t *name;
    int32_t name_length;
    struct list child_node;
    struct list subdirs_list;
    struct index_node *dir_inode;
    struct dir_entry *parent;
    struct dir_entry_operations *dir_ops;
};

struct file
{
    int64_t position;
    uint64_t mode;
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
    int64_t (*create)(struct index_node *inode, struct dir_entry *dentry, int32_t mode);
    struct dir_entry *(*lookup)(struct index_node *parent_inode, struct dir_entry *dest_dentry);
    int64_t (*mkdir)(struct index_node *inode, struct dir_entry *dentry, int32_t mode);
    int64_t (*rmdir)(struct index_node *inode, struct dir_entry *dentry);
    int64_t (*rename)(struct index_node *old_inode, struct dir_entry *old_dentry, struct index_node *new_inode, struct dir_entry *new_dentry);
    int64_t (*getattr)(struct dir_entry *dentry, uint64_t *attr);
    int64_t (*setattr)(struct dir_entry *dentry, uint64_t *attr);
};

struct dir_entry_operations
{
    int64_t (*compare)(struct dir_entry *parent_dentry, int8_t *source_filename, int8_t *destination_filename);
    int64_t (*hash)(struct dir_entry *dentry, int8_t *filename);
    int64_t (*release)(struct dir_entry *dentry);
    int64_t (*iput)(struct dir_entry *dentry, struct index_node *inode);
};

struct file_operations
{
    int64_t (*open)(struct index_node *inode, struct file *filp);
    int64_t (*close)(struct index_node *inode, struct file *filp);
    int64_t (*read)(struct file *filp, int8_t *buf, uint64_t count, int64_t *position);
    int64_t (*write)(struct file *filp, int8_t *buf, uint64_t count, int64_t *position);
    int64_t (*lseek)(struct file *filp, int64_t offset, int64_t origin);
    int64_t (*ioctl)(struct index_node *inode, struct file *filp, uint64_t cmd, uint64_t arg);
};
extern struct super_block *root_sb;

struct dir_entry *path_walk(int8_t *name, uint64_t flags);
struct super_block *mount_fs(int8_t *name, struct pt_entry *entry, void *buf);
uint64_t register_filesystem(struct file_system_type *fs);
uint64_t unregister_filesystem(struct file_system_type *fs);

#endif