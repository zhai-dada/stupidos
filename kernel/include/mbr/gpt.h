#ifndef __GPT_H__

#define __GPT_H__

#include <mbr/mbr.h>
#include <stdint.h>

struct gpt_head
{
    uint64_t signature;            // 签名
    uint32_t revision;             // 版本
    uint32_t header_size;          // 头部大小
    uint32_t header_crc32;         // 头部CRC32校验值
    uint32_t reserved;             // 保留字段
    uint64_t my_lba;               // 我的LBA
    uint64_t alternate_lba;        // 替代LBA
    uint64_t first_usable_lba;     // 第一个可用的LBA
    uint64_t last_usable_lba;      // 最后一个可用的LBA
    uint64_t disk_guid[2];         // 磁盘GUID
    uint64_t pt_entry_lba;         // 分区项LBA
    uint32_t numofpentry;          // 分区项数量
    uint32_t size_of_pt_entry;     // 分区项大小
    uint32_t pt_entry_array_crc32; // 分区项数组CRC32校验值
} __attribute__((packed));

struct gpt_pt_entry
{
    uint64_t pt_guid[2]; // 分区类型GUID
    uint64_t up_guid[2]; // 唯一分区GUID
    uint64_t start_lba;  // 起始LBA
    uint64_t end_lba;    // 结束LBA
    uint64_t attributes; // 属性
    uint16_t p_name[36]; // 分区名称
} __attribute__((packed));

#endif