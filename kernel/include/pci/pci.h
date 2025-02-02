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

#define PCI_CONF_ADDR 0xCF8
#define PCI_CONF_DATA 0xCFC

#define PCI_BAR_NR 6

#define PCI_ADDR(bus, dev, func, addr) (((u32)(0x80000000) | ((bus & 0xff) << 16) | ((dev & 0x1f) << 11) | ((func & 0x7) << 8) | addr))


typedef struct pci_addr_t
{
    u8 reserved0 : 2; // 最低位
    u8 offset : 6;   // 偏移
    u8 function : 3; // 功能号
    u8 device : 5;   // 设备号
    u8 bus;          // 总线号
    u8 reserved1 : 7; // 保留
    u8 enable : 1;   // 地址有效
} __attribute__((packed)) pci_addr_t;

typedef struct pci_bar_t
{
    u32 iobase;
    u32 size;
} pci_bar_t;

typedef struct pci_device_t
{
    list_t node;
    u8 bus;
    u8 dev;
    u8 func;
    u16 vendorid;
    u16 deviceid;
    u8 revision;
    u32 classcode;
    volatile pci_bar_t bar [PCI_BAR_NR];
} pci_device_t;


struct
{
    u32 classcode;
    u8 *name;
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
        {0x000000, NULL}};

typedef struct pci_command_t
{
    u8 io_space : 1;
    u8 memory_space : 1;
    u8 bus_master : 1;
    u8 special_cycles : 1;
    u8 memory_write_invalidate_enable : 1;
    u8 vga_palette_snoop : 1;
    u8 parity_error_response : 1;
    u8 reserved0 : 1;
    u8 serr : 1;
    u8 fast_back_to_back : 1;
    u8 interrupt_disable : 1;
    u8 reserved1 : 5;
} __attribute__((packed)) pci_command_t;

typedef struct pci_status_t
{
    u8 reserved0 : 3;
    u8 interrupt_status : 1;
    u8 capabilities_list : 1;
    u8 mhz_capable : 1;
    u8 reserved1 : 1;
    u8 fast_back_to_back : 1;
    u8 master_data_parity_error : 1;
    u8 devcel : 2;
    u8 signaled_target_abort : 1;
    u8 received_target_abort : 1;
    u8 received_master_abort : 1;
    u8 signaled_system_error : 1;
    u8 detected_parity_error : 1;
} __attribute__((packed)) pci_status_t;

typedef struct msi_addr_t
{
    u32 
        xx:         2, // 0-1
        dm:         1, // DM（Destination Mode）：0：物理模式（APIC ID 直接指定目标 CPU）。1：逻辑模式（用于多播）。
        rh:         1, // RH（Redirection Hint）：0：直接投递给指定 APIC ID。1：使用物理目标模式（通常为 0）。
        reserved:   8,
        dest:       8, // dest cpu id
        base:       12; // 0xFEE BASE 20 - 31
}__attribute__((packed)) msi_addr_t;

list_t pci_device_list;

u32 pci_in32(u8 bus, u8 dev, u8 func, u8 addr);
void pci_out32(u8 bus, u8 dev, u8 func, u8 addr, u32 value);
static u32 pci_size(u32 base, u32 mask);
void pci_init();
u8 pci_interrupt(pci_device_t *device);
u8 pci_interrupt_pin(pci_device_t *device);
void pci_find_bar(pci_device_t *device);
pci_device_t *pci_find_device_by_class(u32 classcode);
pci_device_t *pci_find_device(u16 vendorid, u16 deviceid);
void pci_enable_busmastering(pci_device_t *device);

#endif