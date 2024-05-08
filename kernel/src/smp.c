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

extern int global_i;
spinlock_t smp_lock;
extern void system_call(void);

void ipi_200(uint64_t nr, uint64_t parameter, struct stackregs* regs)
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
    int i = 0;
    uint32_t a = 0;
    uint32_t b = 0;
    uint32_t c = 0;
    uint32_t d = 0;
    for(i = 0; ; i++)
    {
        cpuid(0x0b, i, &a, &b, &c, &d);
        if(((c >> 8) & 0xff) == 0)
        {
            break;
        }
    }
    memcpy(apu_boot_start, (unsigned char*)0xffff800000020000, (uint64_t)&apu_boot_end - (uint64_t)&apu_boot_start);
    for(i = 0xc8; i <= 0xd1; i++)
    {
        set_intr_gate(i, 2, smp_interrupt[i - 0xc8]);
    }
    memset(smp_ipi_desc, 0, sizeof(irq_desc_t) * 10);
    // register_ipi(200, NULL, &ipi_200, NULL, NULL, "IPI 200");
    spinlock_init(&smp_lock);
    struct IRQ_CMD_REG icr_entry;
    uint8_t *ptr = NULL;
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
    wrmsr(0x830, *(uint64_t *)&icr_entry);
    for (global_i = 1; global_i < 2; ++global_i)
    {
        spinlock_lock(&smp_lock);
        ptr = (uint8_t *)((uint64_t)kmalloc(STACK_SIZE, 0) + STACK_SIZE);
        if (ptr == NULL)
        {
            color_printk(RED, BLACK, "kmalloc NULL\n");
        }
        ((struct task_struct *)(ptr - STACK_SIZE))->cpu_id = global_i;
        _stack_start_ = (uint64_t)ptr;
        memset(&init_tss[global_i], 0, sizeof(struct tss_struct));
        init_tss[global_i].rsp0 = (uint64_t)ptr;
        init_tss[global_i].rsp1 = (uint64_t)ptr;
        init_tss[global_i].rsp2 = (uint64_t)ptr;
        ptr = (uint8_t *)kmalloc(STACK_SIZE, 0) + STACK_SIZE;
        ((struct task_struct *)(ptr - STACK_SIZE))->cpu_id = global_i;
        init_tss[global_i].ist1 = (uint64_t)ptr;
        init_tss[global_i].ist2 = (uint64_t)ptr;
        init_tss[global_i].ist3 = (uint64_t)ptr;
        init_tss[global_i].ist4 = (uint64_t)ptr;
        init_tss[global_i].ist5 = (uint64_t)ptr;
        init_tss[global_i].ist6 = (uint64_t)ptr;
        init_tss[global_i].ist7 = (uint64_t)ptr;
        set_tss_descriptor(10 + global_i * 2, &init_tss[global_i]);
        icr_entry.vector_num = 0x20;
        icr_entry.deliver_mode = IOAPIC_ICR_START_UP;
        icr_entry.dest_shorthand = ICR_NO_SHORTHAND;
        icr_entry.destination.x2apic_destination = global_i;
        wrmsr(0x830, *(uint64_t *)&icr_entry);
        wrmsr(0x830, *(uint64_t *)&icr_entry);
    }
    return;
}
void start_smp()
{
    uint32_t x = 0;
    uint32_t y = 0;
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
    // color_printk(GREEN, BLACK, "CPU ID:%018lx, %018lx\n", current, get_rsp());

    current->state = TASK_RUNNING;
    current->flags = PF_KTHREAD;
    current->mm = &init_mm;
    list_init(&current->list);
    current->addr_limit = TASK_SIZE;
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
    current->next = init_task[0];
    load_TR(10 + smp_cpu_id() * 2);
    spinlock_unlock(&smp_lock);
    current->preempt_count = 0;
    // task_init();
    sti();
    while(1)
    {
        hlt();
    }
    return;
}
