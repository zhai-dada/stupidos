#include <stackregs.h>
#include <spinlock.h>
#include <memory.h>
#include <task.h>
#include <printk.h>
#include <smp/cpu.h>
#include <vfs/fat32.h>
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <vfs/vfs.h>
#include <schedule.h>

struct mm_struct init_mm;
int64_t global_pid;

union task_stack_union init_task_stack __attribute__((__section__(".data.init_task_stack"))) =
{
    INIT_TASK(init_task_stack.task)
};

struct thread_struct init_thread =
{
    .rsp0 = (uint64_t)(init_task_stack.stack + STACK_SIZE / sizeof(uint64_t)),
    .rsp = (uint64_t)(init_task_stack.stack + STACK_SIZE / sizeof(uint64_t)),
    .fs = KERNEL_DATA_SEGMENT,
    .gs = KERNEL_DATA_SEGMENT,
    .cr2 = 0,
    .trap_nr = 0,
    .error_code = 0
};

struct task_struct *init_task[CPUNUM] = {&init_task_stack.task, 0};

struct mm_struct init_mm = {0};

struct tss_struct init_tss[CPUNUM] =
    {
        [0 ... CPUNUM - 1] = INIT_TSS};

struct task_struct *get_task(int64_t pid)
{
    struct task_struct *task = NULL;
    for (task = init_task[smp_cpu_id()]->next; task != init_task[smp_cpu_id()]; task = task->next)
    {
        if (task->pid == pid)
        {
            return task;
        }
    }
    return NULL;
}
struct file *open_exec_file(int8_t *path)
{
    struct dir_entry *dentry = NULL;
    struct file *filp = NULL;

    dentry = path_walk(path, 0);

    if (dentry == NULL)
    {
        return (struct file *)-ENOENT;
    }
    if (dentry->dir_inode->attribute == FS_ATTR_DIR)
    {
        return (struct file *)-ENOTDIR;
    }
    filp = (struct file *)kmalloc(sizeof(struct file), 0);
    if (filp == NULL)
    {
        return (struct file *)-ENOMEM;
    }
    filp->position = 0;
    filp->mode = 0;
    filp->dentry = dentry;
    filp->mode = O_RDONLY;
    filp->f_ops = dentry->dir_inode->f_ops;

    return filp;
}
extern void ret_system_call(void);
extern void fc(void);

