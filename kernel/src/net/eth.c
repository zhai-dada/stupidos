#include <lib.h>
#include <task.h>
#include <debug.h>
#include <errno.h>
#include <net/eth.h>
#include <net/netif.h>
#include <net/addr.h>
#include <net/arp.h>

// 接收以太网帧
u64 eth_input(netif_t *netif, pbuf_t *pbuf)
{
    eth_t *eth = (eth_t *)pbuf->eth;
    eth->type = ntohs(eth->type);

    switch (eth->type)
    {
    case ETH_TYPE_IP:
        DBG_SERIAL(SERIAL_ATTR_FRONT_CYAN, SERIAL_ATTR_BACK_BLACK ,"ETH %m -> %m IP, %d\n", eth->src, eth->dst, pbuf->length);
        break;
    case ETH_TYPE_IPV6:
        DBG_SERIAL(SERIAL_ATTR_FRONT_CYAN, SERIAL_ATTR_BACK_BLACK ,"ETH %m -> %m IP6, %d\n", eth->src, eth->dst, pbuf->length);
        break;
    case ETH_TYPE_ARP:
        DBG_SERIAL(SERIAL_ATTR_FRONT_CYAN, SERIAL_ATTR_BACK_BLACK ,"ETH %m -> %m ARP, %d\n", eth->src, eth->dst, pbuf->length);
        arp_input(netif, pbuf);
        // eth_output(netif, pbuf, ((arp_t*)pbuf->eth->arp)->hwdst, ETH_TYPE_ARP, sizeof(arp_t));
        break;
    default:
        DBG_SERIAL(SERIAL_ATTR_FRONT_CYAN, SERIAL_ATTR_BACK_BLACK , "ETH %m -> %m UNKNOWN [%04X], %d\n", eth->type, eth->src, eth->dst, pbuf->length);
        pbuf_release(pbuf);
        return -EPROTO;
    }
    return 0;
}

// 发送以太网帧
u64 eth_output(netif_t *netif, pbuf_t *pbuf, eth_addr_t dst, u16 type, u32 len)
{
    pbuf->eth->type = htons(type);
    eth_addr_copy(dst, pbuf->eth->dst);
    eth_addr_copy(netif->hwaddr, pbuf->eth->src);
    pbuf->length = sizeof(eth_t) + len;

    netif_output(netif, pbuf);
    return 0;
}
