#ifndef __DISK_H__
#define __DISK_H__

#include <disk/block.h>

// 硬盘0端口定义
#define PORT_DISK0_DATA             0x1f0                   // 数据端口
#define PORT_DISK0_ERR_FEATURE      0x1f1                   // 错误/特征寄存器
#define PORT_DISK0_SECTOR_CNT       0x1f2                   // 扇区计数寄存器
#define PORT_DISK0_SECTOR_LOW       0x1f3                   // 扇区低字节寄存器
#define PORT_DISK0_SECTOR_MID       0x1f4                   // 扇区中间字节寄存器
#define PORT_DISK0_SECTOR_HIGH      0x1f5                   // 扇区高字节寄存器
#define PORT_DISK0_DEVICE           0x1f6                   // 设备寄存器
#define PORT_DISK0_STATUS_CMD       0x1f7                   // 状态/命令寄存器

#define PORT_DISK0_ALT_STA_CTL      0x3f6                   // 备用状态/控制寄存器

// 硬盘1端口定义
#define PORT_DISK1_DATA             0x170                   // 数据端口
#define PORT_DISK1_ERR_FEATURE      0x171                   // 错误/特征寄存器
#define PORT_DISK1_SECTOR_CNT       0x172                   // 扇区计数寄存器
#define PORT_DISK1_SECTOR_LOW       0x173                   // 扇区低字节寄存器
#define PORT_DISK1_SECTOR_MID       0x174                   // 扇区中间字节寄存器
#define PORT_DISK1_SECTOR_HIGH      0x175                   // 扇区高字节寄存器
#define PORT_DISK1_DEVICE           0x176                   // 设备寄存器
#define PORT_DISK1_STATUS_CMD       0x177                   // 状态/命令寄存器

#define PORT_DISK1_ALT_STA_CTL      0x376                   // 备用状态/控制寄存器

// 硬盘状态位定义
#define DISK_STATUS_BUSY            (1 << 7)                // 忙位
#define DISK_STATUS_READY           (1 << 6)                // 就绪位
#define DISK_STATUS_SEEK            (1 << 4)                // 寻道位
#define DISK_STATUS_REQ             (1 << 3)                // 请求位
#define DISK_STATUS_ERROR           (1 << 0)                // 错误位

#define ATA_READ_CMD		0x20    //28 LBA read
#define ATA_WRITE_CMD		0x30    //28 LBA write

extern struct block_device_operation disk_device_operation;
extern struct request_queue disk_request;
extern uint64_t disk_flags;

void disk_init(void);

#endif