#include <global.h>
#include <sched.h>
void kernel(void)
{
    global_pid = 1;
    s32 i = 0;
    u64 *ptr = NULL;

    memset((void *)&_bss, 0, (u64)&_end - (u64)&_bss);
    mem_structure.start_code = (u64)&_text;
    mem_structure.end_code = (u64)&_etext;
    mem_structure.start_data = (u64)&_data;
    mem_structure.end_data = (u64)&_edata;
    mem_structure.start_brk = (u64)&_end;
    mem_structure.end_rodata = (u64)&_erodata;

    serial_init();
    init_printk();

    sys_vector_init();
    init_memory();
    get_cpuinfo();
    kmem_init();

    ptr = (u64 *)kmalloc(STACK_SIZE, 0) + STACK_SIZE;
    ((struct task_struct *)(ptr - STACK_SIZE))->cpu_id = i;
    init_tss[i].ist1 = (u64)ptr;
    init_tss[i].ist2 = (u64)ptr;
    init_tss[i].ist3 = (u64)ptr;
    init_tss[i].ist4 = (u64)ptr;
    init_tss[i].ist5 = (u64)ptr;
    init_tss[i].ist6 = (u64)ptr;
    init_tss[i].ist7 = (u64)ptr;

    set_tss64((u32 *)&init_tss[current->cpu_id], init_tss[current->cpu_id].rsp0, \
        init_tss[current->cpu_id].rsp1, init_tss[current->cpu_id].rsp2, \
        init_tss[current->cpu_id].ist1, init_tss[current->cpu_id].ist2, \
        init_tss[current->cpu_id].ist3, init_tss[current->cpu_id].ist4, \
        init_tss[current->cpu_id].ist5, init_tss[current->cpu_id].ist6, init_tss[current->cpu_id].ist7);
    load_tr(10);
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
    keyboard_init();
    pci_init();
    serial_irq_en();
    smp_init();
    e1000_init();
    task_init();

    sti();
    kernel_thread(net_output_thread, 10, CLONE_FS | CLONE_SIGNAL | CLONE_VM);
    kernel_thread(net_input_thread, 10, CLONE_FS | CLONE_SIGNAL | CLONE_VM);
    while (1)
    {
        hlt();
    }
    return;
}
