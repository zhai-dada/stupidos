#include <apic.h>
#include <driver/vbe.h>
#include <task.h>
#include <trap.h>
#include <driver/hpet.h>
#include <softirq.h>

u64 globalpid = 0;

int kernel(void)
{
    memset((void *)&_bss, 0, (u64)&_end - (u64)&_bss);

    serial_init();
    vbe_init();

    set_tss_descriptor(10, (void *)&tss[0]); // tss 0 
    load_tr(10);

    sys_vector_init();

    get_cpuinfo();

    mm_init();
    kmem_init();
    vbe_buffer_init();

    apic_ioapic_init();
    serial_irq_en();

    softirq_init();

    hpet_init();
    
    sti();
    while (1)
    {
        ;
    }
    return SOK;
}