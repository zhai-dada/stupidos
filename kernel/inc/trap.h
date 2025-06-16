#ifndef __TRAP_H__
#define __TRAP_H__

#include <stackregs.h>
#include <lib/asm.h>

extern void divide_error();
extern void debug();
extern void nmi();
extern void int3();
extern void overflow();
extern void bounds();
extern void undefined_opcode();
extern void dev_not_available();
extern void double_fault();
extern void coprocessor_segment_overrun();
extern void invalid_tss();
extern void segment_not_present();
extern void stack_segment_fault();
extern void general_protection();
extern void page_fault();
extern void x87_FPU_error();
extern void alignment_check();
extern void machine_check();
extern void SIMD_exception();
extern void virtualization_exception();

void sys_vector_init();
void display_regs(stackregs_t *regs);

#endif