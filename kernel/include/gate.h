#ifndef __GATE_H_
#define __GATE_H__

#include <stdint.h>

struct gdt_struct
{
    u8 gdt[8];
};
struct idt_struct
{
    u8 idt[16];
};

extern struct gdt_struct gdt_table[];
extern struct idt_struct idt_table[];

#define set_gate(gate_addr, attr, ist, code_addr)                               \
        u64 d0, d1;                                                             \
        asm volatile                                                            \
        (                                                                       \
            "movw %%dx, %%ax	\n"                                             \
            "andq $0x7, %%rcx	\n"                                             \
            "addq %4, %%rcx     \n"                                             \
            "shlq $32, %%rcx	\n"                                             \
            "addq %%rcx, %%rax	\n"                                             \
            "xorq %%rcx, %%rcx	\n"                                             \
            "movl %%edx, %%ecx	\n"                                             \
            "shrq $16, %%rcx	\n"                                             \
            "shlq $48, %%rcx	\n"                                             \
            "addq %%rcx, %%rax	\n"                                             \
            "movq %%rax, %0	    \n"                                             \
            "shrq $32, %%rdx	\n"                                             \
            "movq %%rdx, %1     \n"                                             \
            :   "=m"(*((u64 *)(gate_addr))),                                    \
                "=m"(*(1 + (u64 *)(gate_addr))), "=&a"(d0), "=&d"(d1)           \
            :   "i"(attr << 8),                                                 \
                "2"(0x8 << 16), "3"((u64 *)(code_addr)), "c"(ist)               \
            :   "memory"                                                        \
        );

#define load_tr(n)          \
        asm volatile        \
        (                   \
            "ltr %%ax   \n" \
            :               \
            : "a"(n << 3)   \
            : "memory"      \
        );

void set_intr_gate(u32 n, u8 ist, void *addr)
{
    set_gate(idt_table + n, 0x8E, ist, addr);
    // P, DPL = 0, TYPE = E
    return;
}
void set_trap_gate(u32 n, u8 ist, void *addr)
{
    set_gate(idt_table + n, 0x8F, ist, addr);
    // P, DPL = 0, TYPE = F
    return;
}
void set_system_intr_gate(u32 n, u8 ist, void *addr)
{
    set_gate(idt_table + n, 0xEE, ist, addr);
    // P, DPL = 3, TYPE = E
    return;
}
void set_system_trap_gate(u32 n, u8 ist, void *addr)
{
    set_gate(idt_table + n, 0xEF, ist, addr);
    // P DPL = 3, TYPE = F
    return;
}
void set_tss64(u32* tss_table, u64 rsp0, u64 rsp1, u64 rsp2, u64 ist1, \
                u64 ist2, u64 ist3, u64 ist4, u64 ist5, u64 ist6, u64 ist7)
{
    *(u64 *)(tss_table + 1) = rsp0;
    *(u64 *)(tss_table + 3) = rsp1;
    *(u64 *)(tss_table + 5) = rsp2;

    *(u64 *)(tss_table + 9) = ist1;
    *(u64 *)(tss_table + 11) = ist2;
    *(u64 *)(tss_table + 13) = ist3;
    *(u64 *)(tss_table + 15) = ist4;
    *(u64 *)(tss_table + 17) = ist5;
    *(u64 *)(tss_table + 19) = ist6;
    *(u64 *)(tss_table + 21) = ist7;
    return;
}

/**
 * 按照x86 的tss来写，来配置
*/
void set_tss_descriptor(u32 n, void* addr)
{
    u64 limit = 103;
    *(u64*)(gdt_table + n) = \
                    (limit & 0xffff) | (((u64)addr & 0xffff) << 16) | (((u64)addr >> 16 & 0xff) << 32) | \
                    ((u64)0x89 << 40) | ((limit >> 16 & 0xf) << 48) | (((u64)addr >> 24 & 0xff) << 56);
    *(u64*)(gdt_table + n + 1) = ((u64)addr >> 32 & 0xffffffff) | 0;
    return;
}

#endif