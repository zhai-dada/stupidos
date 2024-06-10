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

extern int8_t _text;
extern int8_t _etext;

extern int8_t _data;
extern int8_t _edata;

extern int8_t _rodata;
extern int8_t _erodata;

extern int8_t _bss;
extern int8_t _ebss;

extern int8_t _end;

extern int64_t global_pid;

extern int64_t _stack_start_;
extern void ret_from_intr();

struct mm_struct
{
    pml4t_t* pgd;
    uint64_t start_code, end_code;
    uint64_t start_data, end_data;
    uint64_t start_rodata, end_rodata;
    uint64_t start_bss, end_bss;
    uint64_t start_brk, end_brk;
    uint64_t start_stack;
};
struct thread_struct
{
    uint64_t rsp0;
    uint64_t rip;
    uint64_t rsp;
    uint64_t fs;
    uint64_t gs;
    uint64_t cr2;
    uint64_t trap_nr;
    uint64_t error_code;
};

#define PF_KTHREAD  (1UL << 0)
#define NEED_SCHEDULE    (1UL << 1)
#define PF_VFORK	(1UL << 2)

#define TASK_FILE_MAX 10
struct task_struct
{
    volatile int64_t state;                 //0x00
    volatile uint64_t flags;                //0x08
    volatile int64_t preempt_count;         //0x10
    volatile int64_t signal;                //0x18
    int64_t cpu_id;                         //0x20
    int64_t pid;               
    int64_t priority;          
    int64_t vruntime;          
    uint64_t addr_limit;
    int64_t exitcode;
    struct mm_struct* mm;
    struct thread_struct* thread;
    struct list list;
    struct file* filestruct[TASK_FILE_MAX];
    waitque_t childexit_wait;
    struct task_struct *next;
	struct task_struct *parent;
};

struct tss_struct
{
    uint32_t reserved0;
    uint64_t rsp0;
    uint64_t rsp1;;
    uint64_t rsp2;
    uint64_t reserved1;
    uint64_t ist1;
    uint64_t ist2;
    uint64_t ist3;
    uint64_t ist4;
    uint64_t ist5;
    uint64_t ist6;
    uint64_t ist7;
    uint64_t reserved2;
    uint16_t reserved3;
    uint16_t iomapbaseaddr;
}__attribute__((packed));

union task_stack_union
{
    struct task_struct task;
    uint64_t stack[STACK_SIZE / sizeof(uint64_t)];
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
    .rsp0 = (uint64_t)(init_task_stack.stack + STACK_SIZE / sizeof(uint64_t)),  \
    .rsp1 = (uint64_t)(init_task_stack.stack + STACK_SIZE / sizeof(uint64_t)),  \
    .rsp2 = (uint64_t)(init_task_stack.stack + STACK_SIZE / sizeof(uint64_t)),  \
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
uint64_t do_fork(struct stackregs *regs, uint64_t clone_flags, uint64_t stack_start, uint64_t stack_size);
void wakeup_process(struct task_struct *task);
void smp_task_init(void);
void exit_mem(struct task_struct *task);
uint64_t do_exit(int64_t code);

uint64_t do_execve(struct stackregs *regs, int8_t *name, uint8_t *argv[], uint8_t *envp[]);
#endif