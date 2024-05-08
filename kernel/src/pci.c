#include <pci/pci.h>
#include <errno.h>


#define PCI_CONF_ADDR 0xCF8
#define PCI_CONF_DATA 0xCFC

#define PCI_BAR_NR 6

#define PCI_ADDR(bus, dev, func, addr) (((uint32_t)(0x80000000) | ((bus & 0xff) << 16) | ((dev & 0x1f) << 11) | ((func & 0x7) << 8) | addr))

struct
{
    uint32_t classcode;
    char *name;
} pci_classnames[] =
{
    {0x000000, "Non-VGA unclassified device"},
    {0x000100, "VGA compatible unclassified device"},
    {0x010000, "SCSI storage controller"},
    {0x010100, "IDE interface"},
    {0x010200, "Floppy disk controller"},
    {0x010300, "IPI bus controller"},
    {0x010400, "RAID bus controller"},
    {0x018000, "Unknown mass storage controller"},
    {0x020000, "Ethernet controller"},
    {0x020100, "Token ring network controller"},
    {0x020200, "FDDI network controller"},
    {0x020300, "ATM network controller"},
    {0x020400, "ISDN controller"},
    {0x028000, "Network controller"},
    {0x030000, "VGA controller"},
    {0x030100, "XGA controller"},
    {0x030200, "3D controller"},
    {0x038000, "Display controller"},
    {0x040000, "Multimedia video controller"},
    {0x040100, "Multimedia audio controller"},
    {0x040200, "Computer telephony device"},
    {0x048000, "Multimedia controller"},
    {0x050000, "RAM memory"},
    {0x050100, "FLASH memory"},
    {0x058000, "Memory controller"},
    {0x060000, "Host bridge"},
    {0x060100, "ISA bridge"},
    {0x060200, "EISA bridge"},
    {0x060300, "MicroChannel bridge"},
    {0x060400, "PCI bridge"},
    {0x060500, "PCMCIA bridge"},
    {0x060600, "NuBus bridge"},
    {0x060700, "CardBus bridge"},
    {0x060800, "RACEway bridge"},
    {0x060900, "Semi-transparent PCI-to-PCI bridge"},
    {0x060A00, "InfiniBand to PCI host bridge"},
    {0x068000, "Bridge"},
    {0x070000, "Serial controller"},
    {0x070100, "Parallel controller"},
    {0x070200, "Multiport serial controller"},
    {0x070300, "Modem"},
    {0x078000, "Communication controller"},
    {0x080000, "PIC"},
    {0x080100, "DMA controller"},
    {0x080200, "Timer"},
    {0x080300, "RTC"},
    {0x080400, "PCI Hot-plug controller"},
    {0x088000, "System peripheral"},
    {0x090000, "Keyboard controller"},
    {0x090100, "Digitizer Pen"},
    {0x090200, "Mouse controller"},
    {0x090300, "Scanner controller"},
    {0x090400, "Gameport controller"},
    {0x098000, "Input device controller"},
    {0x0A0000, "Generic Docking Station"},
    {0x0A8000, "Docking Station"},
    {0x0B0000, "386"},
    {0x0B0100, "486"},
    {0x0B0200, "Pentium"},
    {0x0B1000, "Alpha"},
    {0x0B2000, "Power PC"},
    {0x0B3000, "MIPS"},
    {0x0B4000, "Co-processor"},
    {0x0C0000, "FireWire (IEEE 1394)"},
    {0x0C0100, "ACCESS Bus"},
    {0x0C0200, "SSA"},
    {0x0C0300, "USB Controller"},
    {0x0C0400, "Fiber Channel"},
    {0x0C0500, "SMBus"},
    {0x0C0600, "InfiniBand"},
    {0x0D0000, "IRDA controller"},
    {0x0D0100, "Consumer IR controller"},
    {0x0D1000, "RF controller"},
    {0x0D8000, "Wireless controller"},
    {0x0E0000, "I2O"},
    {0x0F0000, "Satellite TV controller"},
    {0x0F0100, "Satellite audio communication controller"},
    {0x0F0300, "Satellite voice communication controller"},
    {0x0F0400, "Satellite data communication controller"},
    {0x100000, "Network and computing encryption device"},
    {0x101000, "Entertainment encryption device"},
    {0x108000, "Encryption controller"},
    {0x110000, "DPIO module"},
    {0x110100, "Performance counters"},
    {0x111000, "Communication synchronizer"},
    {0x118000, "Signal processing controller"},
    {0x000000, NULL}
};

