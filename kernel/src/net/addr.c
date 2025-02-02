#include <errno.h>
#include <lib.h>
#include <net/addr.h>
#include <printk.h>

// MAC 地址拷贝
void eth_addr_copy(eth_addr_t src, eth_addr_t dst)
{
    memcpy(src, dst, ETH_ADDR_LEN);
    return;
}

// 判断地址是否全为 0
u64 eth_addr_isany(eth_addr_t addr)
{
    for (u64 i = 0; i < ETH_ADDR_LEN; i++)
    {
        if (addr[i] != 0)
        {
            return 0;
        }
    }
    return 1;
}

// 比较两 mac 地址是否相等
u64 eth_addr_cmp(eth_addr_t addr1, eth_addr_t addr2)
{
    for (u64 i = 0; i < ETH_ADDR_LEN; i++)
    {
        if (addr1[i] != addr2[i])
        {
            return 0;
        }
    }
    return 1;
}

// 复制src 到 dst
void ip_addr_copy(ip_addr_t src, ip_addr_t dst)
{
    *(u32 *)dst = *(u32 *)src;
}

// 字符串转换 IP 地址
s64 inet_aton(const s8 *str, ip_addr_t addr)
{
    const s8 *ptr = str;

    u8 parts[4];

    for (u64 i = 0; i < 4 && *ptr != '\0'; i++, ptr++)
    {
        u8 value = 0;
        u8 k = 0;
        for (; 1; ptr++, k++)
        {
            if (*ptr == '.' || *ptr == '\0')
            {
                break;
            }
            if (!is_digit(*ptr))
            {
                return -EFAULT;
            }
            value = value * 10 + ((*ptr) - '0');
        }
        if (k == 0 || value < 0 || value > 255)
        {
            return -EFAULT;
        }
        parts[i] = value;
    }

    ip_addr_copy(parts, addr);
    return 0;
}

// 比较两 ip 地址是否相等
u64 ip_addr_cmp(ip_addr_t addr1, ip_addr_t addr2)
{
    u32 a1 = *(u32 *)addr1;
    u32 a2 = *(u32 *)addr2;
    return a1 == a2;
}

// 比较两地址是否在同一子网
u64 ip_addr_maskcmp(ip_addr_t addr1, ip_addr_t addr2, ip_addr_t mask)
{
    u32 a1 = *(u32 *)addr1;
    u32 a2 = *(u32 *)addr2;
    u32 m = *(u32 *)mask;
    return (a1 & m) == (a2 & m);
}

// 判断地址是否是广播地址
u64 ip_addr_isbroadcast(ip_addr_t addr, ip_addr_t mask)
{
    u32 a = *(u32 *)addr;
    u32 m = *(u32 *)mask;
    return (a & ~m) == (-1 & (~m)) || a == -1 || a == 0;
}

// 判断地址是否全为 0
u64 ip_addr_isany(ip_addr_t addr)
{
    u32 a = *(u32 *)addr;
    return a == 0;
}

// 判断地址是否为多播地址 多播地址范围 0xE0000000(224.0.0.0) - 0xEFFFFFFF(239.255.255.255)
u64 ip_addr_ismulticast(ip_addr_t addr)
{
    u32 a = *(u32 *)addr;
    return (a & ntohl(0xF0000000)) == ntohl(0xE0000000);
}
