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

u64 *get_gdt(void);

#endif