#ifndef __GPT_H__

#define __GPT_H__

#include <mbr/mbr.h>
#include <stdint.h>

struct gpt_head
{
    u64 signature;            // 签名
    u32 revision;             // 版本
    u32 header_size;          // 头部大小
    u32 header_crc32;         // 头部CRC32校验值
    u32 reserved;             // 保留字段
    u64 my_lba;               // 我的LBA
    u64 alternate_lba;        // 替代LBA
    u64 first_usable_lba;     // 第一个可用的LBA
    u64 last_usable_lba;      // 最后一个可用的LBA
    u64 disk_guid[2];         // 磁盘GUID
    u64 pt_entry_lba;         // 分区项LBA
    u32 numofpentry;          // 分区项数量
    u32 size_of_pt_entry;     // 分区项大小
    u32 pt_entry_array_crc32; // 分区项数组CRC32校验值
} __attribute__((packed));

struct gpt_pt_entry
{
    u64 pt_guid[2]; // 分区类型GUID
    u64 up_guid[2]; // 唯一分区GUID
    u64 start_lba;  // 起始LBA
    u64 end_lba;    // 结束LBA
    u64 attributes; // 属性
    u16 p_name[36]; // 分区名称
} __attribute__((packed));

#endif