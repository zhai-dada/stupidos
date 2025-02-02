#ifndef __INTERRUPT_H__
#define __INTERRUPT_H__

#include <stdint.h>
#include <apic.h>
#include <stackregs.h>


extern void do_irq(struct stackregs* regs, u64 nr);

#define IRQ_NR 25
#define SMP_IRQ_NR  10

extern void (*interrupt[IRQ_NR])(void);
extern void (*smp_interrupt[SMP_IRQ_NR])(void);

typedef struct
{
    void (*enable)(u64 irq);
    void (*disable)(u64 irq);
    u64 (*install)(u64 irq, void* arg);
    void (*uninstall)(u64 irq);
    void (*ack)(u64 irq);
}irq_controller;

typedef struct
{
    irq_controller* controler;
    s8* irq_name;
    u64 parameter;
    void (*handler)(u64 nr, u64 parameter, struct stackregs* reg);
    u64 flags;
}irq_desc_t;


irq_desc_t interrupt_desc[IRQ_NR] = {0};
irq_desc_t smp_ipi_desc[SMP_IRQ_NR] = {0};

int register_irq(u64 irq, void* arg, void (*handler)(u64 nr, u64 parameter, struct stackregs* reg), u64 parameter, irq_controller* controler, s8* irq_name);
int unregister_irq(u64 irq);
int register_ipi(u64 irq, void* arg, void (*handler)(u64 nr, u64 parameter, struct stackregs* reg), u64 parameter, irq_controller* controler, s8* irq_name);
int unregister_ipi(u64 irq);

#endif