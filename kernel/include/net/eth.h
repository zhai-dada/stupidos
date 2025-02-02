#ifndef __ETH_H__
#define __ETH_H__

#include <stdint.h>

typedef struct netif_t netif_t;
typedef struct pbuf_t pbuf_t;
typedef struct arp_t arp_t;

#define ETH_FCS_LEN 4

#define ETH_BROADCAST "\xff\xff\xff\xff\xff\xff"
#define ETH_ANY "\x00\x00\x00\x00\x00\x00"

enum
{
    ETH_TYPE_IP = 0x0800,   // IPV4 协议
    ETH_TYPE_ARP = 0x0806,  // ARP 协议
    ETH_TYPE_IPV6 = 0x86DD, // IPV6 协议
};

// 以太网帧
typedef struct eth_t
{
    eth_addr_t dst; // 目标地址
    eth_addr_t src; // 源地址
    u16 type;       // 类型
    union
    {
        u8 payload[0]; // 载荷
        u8 arp[0];  // arp 包
        u8 ip[0];    // ip 包
    };

}__attribute__((packed)) eth_t;

// 以太网解析
u64 eth_input(netif_t *netif, pbuf_t *pbuf);
u64 eth_output(netif_t *netif, pbuf_t *pbuf, eth_addr_t dst, u16 type, u32 len);

#endif
