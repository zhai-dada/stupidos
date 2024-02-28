#ifndef __INTERRUPT_H__
#define __INTERRUPT_H__

#include <stdint.h>
#include <apic.h>
#include <stackregs.h>



extern void (*interrupt[24])(void);
extern void (*smp_interrupt[10])(void);
extern void do_irq(struct stackregs* regs, uint64_t nr);

#define IRQ_NR 24
#define SMP_IRQ_NR  10

typedef struct
{
    void (*enable)(uint64_t irq);
    void (*disable)(uint64_t irq);
    uint64_t (*install)(uint64_t irq, void* arg);
    void (*uninstall)(uint64_t irq);
    void (*ack)(uint64_t irq);
}irq_controller;

typedef struct
{
    irq_controller* controler;
    int8_t* irq_name;
    uint64_t parameter;
    void (*handler)(uint64_t nr, uint64_t parameter, struct stackregs* reg);
    uint64_t flags;
}irq_desc_t;


irq_desc_t interrupt_desc[IRQ_NR] = {0};
irq_desc_t smp_ipi_desc[SMP_IRQ_NR] = {0};

int register_irq(uint64_t irq, void* arg, void (*handler)(uint64_t nr, uint64_t parameter, struct stackregs* reg), uint64_t parameter, irq_controller* controler, int8_t* irq_name);
int unregister_irq(uint64_t irq);
int register_ipi(uint64_t irq, void* arg, void (*handler)(uint64_t nr, uint64_t parameter, struct stackregs* reg), uint64_t parameter, irq_controller* controler, int8_t* irq_name);
int unregister_ipi(uint64_t irq);

#endif