inline void wakeup_process(struct task_struct *task)
{
    task->state = TASK_RUNNING;
    insert_task_queue(task);
    current->flags |= NEED_SCHEDULE;
    return;
}
uint64_t copy_flags(uint64_t clone_flags, struct task_struct *task)
{
    if (clone_flags & CLONE_VM)
    {
        task->flags |= PF_VFORK;
    }
    return 0;
}
uint64_t copy_file(uint64_t clone_flags, struct task_struct *task)
{
    int32_t error = 0;
    int32_t i = 0;
    if (clone_flags & CLONE_FS)
    {
        goto out;
    }
    for (i = 0; i < TASK_FILE_MAX; i++)
    {
        if (current->filestruct[i] != NULL)
        {
            task->filestruct[i] = (struct file *)kmalloc(sizeof(struct file), 0);
            memcpy(current->filestruct[i], task->filestruct[i], sizeof(struct file));
        }
    }
out:
    return error;
}
void exit_file(struct task_struct *task)
{
    int32_t i = 0;
    if (task->flags & PF_VFORK)
    {
        return;
    }
    else
    {
        for (i = 0; i < TASK_FILE_MAX; i++)
        {
            if (task->filestruct[i] != NULL)
            {
                kfree(task->filestruct[i]);
            }
        }
    }
    memset(task->filestruct, 0, sizeof(struct file *) * TASK_FILE_MAX);
    return;
}
uint64_t copy_mem(uint64_t clone_flags, struct task_struct *task)
{
    int32_t error = 0;
    struct mm_struct *newmm = NULL;
    uint64_t code_start_addr = 0x800000;
    uint64_t stack_start_addr = 0xa00000;
    uint64_t brk_start_addr = 0xc00000;
    uint64_t *tmp;
    uint64_t *virtual = NULL;
    struct page *p = NULL;

    if (clone_flags & CLONE_VM)
    {
        newmm = current->mm;
        goto out;
    }

    newmm = (struct mm_struct *)kmalloc(sizeof(struct mm_struct), 0);
    memcpy(current->mm, newmm, sizeof(struct mm_struct));

    newmm->pgd = (pml4t_t *)V_TO_P(kmalloc(PAGE_4K_SIZE, 0));
    memcpy((void *)(P_TO_V(init_task[smp_cpu_id()]->mm->pgd) + 256 * 8), (void *)(P_TO_V(newmm->pgd) + 256 * 8), PAGE_4K_SIZE / 2); // copy kernel space

    memset((void *)(P_TO_V(newmm->pgd)), 0, PAGE_4K_SIZE / 2); // copy user code & data & bss space

    tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)newmm->pgd & (~0xfffUL))) + ((code_start_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
    virtual = kmalloc(PAGE_4K_SIZE, 0);
    memset(virtual, 0, PAGE_4K_SIZE);
    set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_USER_GDT));

    tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp) & (~0xfffUL))) + ((code_start_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
    virtual = kmalloc(PAGE_4K_SIZE, 0);
    memset(virtual, 0, PAGE_4K_SIZE);
    set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_USER_DIR));

    tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp) & (~0xfffUL))) + ((code_start_addr >> PAGE_2M_SHIFT) & 0x1ff) * 8);
    p = alloc_pages(ZONE_NORMAL, 1, PAGE_PT_MAPED);
    set_pdt(tmp, make_pdt(p->p_address, PAGE_USER_PAGE));

    memcpy((void *)(code_start_addr), (void *)(P_TO_V(p->p_address)), stack_start_addr - code_start_addr);
    if (current->mm->end_brk - current->mm->start_brk != 0)
    {
        tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)newmm->pgd & (~0xfffUL))) + ((brk_start_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
        tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp) & (~0xfffUL))) + ((brk_start_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
        tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp) & (~0xfffUL))) + ((brk_start_addr >> PAGE_2M_SHIFT) & 0x1ff) * 8);
        p = alloc_pages(ZONE_NORMAL, 1, PAGE_PT_MAPED);
        set_pdt(tmp, make_pdt(p->p_address, PAGE_USER_PAGE));
        memcpy((void *)brk_start_addr, (void *)P_TO_V(p->p_address), PAGE_2M_SIZE);
    }

