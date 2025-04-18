#include <driver/hpet.h>
#include <apic.h>
#include <stdint.h>
#include <interrupt.h>
#include <driver/cmos.h>
#include <softirq.h>

time_t time;

irq_controller hpet_controller = 
{
    .enable = ioapic_enable,
    .disable = ioapic_disable,
    .install = ioapic_install,
    .uninstall = ioapic_uninstall,
    .ack = ioapic_edge_ack,
};

void hpet_handler(u64 nr, u64 parameter, stackregs_t* reg)
{
    jiffies++;
    set_softirq_status(TIMER_S_IRQ);
}

void hpet_init(void)
{
    u8* hpet_addr = (u8*)HPET_BASEADDR;
    ioapic_ret_entry_t entry;
    entry.vector_num = HPET_IRQ;
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
    register_irq(HPET_IRQ, &entry, &hpet_handler, NULL, &hpet_controller, "HPET");
    *(u64*)(hpet_addr + 0x010) = 3; // 开启中断和转发
    io_mfence();
    *(u64*)(hpet_addr + 0x100) = 0x004c;
    io_mfence();
    *(u64*)(hpet_addr + 0x108) = 105532967; // 1 s : 105532967 * 9.475712(读取(hpet_addr + 0x0000))
    io_mfence();
    *(u64*)(hpet_addr + 0x0f0) = 0; // 计数值清零
    io_mfence();
    return;
}