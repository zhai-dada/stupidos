#include <global.h>

void kernel(void)
{
    memset((void *)&_bss, 0, (uint64_t)&_end - (uint64_t)&_bss);
    mem_structure.start_code = (uint64_t)&_text;
    mem_structure.end_code = (uint64_t)&_etext;
    mem_structure.start_data = (uint64_t)&_data;
    mem_structure.end_data = (uint64_t)&_edata;
    mem_structure.start_brk = (uint64_t)&_end;
    mem_structure.end_rodata = (uint64_t)&_erodata;

    global_pid = 1;
    
    int32_t i = 0;
    uint8_t *ptr = NULL;
    init_printk();
    load_TR(10);
    set_tss64((uint32_t *)&init_tss[0], _stack_start_, _stack_start_, _stack_start_, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00);
    sys_vector_init();
    init_memory();
    // get_cpuinfo();
    kmem_init();
    ptr = (uint8_t *)kmalloc(STACK_SIZE, 0) + STACK_SIZE;
    ((struct task_struct *)(ptr - STACK_SIZE))->cpu_id = 0;
    init_tss[0].ist1 = (uint64_t)ptr;
    init_tss[0].ist2 = (uint64_t)ptr;
    init_tss[0].ist3 = (uint64_t)ptr;
    init_tss[0].ist4 = (uint64_t)ptr;
    init_tss[0].ist5 = (uint64_t)ptr;
    init_tss[0].ist6 = (uint64_t)ptr;
    init_tss[0].ist7 = (uint64_t)ptr;
    vbe_buffer_init();
    pagetable_init();
    local_apic_init();
    apic_ioapic_init();
    disk_init();
    schedule_init();
    spinlock_init(&smp_lock);
    softirq_init();
    hpet_init();
    timer_init();
    smp_init();
    keyboard_init();
    color_printk(GREEN, BLACK, "ƒ„∫√ ¿ΩÁ\n");

    uint32_t pci = pci_in32(0, 3, 0, 0);
    color_printk(INDIGO, BLACK, "%lx\n", pci);

    task_init();
    sti();
    while (1)
    {
        hlt();
    }
    return;
}
