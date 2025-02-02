#include <net/arp.h>
#include <errno.h>
#include <net/addr.h>
#include <debug.h>

static u64 arp_reply(netif_t *netif, pbuf_t *pbuf)
{
    arp_t *arp = pbuf->eth->arp;

    arp->opcode = htons(ARP_OP_REPLY);

    eth_addr_copy(arp->hwsrc, arp->hwdst);
    ip_addr_copy(arp->ipsrc, arp->ipdst);

    eth_addr_copy(netif->hwaddr, arp->hwsrc);
    ip_addr_copy(netif->ipaddr, arp->ipsrc);

    pbuf->count++;

    return eth_output(netif, pbuf, arp->hwdst, ETH_TYPE_ARP, sizeof(arp_t));
}

u64 arp_input(netif_t *netif, pbuf_t *pbuf)
{
    arp_t *arp = pbuf->eth->arp;

    // 只支持 以太网
    if (ntohs(arp->hwtype) != ARP_HARDWARE_ETH)
    {
        return -EPROTO;
    }

    // 只支持 IP
    if (ntohs(arp->proto) != ARP_PROTOCOL_IP)
    {
        return -EPROTO;
    }

    // 如果请求的目的地址不是本机 ip 则忽略
    if (!ip_addr_cmp(netif->ipaddr, arp->ipdst))
    {
        return -EPROTO;
    }

    u16 type = ntohs(arp->opcode);
    switch (type)
    {
    case ARP_OP_REQUEST:
        return arp_reply(netif, pbuf);
    case ARP_OP_REPLY:
        // return arp_refresh(netif, pbuf);
    default:
        return -EPROTO;
    }
    return 0;
}
