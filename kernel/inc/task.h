#ifndef __TASK_H__
#define __TASK_H__

#include <stdint.h>
#include <cpu.h>
#include <mm/kmem.h>
#include <lib/list.h>

#define STACK_SIZE 65536

// TSS
typedef struct
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

struct task_struct
{
    volatile s64 state;                 //0x00
    volatile u64 flags;                 //0x08
    volatile s64 preempt_count;         //0x10
    volatile s64 signal;                //0x18
    u64 cpu_id;                         //0x20
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
};

typedef union
{
    struct task_struct task;
    u64 stack[STACK_SIZE / sizeof(u64)];
}__attribute__((aligned(8))) task_stack;

#endif