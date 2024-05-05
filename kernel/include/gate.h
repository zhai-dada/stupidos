#ifndef __GATE_H__
#define __GATE_H__

#include <stdint.h>

struct gdt_struct
{
    uint8_t gdt[8];
};
struct idt_struct
{
    uint8_t idt[16];
};

extern struct gdt_struct gdt_table[];
extern struct idt_struct idt_table[];

#define set_gate(gate_addr, attr, ist, code_addr)                               \
        uint64_t d0, d1;                                                        \
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
            : "=m"(*((uint64_t *)(gate_addr))),                                 \
              "=m"(*(1 + (uint64_t *)(gate_addr))), "=&a"(d0), "=&d"(d1)        \
            : "i"(attr << 8),                                                   \
              "3"((uint64_t *)(code_addr)), "2"(0x8 << 16), "c"(ist)            \
            : "memory"                                                          \
        );

#define load_TR(n)          \
        asm volatile        \
        (                   \
            "ltr %%ax   \n" \
            :               \
            : "a"(n << 3)   \
            : "memory"      \
        );

void set_intr_gate(uint32_t n, uint8_t ist, void *addr)
{
    set_gate(idt_table + n, 0x8E, ist, addr);
    // P, DPL = 0, TYPE = E
    return;
}
void set_trap_gate(uint32_t n, uint8_t ist, void *addr)
{
    set_gate(idt_table + n, 0x8F, ist, addr);
    // P, DPL = 0, TYPE = F
    return;
}
void set_system_intr_gate(uint32_t n, uint8_t ist, void *addr)
{
    set_gate(idt_table + n, 0xEE, ist, addr);
    // P, DPL = 3, TYPE = E
    return;
}
void set_system_trap_gate(uint32_t n, uint8_t ist, void *addr)
{
    set_gate(idt_table + n, 0xEF, ist, addr);
    // P DPL = 3, TYPE = F
    return;
}
void set_tss64(uint32_t* tss_table, uint64_t rsp0, uint64_t rsp1, uint64_t rsp2, uint64_t ist1, uint64_t ist2, uint64_t ist3, uint64_t ist4, uint64_t ist5, uint64_t ist6, uint64_t ist7)
{
    *(uint64_t *)(tss_table + 1) = rsp0;
    *(uint64_t *)(tss_table + 3) = rsp1;
    *(uint64_t *)(tss_table + 5) = rsp2;

    *(uint64_t *)(tss_table + 9) = ist1;
    *(uint64_t *)(tss_table + 11) = ist2;
    *(uint64_t *)(tss_table + 13) = ist3;
    *(uint64_t *)(tss_table + 15) = ist4;
    *(uint64_t *)(tss_table + 17) = ist5;
    *(uint64_t *)(tss_table + 19) = ist6;
    *(uint64_t *)(tss_table + 21) = ist7;
    return;
}
/**
 * 按照x86 的tss来写，来配置
*/
void set_tss_descriptor(uint32_t n, void* addr)
{
    uint64_t limit = 103;
    *(uint64_t*)(gdt_table + n) = (limit & 0xffff) | (((uint64_t)addr & 0xffff) << 16) | (((uint64_t)addr >> 16 & 0xff) << 32) | ((uint64_t)0x89 << 40) | ((limit >> 16 & 0xf) << 48) | (((uint64_t)addr >> 24 & 0xff) << 56);
    *(uint64_t*)(gdt_table + n + 1) = ((uint64_t)addr >> 32 & 0xffffffff) | 0;
    return;
}
#endif