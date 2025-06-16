#ifndef __TASK_H__
#define __TASK_H__

#include <stdint.h>
#include <cpu.h>
#include <mm/kmem.h>
#include <lib/asm.h>

#define STACK_SIZE 65536

#define KERNEL_CODE_SEGMENT (0x08)
#define KERNEL_DATA_SEGMENT (0x10)
#define	USER_CODE_SEGMENT	(0x28)
#define USER_DATA_SEGMENT 	(0x30)

// tss
typedef struct
{
    u32 reserved0;  // 0
    u64 rsp0;       // 1
    u64 rsp1;       // 3
    u64 rsp2;       // 5
    u64 reserved1;  // 7
    u64 ist1;       // 9
    u64 ist2;       // 11
    u64 ist3;       // 13
    u64 ist4;       // 15
    u64 ist5;       // 17
    u64 ist6;       // 19
    u64 ist7;       // 21
    u64 reserved2;  // 23
    u16 reserved3;  // 25
    u16 iomapbaseaddr;
}__attribute__((packed)) tss_t;

#define INIT_TSS                     \
{                                    \
    .reserved0 = (u32)0,             \
    .rsp0 = (u64)0xffff800000007c00, \
    .rsp1 = (u64)0xffff800000007c00, \
    .rsp2 = (u64)0xffff800000007c00, \
    .reserved1 = (u64)0,             \
    .ist1 = (u64)0xffff800000007c00, \
    .ist2 = (u64)0xffff800000007c00, \
    .ist3 = (u64)0xffff800000007c00, \
    .ist4 = (u64)0xffff800000007c00, \
    .ist5 = (u64)0xffff800000007c00, \
    .ist6 = (u64)0xffff800000007c00, \
    .ist7 = (u64)0xffff800000007c00, \
    .reserved2 = (u64)0,             \
    .reserved3 = (u16)0,             \
    .iomapbaseaddr = (u16)0          \
}

extern tss_t tss[MAX_CPUNUM];

// task mmm
typedef struct
{
    pml4t_t* pgd;
    u64 start_code, end_code;
    u64 start_data, end_data;
    u64 start_rodata, end_rodata;
    u64 start_bss, end_bss;
    u64 start_brk, end_brk;
    u64 start_stack, end_stack;
} task_mm_t;

// thread
typedef struct
{
    u64 rsp0;
    u64 rip;
    u64 rsp;
    u64 fs;
    u64 gs;
    u64 cr2;
    u64 trap_nr;
    u64 error_code;
} thread_t;

typedef struct task_struct
{
    volatile s64 state;                 //0x00
    volatile u64 flags;                 //0x08
    volatile s64 preempt_count;         //0x10
    volatile s64 signal;                //0x18
    u64 cpuid;                          //0x20
    u64 pid;               
    s64 priority;          
    s64 vruntime;          
    u64 addrlimit;
    s64 exitcode;
    task_mm_t* mm;
    thread_t* thread;
    list_t list;
    struct task_struct *next;
	struct task_struct *parent;
} task_t;

typedef union
{
    struct task_struct task;
    u64 stack[STACK_SIZE / sizeof(u64)];
}__attribute__((aligned(8))) task_stack_t;

// task states
#define TASK_RUNNING            (1UL << 0)
#define TASK_INTERRUPTIBLE      (1UL << 1)
#define TASK_UNINTERRUPTIBLE    (1UL << 2)
#define TASK_ZOMBIE             (1UL << 3)
#define TASK_STOPPED            (1UL << 4)

// task flags
#define PF_KTHREAD              (1UL << 0)
#define NEED_SCHEDULE           (1UL << 1)
#define PF_VFORK	            (1UL << 2)

#define CLONE_VM		(1 << 0)	/* 进程间共享虚拟内存 */
#define CLONE_FS		(1 << 1)	/* 进程间共享文件系统信息 */
#define CLONE_SIGNAL	(1 << 2)	/* 进程间共享信号 */

extern task_mm_t init_mm;
extern thread_t init_thread;

#define INIT_TASK(task)                     \
{                                           \
    .state = TASK_UNINTERRUPTIBLE,          \
    .flags = PF_KTHREAD,                    \
    .preempt_count = 0,                     \
    .signal = 0,                            \
    .cpuid = 0,                            \
    .pid = 0,                               \
    .priority = 2,                          \
    .vruntime = 0,                          \
    .addrlimit = 0xffff800000000000,       \
    .mm = &init_mm,                         \
    .thread = &init_thread,                 \
    .next = &task,                          \
    .parent = &task                         \
}

__attribute__((always_inline)) inline task_t* get_current()
{
    task_t* current = NULL;
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

#define switch_to(prev, next)                                               \
asm volatile                                                                \
(                                                                           \
    "pushq %%rbp\n"                                                         \
    "pushq %%rax\n"                                                         \
    "movq %%rsp, %0\n"                                                      \
    "movq %2, %%rsp\n"                                                      \
    "leaq 1f(%%rip), %%rax\n"                                               \
    "movq %%rax, %1\n"                                                      \
    "pushq %3\n"                                                            \
    "jmp _switch_to_\n"                                                     \
    "1:\n"                                                                  \
    "popq %%rax\n"                                                          \
    "popq %%rbp\n"                                                          \
    :"=m"(prev->thread->rsp), "=m"(prev->thread->rip)                       \
    :"m"(next->thread->rsp), "m"(next->thread->rip), "D"(prev), "S"(next)   \
    :"memory"                                                               \
);

extern u64 globalpid;

extern task_t* tasklist[MAX_CPUNUM];

void wakeup_process(task_t *task);
void switch_mm(task_t *prev, task_t *next);

#endif