typedef struct pci_command_t
{
    uint8_t io_space : 1;
    uint8_t memory_space : 1;
    uint8_t bus_master : 1;
    uint8_t special_cycles : 1;
    uint8_t memory_write_invalidate_enable : 1;
    uint8_t vga_palette_snoop : 1;
    uint8_t parity_error_response : 1;
    uint8_t reserved0 : 1;
    uint8_t serr : 1;
    uint8_t fast_back_to_back : 1;
    uint8_t interrupt_disable : 1;
    uint8_t reserved1 : 5;
} __attribute__((packed)) pci_command_t;

typedef struct pci_status_t
{
    uint8_t reserved0 : 3;
    uint8_t interrupt_status : 1;
    uint8_t capabilities_list : 1;
    uint8_t mhz_capable : 1;
    uint8_t reserved1 : 1;
    uint8_t fast_back_to_back : 1;
    uint8_t master_data_parity_error : 1;
    uint8_t devcel : 2;
    uint8_t signaled_target_abort : 1;
    uint8_t received_target_abort : 1;
    uint8_t received_master_abort : 1;
    uint8_t signaled_system_error : 1;
    uint8_t detected_parity_error : 1;
} __attribute__((packed)) pci_status_t;

uint32_t pci_in32(uint8_t bus, uint8_t dev, uint8_t func, uint8_t addr)
{
    io_out32(PCI_CONF_ADDR, PCI_ADDR(bus, dev, func, addr));
    return io_in32(PCI_CONF_DATA);
}

void pci_out32(uint8_t bus, uint8_t dev, uint8_t func, uint8_t addr, uint32_t value)
{
    io_out32(PCI_CONF_ADDR, PCI_ADDR(bus, dev, func, addr));
    io_out32(PCI_CONF_DATA, value);
}

static uint32_t pci_size(uint32_t base, uint32_t mask)
{
    // 去掉必须设置的低位
    uint32_t size = mask & base;

    // 按位取反再加1得到大小
    size = ~size + 1;

    return size;
}

// // 获取某种类型的 Base Address Register
// uint32_t pci_find_bar(pci_device_t *device, pci_bar_t *bar, int32_t type)
// {
//     for (uint64_t idx = 0; idx < PCI_BAR_NR; idx++)
//     {
//         uint8_t addr = PCI_CONF_BASE_ADDR0 + (idx << 2);
//         uint32_t value = pci_inl(device->bus, device->dev, device->func, addr);
//         pci_outl(device->bus, device->dev, device->func, addr, -1);
//         uint32_t len = pci_inl(device->bus, device->dev, device->func, addr);
//         pci_outl(device->bus, device->dev, device->func, addr, value);

//         if (value == 0)
//             continue;

//         if (len == 0 || len == -1)
//             continue;

//         if (value == -1)
//             value = 0;

//         if ((value & 1) && type == PCI_BAR_TYPE_IO)
//         {
//             bar->iobase = value & PCI_BAR_IO_MASK;
//             bar->size = pci_size(len, PCI_BAR_IO_MASK);
//             return 0;
//         }
//         if (!(value & 1) && type == PCI_BAR_TYPE_MEM)
//         {
//             bar->iobase = value & PCI_BAR_MEM_MASK;
//             bar->size = pci_size(len, PCI_BAR_MEM_MASK);
//             return 0;
//         }
//     }
//     return -EAFNOSUPPORT;
// }

