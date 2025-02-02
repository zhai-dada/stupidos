#ifndef __PBUF_H__
#define __PBUF_H__

#include <stdint.h>
#include <lib.h>
#include <net/eth.h>

typedef struct pbuf_t
{
    list_t node; // 列表节点
    u64 length;    // 载荷长度
    u32 count;        // 引用计数

    list_t tcpnode; // TCP 缓冲节点
    u8 *data;            // TCP 数据指针
    u64 total;        // TCP 总长度 头 + 数据长度
    u64 size;         // TCP 数据长度
    u32 seqno;           // TCP 序列号

    union
    {
        u8 payload[0]; // 载荷
        eth_t eth[0];  // 以太网帧
    };
} pbuf_t;

// 分配pbuf空间
void pbuf_alloc(u64 count);

// 获取空闲缓冲
pbuf_t *pbuf_get();
// 加入空闲
void pbuf_release(pbuf_t *pbuf);

// 释放缓冲
void pbuf_free(pbuf_t *pbuf);

void pbuf_delete_list(pbuf_t* pbuf);

// 初始化数据包缓冲
void pbuf_init();

#endif
