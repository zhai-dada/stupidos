#include <apic.h>
#include <interrupt.h>
#include <schedule.h>
#include <printk.h>
#include <lib.h>
#include <time.h>
#include <softirq.h>
#include <stackregs.h>
#include <debug.h>

extern struct time time;
extern struct timer_list timer_list_head;

irq_controller HPET_controller = 
{
    .enable = ioapic_enable,
    .disable = ioapic_disable,
    .install = ioapic_install,
    .uninstall = ioapic_uninstall,
    .ack = ioapic_edge_ack,
};

void hpet_handler(u64 nr, u64 parameter, struct stackregs* reg)
{
    jiffies++;
    if(container_of(list_next(&timer_list_head.list), struct timer_list, list)->jiffies <= jiffies)
    {
        set_softirq_status(TIMER_S_IRQ);
    }
    struct IRQ_CMD_REG icr_entry;
    memset(&icr_entry, 0, sizeof(icr_entry));
    icr_entry.vector_num = 0xc8;
    icr_entry.dest_shorthand = ICR_ALL_EXCLUDE_SELF;
    icr_entry.trigger = IOAPIC_TRIGGER_EDGE;
    icr_entry.dest_mode = IOAPIC_DEST_MODE_PHYSICAL;
    icr_entry.deliver_mode = IOAPIC_FIXED;
    wrmsr(0x830, *(u64*)&icr_entry);
    switch(current->priority)
    {
        case 0:
        case 1:
            task_schedule[smp_cpu_id()].exectask_jiffies -= 1;
            current->vruntime += 1;
            break;
        case 2:
        default:
            task_schedule[smp_cpu_id()].exectask_jiffies -= 2;
            current->vruntime += 2;
            break;
    }
    if(task_schedule[smp_cpu_id()].exectask_jiffies <= 0)
    {
        current->flags |= NEED_SCHEDULE;
    }
}
void hpet_init()
{
    u8* HPET_addr = (u8*)P_TO_V(0xfed00000);
    struct IOAPIC_RET_ENTRY entry;
    entry.vector_num = 0x22;
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
    register_irq(0x22, &entry, &hpet_handler, NULL, &HPET_controller, "HPET");
    *(u64*)(HPET_addr + 0x10) = 3;
    io_mfence();
    *(u64*)(HPET_addr + 0x100) = 0x004c;
    io_mfence();
    *(u64*)(HPET_addr + 0x108) = 14318179 * 1; // 1 s
    io_mfence();
    get_cmos_time(&time);
    *(u64*)(HPET_addr + 0xf0) = 0;
    io_mfence();
    return;
}