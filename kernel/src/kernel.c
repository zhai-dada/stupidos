#include <apic.h>
#include <driver/vbe.h>
#include <task.h>
#include <trap.h>

extern u64* _start;

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
    serial_printf(SFRED, SBBLACK, "%lx\n", interrupt[4]);

    sti();

    while (1)
    {
        ;
    }
    return SOK;
}