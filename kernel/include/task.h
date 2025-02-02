#ifndef __TASK_H__
#define __TASK_H__

#include <lib.h>
#include <stdint.h>
#include <memory.h>
#include <smp/cpu.h>
#include <smp/smp.h>
#include <stackregs.h>
#include <waitque.h>

#define STACK_SIZE 65536
#define TASK_SIZE 0x00007fffffffffff
#define KERNEL_CODE_SEGMENT (0x08)
#define KERNEL_DATA_SEGMENT (0x10)
#define	USER_CODE_SEGMENT	(0x28)
#define USER_DATA_SEGMENT 	(0x30)

extern s8 _text;
extern s8 _etext;

extern s8 _data;
extern s8 _edata;

extern s8 _rodata;
extern s8 _erodata;

extern s8 _bss;
extern s8 _ebss;

extern s8 _end;

extern s64 global_pid;

extern u64 _stack_start_;
extern void ret_from_intr();

struct mm_struct
{
    pml4t_t* pgd;
    u64 start_code, end_code;
    u64 start_data, end_data;
    u64 start_rodata, end_rodata;
    u64 start_bss, end_bss;
    u64 start_brk, end_brk;
    u64 start_stack;
};
struct thread_struct
{
    u64 rsp0;
    u64 rip;
    u64 rsp;
    u64 fs;
    u64 gs;
    u64 cr2;
    u64 trap_nr;
    u64 error_code;
};

#define PF_KTHREAD  (1UL << 0)
#define NEED_SCHEDULE    (1UL << 1)
#define PF_VFORK	(1UL << 2)

#define TASK_FILE_MAX 10
struct task_struct
{
    volatile s64 state;                 //0x00
    volatile u64 flags;                //0x08
    volatile s64 preempt_count;         //0x10
    volatile s64 signal;                //0x18
    s64 cpu_id;                         //0x20
    s64 pid;               
    s64 priority;          
    s64 vruntime;          
    u64 addr_limit;
    s64 exitcode;
    struct mm_struct* mm;
    struct thread_struct* thread;
    list_t list;
    struct file* filestruct[TASK_FILE_MAX];
    waitque_t childexit_wait;
    struct task_struct *next;
	struct task_struct *parent;
};

struct tss_struct
{
    u32 reserved0;
    u64 rsp0;
    u64 rsp1;;
    u64 rsp2;
    u64 reserved1;
    u64 ist1;
    u64 ist2;
    u64 ist3;
    u64 ist4;
    u64 ist5;
    u64 ist6;
    u64 ist7;
    u64 reserved2;
    u16 reserved3;
    u16 iomapbaseaddr;
}__attribute__((packed));

union task_stack_union
{
    struct task_struct task;
    u64 stack[STACK_SIZE / sizeof(u64)];
}__attribute__((aligned(8)));

#define TASK_RUNNING            (1UL << 0)
#define TASK_INTERRUPTIBLE      (1UL << 1)
#define TASK_UNINTERRUPTIBLE    (1UL << 2)
#define TASK_ZOMBIE             (1UL << 3)
#define TASK_STOPPED            (1UL << 4)

extern struct mm_struct init_mm;
extern struct thread_struct init_thread;

#define INIT_TASK(task)                     \
{                                           \
    .state = TASK_UNINTERRUPTIBLE,          \
    .flags = PF_KTHREAD,                    \
    .preempt_count = 0,                     \
    .signal = 0,                            \
    .cpu_id = 0,                            \
    .pid = 0,                               \
    .priority = 2,                          \
    .vruntime = 0,                          \
    .addr_limit = 0xffff800000000000,       \
    .mm = &init_mm,                         \
    .thread = &init_thread,                 \
    .filestruct = {0},                      \
    .next = &task,                          \
    .parent = &task                         \
}

#define INIT_TSS                \
{                               \
    .reserved0 = 0,             \
    .rsp0 = (u64)(init_task_stack.stack + STACK_SIZE / sizeof(u64)),  \
    .rsp1 = (u64)(init_task_stack.stack + STACK_SIZE / sizeof(u64)),  \
    .rsp2 = (u64)(init_task_stack.stack + STACK_SIZE / sizeof(u64)),  \
    .reserved1 = 0,             \
    .ist1 = 0xffff800000007c00, \
    .ist2 = 0xffff800000007c00, \
    .ist3 = 0xffff800000007c00, \
    .ist4 = 0xffff800000007c00, \
    .ist5 = 0xffff800000007c00, \
    .ist6 = 0xffff800000007c00, \
    .ist7 = 0xffff800000007c00, \
    .reserved2 = 0,             \
    .reserved3 = 0,             \
    .iomapbaseaddr = 0          \
}
__attribute__((always_inline)) inline struct task_struct* get_current()
{
    struct task_struct* current = NULL;
    asm volatile
    (
        "andq %%rsp, %0\n"
        :"=r"(current)
        :"0"(~65535UL)
        :
    );
    return current;
}
#define current get_current()

#define switch_to(prev, next)                   \
    asm volatile                                \
    (                                           \
        "pushq %%rbp\n"                         \
        "pushq %%rax\n"                         \
        "movq %%rsp, %0\n"                      \
        "movq %2, %%rsp\n"                      \
        "leaq 1f(%%rip), %%rax\n"               \
        "movq %%rax, %1\n"                      \
        "pushq %3\n"                            \
        "jmp _switch_to_\n"                     \
        "1:\n"                                  \
        "popq %%rax\n"                          \
        "popq %%rbp\n"                          \
        :"=m"(prev->thread->rsp), "=m"(prev->thread->rip)  \
        :"m"(next->thread->rsp), "m"(next->thread->rip), "D"(prev), "S"(next)  \
        :"memory"                               \
    );

extern union task_stack_union init_task_stack __attribute__((__section__(".data.init_task_stack")));
extern struct task_struct* init_task[CPUNUM];
extern struct mm_struct init_mm;
extern struct tss_struct init_tss[CPUNUM];

void task_init(void);
void _switch_to_(struct task_struct* prev, struct task_struct* next);
void switch_mm(struct task_struct *prev, struct task_struct *next);
u64 do_fork(struct stackregs *regs, u64 clone_flags, u64 stack_start, u64 stack_size);
void wakeup_process(struct task_struct *task);
void smp_task_init(void);
void exit_mem(struct task_struct *task);
u64 do_exit(s64 code);

u64 do_execve(struct stackregs *regs, s8 *name, u8 *argv[], u8 *envp[]);
s32 kernel_thread(u64 (*func)(u64), u64 args, u64 flags);

#endif