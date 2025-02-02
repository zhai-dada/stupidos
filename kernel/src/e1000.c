#include <errno.h>
#include <memory.h>
#include <pci/pci.h>
#include <task.h>
#include <interrupt.h>
#include <apic.h>
#include <memory.h>
#include <debug.h>
#include <e1000.h>
#include <task.h>
#include <schedule.h>

static void e1000_reset(e1000_t *e1000);

// 接收数据包
static void recv_packet(e1000_t *e1000)
{
    u64 head = min32(e1000->membase + E1000_RDH);
    u64 tail = min32(e1000->membase + E1000_RDT);

    rx_desc_t *rx = &e1000->rx_desc[e1000->rx_cur];
    if ((rx->status & RS_DD))
    {
        pbuf_t *pbuf_recv = container_of((u8(*)[])P_TO_V(rx->addr), pbuf_t, payload);
        DBG_SERIAL(
            SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "head %lx tail %lx current %lx ETH R %018lx [0x%04X]: %m -> %m, %d\n",
            head, tail, e1000->rx_cur,
            pbuf_recv,
            ntohs(pbuf_recv->eth->type),
            pbuf_recv->eth->src,
            pbuf_recv->eth->dst,
            rx->length);
        pbuf_recv->length = rx->length;
        
        pbuf_t* pbuf_next = pbuf_get();
        rx->addr = V_TO_P(pbuf_next->payload);
        rx->status = 0;

        netif_input(e1000->netif, pbuf_recv);

        mout32(e1000->membase + E1000_RDT, e1000->rx_cur);
        e1000->rx_cur = (e1000->rx_cur + 1) % RX_DESC_NR;
        mout32(e1000->membase + E1000_RDH, e1000->rx_cur);
    }
}

void send_packet(netif_t *netif, pbuf_t *pbuf)
{
    e1000_t *e1000 = &obj;
    tx_desc_t *tx = &e1000->tx_desc[e1000->tx_cur];
    u64 head = min32(e1000->membase + E1000_TDH);
    u64 tail = min32(e1000->membase + E1000_TDT);
    
    tx->addr = V_TO_P(pbuf->payload);
    tx->length = pbuf->length;
    tx->cmd = TCMD_EOP | TCMD_RS | TCMD_RPS | TCMD_IFCS;
    tx->status = 0;

    
    mout32(e1000->membase + E1000_TDH, e1000->tx_cur);
    e1000->tx_cur = (e1000->tx_cur + 1) % TX_DESC_NR;
    mout32(e1000->membase + E1000_TDT, e1000->tx_cur);
    
    
    DBG_SERIAL(
        SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "head %lx tail %lx current %lx ETH S %018lx [0x%04x]: %m -> %m %d\n",
        head, tail, e1000->tx_cur,
        pbuf,
        htons(pbuf->eth->type),
        pbuf->eth->src,
        pbuf->eth->dst,
        pbuf->length);
}

// 发送测试数据包
// void test_e1000_send_packet(s8 *data)
// {
//     e1000_t *e1000 = &obj;
//     pbuf_t *pbuf = pbuf_get();

//     memcpy(e1000->mac, pbuf->eth->src, 6);
//     memcpy("\xff\xff\xff\xff\xff\xff", pbuf->eth->dst, 6);

//     pbuf->eth->type = 0x8680;
//     pbuf->length = 1500 + sizeof(pbuf_t);