out:
    task->mm = newmm;
    return error;
}
void exit_mem(struct task_struct *task)
{
    uint64_t code_start_addr = current->mm->start_code;
    uint64_t *tmp4;
    uint64_t *tmp3;
    uint64_t *tmp2;

    if (task->flags & PF_VFORK)
    {
        return;
    }
    if (task->mm->pgd != NULL)
    {
        tmp4 = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)task->mm->pgd & (~0xfffUL))) + ((code_start_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
        tmp3 = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp4) & (~0xfffUL))) + ((code_start_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
        tmp2 = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp3) & (~0xfffUL))) + ((code_start_addr >> PAGE_2M_SHIFT) & 0x1ff) * 8);

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
void switch_mm(struct task_struct *prev, struct task_struct *next)
{
    asm volatile
    (
        "movq %0, %%cr3	\n"
        :
        : "r"(next->mm->pgd)
        : "memory"
    );
    return;
}
uint64_t copy_thread(uint64_t clone_flags, uint64_t stack_start, uint64_t stack_size, struct task_struct *task, struct stackregs *regs)
{
    uint32_t color = 0;
    switch (smp_cpu_id())
    {
    case 0:
        color = GREEN;
        break;
    case 1:
        color = YELLOW;
        break;
    case 2:
        color = BLUE;
        break;
    case 3:
        color = ORANGE;
        break;
    }
    struct thread_struct *thd = NULL;
    struct stackregs *childregs = NULL;

    thd = (struct thread_struct *)(task + 1);
    memset(thd, 0, sizeof(struct thread_struct));
    task->thread = thd;

    childregs = (struct stackregs *)((uint64_t)task + STACK_SIZE) - 1;

    memcpy(regs, childregs, sizeof(struct stackregs));
    childregs->rax = 0;
    childregs->rsp = stack_start;

    thd->rsp0 = (uint64_t)task + STACK_SIZE;
    thd->rsp = (uint64_t)childregs;
    thd->fs = current->thread->fs;
    thd->gs = current->thread->gs;

    if (task->flags & PF_KTHREAD)
    {
        thd->rip = (uint64_t)fc;
    }
    else
    {
        thd->rip = (uint64_t)ret_system_call;
    }
    return 0;
}
void exit_thread(struct task_struct *task)
{
    return;
}
uint64_t do_fork(struct stackregs *regs, uint64_t clone_flags, uint64_t stack_start, uint64_t stack_size)
{
    int32_t retval = 0;
    struct task_struct *task = NULL;
    task = (struct task_struct *)kmalloc(STACK_SIZE, 0);
    // color_printk(INDIGO, BLACK, "struct task_struct address:%#018lx\n", (uint64_t)task);
    if (task == NULL)
    {
        retval = -EAGAIN;
        goto alloc_copy_task_fail;
    }
    memset(task, 0, sizeof(struct task_struct));
    memcpy(current, task, sizeof(struct task_struct));
    list_init(&task->list);
    task->priority = 2;
    task->cpu_id = smp_cpu_id();
    task->pid = global_pid++;
    task->preempt_count = 0;
    task->state = TASK_UNINTERRUPTIBLE;
    task->parent = current;
    task->exitcode = 0;
    task->next = init_task_stack.task.next;
    init_task_stack.task.next = task;
    wait_queue_init(&task->childexit_wait, NULL);
    retval = -ENOMEM;
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
alloc_copy_task_fail:
    kfree(task);
    return retval;
}
void _switch_to_(struct task_struct *prev, struct task_struct *next)
{
    uint32_t color = 0;
    switch (smp_cpu_id())
    {
    case 0:
        color = GREEN;
        break;
    case 1:
        color = YELLOW;
        break;
    case 2:
        color = BLUE;
        break;
    case 3:
        color = ORANGE;
        break;
    }
    init_tss[smp_cpu_id()].rsp0 = next->thread->rsp0;
    asm volatile("movq %%fs, %0\n" : "=a"(prev->thread->fs));
    asm volatile("movq %%gs, %0\n" : "=a"(prev->thread->gs));
    asm volatile("movq %0, %%fs\n" ::"a"(next->thread->fs));
    asm volatile("movq %0, %%gs\n" ::"a"(next->thread->gs));
    wrmsr(0x175, next->thread->rsp0);
    // color_printk(color, BLACK, "%0#018lx %#018lx\n", current->thread->rsp0, next->thread->rsp0);
}

