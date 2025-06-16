#ifndef __TYPES_NET_H__
#define __TYPES_NET_H__

// 主机字节序到网络字节序
#define htonl(l) ((((l) & 0xFF) << 24) | (((l) & 0xFF00) << 8) | (((l) & 0xFF0000) >> 8) | (((l) & 0xFF000000) >> 24))
#define htons(s) ((((s) & 0xFF) << 8) | (((s) & 0xFF00) >> 8))

// 网络字节序到主机字节序
#define ntohl(l) htonl((l))
#define ntohs(s) htons((s))

#define NET_TIMEOUT     5000

#define ETH_ADDR_LEN    6
#define IP_ADDR_LEN     4

#endif