//     strcpy(pbuf->eth->payload, data);
//     send_packet(e1000->netif, pbuf);
//     pbuf_put(pbuf);
// }
void test_e1000_send_packet(s8 *data)
{
    e1000_t *e1000 = &obj;
    pbuf_t *pbuf = pbuf_get();
    netif_t* netif = netif_get(0);

    memcpy(e1000->mac, pbuf->eth->src, 6);
    memcpy("\xff\xff\xff\xff\xff\xff", pbuf->eth->dst, 6);

    pbuf->eth->type = 0x8680;
    pbuf->length = 1500 + sizeof(eth_t);

    strcpy(pbuf->eth->payload, data);
    // netif_output(netif, pbuf);
    eth_output(netif, pbuf, ETH_BROADCAST, ETH_TYPE_ARP, 32);
    // send_packet(e1000->netif, pbuf);
    // pbuf_put(pbuf);
}
// 中断处理函数
static void e1000_handler()
{
    e1000_t *e1000 = &obj;

    u32 status = min32(e1000->membase + E1000_ICR);
    if (status == 0)
    {
        return;
    }
    DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "e1000 interrupt fired status %X\n", status);

    // 传输描述符写回，表示有一个数据包发送完毕
    if ((status & IM_TXDW))
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "e1000 TXDW...\n");
    }

    // 传输队列为空，并且传输进程阻塞
    if ((status & IM_TXQE))
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "e1000 TXQE...\n");
    }

    // 连接状态改变
    if (status & IM_LSC)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "e1000 link state changed...\n");
        // u32 e1000_status = min32(e1000->membase +  E1000_STATUS);
        // e1000->link = (e1000_status & STATUS_LU != 0);
    }

    // Overrun
    if (status & IM_RXO)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "e1000 RXO...\n");
        // overrun
    }

    if (status & IM_RXDMT0)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "e1000 RXDMT0...\n");
    }

    if (status & IM_RXT0)
    {
        recv_packet(e1000);
    }

    // 去掉已知中断状态，其他的如果发生再说；
    status &= ~IM_TXDW & ~IM_TXQE & ~IM_LSC & ~IM_RXO;
    status &= ~IM_RXDMT0 & ~IM_RXT0 & ~IM_ASSERTED;
    if (status)
    {
        // DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "e1000 status unhandled %d\n", status);
    }
    EOI();
}

// 检测只读存储器
static void e1000_eeprom_detect(e1000_t *e1000)
{
    mout32(e1000->membase + E1000_EERD, 0x1);
    for (u64 i = 0; i < 1000; i++)
    {
        u32 val = min32(e1000->membase + E1000_EERD);
        if (val & 0x02)
        {
            e1000->eeprom = 1;
        }
        else
        {
            e1000->eeprom = 0;
        }
    }
    return;
}

// 读取只读存储器
static u16 e1000_eeprom_read(e1000_t *e1000, u8 addr)
{
    u32 tmp;
    if (e1000->eeprom)
    {
        mout32(e1000->membase + E1000_EERD, 1 | (u32)addr << 2);
        while (!((tmp = min32(e1000->membase + E1000_EERD)) & (1 << 1)))
            ;
    }
    else
    {
        mout32(e1000->membase + E1000_EERD, 1 | (u32)addr << 2);
        while (!((tmp = min32(e1000->membase + E1000_EERD)) & (1 << 1)))
            ;
    }
    return (tmp >> 16) & 0xFFFF;
}

// 读取 MAC 地址
static void e1000_read_mac(e1000_t *e1000)
{
    e1000_eeprom_detect(e1000);
    if (e1000->eeprom)
    {
        u16 val;
        val = e1000_eeprom_read(e1000, 0);
        e1000->mac[0] = val & 0xFF;
        e1000->mac[1] = val >> 8;

        val = e1000_eeprom_read(e1000, 1);
        e1000->mac[2] = val & 0xFF;
        e1000->mac[3] = val >> 8;

        val = e1000_eeprom_read(e1000, 2);
        e1000->mac[4] = val & 0xFF;
        e1000->mac[5] = val >> 8;
    }
    else
    {
        u8 *mac = (u8 *)e1000->membase + 0x5400;
        for (u32 i = 5; i >= 0; i--)
        {
            e1000->mac[i] = mac[i];
        }
    }

    DBG_SERIAL(
        SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "E1000e MAC: %x:%x:%x:%x:%x:%x\n",
        e1000->mac[0], e1000->mac[1], e1000->mac[2],
        e1000->mac[3], e1000->mac[4], e1000->mac[5]);
}

