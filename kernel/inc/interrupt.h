#ifndef __INTERRUPT_H__
#define __INTERRUPT_H__

#include <stdint.h>
#include <apic.h>
#include <stackregs.h>
#include <linkage.h>

#define IRQ_NR 24

#define HPET_IRQ        0x22
#define SERIALCOM1_IRQ   0x24

#define SAVE_ALL_REGS               \
    "cld                        \n" \
    "pushq %rax                 \n" \
    "pushq %rax                 \n" \
    "movq %es, %rax             \n" \
    "pushq %rax                 \n" \
    "movq %ds, %rax             \n" \
    "pushq %rax                 \n" \
    "xorq %rax, %rax            \n" \
    "pushq %rbp                 \n" \
    "pushq %rdi                 \n" \
    "pushq %rsi                 \n" \
    "pushq %rdx                 \n" \
    "pushq %rcx                 \n" \
    "pushq %rbx                 \n" \
    "pushq %r8                  \n" \
    "pushq %r9                  \n" \
    "pushq %r10                 \n" \
    "pushq %r11                 \n" \
    "pushq %r12                 \n" \
    "pushq %r13                 \n" \
    "pushq %r14                 \n" \
    "pushq %r15                 \n" \
    "movq $0x10, %rdx           \n" \
    "movq %rdx, %ds             \n" \
    "movq %rdx, %es             \n"

#define IRQ_NAME2(nr) nr##_interrupt(void)
#define IRQ_NAME(nr) IRQ_NAME2(IRQ##nr)

// push 0x00 占位错误码
#define INIT_IRQ(nr)                                    \
    void IRQ_NAME(nr);                                  \
    asm                                                 \
    (                                                   \
        SYMBOL_NAME_STR(IRQ)#nr"_interrupt:     \n"     \
        "pushq $0x00                            \n"     \
        SAVE_ALL_REGS                                   \
        "movq %rsp, %rdi                        \n"     \
        "leaq ret_from_intr(%rip), %rax         \n"     \
        "pushq %rax                             \n"     \
        "movq $"#nr", %rsi                      \n"     \
        "jmp do_irq                             \n"     \
    );

typedef struct
{
    void (*enable)(u64 irq);
    void (*disable)(u64 irq);
    u64 (*install)(u64 irq, void* arg);
    void (*uninstall)(u64 irq);
    void (*ack)(u64 irq);
} irq_controller;

typedef struct
{
    irq_controller* controler;
    s8* irq_name;
    u64 parameter;
    void (*handler)(u64 nr, u64 parameter, stackregs_t* reg);
    u64 flags;
} irq_desc_t;

extern void (*interrupt[IRQ_NR])(void);
extern irq_desc_t interrupt_desc[IRQ_NR];

extern void do_irq(stackregs_t* regs, u64 nr);

int register_irq(u64 irq, void* arg, void (*handler)(u64 nr, u64 parameter, stackregs_t* reg), u64 parameter, irq_controller* controler, s8* irq_name);


#endif
