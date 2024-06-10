#include <pci/pci.h>
#include <errno.h>
#include <memory.h>
#include <printk.h>

uint32_t pci_in32(uint8_t bus, uint8_t dev, uint8_t func, uint8_t addr)
{
    io_out32(PCI_CONF_ADDR, PCI_ADDR(bus, dev, func, addr));
    return io_in32(PCI_CONF_DATA);
}

void pci_out32(uint8_t bus, uint8_t dev, uint8_t func, uint8_t addr, uint32_t value)
{
    io_out32(PCI_CONF_ADDR, PCI_ADDR(bus, dev, func, addr));
    io_out32(PCI_CONF_DATA, value);
    return;
}

static uint32_t pci_size(uint32_t base, uint32_t mask)
{
    // 去掉必须设置的低位
    uint32_t size = mask & base;
    // 按位取反再加1得到大小
    size = ~size + 1;
    return size;
}

// 获取某种类型的 Base Address Register
void pci_find_bar(pci_device_t *device)
{
    for (uint64_t idx = 0; idx < PCI_BAR_NR; idx++)
    {
        uint8_t addr = PCI_CONF_BASE_ADDR0 + (idx << 2);
        uint32_t value = pci_in32(device->bus, device->dev, device->func, addr);
        pci_out32(device->bus, device->dev, device->func, addr, -1);
        uint32_t len = pci_in32(device->bus, device->dev, device->func, addr);
        pci_out32(device->bus, device->dev, device->func, addr, value);

        if (value == 0)
        {
            continue;
        }
        if (len == 0 || len == -1)
        {
            continue;
        }
        if (value == -1)
        {
            value = 0;
        }
        if ((value & 1))
        {
            device->bar[idx].iobase = value & PCI_BAR_IO_MASK;
            device->bar[idx].size = pci_size(len, PCI_BAR_IO_MASK);
        }
        if (!(value & 1))
        {
            device->bar[idx].iobase = value & PCI_BAR_MEM_MASK;
            device->bar[idx].size = pci_size(len, PCI_BAR_MEM_MASK);
        }
    }
    return;
}

// 获得 PCI 类型描述
const char *pci_classname(uint32_t classcode)
{
    for (uint64_t i = 0; pci_classnames[i].name != NULL; ++i)
    {
        if (pci_classnames[i].classcode == classcode)
        {
            return pci_classnames[i].name;
        }
        else if (pci_classnames[i].classcode == (classcode & 0xFFFF00))
        {
            return pci_classnames[i].name;
        }
    }
    return "Unknown device";
}

// 检测设备
static void pci_check_device(uint8_t bus, uint8_t dev)
{
    uint32_t value = 0;

    for (uint8_t func = 0; func < 8; ++func)
    {
        value = pci_in32(bus, dev, func, PCI_CONF_VENDOR);
        uint16_t vendorid = value & 0xFFFF;
        if (vendorid == 0 || vendorid == 0xFFFF)
        {
            return;
        }
        pci_device_t *device = (pci_device_t *)kmalloc(sizeof(pci_device_t), 0);
        list_init(&device->node);
        list_add_before(&pci_device_list, &device->node);
        device->bus = bus;
        device->dev = dev;
        device->func = func;

        device->vendorid = vendorid;
        device->deviceid = value >> 16;

        value = pci_in32(bus, dev, func, PCI_CONF_COMMAND);
        pci_command_t *cmd = (pci_command_t *)&value;
        pci_status_t *status = (pci_status_t *)(&value + 2);

        value = pci_in32(bus, dev, func, PCI_CONF_REVISION);
        device->classcode = value >> 8;
        device->revision = value & 0xff;
        pci_find_bar(device);
        color_printk(
            GREEN, BLACK, "PCI bus:%02x dev:%02x func:%x vendorid:%4x deviceid:%4x classname:%s intnum:%d intpin:%d\n",
            device->bus, device->dev, device->func,
            device->vendorid, device->deviceid,
            pci_classname(device->classcode), pci_interrupt(device), pci_interrupt_pin(device));
    }
    return;
}

// 通过供应商/设备号查找设备
pci_device_t *pci_find_device(uint16_t vendorid, uint16_t deviceid)
{
    struct list *list = &pci_device_list;
    for (struct list *node = list->next; node != list; node = node->next)
    {
        pci_device_t *device = container_of(node, pci_device_t, node);
        if (device->vendorid != vendorid)
        {
            continue;
        }
        if (device->deviceid != deviceid)
        {
            continue;
        }
        return device;
    }
    return NULL;
}

// 通过类型查找设备
pci_device_t *pci_find_device_by_class(uint32_t classcode)
{
    struct list *list = &pci_device_list;

    for (struct list *node = list->next; node != list; node = node->next)
    {
        pci_device_t *device = container_of(node, pci_device_t, node);
        if (device->classcode == classcode)
        {
            return device;
        }
        if ((device->classcode & PCI_SUBCLASS_MASK) == classcode)
        {
            return device;
        }
    }
    return NULL;
}

// 获得中断 IRQ
uint8_t pci_interrupt(pci_device_t *device)
{
    uint32_t data = pci_in32(device->bus, device->dev, device->func, PCI_CONF_INTERRUPT);
    return data & 0xff;
}

// 获得中断 IRQ PIN
uint8_t pci_interrupt_pin(pci_device_t *device)
{
    uint32_t data = pci_in32(device->bus, device->dev, device->func, PCI_CONF_INTERRUPT);
    return (data >> 8) & 0xff;
}

// 启用总线主控，用于发起 DMA
void pci_enable_busmastering(pci_device_t *device)
{
    uint32_t data = pci_in32(device->bus, device->dev, device->func, PCI_CONF_COMMAND);
    data |= PCI_COMMAND_MASTER;
    pci_out32(device->bus, device->dev, device->func, PCI_CONF_COMMAND, data);
    return;
}

// PCI 总线枚举
static void pci_enum_device()
{
    for (int32_t bus = 0; bus < 256; bus++)
    {
        for (int32_t dev = 0; dev < 32; dev++)
        {
            pci_check_device(bus, dev);
        }
    }
    return;
}

// 初始化 PCI 设备
void pci_init()
{
    list_init(&pci_device_list);
    pci_enum_device();
    return;
}