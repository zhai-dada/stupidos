#include <disk/disk.h>
#include <disk/block.h>
#include <vfs/fat32.h>
#include <vfs/vfs.h>
#include <printk.h>
#include <errno.h>
#include <task.h>
#include <stdio.h>
#include <stackregs.h>
#include <mbr/mbr.h>
#include <mbr/gpt.h>

uint32_t readfatentry(struct fat32_sb_info *fsbi, uint32_t fat_entry)
{
    uint32_t *buffer = (uint32_t*)kmalloc(512, 0);
    memset(buffer, 0, 512);
    disk_device_operation.transfer(ATA_READ_CMD, fsbi->fat1_firstsector + (fat_entry >> 7), 1, (uint8_t *)buffer);
    return buffer[fat_entry & 0x7f] & 0x0fffffff;
    kfree(buffer);
}
uint64_t writefatentry(struct fat32_sb_info *fsbi, uint32_t fat_entry, uint32_t value)
{
    uint32_t buffer[128];
    memset(buffer, 0, 512);
    disk_device_operation.transfer(ATA_READ_CMD, fsbi->fat1_firstsector + (fat_entry >> 7), 1, (uint8_t *)buffer);
    int32_t i = 0;
    buffer[fat_entry & 0x7f] = (buffer[fat_entry & 0x7f] & 0xf0000000) | (value & 0x0fffffff);
    for (i = 0; i < fsbi->numfats; i++)
    {
        disk_device_operation.transfer(ATA_WRITE_CMD, fsbi->fat1_firstsector + fsbi->sector_per_fat * i + (fat_entry >> 7), 1, (uint8_t *)buffer);
    }
    return 1;
}

int64_t fat32_open(struct index_node *inode, struct file *filp)
{
    return 1;
}
int64_t fat32_close(struct index_node *inode, struct file *filp)
{
    return 1;
}
int64_t fat32_read(struct file *filp, int8_t *buf, uint64_t count, int64_t *position)
{
    struct fat32_inode_info *finode = filp->dentry->dir_inode->private_index_info;
    struct fat32_sb_info *fsbi = filp->dentry->dir_inode->sb->private_sb_info;

    uint64_t cluster = finode->first_cluster;
    uint64_t sector = 0;
    int32_t i, length = 0;
    int64_t retval = 0;
    int32_t index = *position / fsbi->bytes_per_cluster;
    int64_t offset = *position % fsbi->bytes_per_cluster;
    int8_t *buffer = (int8_t *)kmalloc(fsbi->bytes_per_cluster, 0);

    if (!cluster)
    {
        return -EFAULT;
    }
    for (i = 0; i < index; i++)
    {
        cluster = readfatentry(fsbi, cluster);
    }
    if (*position + count > filp->dentry->dir_inode->file_size)
    {
        index = count = filp->dentry->dir_inode->file_size - *position;
    }
    else
    {
        index = count;
    }
    // color_printk(GREEN, BLACK, "fat32_read first_cluster:%d,size:%d,preempt_count:%d\n", finode->first_cluster, filp->dentry->dir_inode->file_size, current->preempt_count);

    do
    {
        memset(buffer, 0, fsbi->bytes_per_cluster);
        sector = fsbi->data_firstsector + (cluster - 2) * fsbi->sector_per_cluster;
        if (!disk_device_operation.transfer(ATA_READ_CMD, sector, fsbi->sector_per_cluster, (uint8_t *)buffer))
        {
            color_printk(RED, BLACK, "fat32 FS(read) read disk ERROR!!!!!!!!!!\n");
            retval = -EIO;
            break;
        }

        length = (index <= (fsbi->bytes_per_cluster - offset)) ? index : (fsbi->bytes_per_cluster - offset);

        if ((uint64_t)buf < TASK_SIZE)
        {
            copy_to_user(buffer + offset, buf, length);
        }
        else
        {
            memcpy(buffer + offset, buf, length);
        }
        index -= length;
        buf += length;
        offset -= offset;
        *position += length;
    } while (index && (cluster = readfatentry(fsbi, cluster)));

    kfree(buffer);
    if (!index)
    {
        retval = count;
    }
    return retval;
}

