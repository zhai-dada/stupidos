#ifndef __PCI_H__
#define __PCI_H__

#include <bit/types.h>
#include <lib.h>

#define PCI_CONF_VENDOR 0X0   // 厂商
#define PCI_CONF_DEVICE 0X2   // 设备
#define PCI_CONF_COMMAND 0x4  // 命令
#define PCI_CONF_STATUS 0x6   // 状态
#define PCI_CONF_REVISION 0x8 //
#define PCI_CONF_BASE_ADDR0 0x10
#define PCI_CONF_BASE_ADDR1 0x14
#define PCI_CONF_BASE_ADDR2 0x18
#define PCI_CONF_BASE_ADDR3 0x1C
#define PCI_CONF_BASE_ADDR4 0x20
#define PCI_CONF_BASE_ADDR5 0x24
#define PCI_CONF_INTERRUPT 0x3C

#define PCI_CLASS_MASK 0xFF0000
#define PCI_SUBCLASS_MASK 0xFFFF00

#define PCI_CLASS_STORAGE_IDE 0x010100

#define PCI_BAR_TYPE_MEM 0
#define PCI_BAR_TYPE_IO 1

#define PCI_BAR_IO_MASK (~0x3)
#define PCI_BAR_MEM_MASK (~0xF)

#define PCI_COMMAND_IO 0x0001          // Enable response in I/O space
#define PCI_COMMAND_MEMORY 0x0002      // Enable response in Memory space
#define PCI_COMMAND_MASTER 0x0004      // Enable bus mastering
#define PCI_COMMAND_SPECIAL 0x0008     // Enable response to special cycles
#define PCI_COMMAND_INVALIDATE 0x0010  // Use memory write and invalidate
#define PCI_COMMAND_VGA_PALETTE 0x0020 // Enable palette snooping
#define PCI_COMMAND_PARITY 0x0040      // Enable parity checking
#define PCI_COMMAND_WAIT 0x0080        // Enable address/data stepping
#define PCI_COMMAND_SERR 0x0100        // Enable SERR/
#define PCI_COMMAND_FAST_BACK 0x0200   // Enable back-to-back writes

#define PCI_STATUS_CAP_LIST 0x010    // Support Capability List
#define PCI_STATUS_66MHZ 0x020       // Support 66 Mhz PCI 2.1 bus
#define PCI_STATUS_UDF 0x040         // Support User Definable Features [obsolete]
#define PCI_STATUS_FAST_BACK 0x080   // Accept fast-back to back
#define PCI_STATUS_PARITY 0x100      // Detected parity error
#define PCI_STATUS_DEVSEL_MASK 0x600 // DEVSEL timing
#define PCI_STATUS_DEVSEL_FAST 0x000
#define PCI_STATUS_DEVSEL_MEDIUM 0x200
#define PCI_STATUS_DEVSEL_SLOW 0x400

typedef struct pci_addr_t
{
    uint8_t reserved0 : 2; // 最低位
    uint8_t offset : 6;   // 偏移
    uint8_t function : 3; // 功能号
    uint8_t device : 5;   // 设备号
    uint8_t bus;          // 总线号
    uint8_t reserved1 : 7; // 保留
    uint8_t enable : 1;   // 地址有效
} __attribute__((packed)) pci_addr_t;

typedef struct pci_bar_t
{
    uint32_t iobase;
    uint32_t size;
} pci_bar_t;

typedef struct pci_device_t
{
    struct list node;
    uint8_t bus;
    uint8_t dev;
    uint8_t func;
    uint16_t vendorid;
    uint16_t deviceid;
    uint8_t revision;
    uint32_t classcode;
} pci_device_t;

uint32_t pci_in32(uint8_t bus, uint8_t dev, uint8_t func, uint8_t addr);
void pci_out32(uint8_t bus, uint8_t dev, uint8_t func, uint8_t addr, uint32_t value);
static uint32_t pci_size(uint32_t base, uint32_t mask);

#endif