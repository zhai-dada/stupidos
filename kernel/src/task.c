#include <task.h>
#include <stackregs.h>
#include <errno.h>
#include <debug.h>

tss_t tss[MAX_CPUNUM] = 
{
    [0 ... MAX_CPUNUM - 1] = INIT_TSS,
};

task_stack_t inittask_stack __attribute__((__section__(".data.inittask_stack"))) ={INIT_TASK(inittask_stack.task)};

task_t* tasklist[MAX_CPUNUM] = {&inittask_stack.task, 0};
task_mm_t init_mm = {0};

thread_t init_thread = 
{
    .rsp0 = (u64)(inittask_stack.stack + STACK_SIZE / sizeof(u64)),
    .rsp = (u64)(inittask_stack.stack + STACK_SIZE / sizeof(u64)),
    .fs = KERNEL_CODE_SEGMENT,
    .gs = KERNEL_DATA_SEGMENT,
    .cr2 = 0,
    .error_code = 0,
    .trap_nr = 0,
};

extern void system_ret(void);

extern void kernel_thread_func(void);
asm
(
    ".global kernel_thread_func             \n"
    ".type kernel_thread_func, @function    \n"
    "kernel_thread_func:                    \n"
    "popq %r15                              \n"
    "popq %r14                              \n"
    "popq %r13                              \n"
    "popq %r12                              \n"
    "popq %r11                              \n"
    "popq %r10                              \n"
    "popq %r9                               \n"
    "popq %r8                               \n"
    "popq %rbx                              \n"
    "popq %rcx                              \n"
    "popq %rdx                              \n"
    "popq %rsi                              \n"
    "popq %rdi                              \n"
    "popq %rbp                              \n"
    "popq %rax                              \n"
    "movq %rax, %ds                         \n"
    "popq %rax                              \n"
    "movq %rax, %es                         \n"
    "popq %rax                              \n"
    "addq $0x38, %rsp                       \n"
    "movq %rdx, %rdi                        \n"
    "callq *%rbx                            \n"
    "movq %rax, %rdi                        \n"
    "callq do_exit                          \n"
);

void switch_mm(task_t *prev, task_t *next)
{
    asm volatile
    (
        "movq %%cr3, %0 \n"
        "movq %1, %%cr3	\n"
        : "=r"(prev->mm->pgd)
        : "r"(next->mm->pgd)
        : "memory"
    );
    return;
}

static u64 copy_flags(u64 clone_flags, task_t *task)
{
    if (clone_flags & CLONE_VM)
    {
        task->flags |= PF_VFORK;
    }
    return 0;
}