uint64_t fat32_find_available_cluster(struct fat32_sb_info *fsbi)
{
    int32_t i = 0, j = 0;
    int32_t fat_entry = 0;
    uint64_t sector_per_fat = fsbi->sector_per_fat;
    uint32_t buf[128] = {0};

    for (i = 0; i < sector_per_fat; i++)
    {
        memset(buf, 0, 512);
        disk_device_operation.transfer(ATA_READ_CMD, fsbi->fat1_firstsector + i, 1, (uint8_t *)buf);

        for (j = 0; j < 128; j++)
        {
            if ((buf[j] & 0x0fffffff) == 0)
            {
                return (i << 7) + j;
            }
        }
    }
    return 0;
}

int64_t fat32_write(struct file *filp, int8_t *buf, uint64_t count, int64_t *position)
{
    struct fat32_inode_info *finode = filp->dentry->dir_inode->private_index_info;
    struct fat32_sb_info *fsbi = filp->dentry->dir_inode->sb->private_sb_info;

    uint64_t cluster = finode->first_cluster;
    uint64_t next_cluster = 0;
    uint64_t sector = 0;
    int32_t i, length = 0;
    int64_t retval = 0;
    int64_t flags = 0;
    int32_t index = *position / fsbi->bytes_per_cluster;
    int64_t offset = *position % fsbi->bytes_per_cluster;
    int8_t *buffer = (int8_t *)kmalloc(fsbi->bytes_per_cluster, 0);

    if (!cluster)
    {
        cluster = fat32_find_available_cluster(fsbi);
        flags = 1;
    }
    else
    {
        for (i = 0; i < index; i++)
        {
            cluster = readfatentry(fsbi, cluster);
        }
    }
    if (!cluster)
    {
        kfree(buffer);
        return -ENOSPC;
    }

    if (flags)
    {
        finode->first_cluster = cluster;
        filp->dentry->dir_inode->sb->sb_ops->write_inode(filp->dentry->dir_inode);
        writefatentry(fsbi, cluster, 0x0ffffff8);
    }

    index = count;

    do
    {
        if (!flags)
        {
            memset(buffer, 0, fsbi->bytes_per_cluster);
            sector = fsbi->data_firstsector + (cluster - 2) * fsbi->sector_per_cluster;
            if (!disk_device_operation.transfer(ATA_READ_CMD, sector, fsbi->sector_per_cluster, (uint8_t *)buffer))
            {
                color_printk(RED, BLACK, "fat32 FS(write) read disk ERROR!!!!!!!!!!\n");
                retval = -EIO;
                break;
            }
        }

        length = index <= fsbi->bytes_per_cluster - offset ? index : fsbi->bytes_per_cluster - offset;

        if ((uint64_t)buf < TASK_SIZE)
        {
            copy_from_user(buf, buffer + offset, length);
        }
        else
        {
            memcpy(buf, buffer + offset, length);
        }
        if (!disk_device_operation.transfer(ATA_WRITE_CMD, sector, fsbi->sector_per_cluster, (uint8_t *)buffer))
        {
            color_printk(RED, BLACK, "fat32 FS(write) write disk ERROR!!!!!!!!!!\n");
            retval = -EIO;
            break;
        }

        index -= length;
        buf += length;
        offset -= offset;
        *position += length;

        if (index)
        {
            next_cluster = readfatentry(fsbi, cluster);
        }
        else
        {
            break;
        }
        if (next_cluster >= 0x0ffffff8)
        {
            next_cluster = fat32_find_available_cluster(fsbi);
            if (!next_cluster)
            {
                kfree(buffer);
                return -ENOSPC;
            }

            writefatentry(fsbi, cluster, next_cluster);
            writefatentry(fsbi, next_cluster, 0x0ffffff8);
            cluster = next_cluster;
            flags = 1;
        }

    } while (index);

    if (*position > filp->dentry->dir_inode->file_size)
    {
        filp->dentry->dir_inode->file_size = *position;
        filp->dentry->dir_inode->sb->sb_ops->write_inode(filp->dentry->dir_inode);
    }

    kfree(buffer);
    if (!index)
    {
        retval = count;
    }
    return retval;
}

