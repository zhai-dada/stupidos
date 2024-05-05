#ifndef __FAT32_H__
#define __FAT32_H__

#include <stdint.h>

struct fat32_bootsector
{
    uint8_t bs_jmpboot[3];      // 引导码
    uint8_t bs_oemname[8];      // OEM名称
    uint16_t bpb_bytespersec;   // 每扇区字节数
    uint8_t bpb_secperclus;     // 每簇扇区数
    uint16_t bpb_rsvdseccnt;    // 保留扇区数
    uint8_t bpb_numfats;        // FAT表个数
    uint16_t bpb_rootentcnt;    // 根目录条目数
    uint16_t bpb_totsec16;      // 总扇区数（16位）
    uint8_t bpb_media;          // 媒体描述符
    uint16_t bpb_fatsz16;       // 每FAT扇区数（16位）
    uint16_t bpb_secpertrk;     // 每磁道扇区数
    uint16_t bpb_numheads;      // 磁头数
    uint32_t bpb_hiddsec;       // 隐藏扇区数
    uint32_t bpb_totsec32;      // 总扇区数（32位）
    uint32_t bpb_fatsz32;       // 每FAT扇区数（32位）
    uint16_t bpb_extflags;      // 扩展标志
    uint16_t bpb_fsver;         // 文件系统版本
    uint32_t bpb_rootclus;      // 根目录簇号
    uint16_t bpb_fsinfo;        // FSINFO扇区号
    uint16_t bpb_bkbootsec;     // 启动扇区备份
    uint8_t bpb_reserved[12];   // 保留字段
    uint8_t bs_drvnum;          // 驱动器编号
    uint8_t bs_reserved1;       // 保留字段1
    uint8_t bs_bootsig;         // 启动标记
    uint32_t bs_volid;          // 卷序列号
    uint8_t bs_vollab[11];      // 卷标
    uint8_t bs_filfstype[8];    // 文件系统类型
    uint8_t bootcode[420];      // 引导代码
    uint16_t bs_trailsig;       // 结尾标记
} __attribute__((packed));

struct fat32_fsinfo
{
    uint32_t fsi_leadsig;       // FSINFO标志
    uint8_t fsi_reserved1[480]; // 保留字段
    uint32_t fsi_strucsig;      // 结构标志
    uint32_t fsi_free_count;    // 空闲簇计数
    uint32_t fsi_nxt_free;      // 下一个空闲簇
    uint8_t fsi_reserved2[12];  // 保留字段
    uint32_t fsi_trailsig;      // 结尾标记
} __attribute__((packed));

struct fat32_dir
{
    uint8_t dir_name[11];       // 目录名
    uint8_t dir_attr;           // 文件属性
    uint8_t dir_ntres;          // NT保留字段
    uint8_t dir_crttimetenth;   // 创建时间1/10秒
    uint16_t dir_crttime;       // 创建时间
    uint16_t dir_crtdate;       // 创建日期
    uint16_t dir_lastaccdate;   // 最后访问日期
    uint16_t dir_fstclushi;     // 起始簇号（高16位）
    uint16_t dir_wrttime;       // 最后修改时间
    uint16_t dir_wrtdate;       // 最后修改日期
    uint16_t dir_fstcluslo;     // 起始簇号（低16位）
    uint32_t dir_filesize;      // 文件大小
} __attribute__((packed));

struct fat32_ldir
{
    uint8_t ldir_ord;           // 目录顺序号
    uint16_t ldir_name1[5];     // 目录名1
    uint8_t ldir_attr;          // 文件属性
    uint8_t ldir_type;          // 目录项类型
    uint8_t ldir_chksum;        // 校验和
    uint16_t ldir_name2[6];     // 目录名2
    uint16_t ldir_fstcluslo;    // 起始簇号（低16位）
    uint16_t ldir_name3[2];     // 目录名3
} __attribute__((packed));

struct fat32_sb_info
{
    uint64_t start_sector;              // 起始扇区
    uint64_t sector_count;              // 扇区数量

    long sector_per_cluster;            // 每簇扇区数
    long bytes_per_cluster;             // 每簇字节数
    long bytes_per_sector;              // 每扇区字节数

    uint64_t data_firstsector;          // 数据区起始扇区
    uint64_t fat1_firstsector;          // FAT1起始扇区
    uint64_t sector_per_fat;            // 每FAT扇区数
    uint64_t numfats;                   // FAT表个数

    uint64_t fsinfo_sector_infat;       // FAT中的FSINFO扇区
    uint64_t bootsector_bk_infat;       // FAT中的引导扇区备份

    struct fat32_fsinfo *fat_fsinfo;    // FAT32文件系统信息
};

struct fat32_inode_info
{
    uint64_t first_cluster;         // 起始簇号
    uint64_t dentry_location;       // 目录项位置（0表示根目录，1表示无效）
    uint64_t dentry_position;       // 目录项偏移量

    uint16_t create_date;           // 创建日期
    uint16_t create_time;           // 创建时间

    uint16_t write_date;            // 最后修改日期
    uint16_t write_time;            // 最后修改时间
};

#define LOWERCASE_BASE 	(8)
#define LOWERCASE_EXT 	(16)

#define	ATTR_READ_ONLY	(1 << 0)
#define ATTR_HIDDEN		(1 << 1)
#define ATTR_SYSTEM		(1 << 2)
#define ATTR_VOLUME_ID	(1 << 3)
#define ATTR_DIRECTORY	(1 << 4)
#define ATTR_ARCHIVE	(1 << 5)
#define ATTR_LONG_NAME	(ATTR_READ_ONLY | ATTR_HIDDEN | ATTR_SYSTEM | ATTR_VOLUME_ID)

extern struct index_node_operations fat32_inode_ops;
extern struct file_operations fat32_file_ops;
extern struct dir_entry_operations fat32_dentry_ops;
extern struct super_block_operations fat32_sb_ops;

uint32_t readfatentry(struct fat32_sb_info *fsbi, uint32_t fat_entry);
uint64_t writefatentry(struct fat32_sb_info *fsbi, uint32_t fat_entry, uint32_t value);
void disk_fat32_fs_init();


#endif