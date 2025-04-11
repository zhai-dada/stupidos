#ifndef __GATE_H_
#define __GATE_H__

#include <stdint.h>

typedef struct
{
    u64 gdt;
}__attribute__((packed)) gdt_t;
typedef struct
{
    u64 idt_low;
    u64 idt_high;
}__attribute__((packed)) idt_t;

extern gdt_t gdt_table[];
extern idt_t idt_table[];


#define load_tr(n)          \
        asm volatile        \
        (                   \
            "ltr %%ax   \n" \
            :               \
            : "a"(n << 3)   \
            : "memory"      \
        );

void set_intr_gate(u32 n, u8 ist, void *addr);
void set_trap_gate(u32 n, u8 ist, void *addr);

void set_system_intr_gate(u32 n, u8 ist, void *addr);
void set_system_trap_gate(u32 n, u8 ist, void *addr);

void set_tss_descriptor(u32 n, void* addr);
void set_tss64(u32* tss_table, u64 rsp0, u64 rsp1, u64 rsp2, u64 ist1, \
    u64 ist2, u64 ist3, u64 ist4, u64 ist5, u64 ist6, u64 ist7);
    
#endif