int64_t fat32_lseek(struct file *filp, int64_t offset, int64_t origin)
{
    struct index_node *inode = filp->dentry->dir_inode;
    int64_t pos = 0;

    switch (origin)
    {
    case SEEK_SET:
        pos = 0 + offset;
        break;

    case SEEK_CUR:
        pos = filp->position + offset;
        break;

    case SEEK_END:
        pos = filp->dentry->dir_inode->file_size + offset;
        break;

    default:
        return -EINVAL;
        break;
    }

    if (pos < 0 || pos > filp->dentry->dir_inode->file_size)
    {
        return -EOVERFLOW;
    }
    filp->position = pos;
    return pos;
}
int64_t fat32_ioctl(struct index_node *inode, struct file *filp, uint64_t cmd, uint64_t arg)
{
    return 1;
}
struct file_operations fat32_file_ops =
    {
        .open = fat32_open,
        .close = fat32_close,
        .read = fat32_read,
        .write = fat32_write,
        .lseek = fat32_lseek,
        .ioctl = fat32_ioctl,
};
int64_t fat32_create(struct index_node *inode, struct dir_entry *dentry, int32_t mode)
{
    return 1;
}
int64_t fat32_mkdir(struct index_node *inode, struct dir_entry *dentry, int32_t mode)
{
    return 1;
}
int64_t fat32_rmdir(struct index_node *inode, struct dir_entry *dentry)
{
    return 1;
}
int64_t fat32_rename(struct index_node *old_inode, struct dir_entry *old_dentry, struct index_node *new_inode, struct dir_entry *new_dentry)
{
    return 1;
}
int64_t fat32_getattr(struct dir_entry *dentry, uint64_t *attr)
{
    return 1;
}
int64_t fat32_setattr(struct dir_entry *dentry, uint64_t *attr)
{
    return 1;
}
struct dir_entry *fat32_lookup(struct index_node *parent_inode, struct dir_entry *dest_dentry)
{
    struct fat32_inode_info *finode = parent_inode->private_index_info;
    struct fat32_sb_info *fsbi = parent_inode->sb->private_sb_info;

    uint32_t cluster = 0;
    uint64_t sector = 0;
    uint8_t *buff = NULL;
    int32_t i = 0, j = 0, x = 0;
    struct fat32_dir *tmpdentry = NULL;
    struct fat32_ldir *tmpldentry = NULL;
    struct index_node *p = NULL;

    buff = kmalloc(fsbi->bytes_per_cluster, 0);

    cluster = finode->first_cluster;

next_cluster:
    sector = fsbi->data_firstsector + (cluster - 2) * fsbi->sector_per_cluster;
    color_printk(BLUE, BLACK, "lookup cluster:%#010x,sector:%#018lx\n", cluster, sector);
    if (!disk_device_operation.transfer(ATA_READ_CMD, sector, fsbi->sector_per_cluster, (uint8_t *)buff))
    {
        color_printk(RED, BLACK, "fat32 FS(lookup) read disk ERROR!!!!!!!!!!\n");
        kfree(buff);
        return NULL;
    }

    tmpdentry = (struct fat32_dir *)buff;

