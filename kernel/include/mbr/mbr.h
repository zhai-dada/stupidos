#ifndef __MRB_H__
#define __MRB_H__

#include <stdint.h>

struct pt_entry
{
    uint8_t flags;              // 标志
    uint8_t start_head;         // 起始磁头号
    uint16_t start_sector : 6,  // 起始扇区号（0~5位）
            start_cylinder : 10;// 起始柱面号（6~15位）
    uint8_t type;               // 分区类型
    uint8_t end_head;           // 结束磁头号
    uint16_t end_sector : 6,    // 结束扇区号（0~5位）
            end_cylinder : 10;  // 结束柱面号（6~15位）
    uint32_t start_lba;         // 起始逻辑块地址
    uint32_t sectors_limit;     // 扇区限制
} __attribute__((packed));

struct disk_partition_table
{
    uint8_t bs_reserved[446];       // 引导代码区保留
    struct pt_entry dpte[4];        // 分区表项数组
    uint16_t bs_trailsig;           // 结尾标志
} __attribute__((packed));

#endif
