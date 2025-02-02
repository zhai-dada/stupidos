/**
 * types.h
 */
#ifndef __BITS_TYPES_H__
#define __BITS_TYPES_H__

typedef unsigned char   u8;
typedef unsigned short  u16;
typedef unsigned int    u32;
typedef unsigned long   u64;
typedef char            s8;
typedef short           s16;
typedef int             s32;
typedef long            s64;

/**
 * 网络type
 */
// 主机字节序到网络字节序
#define htonl(l) ((((l) & 0xFF) << 24) | (((l) & 0xFF00) << 8) | (((l) & 0xFF0000) >> 8) | (((l) & 0xFF000000) >> 24))
#define htons(s) ((((s) & 0xFF) << 8) | (((s) & 0xFF00) >> 8))

// 网络字节序到主机字节序
#define ntohl(l) htonl((l))
#define ntohs(s) htons((s))

#define NET_TIMEOUT     5000

#define ETH_ADDR_LEN    6
#define IP_ADDR_LEN     4

typedef u8 eth_addr_t[ETH_ADDR_LEN]; // MAC 地址
typedef u8 ip_addr_t[IP_ADDR_LEN];   // IPV4 地址

#endif