static u64 copy_mem(u64 clone_flags, task_t *task)
{
    s32 error = 0;
    task_mm_t *newmm = NULL;
    u64 code_start_addr = 0x800000;
    u64 stack_start_addr = 0xa00000;
    u64 brk_start_addr = 0xc00000;
    u64 *tmp;
    u64 *virtual = NULL;
    page_t *p = NULL;

    if (clone_flags & CLONE_VM)
    {
        newmm = current->mm;
        goto out;
    }

    newmm = (task_mm_t *)kmalloc(sizeof(task_mm_t), 0);
    
    newmm->pgd = (pml4t_t *)V_TO_P(kmalloc(PAGE_4K_SIZE, 0));
    memcpy((void *)(P_TO_V(newmm->pgd) + 256 * 8), (void *)(P_TO_V(tasklist[current->cpuid]->mm->pgd) + 256 * 8), PAGE_4K_SIZE / 2); // copy kernel space

    memset((void *)(P_TO_V(newmm->pgd)), 0, PAGE_4K_SIZE / 2); // copy user code & data & bss space

    tmp = (u64 *)(((u64)P_TO_V((u64)newmm->pgd & (~0xfffUL))) + ((code_start_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
    virtual = kmalloc(PAGE_4K_SIZE, 0);
    memset(virtual, 0, PAGE_4K_SIZE);
    set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_ATTR_USER_GDT));

    tmp = (u64 *)(((u64)P_TO_V((u64)(*tmp) & (~0xfffUL))) + ((code_start_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
    virtual = kmalloc(PAGE_4K_SIZE, 0);
    memset(virtual, 0, PAGE_4K_SIZE);
    set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_ATTR_USER_DIR));

    tmp = (u64 *)(((u64)P_TO_V((u64)(*tmp) & (~0xfffUL))) + ((code_start_addr >> PAGE_2M_SHIFT) & 0x1ff) * 8);
    p = alloc_pages(1, 1, PAGE_PT_MAPED);
    set_pdt(tmp, make_pdt(p->p_address, PAGE_ATTR_USER_PAGE));

    memcpy((void *)(P_TO_V(p->p_address)), (void *)(code_start_addr), stack_start_addr - code_start_addr);
    // if (current->mm->end_brk - current->mm->start_brk != 0)
    // {
    //     tmp = (u64 *)(((u64)P_TO_V((u64)newmm->pgd & (~0xfffUL))) + ((brk_start_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
    //     tmp = (u64 *)(((u64)P_TO_V((u64)(*tmp) & (~0xfffUL))) + ((brk_start_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
    //     tmp = (u64 *)(((u64)P_TO_V((u64)(*tmp) & (~0xfffUL))) + ((brk_start_addr >> PAGE_2M_SHIFT) & 0x1ff) * 8);
    //     p = alloc_pages(1, 1, PAGE_PT_MAPED);
    //     set_pdt(tmp, make_pdt(p->p_address, PAGE_ATTR_USER_PAGE));
    //     memcpy((void *)P_TO_V(p->p_address), (void *)brk_start_addr, PAGE_2M_SIZE);
    // }

out:
    task->mm = newmm;
    return error;
}

static void exit_mem(task_t *task)
{
    u64 code_start_addr = current->mm->start_code;
    u64 *tmp4;
    u64 *tmp3;
    u64 *tmp2;

    if (task->flags & PF_VFORK)
    {
        return;
    }
    if (task->mm->pgd != NULL)
    {
        tmp4 = (u64 *)(((u64)P_TO_V((u64)task->mm->pgd & (~0xfffUL))) + ((code_start_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
        tmp3 = (u64 *)(((u64)P_TO_V((u64)(*tmp4) & (~0xfffUL))) + ((code_start_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
        tmp2 = (u64 *)(((u64)P_TO_V((u64)(*tmp3) & (~0xfffUL))) + ((code_start_addr >> PAGE_2M_SHIFT) & 0x1ff) * 8);

        free_pages(P_TO_2M(*tmp2), 1);
        kfree((void *)(P_TO_V(*tmp3)));
        kfree((void *)(P_TO_V(*tmp4)));
        kfree((void *)(P_TO_V(task->mm->pgd)));
    }
    if (task->mm != NULL)
    {
        kfree(task->mm);
    }
}

static u64 copy_file(u64 clone_flags, task_t *task)
{
    return 0;
}

static void exit_file(task_t* task)
{
    return;
}

static u64 copy_thread(u64 clone_flags, u64 stack_start, u64 stack_size, task_t *task, stackregs_t *regs)
{
    thread_t *thd = NULL;
    stackregs_t *childregs = NULL;

    thd = (thread_t *)(task + 1);
    memset(thd, 0, sizeof(thread_t));
    task->thread = thd;

    childregs = (stackregs_t *)((u64)task + STACK_SIZE) - 1;

    memcpy(regs, childregs, sizeof(stackregs_t));
    childregs->rax = 0;
    childregs->rsp = stack_start;

    thd->rsp0 = (u64)task + STACK_SIZE;
    thd->rsp = (u64)childregs;
    thd->fs = current->thread->fs;
    thd->gs = current->thread->gs;

    // 如果是 内核线程
    if (task->flags & PF_KTHREAD)
    {
        thd->rip = (u64)kernel_thread_func;
    }
    else
    {
        thd->rip = (u64)system_ret;
    }
    return 0;
}

static void exit_thread(task_t *task)
{
    return;
}

void wakeup_process(task_t *task)
{
    task->state = TASK_RUNNING;
    // insert_task_queue(task);
    current->flags |= NEED_SCHEDULE;
    return;
}

static void do_exit(u64)
{
    printk("do exit\n");
    return;
}

u64 do_fork(stackregs_t *regs, u64 clone_flags, u64 stack_start, u64 stack_size)
{
    s32 retval = 0;
    task_t *task = NULL;
    task = (task_t *)kmalloc(STACK_SIZE, 0);
    if (task == NULL)
    {
        retval = -EAGAIN;
        goto alloc_copy_task_fail;
    }
    memset(task, 0, sizeof(task_t));
    memcpy(task, current, sizeof(task_t));

    list_init(&task->list);
    task->priority = 2;
    task->cpuid = current->cpuid;
    task->pid = globalpid++;
    task->preempt_count = 0;
    task->state = TASK_UNINTERRUPTIBLE;
    task->parent = current;
    task->exitcode = 0;
    task->next = tasklist[current->cpuid]->next;

    list_add_behind(&tasklist[current->cpuid]->list, &task->list);

    if (copy_flags(clone_flags, task))
    {
        goto copy_flags_fail;
    }
    if (copy_mem(clone_flags, task))
    {
        goto copy_mem_fail;
    }
    if (copy_file(clone_flags, task))
    {
        goto copy_file_fail;
    }
    if (copy_thread(clone_flags, stack_start, stack_size, task, regs))
    {
        goto copy_thread_fail;
    }
    retval = task->pid;
    wakeup_process(task);
fork_ok:
    return retval;
copy_thread_fail:
    exit_thread(task);
copy_file_fail:
    exit_file(task);
copy_mem_fail:
    exit_mem(task);
copy_flags_fail:
    kfree(task);
alloc_copy_task_fail:
    return retval;
}

s32 kernel_thread(u64 (*func)(u64), u64 args, u64 flags)
{
    stackregs_t regs;
    memset(&regs, 0, sizeof(stackregs_t));

    regs.rbx = (u64)func;
    regs.rdx = args;
    regs.ds = KERNEL_DATA_SEGMENT;
    regs.es = KERNEL_DATA_SEGMENT;
    regs.cs = KERNEL_CODE_SEGMENT;
    regs.ss = KERNEL_DATA_SEGMENT;
    regs.rflags = get_rflags();
    regs.rip = (u64)kernel_thread_func;
    return do_fork(&regs, flags, 0, 0);
}

void _switch_to_(task_t *prev, task_t *next)
{
    tss[current->cpuid].rsp0 = next->thread->rsp0;
    asm volatile("movq %%fs, %0\n" : "=a"(prev->thread->fs));
    asm volatile("movq %%gs, %0\n" : "=a"(prev->thread->gs));
    asm volatile("movq %0, %%fs\n" ::"a"(next->thread->fs));
    asm volatile("movq %0, %%gs\n" ::"a"(next->thread->gs));
    wrmsr(0x175, next->thread->rsp0);
}

