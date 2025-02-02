#include <net/netif.h>
#include <net/addr.h>
#include <memory.h>
#include <debug.h>
#include <waitque.h>
#include <task.h>
#include <schedule.h>

list_t netif_list;

waitque_t input_queue;
waitque_t output_queue;

netif_t *netif_create()
{
    netif_t *netif = kmalloc(sizeof(netif_t), 0);
    memset(netif, 0, sizeof(netif_t));
    spinlock_init(&netif->rx_lock);
    spinlock_init(&netif->tx_lock);

    netif->index = list_size(&netif_list);
    sprintf(netif->name, "eth%d", netif->index);

    list_add_behind(&netif_list, &netif->node);
    list_init(&netif->rx_pbuf_list);
    list_init(&netif->tx_pbuf_list);
    DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN, SERIAL_ATTR_BACK_BLACK, "netif_create ok %x\n", netif);
    return netif;
}

// 初始化虚拟网卡
netif_t *netif_setup(void *nic, eth_addr_t hwaddr, void *output)
{
    list_init(&netif_list);
    wait_queue_init(&input_queue, NULL);
    wait_queue_init(&output_queue, NULL);

    netif_t *netif = netif_create();
    eth_addr_copy(hwaddr, netif->hwaddr);

    netif->nic = nic;
    netif->nic_output = output;
    inet_aton("192.168.10.10", netif->ipaddr);
    inet_aton("255.255.255.0", netif->netmask);
    inet_aton("192.168.10.1", netif->gateway);
    DBG_SERIAL(SERIAL_ATTR_FRONT_GREEN, SERIAL_ATTR_BACK_BLACK, "netif_setup ok %x\n", netif);
    return netif;
}

// 获取虚拟网卡
netif_t *netif_get(u64 index)
{
    netif_t *netif = NULL;
    list_t *list = &netif_list;
    for (list_t *node = list->next; node != list; node = node->next)
    {
        netif_t *ptr = container_of(node, netif_t, node);
        if (ptr->index == index)
        {
            netif = ptr;
            break;
        }
    }
    return netif;
}

// 网卡接收任务输入
void netif_input(netif_t *netif, pbuf_t *pbuf)
{
    spinlock_lock(&netif->rx_lock);

    while (netif->rx_pbuf_size >= NETIF_RX_PBUF_SIZE)
    {
        pbuf_t *nbuf = container_of(list_prev(&netif->rx_pbuf_list), pbuf_t, node);
        netif->rx_pbuf_size--;
        list_delete(&pbuf->node);
    }
    list_add_behind(&netif->rx_pbuf_list, &pbuf->node);
    netif->rx_pbuf_size++;

    wakeup(&input_queue, TASK_UNINTERRUPTIBLE);

    spinlock_unlock(&netif->rx_lock);
}

// 网卡发送任务输出
void netif_output(netif_t *netif, pbuf_t *pbuf)
{
    spinlock_lock(&netif->tx_lock);
    list_add_behind(&netif->tx_pbuf_list, &pbuf->node);
    netif->tx_pbuf_size++;
    wakeup(&output_queue, TASK_UNINTERRUPTIBLE);
    
    spinlock_unlock(&netif->tx_lock);
}

u64 net_output_thread(u64 arg)
{
    list_t *node = &netif_list;
    pbuf_t *pbuf = NULL;
    netif_t *netif = NULL;
    while (1)
    {
        u64 count = 0;
        for (node = node->next; node != &netif_list; node = node->next)
        {
            netif = container_of(node, netif_t, node);
            if (!list_is_empty(&netif->tx_pbuf_list))
            {
                spinlock_lock(&netif->tx_lock);
                pbuf = container_of(list_prev(&netif->tx_pbuf_list), pbuf_t, node);
                netif->tx_pbuf_size--;
                list_delete(&pbuf->node);
                spinlock_unlock(&netif->tx_lock);

                netif->nic_output(netif, pbuf);
                count++;
            }
        }
        if (!count)
        {
            sleep_on(&output_queue);
        }
    }
}

u64 net_input_thread(u64 arg)
{
    list_t *node = &netif_list;
    pbuf_t *pbuf = NULL;
    netif_t *netif = NULL;
    while (1)
    {
        u64 count = 0;
        for (node = node->next; node != &netif_list; node = node->next)
        {
            netif = container_of(node, netif_t, node);
            if (!list_is_empty(&netif->rx_pbuf_list))
            {
                spinlock_lock(&netif->rx_lock);
                pbuf = container_of(list_prev(&netif->rx_pbuf_list), pbuf_t, node);
                netif->rx_pbuf_size--;
                list_delete(&pbuf->node);
                spinlock_unlock(&netif->rx_lock);

                eth_input(netif, pbuf);
                
                count++;                
            }
        }
        if (!count)
        {
            sleep_on(&input_queue);
        }
    }
}