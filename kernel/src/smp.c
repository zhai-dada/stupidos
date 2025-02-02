#include <printk.h>
#include <spinlock.h>
#include <stdint.h>
#include <interrupt.h>
#include <smp/smp.h>
#include <stackregs.h>
#include <memory.h>
#include <task.h>
#include <schedule.h>
#include <memory.h>
#include <gate.h>
#include <hpet.h>
#include <task.h>
#include <time.h>
#include <debug.h>

extern s32 global_i;
spinlock_t smp_lock;
extern void system_call(void);

void ipi_200(u64 nr, u64 parameter, struct stackregs* regs)
{
    switch(current->priority)
    {
        case 0:
        case 1:
            task_schedule[smp_cpu_id()].exectask_jiffies--;
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
void smp_init()
{
    s32 i = 0;
    u32 a = 0;
    u32 b = 0;
    u32 c = 0;
    u32 d = 0;
    for(i = 0; ; i++)
    {
        cpuid(0x0b, i, &a, &b, &c, &d);
        if(((c >> 8) & 0xff) == 0)
        {
            break;
        }
    }
    memcpy(apu_boot_start, (u8*)0xffff800000020000, (u64)&apu_boot_end - (u64)&apu_boot_start);
    for(i = 0xc8; i <= 0xd1; i++)
    {
        set_intr_gate(i, 2, smp_interrupt[i - 0xc8]);
    }
    memset(smp_ipi_desc, 0, sizeof(irq_desc_t) * 10);
    register_ipi(200, NULL, &ipi_200, NULL, NULL, "IPI 200");
    spinlock_init(&smp_lock);
    struct IRQ_CMD_REG icr_entry;
    u8 *ptr = NULL;
    icr_entry.vector_num = 0x00;
    icr_entry.deliver_mode = IOAPIC_INIT;
    icr_entry.dest_mode = IOAPIC_DEST_MODE_PHYSICAL;
    icr_entry.deliver_status = IOAPIC_DELI_STATUS_IDLE;
    icr_entry.res_1 = 0;
    icr_entry.level = ICR_LEVEL_DE_ASSERT;
    icr_entry.trigger = IOAPIC_TRIGGER_EDGE;
    icr_entry.res_2 = 0;
    icr_entry.dest_shorthand = ICR_ALL_EXCLUDE_SELF;
    icr_entry.res_3 = 0;
    icr_entry.destination.x2apic_destination = 0x00;
    wrmsr(0x830, *(u64 *)&icr_entry);
    for (global_i = 1; global_i < 4; ++global_i)
    {
        spinlock_lock(&smp_lock);
        ptr = (u8 *)((u64)kmalloc(STACK_SIZE, 0));
        if (ptr == NULL)
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "kmalloc NULL\n");
        }
        _stack_start_ = (u64)ptr + STACK_SIZE;
        ((struct task_struct *)(ptr))->cpu_id = global_i;

        memset(&init_tss[global_i], 0, sizeof(struct tss_struct));
        init_tss[global_i].rsp0 = (u64)_stack_start_;
        init_tss[global_i].rsp1 = (u64)_stack_start_;
        init_tss[global_i].rsp2 = (u64)_stack_start_;
        ptr = (u8 *)kmalloc(STACK_SIZE, 0) + STACK_SIZE;
        ((struct task_struct *)(ptr - STACK_SIZE))->cpu_id = global_i;
        init_tss[global_i].ist1 = (u64)ptr;
        init_tss[global_i].ist2 = (u64)ptr;
        init_tss[global_i].ist3 = (u64)ptr;
        init_tss[global_i].ist4 = (u64)ptr;
        init_tss[global_i].ist5 = (u64)ptr;
        init_tss[global_i].ist6 = (u64)ptr;
        init_tss[global_i].ist7 = (u64)ptr;
        set_tss_descriptor(10 + global_i * 2, &init_tss[global_i]);
        icr_entry.vector_num = 0x20;
        icr_entry.deliver_mode = IOAPIC_ICR_START_UP;
        icr_entry.dest_shorthand = ICR_NO_SHORTHAND;
        icr_entry.destination.x2apic_destination = global_i;
        set_tss64((u32 *)&init_tss[global_i], init_tss[global_i].rsp0, init_tss[global_i].rsp1, init_tss[global_i].rsp2, init_tss[global_i].ist1, init_tss[global_i].ist2, init_tss[global_i].ist3, init_tss[global_i].ist4, init_tss[global_i].ist5, init_tss[global_i].ist6, init_tss[global_i].ist7);

        wrmsr(0x830, *(u64 *)&icr_entry);
        wrmsr(0x830, *(u64 *)&icr_entry);
    }
    return;
}
void start_smp()
{
    u32 x = 0;
    u32 y = 0;
    asm volatile
    (
        "movq $0x1b, %%rcx\n"
        "rdmsr\n"
        "bts $10, %%rax\n"
        "bts $11, %%rax\n"
        "wrmsr\n"
        "movq $0x1b, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    asm volatile
    (
        "movq $0x80f, %%rcx\n"
        "rdmsr\n"
        "bts $8, %%rax\n"
        "bts $12, %%rax\n"
        "wrmsr\n"
        "movq $0x80f, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    asm volatile
    (
        "movq $0x802, %%rcx\n"
        "rdmsr\n"
        :"=a"(x), "=d"(y)
        :
        :"memory"
    );
    DBG_SERIAL(SERIAL_ATTR_FRONT_YELLOW, SERIAL_ATTR_BACK_BLACK, "CPU ID:%018lx, %018lx\n", current->cpu_id, get_rsp());

    current->state = TASK_RUNNING;
    current->flags = PF_KTHREAD;
    current->mm = &init_mm;
    list_init(&current->list);
    current->addr_limit = 0xffff800000000000;
    current->pid = global_pid++;
    current->priority = 2;
    current->vruntime = 0;
    current->thread = (struct thread_struct*)(current + 1);

    memset(current->thread, 0, sizeof(struct thread_struct));
    current->thread->rsp0 = init_tss[smp_cpu_id()].rsp0;
    current->thread->rsp = init_tss[smp_cpu_id()].rsp0;
    current->thread->fs = KERNEL_DATA_SEGMENT;
    current->thread->gs = KERNEL_DATA_SEGMENT;
    init_task[smp_cpu_id()] = current;

    current->next = current;
    load_tr(10 + smp_cpu_id() * 2);
    spinlock_unlock(&smp_lock);
    current->preempt_count = 0;
    // current->flags &= (~NEED_SCHEDULE);
    // task_init();
    sti();
    while(1)
    {
        hlt();
    }
    return;
}
