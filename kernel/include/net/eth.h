#ifndef __ETH_H__
#define __ETH_H__

#include <stdint.h>

typedef struct netif_t netif_t;
typedef struct pbuf_t pbuf_t;
typedef struct arp_t arp_t;

#define ETH_FCS_LEN 4

#define ETH_BROADCAST "\xff\xff\xff\xff\xff\xff"
#define ETH_ANY "\x00\x00\x00\x00\x00\x00"
#define ETH_ZERO "\x00\x00\x00\x00\x00\x00"

enum
{
    ETH_TYPE_IP = 0x0800,     // IPv4 协议
    ETH_TYPE_ARP = 0x0806,    // ARP 协议
    ETH_TYPE_IPV6 = 0x86DD,   // IPv6 协议

    
    ETH_TYPE_MPLS = 0x8847,   // MPLS 协议
    ETH_TYPE_MPLS_MCAST = 0x8848, // MPLS 多播协议
    ETH_TYPE_VLAN = 0x8100,   // VLAN 协议
    ETH_TYPE_8021Q = 0x8100,  // 802.1Q VLAN 标记
    ETH_TYPE_8021AD = 0x88A8, // 802.1AD Q-in-Q VLAN 标记
    ETH_TYPE_PPPoE = 0x8864,  // PPPoE 协议
    ETH_TYPE_PPPOED = 0x8863, // PPPoE Discovery
    ETH_TYPE_LLC = 0xAAAA,    // LLC（逻辑链路控制）协议
    ETH_TYPE_BRP = 0xFFFF,    // Bounded Resource Protocol
    ETH_TYPE_FCOE = 0x8914,   // FCoE (Fibre Channel over Ethernet)
    ETH_TYPE_IGMP = 0x0800,   // IGMP (Internet Group Management Protocol)
    ETH_TYPE_EAPOL = 0x888E,  // EAP over LAN (802.1X认证)
    ETH_TYPE_802_3 = 0x0600,   // 802.3 以太网协议
    ETH_TYPE_802_11 = 0x8906  // 802.11 无线网络协议
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