    for (i = 0; i < fsbi->bytes_per_cluster; i += 32, tmpdentry++)
    {
        if (tmpdentry->dir_attr == ATTR_LONG_NAME)
        {
            continue;
        }
        if (tmpdentry->dir_name[0] == 0xe5 || tmpdentry->dir_name[0] == 0x00 || tmpdentry->dir_name[0] == 0x05)
        {
            continue;
        }
        tmpldentry = (struct fat32_ldir *)tmpdentry - 1;
        j = 0;

        // int64_t file or dir name compare
        while (tmpldentry->ldir_attr == ATTR_LONG_NAME && tmpldentry->ldir_ord != 0xe5)
        {
            for (x = 0; x < 5; x++)
            {
                if (j > dest_dentry->name_length && tmpldentry->ldir_name1[x] == 0xffff)
                {
                    continue;
                }
                else if (j > dest_dentry->name_length || tmpldentry->ldir_name1[x] != (uint16_t)(dest_dentry->name[j++]))
                {
                    goto continue_cmp_fail;
                }
            }
            for (x = 0; x < 6; x++)
            {
                if (j > dest_dentry->name_length && tmpldentry->ldir_name2[x] == 0xffff)
                {
                    continue;
                }
                else if (j > dest_dentry->name_length || tmpldentry->ldir_name2[x] != (uint16_t)(dest_dentry->name[j++]))
                {
                    goto continue_cmp_fail;
                }
            }
            for (x = 0; x < 2; x++)
            {
                if (j > dest_dentry->name_length && tmpldentry->ldir_name3[x] == 0xffff)
                {
                    continue;
                }
                else if (j > dest_dentry->name_length || tmpldentry->ldir_name3[x] != (uint16_t)(dest_dentry->name[j++]))
                {
                    goto continue_cmp_fail;
                }
            }

            if (j >= dest_dentry->name_length)
            {
                goto find_lookup_success;
            }

            tmpldentry--;
        }

        // short file or dir base name compare
        j = 0;
        for (x = 0; x < 8; x++)
        {
            switch (tmpdentry->dir_name[x])
            {
            case ' ':
                if (!(tmpdentry->dir_attr & ATTR_DIRECTORY))
                {
                    if (dest_dentry->name[j] == '.')
                    {
                        continue;
                    }
                    else if (tmpdentry->dir_name[x] == dest_dentry->name[j])
                    {
                        j++;
                        break;
                    }
                    else
                    {
                        goto continue_cmp_fail;
                    }
                }
                else
                {
                    if (j < dest_dentry->name_length && tmpdentry->dir_name[x] == dest_dentry->name[j])
                    {
                        j++;
                        break;
                    }
                    else if (j == dest_dentry->name_length)
                    {
                        continue;
                    }
                    else
                    {
                        goto continue_cmp_fail;
                    }
                }
            case 'A' ... 'Z':
            case 'a' ... 'z':
                if (tmpdentry->dir_ntres & LOWERCASE_BASE)
                {
                    if (j < dest_dentry->name_length && tmpdentry->dir_name[x] + 32 == dest_dentry->name[j])
                    {
                        j++;
                        break;
                    }
                    else
                    {
                        goto continue_cmp_fail;
                    }
                }
                else
                {
                    if (j < dest_dentry->name_length && tmpdentry->dir_name[x] == dest_dentry->name[j])
                    {
                        j++;
                        break;
                    }
                    else
                    {
                        goto continue_cmp_fail;
                    }
                }

            case '0' ... '9':
                if (j < dest_dentry->name_length && tmpdentry->dir_name[x] == dest_dentry->name[j])
                {
                    j++;
                    break;
                }
                else
                {
                    goto continue_cmp_fail;
                }

            default:
                j++;
                break;
            }
        }
        // short file ext name compare
        if (!(tmpdentry->dir_attr & ATTR_DIRECTORY))
        {
            j++;
            for (x = 8; x < 11; x++)
            {
                switch (tmpdentry->dir_name[x])
                {
                case 'A' ... 'Z':
                case 'a' ... 'z':
                    if (tmpdentry->dir_ntres & LOWERCASE_EXT)
                    {
                        if (tmpdentry->dir_name[x] + 32 == dest_dentry->name[j])
                        {
                            j++;
                            break;
                        }
                        else
                        {
                            goto continue_cmp_fail;
                        }
                    }
                    else
                    {
                        if (tmpdentry->dir_name[x] == dest_dentry->name[j])
                        {
                            j++;
                            break;
                        }
                        else
                        {
                            goto continue_cmp_fail;
                        }
                    }

                case '0' ... '9':
                    if (tmpdentry->dir_name[x] == dest_dentry->name[j])
                    {
                        j++;
                        break;
                    }
                    else
                    {
                        goto continue_cmp_fail;
                    }

                case ' ':
                    if (tmpdentry->dir_name[x] == dest_dentry->name[j])
                    {
                        j++;
                        break;
                    }
                    else
                    {
                        goto continue_cmp_fail;
                    }

                default:
                    goto continue_cmp_fail;
                }
            }
        }
        goto find_lookup_success;

    continue_cmp_fail:;
    }