// 重置网卡
static void e1000_reset(e1000_t *e1000)
{
    e1000_read_mac(e1000);

    // 初始化组播表数组
    for (u32 i = E1000_MAT0; i < E1000_MAT1; i += 4)
    {
        mout32(e1000->membase + i, 0);
    }
    // 禁用中断
    mout32(e1000->membase + E1000_IMS, 0);

    // 接收初始化
    e1000->rx_desc = (rx_desc_t *)kmalloc(4096, 0);
    e1000->rx_cur = 0;
    mout64(e1000->membase + E1000_RDBAL, V_TO_P(e1000->rx_desc));
    mout32(e1000->membase + E1000_RDLEN, sizeof(rx_desc_t) * RX_DESC_NR << 7);

    // 接收描述符头尾指针
    mout32(e1000->membase + E1000_RDH, 0);
    mout32(e1000->membase + E1000_RDT, RX_DESC_NR - 1);

    // 接收描述符地址
    for (u64 i = 0; i < RX_DESC_NR; ++i)
    {
        e1000->rx_desc[i].addr = V_TO_P(pbuf_get()->payload);
        e1000->rx_desc[i].status = 0;
    }

    // 接收控制寄存器
    u32 value = 0;
    value |= RCTL_EN | RCTL_SBP | RCTL_UPE;
    value |= RCTL_MPE | RCTL_LBM_NONE | RTCL_RDMTS_HALF;
    // value |= RCTL_MPE | RCTL_LBM_MAC | RTCL_RDMTS_HALF;
    value |= RCTL_BAM | RCTL_SECRC | RCTL_BSIZE_2048;
    mout32(e1000->membase + E1000_RCTL, value);

    // 传输初始化
    e1000->tx_desc = (tx_desc_t *)kmalloc(4096, 0);
    e1000->tx_cur = 0;
    mout64(e1000->membase + E1000_TDBAL, (V_TO_P(e1000->tx_desc)));
    mout32(e1000->membase + E1000_TDLEN, sizeof(tx_desc_t) * TX_DESC_NR << 7);

    // 传输描述符头尾指针
    mout32(e1000->membase + E1000_TDH, 0);
    mout32(e1000->membase + E1000_TDT, 0);

    // 传输描述符基地址
    for (u64 i = 0; i < TX_DESC_NR; ++i)
    {
        e1000->tx_desc[i].addr = V_TO_P(pbuf_get()->payload);
        e1000->tx_desc[i].status = TS_DD;
    }

    // 传输控制寄存器
    value = 0;
    value |= TCTL_EN | TCTL_PSP | TCTL_RTLC;
    value |= 0x10 << TCTL_CT;
    value |= 0x40 << TCTL_COLD;
    mout32(e1000->membase + E1000_TCTL, value);

    // 初始化中断
    value = 0;
    value = IM_RXT0 | IM_RXO | IM_RXDMT0 | IM_RXSEQ | IM_LSC;
    value |= IM_TXQE | IM_TXDW | IM_TXDLOW;
    mout32(e1000->membase + E1000_IMS, value);
}
irq_controller e1000e_controller =
    {
        .enable = ioapic_enable,
        .disable = ioapic_disable,
        .install = ioapic_install,
        .uninstall = ioapic_uninstall,
        .ack = ioapic_edge_ack,
};
// 查找网卡设备
static pci_device_t *find_e1000_device()
{
    pci_device_t *device = NULL;
    device = pci_find_device(VENDORID, DEVICEID_E1000);
    return device;
}

// 初始化 e1000
void e1000_init()
{
    pci_device_t *device = find_e1000_device();
    if (!device)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_BLUE, SERIAL_ATTR_BACK_BLACK, "PCI e1000 ethernet card not exists...\n");
        return;
    }

    e1000_t *e1000 = &obj;
    e1000->tx_waiter = NULL;

    strcpy(e1000->name, "e1000");

    e1000->device = device;
    pci_enable_busmastering(device);

    e1000->membase = buffer_remap(device->bar[0].iobase, device->bar[0].size);

    pbuf_init();
    e1000_reset(e1000);
    e1000->netif = netif_setup(e1000, e1000->mac, send_packet);



    struct IOAPIC_RET_ENTRY entry;
    entry.vector_num = 0x37;
    entry.deliver_mode = IOAPIC_FIXED;
    entry.dest_mode = IOAPIC_DEST_MODE_PHYSICAL;
    entry.deliver_status = IOAPIC_DELI_STATUS_IDLE;
    entry.irr = IOAPIC_IRR_RESET;
    entry.trigger = IOAPIC_TRIGGER_EDGE;
    entry.polarity = IOAPIC_POLARITY_HIGH;
    entry.mask = IOAPIC_MASK_MASKED;
    entry.reserved = 0;
    entry.destination.physical.reserved1 = 0;
    entry.destination.physical.reserved2 = 0;
    entry.destination.physical.phy_dest = 0;
    register_irq(0x37, &entry, &e1000_handler, NULL, &e1000e_controller, "e1000e");

    msi_addr_t e1000e_msi = {.base = 0xFEE, .dest = 0, .reserved = 0x00, .rh = 0, .dm = 0, .xx = 0};
    // 开启 PCI MSI中断
    pci_out32(device->bus, device->dev, device->func, 0xd0, pci_in32(device->bus, device->dev, device->func, 0xd0) | 0x10000);
    pci_out32(device->bus, device->dev, device->func, 0xd4, *(u32 *)&e1000e_msi);
    pci_out32(device->bus, device->dev, device->func, 0xd8, 0x00000000);
    pci_out32(device->bus, device->dev, device->func, 0xdc, 0x37);
    return;
}