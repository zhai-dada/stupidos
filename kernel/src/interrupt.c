#include <interrupt.h>
#include <printk.h>
#include <stackregs.h>

#define SAVE_ALL                    \
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

#define BUILD_IRQ(nr)                                   \
void IRQ_NAME(nr);                                      \
    asm(                                                \
        SYMBOL_NAME_STR(IRQ)#nr"_interrupt:     \n"     \
        "pushq $0x00                            \n"     \
        SAVE_ALL                                        \
        "movq %rsp, %rdi                        \n"     \
        "leaq ret_from_intr(%rip), %rax         \n"     \
        "pushq %rax                             \n"     \
        "movq $"#nr", %rsi                      \n"     \
        "jmp do_irq                             \n");


BUILD_IRQ(0x20)
BUILD_IRQ(0x21)
BUILD_IRQ(0x22)
BUILD_IRQ(0x23)
BUILD_IRQ(0x24)
BUILD_IRQ(0x25)
BUILD_IRQ(0x26)
BUILD_IRQ(0x27)
BUILD_IRQ(0x28)
BUILD_IRQ(0x29)
BUILD_IRQ(0x2a)
BUILD_IRQ(0x2b)
BUILD_IRQ(0x2c)
BUILD_IRQ(0x2d)
BUILD_IRQ(0x2e)
BUILD_IRQ(0x2f)
BUILD_IRQ(0x30)
BUILD_IRQ(0x31)
BUILD_IRQ(0x32)
BUILD_IRQ(0x33)
BUILD_IRQ(0x34)
BUILD_IRQ(0x35)
BUILD_IRQ(0x36)
BUILD_IRQ(0x37)

BUILD_IRQ(0xc8)
BUILD_IRQ(0xc9)
BUILD_IRQ(0xca)
BUILD_IRQ(0xcb)
BUILD_IRQ(0xcc)
BUILD_IRQ(0xcd)
BUILD_IRQ(0xce)
BUILD_IRQ(0xcf)
BUILD_IRQ(0xd0)
BUILD_IRQ(0xd1)



void (* interrupt[24])(void) = 
{
    IRQ0x20_interrupt,
    IRQ0x21_interrupt,
    IRQ0x22_interrupt,
    IRQ0x23_interrupt,
    IRQ0x24_interrupt,
    IRQ0x25_interrupt,
    IRQ0x26_interrupt,
    IRQ0x27_interrupt,
    IRQ0x28_interrupt,
    IRQ0x29_interrupt,
    IRQ0x2a_interrupt,
    IRQ0x2b_interrupt,
    IRQ0x2c_interrupt,
    IRQ0x2d_interrupt,
    IRQ0x2e_interrupt,
    IRQ0x2f_interrupt,
    IRQ0x30_interrupt,
    IRQ0x31_interrupt,
    IRQ0x32_interrupt,
    IRQ0x33_interrupt,
    IRQ0x34_interrupt,
    IRQ0x35_interrupt,
    IRQ0x36_interrupt,
    IRQ0x37_interrupt
};
void (*smp_interrupt[10])(void) = 
{
    IRQ0xc8_interrupt,
    IRQ0xc9_interrupt,
    IRQ0xca_interrupt,
    IRQ0xcb_interrupt,
    IRQ0xcc_interrupt,
    IRQ0xcd_interrupt,
    IRQ0xce_interrupt,
    IRQ0xcf_interrupt,
    IRQ0xd0_interrupt,
    IRQ0xd1_interrupt
};

int register_irq(uint64_t irq, void* arg, void (*handler)(uint64_t nr, uint64_t parameter, struct stackregs* reg), uint64_t parameter, irq_controller* controler, char* irq_name)
{
    irq_desc_t* p = &interrupt_desc[irq - 0x20];
    p->controler = controler;
    p->irq_name = irq_name;
    p->parameter = parameter;
    p->flags = 0;
    p->handler = handler;
    p->controler->install(irq, arg);
    p->controler->enable(irq);
    return 1;
}
int unregister_irq(uint64_t irq)
{
    irq_desc_t* p = &interrupt_desc[irq - 0x20];
    p->controler->disable(irq);
    p->controler->uninstall(irq);
    p->handler = NULL;
    p->flags = 0;
    p->parameter = 0;
    p->controler = NULL;
    p->irq_name = NULL;
    return 1;
}
int register_ipi(uint64_t irq, void* arg, void (*handler)(uint64_t nr, uint64_t parameter, struct stackregs* reg), uint64_t parameter, irq_controller* controler, char* irq_name)
{
    irq_desc_t* p = &smp_ipi_desc[irq - 200];
    p->controler = NULL;
    p->irq_name = irq_name;
    p->parameter = parameter;
    p->flags = 0;
    p->handler = handler;
    return 1;
}
int unregister_ipi(uint64_t irq)
{
    irq_desc_t* p = &smp_ipi_desc[irq - 200];
    p->controler = NULL;
    p->irq_name = NULL;
    p->parameter = NULL;
    p->flags = 0;
    p->handler = NULL;
    return 1;
}