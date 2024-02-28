#include <global.h>
struct KERNEL_BOOT_INFORMATION *boot_info = (struct KERNEL_BOOT_INFORMATION *)0xffff800000060000;

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
    spinlock_init(&pos.printk_lock);
    spinlock_init(&sequence_lock);

    init_printk();
    load_TR(10);
    set_tss64((uint32_t *)&init_tss[0], _stack_start_, _stack_start_, _stack_start_, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00, 0xffff800000007c00);
    color_printk(RED, BLACK, "system vector initing...\n");
    sys_vector_init();
    color_printk(RED, BLACK, "memory initing...\n");
    init_memory();
    color_printk(RED, BLACK, "cpu initing...\n");
    init_cpu();
    color_printk(RED, BLACK, "slab init...\n");
    slab_init();
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
    color_printk(RED, BLACK, "interrupt initing...\n");
    apic_ioapic_init();
    color_printk(RED, BLACK, "disk initing...\n");
    disk_init();
    color_printk(RED, BLACK, "smp initing...\n");
    smp_init();
    color_printk(RED, BLACK, "schedule initing...\n");
    schedule_init();
    color_printk(RED, BLACK, "softirq initing...\n");
    softirq_init();
    color_printk(GREEN, BLACK, "timer initing...\n");
    timer_init();
    color_printk(GREEN, BLACK, "timer clock initing...\n");
    hpet_init();
    assert(3 > 5);
    color_printk(YELLOW, BLACK, "keyboard init\n");
    keyboard_init();
    color_printk(YELLOW, BLACK, "task init\n");
    color_printk(GREEN, BLACK, "ÄãºÃ ÊÀ½ç!\n");
    task_init();
    EOI();
    sti();
    while (1)
    {
        hlt();
    }
    return;
}
