#ifndef __MRB_H__
#define __MRB_H__

#include <stdint.h>

struct pt_entry
{
    u8      flags;              // 标志
    u8      start_head;         // 起始磁头号
    u16     start_sector : 6,   // 起始扇区号（0~5位）
            start_cylinder : 10;// 起始柱面号（6~15位）
    u8      type;               // 分区类型
    u8      end_head;           // 结束磁头号
    u16     end_sector : 6,     // 结束扇区号（0~5位）
            end_cylinder : 10;  // 结束柱面号（6~15位）
    u32     start_lba;          // 起始逻辑块地址
    u32     sectors_limit;      // 扇区限制
} __attribute__((packed));

struct disk_partition_table
{
    u8         bs_reserved[446];        // 引导代码区保留
    struct pt_entry dpte[4];            // 分区表项数组
    u16        bs_trailsig;             // 结尾标志
} __attribute__((packed));

#endif
