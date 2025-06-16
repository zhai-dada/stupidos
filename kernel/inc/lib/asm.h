#ifndef __LIB_ASM_H__
#define __LIB_ASM_H__

#include <stdint.h>

#define nop()       asm volatile ("nop":::"memory")
#define hlt()       asm volatile ("hlt":::"memory")
#define sti()       asm volatile ("sti":::"memory")
#define cli()       asm volatile ("cli":::"memory")
#define io_mfence() asm volatile ("mfence":::"memory")
#define barrier()   asm volatile ("":::"memory")

#define flush_cr3()             \
{                               \
    u64 a;                      \
    asm volatile                \
    (                           \
        "movq %%cr3, %0  \n"    \
        "movq %0, %%cr3  \n"    \
        : "=r"(a)               \
        :                       \
        : "memory"              \
    );                          \
}

#define local_irq_save(x)   \
    asm volatile            \
    (                       \
        "pushfq     \n"     \
        "popq %0    \n"     \
        "cli        \n"     \
        : "=g"(x)           \
        :                   \
        : "memory"          \
    );

#define local_irq_restore(x)\
    asm volatile            \
    (                       \
        "pushq %0   \n"     \
        "popfq      \n"     \
        :                   \
        : "g"(x)            \
        : "memory"          \
    );

__attribute__((always_inline)) inline u64 rdmsr(u64 address)
{
    u64 r1, r2;
    asm volatile
    (
        "rdmsr          \n"
        :"=d"(r1), "=a"(r2)
        :"c"(address)
        :"memory"
    );
    return (u64)((r1 << 32) | r2);
}
__attribute__((always_inline)) inline void wrmsr(u64 address, u64 value)
{
    asm volatile
    (
        "wrmsr\n"
        :
        :"d"(value >> 32), "a"(value & 0xffffffff), "c"(address)
        :"memory"
    );
    return;
}

/**
 * 获取flags寄存器状态
*/
__attribute__((always_inline)) inline u64 get_rflags()
{
	u64 tmp = 0;
    asm volatile
    (
        "pushfq                 \n"
        "movq 0(%%rsp), %0      \n"
        "popfq                  \n"
        : "=r"(tmp)
        :
        : "memory"
    );
	return tmp;
}

u64 *get_gdt(void);

#endif