asm
(
    ".global fc\n"
    "fc:\n"
    "popq %r15\n"
    "popq %r14\n"
    "popq %r13\n"
    "popq %r12\n"
    "popq %r11\n"
    "popq %r10\n"
    "popq %r9\n"
    "popq %r8\n"
    "popq %rbx\n"
    "popq %rcx\n"
    "popq %rdx\n"
    "popq %rsi\n"
    "popq %rdi\n"
    "popq %rbp\n"
    "popq %rax\n"
    "movq %rax, %ds\n"
    "popq %rax\n"
    "movq %rax, %es\n"
    "popq %rax\n"
    "addq $56, %rsp\n"
    "movq %rdx, %rdi\n"
    "callq *%rbx\n"
    "movq %rax, %rdi\n"
    "callq do_exit\n"
);
void exit_notify(void)
{
    wakeup(&current->parent->childexit_wait, TASK_INTERRUPTIBLE);
}
uint64_t do_exit(int64_t code)
{
    struct task_struct *task = current;
    // color_printk(ORANGE, BLACK, "exit task is running, arg code = %#018lx\n", code);
    do_exit_again:
    cli();
    task->state = TASK_ZOMBIE;
    task->exitcode = code;
    exit_thread(task);
    exit_file(task);
    sti();
    exit_notify();
    schedule();
    goto do_exit_again;
    return 0;
}
int32_t kernel_thread(uint64_t (*func)(uint64_t), uint64_t args, uint64_t flags)
{
    struct stackregs regs;
    memset(&regs, 0, sizeof(regs));
    regs.rbx = (uint64_t)func;
    regs.rdx = args;
    regs.ds = KERNEL_DATA_SEGMENT;
    regs.es = KERNEL_DATA_SEGMENT;
    regs.cs = KERNEL_CODE_SEGMENT;
    regs.ss = KERNEL_DATA_SEGMENT;
    regs.rflags = get_rflags();
    regs.rip = (uint64_t)fc;
    return do_fork(&regs, flags | CLONE_VM, 0, 0);
}
uint64_t do_execve(struct stackregs *regs, int8_t *name, uint8_t *argv[], uint8_t *envp[])
{
    uint64_t code_start_addr = 0x800000;
    uint64_t stack_start_addr = 0xa00000;
    uint64_t brk_start_addr = 0xc00000;
    uint64_t *tmp;
    uint64_t *virtual = NULL;
    struct page *p = NULL;
    struct file *filp = NULL;
    uint64_t retval = 0;
    int64_t pos = 0;
    if (current->flags & PF_VFORK)
    {
        current->mm = (struct mm_struct *)kmalloc(sizeof(struct mm_struct), 0);
        memset(current->mm, 0, sizeof(struct mm_struct));

        current->mm->pgd = (pml4t_t *)V_TO_P(kmalloc(PAGE_4K_SIZE, 0));
        color_printk(RED, BLACK, "load_binary_file malloc new pgd:%#018lx\n", current->mm->pgd);
        memset((void *)P_TO_V(current->mm->pgd), 0, PAGE_4K_SIZE / 2);
        memcpy((void *)P_TO_V(init_task[smp_cpu_id()]->mm->pgd) + 256, (void *)P_TO_V(current->mm->pgd) + 256, PAGE_4K_SIZE / 2); // copy kernel space
    }

    tmp = (uint64_t *)P_TO_V((uint64_t *)((uint64_t)current->mm->pgd & (~0xfffUL)) + ((code_start_addr >> PAGE_GDT_SHIFT) & 0x1ff));
    if (*tmp == NULL)
    {
        virtual = (uint64_t *)kmalloc(PAGE_4K_SIZE, 0);
        memset(virtual, 0, PAGE_4K_SIZE);
        set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_USER_GDT));
    }

    tmp = (uint64_t *)P_TO_V((uint64_t *)(*tmp & (~0xfffUL)) + ((code_start_addr >> PAGE_1G_SHIFT) & 0x1ff));
    if (*tmp == NULL)
    {
        virtual = (uint64_t *)kmalloc(PAGE_4K_SIZE, 0);
        memset(virtual, 0, PAGE_4K_SIZE);
        set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_USER_DIR));
    }

    tmp = (uint64_t *)P_TO_V((uint64_t *)(*tmp & (~0xfffUL)) + ((code_start_addr >> PAGE_2M_SHIFT) & 0x1ff));
    if (*tmp == NULL)
    {
        p = alloc_pages(ZONE_NORMAL, 1, PAGE_PT_MAPED);
        set_pdt(tmp, make_pdt(p->p_address, PAGE_USER_PAGE));
    }
    asm volatile
    (
        "movq	%0,	%%cr3	\n"
        :
        : "r"(current->mm->pgd)
        : "memory"
    );
    filp = open_exec_file(name);
	if((uint64_t)filp > -0x1000UL)
	{
        return (uint64_t)filp;
    }
    if (!(current->flags & PF_KTHREAD))
    {
        current->addr_limit = TASK_SIZE;
    }
    current->mm->start_code = code_start_addr;
    current->mm->end_code = 0;
    current->mm->start_data = 0;
    current->mm->end_data = 0;
    current->mm->start_rodata = 0;
    current->mm->end_rodata = 0;
    current->mm->start_bss = code_start_addr + filp->dentry->dir_inode->file_size;
    current->mm->end_bss = stack_start_addr;
    current->mm->start_brk = brk_start_addr;
    current->mm->end_brk = brk_start_addr;
    current->mm->start_stack = stack_start_addr;

    exit_file(current);

    current->flags &= ~PF_VFORK;

	// if(argv != NULL)
	// {
	// 	int argc = 0;
	// 	int len = 0;
	// 	int i = 0;
	// 	uint8_t **dargv = (uint8_t **)(stack_start_addr - 10 * sizeof(char *));
	// 	pos = (uint64_t)dargv;

	// 	for(i = 0; i < 10 && argv[i] != NULL; ++i)
	// 	{
	// 		len = strlen(argv[i]);
	// 		strcpy((uint8_t *)(pos - len), argv[i]);
	// 		dargv[i] = (uint8_t *)(pos - len);
	// 		pos -= len;
	// 	}
	// 	stack_start_addr = pos - 10 - 10;
	// 	regs->rdi = i;
	// 	regs->rsi = (uint64_t)dargv;
	// }

    memset((void *)code_start_addr, 0, stack_start_addr - code_start_addr);
    pos = 0;

    retval = filp->f_ops->read(filp, (void *)code_start_addr, filp->dentry->dir_inode->file_size, &pos);
    asm	volatile
    (
        "movq %0, %%gs  \n"
        "movq %0, %%fs  \n"
        :
        :"r"((uint64_t)0)
        :
    );
    regs->ds = USER_DATA_SEGMENT;
    regs->es = USER_DATA_SEGMENT;
    regs->ss = USER_DATA_SEGMENT;
    regs->cs = USER_CODE_SEGMENT;
    regs->r10 = code_start_addr;
    regs->r11 = stack_start_addr;
    regs->rax = 1;
    return retval;
}
extern void system_call(void);

