#ifndef __FAT32_H__
#define __FAT32_H__

#include <stdint.h>

struct fat32_bootsector
{
    u8 bs_jmpboot[3];      // 引导码
    u8 bs_oemname[8];      // OEM名称
    u16 bpb_bytespersec;   // 每扇区字节数
    u8 bpb_secperclus;     // 每簇扇区数
    u16 bpb_rsvdseccnt;    // 保留扇区数
    u8 bpb_numfats;        // FAT表个数
    u16 bpb_rootentcnt;    // 根目录条目数
    u16 bpb_totsec16;      // 总扇区数（16位）
    u8 bpb_media;          // 媒体描述符
    u16 bpb_fatsz16;       // 每FAT扇区数（16位）
    u16 bpb_secpertrk;     // 每磁道扇区数
    u16 bpb_numheads;      // 磁头数
    u32 bpb_hiddsec;       // 隐藏扇区数
    u32 bpb_totsec32;      // 总扇区数（32位）
    u32 bpb_fatsz32;       // 每FAT扇区数（32位）
    u16 bpb_extflags;      // 扩展标志
    u16 bpb_fsver;         // 文件系统版本
    u32 bpb_rootclus;      // 根目录簇号
    u16 bpb_fsinfo;        // FSINFO扇区号
    u16 bpb_bkbootsec;     // 启动扇区备份
    u8 bpb_reserved[12];   // 保留字段
    u8 bs_drvnum;          // 驱动器编号
    u8 bs_reserved1;       // 保留字段1
    u8 bs_bootsig;         // 启动标记
    u32 bs_volid;          // 卷序列号
    u8 bs_vollab[11];      // 卷标
    u8 bs_filfstype[8];    // 文件系统类型
    u8 bootcode[420];      // 引导代码
    u16 bs_trailsig;       // 结尾标记
} __attribute__((packed));

struct fat32_fsinfo
{
    u32 fsi_leadsig;       // FSINFO标志
    u8 fsi_reserved1[480]; // 保留字段
    u32 fsi_strucsig;      // 结构标志
    u32 fsi_free_count;    // 空闲簇计数
    u32 fsi_nxt_free;      // 下一个空闲簇
    u8 fsi_reserved2[12];  // 保留字段
    u32 fsi_trailsig;      // 结尾标记
} __attribute__((packed));

struct fat32_dir
{
    u8 dir_name[11];       // 目录名
    u8 dir_attr;           // 文件属性
    u8 dir_ntres;          // NT保留字段
    u8 dir_crttimetenth;   // 创建时间1/10秒
    u16 dir_crttime;       // 创建时间
    u16 dir_crtdate;       // 创建日期
    u16 dir_lastaccdate;   // 最后访问日期
    u16 dir_fstclushi;     // 起始簇号（高16位）
    u16 dir_wrttime;       // 最后修改时间
    u16 dir_wrtdate;       // 最后修改日期
    u16 dir_fstcluslo;     // 起始簇号（低16位）
    u32 dir_filesize;      // 文件大小
} __attribute__((packed));

struct fat32_ldir
{
    u8 ldir_ord;           // 目录顺序号
    u16 ldir_name1[5];     // 目录名1
    u8 ldir_attr;          // 文件属性
    u8 ldir_type;          // 目录项类型
    u8 ldir_chksum;        // 校验和
    u16 ldir_name2[6];     // 目录名2
    u16 ldir_fstcluslo;    // 起始簇号（低16位）
    u16 ldir_name3[2];     // 目录名3
} __attribute__((packed));

struct fat32_sb_info
{
    u64 start_sector;              // 起始扇区
    u64 sector_count;              // 扇区数量

    u64 sector_per_cluster;            // 每簇扇区数
    u64 bytes_per_cluster;             // 每簇字节数
    u64 bytes_per_sector;              // 每扇区字节数

    u64 data_firstsector;          // 数据区起始扇区
    u64 fat1_firstsector;          // FAT1起始扇区
    u64 sector_per_fat;            // 每FAT扇区数
    u64 numfats;                   // FAT表个数

    u64 fsinfo_sector_infat;       // FAT中的FSINFO扇区
    u64 bootsector_bk_infat;       // FAT中的引导扇区备份

    struct fat32_fsinfo *fat_fsinfo;    // FAT32文件系统信息
};

struct fat32_inode_info
{
    u64 first_cluster;         // 起始簇号
    u64 dentry_location;       // 目录项位置（0表示根目录，1表示无效）
    u64 dentry_position;       // 目录项偏移量

    u16 create_date;           // 创建日期
    u16 create_time;           // 创建时间

    u16 write_date;            // 最后修改日期
    u16 write_time;            // 最后修改时间
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

u32 readfatentry(struct fat32_sb_info *fsbi, u32 fat_entry);
u64 writefatentry(struct fat32_sb_info *fsbi, u32 fat_entry, u32 value);
void disk_fat32_fs_init();


#endif