#include <interrupt.h>
#include <stackregs.h>

INIT_IRQ(0x20);INIT_IRQ(0x21);INIT_IRQ(0x22);INIT_IRQ(0x23);INIT_IRQ(0x24);
INIT_IRQ(0x25);INIT_IRQ(0x26);INIT_IRQ(0x27);INIT_IRQ(0x28);INIT_IRQ(0x29);
INIT_IRQ(0x2a);INIT_IRQ(0x2b);INIT_IRQ(0x2c);INIT_IRQ(0x2d);INIT_IRQ(0x2e);
INIT_IRQ(0x2f);INIT_IRQ(0x30);INIT_IRQ(0x31);INIT_IRQ(0x32);INIT_IRQ(0x33);
INIT_IRQ(0x34);INIT_IRQ(0x35);INIT_IRQ(0x36);INIT_IRQ(0x37);

irq_desc_t interrupt_desc[IRQ_NR] = {0};

void (* interrupt[IRQ_NR])(void) = 
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

int register_irq(u64 irq, void* arg, void (*handler)(u64 nr, u64 parameter, stackregs_t* reg), u64 parameter, irq_controller* controler, s8* irq_name)
{
    irq_desc_t* p = &interrupt_desc[irq - 0x20];
    p->controler = controler;
    p->irq_name = irq_name;
    p->parameter = parameter;
    p->flags = 0;
    p->handler = handler;
    p->controler->install(irq, arg);
    p->controler->enable(irq);
    return SOK;
}