uint64_t init(uint64_t arg)
{
    disk_fat32_fs_init();
    color_printk(YELLOW, BLACK, "init task is running, arg code = %#018lx\n", arg);
    current->thread->rip = (uint64_t)ret_system_call;
    current->thread->rsp = (uint64_t)current + STACK_SIZE - sizeof(struct stackregs);
    current->thread->fs = USER_DATA_SEGMENT;
    current->thread->gs = USER_DATA_SEGMENT;
    current->flags &= ~PF_KTHREAD;
    asm volatile
    (
        "movq %2, %%rsp\n"
        "pushq %1\n"
        "jmp do_execve\n"
        :
        : "D"(current->thread->rsp), "m"(current->thread->rip), "m"(current->thread->rsp), "S"("/init.bin"), "d"(NULL), "c"(NULL)
        : "memory"
    );
    return 1;
}
void task_init(void)
{
    // color_printk(YELLOW, BLACK, "cpu id:%d into task\n", current->cpu_id);
    uint64_t *tmp = NULL;
    uint64_t *vaddr = NULL;
    uint64_t *virtual = NULL;
    int32_t i = 0;
    if(smp_cpu_id() == 0)
    {
        vaddr = (uint64_t *)P_TO_V((uint64_t)get_gdt() & (~0xfffUL));
        *vaddr = 0UL;
        for (i = 256; i < 512; ++i)
        {
            tmp = vaddr + i;
            if (*tmp == 0)
            {
                virtual = (uint64_t *)kmalloc(PAGE_4K_SIZE, 0);
                memset(virtual, 0, PAGE_4K_SIZE);
                set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_KERNEL_GDT));
            }
        }
        flush_tlb();
        current->mm->pgd = (pml4t_t *)get_gdt();
        current->mm->start_code = (uint64_t)&_text;
        current->mm->end_code = (uint64_t)&_etext;
        current->mm->start_data = (uint64_t)&_data;
        current->mm->end_data = (uint64_t)&_edata;
        current->mm->start_rodata = (uint64_t)&_rodata;
        current->mm->end_rodata = (uint64_t)&_erodata;
        current->mm->start_brk = (uint64_t)&_bss;
        current->mm->end_brk = init_task[smp_cpu_id()]->addr_limit;
        current->mm->start_bss = (uint64_t)&_bss;
        current->mm->end_bss = (uint64_t)&_ebss;
        current->mm->start_stack = init_task[smp_cpu_id()]->thread->rsp0;
    }
    wrmsr(0x174, KERNEL_CODE_SEGMENT);
    wrmsr(0x175, init_task[smp_cpu_id()]->thread->rsp0);
    wrmsr(0x176, (uint64_t)system_call);
    barrier();
    list_init(&init_task[smp_cpu_id()]->list);
    wait_queue_init(&init_task_stack.task.childexit_wait, NULL);
    kernel_thread(init, 10, CLONE_FS | CLONE_SIGNAL);
    init_task[smp_cpu_id()]->preempt_count = 0;
    init_task[smp_cpu_id()]->state = TASK_RUNNING;
    return;
}