    cluster = readfatentry(fsbi, cluster);
    if (cluster < 0x0ffffff7)
    {
        goto next_cluster;
    }
    kfree(buff);
    return NULL;

find_lookup_success:
    p = (struct index_node *)kmalloc(sizeof(struct index_node), 0);
    memset(p, 0, sizeof(struct index_node));
    p->file_size = tmpdentry->dir_filesize;
    p->blocks = (p->file_size + fsbi->bytes_per_cluster - 1) / fsbi->bytes_per_sector;
    p->attribute = (tmpdentry->dir_attr & ATTR_DIRECTORY) ? FS_ATTR_DIR : FS_ATTR_FILE;
    p->sb = parent_inode->sb;
    p->f_ops = &fat32_file_ops;
    p->inode_ops = &fat32_inode_ops;

    p->private_index_info = (struct fat32_inode_info *)kmalloc(sizeof(struct fat32_inode_info), 0);
    memset(p->private_index_info, 0, sizeof(struct fat32_inode_info));
    finode = p->private_index_info;

    finode->first_cluster = (tmpdentry->dir_fstclushi << 16 | tmpdentry->dir_fstcluslo) & 0x0fffffff;
    finode->dentry_location = cluster;
    finode->dentry_position = tmpdentry - (struct fat32_dir *)buff;
    finode->create_date = tmpdentry->dir_crttime;
    finode->create_time = tmpdentry->dir_crtdate;
    finode->write_date = tmpdentry->dir_wrttime;
    finode->write_time = tmpdentry->dir_wrtdate;
    dest_dentry->dir_inode = p;
    kfree(buff);
    return dest_dentry;
}
struct index_node_operations fat32_inode_ops =
{
    .create = fat32_create,
    .lookup = fat32_lookup,
    .mkdir = fat32_mkdir,
    .rmdir = fat32_rmdir,
    .rename = fat32_rename,
    .getattr = fat32_getattr,
    .setattr = fat32_setattr,
};
int64_t fat32_compare(struct dir_entry *parent_dentry, int8_t *source_filename, int8_t *destination_filename)
{
    return 1;
}
int64_t fat32_hash(struct dir_entry *dentry, int8_t *filename)
{
    return 1;
}
int64_t fat32_release(struct dir_entry *dentry)
{
    return 1;
}
int64_t fat32_iput(struct dir_entry *dentry, struct index_node *inode)
{
    return 1;
}
struct dir_entry_operations fat32_dentry_ops =
{
    .compare = fat32_compare,
    .hash = fat32_hash,
    .release = fat32_release,
    .iput = fat32_iput,
};
void fat32_write_superblock(struct super_block *sb)
{
    return;
}

void fat32_put_superblock(struct super_block *sb)
{
    kfree(sb->private_sb_info);
    kfree(sb->root->dir_inode->private_index_info);
    kfree(sb->root->dir_inode);
    kfree(sb->root);
    kfree(sb);
    return;
}

