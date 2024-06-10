#ifndef __NET_H__
#define __NET_H__

#include <bit/types.h>

#define ETH_CRC_LEN 4

// 以太网帧
typedef struct eth_t
{
    eth_addr_t dst; // 目标地址
    eth_addr_t src; // 源地址
    uint16_t type;       // 类型
    uint8_t payload[0];  // 载荷
} __attribute__((packed)) eth_t;

#endif