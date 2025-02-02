#ifndef __ADDR_H__
#define __ADDR_H__

#include <net/eth.h>

// MAC 地址拷贝
void eth_addr_copy(eth_addr_t src, eth_addr_t dst);

// 判断地址是否全为 0
u64 eth_addr_isany(eth_addr_t addr);

// 比较两 mac 地址是否相等
u64 eth_addr_cmp(eth_addr_t addr1, eth_addr_t addr2);

// IP 地址拷贝
void ip_addr_copy(ip_addr_t src, ip_addr_t dst);

// 字符串转换 IP 地址
s64 inet_aton(const s8 *str, ip_addr_t addr);

// 比较两 ip 地址是否相等
u64 ip_addr_cmp(ip_addr_t addr1, ip_addr_t addr2);

// 比较两地址是否在同一子网
u64 ip_addr_maskcmp(ip_addr_t addr1, ip_addr_t addr2, ip_addr_t mask);

// 判断地址是否是广播地址
u64 ip_addr_isbroadcast(ip_addr_t addr, ip_addr_t mask);

// 判断地址是否全为 0
u64 ip_addr_isany(ip_addr_t addr);

// 判断地址是否为多播地址
u64 ip_addr_ismulticast(ip_addr_t addr);

#endif