void fat32_write_inode(struct index_node *inode)
{
    struct fat32_dir *fdentry = NULL;
    struct fat32_dir *buff = NULL;
    struct fat32_inode_info *finode = inode->private_index_info;
    struct fat32_sb_info *fsbi = inode->sb->private_sb_info;
    uint64_t sector = 0;

    if (finode->dentry_location == 0)
    {
        color_printk(RED, BLACK, "FS ERROR:write root inode!\n");
        return;
    }
    sector = fsbi->data_firstsector + (finode->dentry_location - 2) * fsbi->sector_per_cluster;
    buff = (struct fat32_dir *)kmalloc(fsbi->bytes_per_cluster, 0);
    memset(buff, 0, fsbi->bytes_per_cluster);
    disk_device_operation.transfer(ATA_READ_CMD, sector, fsbi->sector_per_cluster, (uint8_t *)buff);
    fdentry = buff + finode->dentry_position;

    ////alert fat32 dentry data
    fdentry->dir_filesize = inode->file_size;
    fdentry->dir_fstcluslo = finode->first_cluster & 0xffff;
    fdentry->dir_fstclushi = (fdentry->dir_fstclushi & 0xf000) | (finode->first_cluster >> 16);

    disk_device_operation.transfer(ATA_WRITE_CMD, sector, fsbi->sector_per_cluster, (uint8_t *)buff);
    kfree(buff);
    return;
}

struct super_block_operations fat32_sb_ops =
{
    .write_superblock = fat32_write_superblock,
    .put_superblock = fat32_put_superblock,
    .write_inode = fat32_write_inode,
};
struct super_block *fat32_read_superblock(struct pt_entry *entry, void *buff)
{
    struct super_block *sbp = NULL;
    struct fat32_inode_info *finode = NULL;
    struct fat32_bootsector *fbs = NULL;
    struct fat32_sb_info *fsbi = NULL;

    ////super block
    sbp = (struct super_block *)kmalloc(sizeof(struct super_block), 0);
    memset(sbp, 0, sizeof(struct super_block));

    sbp->sb_ops = &fat32_sb_ops;
    sbp->private_sb_info = (struct fat32_sb_info *)kmalloc(sizeof(struct fat32_sb_info), 0);
    memset(sbp->private_sb_info, 0, sizeof(struct fat32_sb_info));

    ////fat32 boot sector
    fbs = (struct fat32_bootsector *)buff;
    fsbi = sbp->private_sb_info;
    fsbi->start_sector = entry->start_lba;
    fsbi->sector_count = entry->sectors_limit;
    fsbi->sector_per_cluster = fbs->bpb_secperclus;
    fsbi->bytes_per_cluster = fbs->bpb_secperclus * fbs->bpb_bytespersec;
    fsbi->bytes_per_sector = fbs->bpb_bytespersec;
    fsbi->data_firstsector = entry->start_lba + fbs->bpb_rsvdseccnt + fbs->bpb_fatsz32 * fbs->bpb_numfats;
    fsbi->fat1_firstsector = entry->start_lba + fbs->bpb_rsvdseccnt;
    fsbi->sector_per_fat = fbs->bpb_fatsz32;
    fsbi->numfats = fbs->bpb_numfats;
    fsbi->fsinfo_sector_infat = fbs->bpb_fsinfo;
    fsbi->bootsector_bk_infat = fbs->bpb_bkbootsec;

    // color_printk(BLUE, BLACK, "fat32 Boot Sector\tBPB_FSInfo:%#018lx\tBPB_BkBootSec:%#018lx\tBPB_TotSec32:%#018lx\n", fbs->bpb_fsinfo, fbs->bpb_bkbootsec, fbs->bpb_totsec32);

    ////fat32 fsinfo sector
    fsbi->fat_fsinfo = (struct fat32_fsinfo *)kmalloc(sizeof(struct fat32_fsinfo), 0);
    memset(fsbi->fat_fsinfo, 0, 512);
    disk_device_operation.transfer(ATA_READ_CMD, entry->start_lba + fbs->bpb_fsinfo, 1, (uint8_t *)fsbi->fat_fsinfo);

