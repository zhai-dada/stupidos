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
    color_printk(GREEN, BLACK, "������ʾ����\n");
    pci_init();
    // struct page* p = NULL;
    // for(int j = 0; j < 10; ++j)
    // {
    //     p = alloc_pages(ZONE_NORMAL, 1, 0);
    //     color_printk(INDIGO, BLACK, "page:%d\tattribute:%018lx\taddress:%018lx\n", j, p->attribute, p->p_address);
    //     color_printk(ORANGE, BLACK, "bits_map:%018lx\n", *mem_structure.bits_map);
    // }
    // color_printk(YELLOW, BLACK, "free_pages 5 \t");
    // free_pages(p, 5);
    // color_printk(ORANGE, BLACK, "bits_map:%018lx\n", *mem_structure.bits_map);


    // color_printk(INDIGO, BLACK, "���Ĳ���ABCDEF&*())):[]]{}Hello World!�����\t��\t 123456\n");
    // color_printk(INDIGO, BLACK, "abcdefghijklmnopqrstuvwxyz�����Ҹ���i�����㸶���Ŷ����ckeori8932!@#()))\n");
    // color_printk(INDIGO, BLACK, "jgde\tdaees��hide��\bbbbbbb\n");


    // int a = 1 / 0;
    // *((int *)0xffff900000000000) = 0;

    // uint8_t *a = NULL;
    // for(int i = 0; i < 10; i++)
    // {
    //     a = kmalloc(32, 0);
    //     color_printk(YELLOW, BLACK, "address:%018lx\n", a);
    // }
    // for(int i = 0; i < 10; i++)
    // {
    //     a = kmalloc(64, 0);
    //     color_printk(INDIGO, BLACK, "address:%018lx\n", a);
    // }
    // for(int i = 0; i < 10; i++)
    // {
    //     a = kmalloc(2048, 0);
    //     color_printk(WHITE, BLACK, "address:%018lx\n", a);
    // }
    // uint8_t *a = NULL;
    // for(int i = 0; i < 10; i++)
    // {
    //     a = kmalloc(32, 0);
    //     color_printk(INDIGO, BLACK, "address:%018lx\n", a);
    //     kfree(a);
    // }
    // for(int i = 0; i < 10; i++)
    // {
    //     a = kmalloc(1024, 0);
    //     color_printk(GREEN, BLACK, "address:%018lx\n", a);
    //     kfree(a);
    // }
    // for(int i = 0; i < 10000; i++)
    // {
    //     a = kmalloc(1024 * 1024, 0);
    // }
    task_init();
    sti();
    while (1)
    {
        hlt();
    }
    return;
}