// // 获得 PCI 类型描述
// const char *pci_classname(uint32_t classcode)
// {
//     for (uint64_t i = 0; pci_classnames[i].name != NULL; i++)
//     {
//         if (pci_classnames[i].classcode == classcode)
//             return pci_classnames[i].name;
//         if (pci_classnames[i].classcode == (classcode & 0xFFFF00))
//             return pci_classnames[i].name;
//     }
//     return "Unknown device";
// }

// // 检测设备
// static void pci_check_device(uint8_t bus, uint8_t dev)
// {
//     uint32_t value = 0;

//     for (uint8_t func = 0; func < 8; func++)
//     {
//         value = pci_inl(bus, dev, func, PCI_CONF_VENDOR);
//         uint16_t vendorid = value & 0xffff;
//         if (vendorid == 0 || vendorid == 0xFFFF)
//             return;

//         pci_device_t *device = (pci_device_t *)kmalloc(sizeof(pci_device_t));
//         list_push(&pci_device_list, &device->node);
//         device->bus = bus;
//         device->dev = dev;
//         device->func = func;

//         device->vendorid = vendorid;
//         device->deviceid = value >> 16;

//         value = pci_inl(bus, dev, func, PCI_CONF_COMMAND);
//         pci_command_t *cmd = (pci_command_t *)&value;
//         pci_status_t *status = (pci_status_t *)(&value + 2);

//         value = pci_inl(bus, dev, func, PCI_CONF_REVISION);
//         device->classcode = value >> 8;
//         device->revision = value & 0xff;

//         LOGK("PCI %02x:%02x.%x %4x:%4x %s\n",
//              device->bus, device->dev, device->func,
//              device->vendorid, device->deviceid,
//              pci_classname(device->classcode));
//     }
// }

// // 通过供应商/设备号查找设备
// pci_device_t *pci_find_device(uint16_t vendorid, uint16_t deviceid)
// {
//     list_t *list = &pci_device_list;
//     for (list_node_t *node = list->head.next; node != &list->tail; node = node->next)
//     {
//         pci_device_t *device = element_entry(pci_device_t, node, node);
//         if (device->vendorid != vendorid)
//             continue;
//         if (device->deviceid != deviceid)
//             continue;
//         return device;
//     }
//     return NULL;
// }

// // 通过类型查找设备
// pci_device_t *pci_find_device_by_class(uint32_t classcode)
// {
//     list_t *list = &pci_device_list;

//     for (list_node_t *node = list->head.next; node != &list->tail; node = node->next)
//     {
//         pci_device_t *device = element_entry(pci_device_t, node, node);
//         if (device->classcode == classcode)
//             return device;
//         if ((device->classcode & PCI_SUBCLASS_MASK) == classcode)
//             return device;
//     }
//     return NULL;
// }

// // 获得中断 IRQ
// uint8_t pci_interrupt(pci_device_t *device)
// {
//     uint32_t data = pci_inl(device->bus, device->dev, device->func, PCI_CONF_INTERRUPT);
//     return data & 0xff;
// }

// // 启用总线主控，用于发起 DMA
// void pci_enable_busmastering(pci_device_t *device)
// {
//     uint32_t data = pci_inl(device->bus, device->dev, device->func, PCI_CONF_COMMAND);
//     data |= PCI_COMMAND_MASTER;
//     pci_outl(device->bus, device->dev, device->func, PCI_CONF_COMMAND, data);
// }

// // PCI 总线枚举
// static void pci_enum_device()
// {
//     for (int32_t bus = 0; bus < 256; bus++)
//     {
//         for (int32_t dev = 0; dev < 32; dev++)
//         {
//             pci_check_device(bus, dev);
//         }
//     }
// }

// // 初始化 PCI 设备
// void pci_init()
// {
//     list_init(&pci_device_list);
//     pci_enum_device();
// }