    // color_printk(BLUE, BLACK, "fat32 FSInfo\tFSI_LeadSig:%#018lx\tFSI_StrucSig:%#018lx\tFSI_Free_Count:%#018lx\n", fsbi->fat_fsinfo->fsi_leadsig, fsbi->fat_fsinfo->fsi_strucsig, fsbi->fat_fsinfo->fsi_free_count);

    ////directory entry
    sbp->root = (struct dir_entry *)kmalloc(sizeof(struct dir_entry), 0);
    memset(sbp->root, 0, sizeof(struct dir_entry));

    list_init(&sbp->root->child_node);
    list_init(&sbp->root->subdirs_list);
    sbp->root->parent = sbp->root;
    sbp->root->dir_ops = &fat32_dentry_ops;
    sbp->root->name = (int8_t *)kmalloc(2, 0);
    sbp->root->name[0] = '/';
    sbp->root->name_length = 1;

    ////index node
    sbp->root->dir_inode = (struct index_node *)kmalloc(sizeof(struct index_node), 0);
    memset(sbp->root->dir_inode, 0, sizeof(struct index_node));
    sbp->root->dir_inode->inode_ops = &fat32_inode_ops;
    sbp->root->dir_inode->f_ops = &fat32_file_ops;
    sbp->root->dir_inode->file_size = 0;
    sbp->root->dir_inode->blocks = (sbp->root->dir_inode->file_size + fsbi->bytes_per_cluster - 1) / fsbi->bytes_per_sector;
    sbp->root->dir_inode->attribute = FS_ATTR_DIR;
    sbp->root->dir_inode->sb = sbp;

    ////fat32 root inode
    sbp->root->dir_inode->private_index_info = (struct fat32_inode_info *)kmalloc(sizeof(struct fat32_inode_info), 0);
    memset(sbp->root->dir_inode->private_index_info, 0, sizeof(struct fat32_inode_info));
    finode = (struct fat32_inode_info *)sbp->root->dir_inode->private_index_info;
    finode->first_cluster = fbs->bpb_rootclus;
    finode->dentry_location = 0;
    finode->dentry_position = 0;
    finode->create_date = 0;
    finode->create_time = 0;
    finode->write_date = 0;
    finode->write_time = 0;

    return sbp;
}
struct file_system_type fat32_fs_type =
{
    .name ="FAT32",
    .fs_flags = 0,
    .read_superblock = fat32_read_superblock,
    .next = NULL,
};

void disk_fat32_fs_init()
{
    int32_t i, j;
    struct disk_partition_table dpt = {0};
    struct gpt_head *gpthead = NULL;
    struct gpt_pt_entry *gpt_entry = NULL;
    struct pt_entry dpte;

    uint8_t *buf = (uint8_t *)kmalloc(4096, 0);
    register_filesystem(&fat32_fs_type);

    memset(buf, 0, 4096);
    disk_device_operation.transfer(ATA_READ_CMD, 0, 1, (uint8_t *)buf);
    dpt = *(struct disk_partition_table *)buf;

    memset(buf, 0, 4096);
    disk_device_operation.transfer(ATA_READ_CMD, 1, 1, (uint8_t *)buf);
    gpthead = (struct gpt_head *)buf;

    j = gpthead->pt_entry_lba;

    memset(buf, 0, 4096);
    disk_device_operation.transfer(ATA_READ_CMD, j, 1, (uint8_t *)buf);
    gpt_entry = (struct gpt_pt_entry *)buf;

    dpte.start_lba = gpt_entry[0].start_lba;
    dpte.sectors_limit = gpt_entry[0].end_lba - gpt_entry[0].start_lba;

    memset(buf, 0, 4096);
    disk_device_operation.transfer(ATA_READ_CMD, dpte.start_lba, 1, (uint8_t *)buf);
    io_mfence();
    // color_printk(BLUE, BLACK, "dpte start_LBA:%#018lx\tsectors_limit:%#018lx\n", dpte.start_lba, dpte.sectors_limit);

    root_sb = mount_fs("FAT32", &dpte, buf); // not dev node
    kfree(buf);
    return;
}