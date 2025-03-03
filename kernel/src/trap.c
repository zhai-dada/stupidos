#include <gate.h>
#include <trap.h>
#include <printk.h>
#include <stackregs.h>
#include <lib.h>
#include <smp/smp.h>
#include <task.h>
#include <backtrace.h>
#include <debug.h>

void display_regs(struct stackregs *regs)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "CS:%#010x,SS:%#010x\nDS:%#010x,ES:%#010x\nRFLAGS:%#018lx\n", regs->cs, regs->ss, regs->ds, regs->es, regs->rflags);
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "RAX:%#018lx,RBX:%#018lx,RCX:%#018lx,RDX:%#018lx\nRSP:%#018lx,RBP:%#018lx,RIP:%#018lx\nRSI:%#018lx,RDI:%#018lx\n", regs->rax, regs->rbx, regs->rcx, regs->rdx, regs->rsp, regs->rbp, regs->rip, regs->rsi, regs->rdi);
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "R8 :%#018lx,R9 :%#018lx\nR10:%#018lx,R11:%#018lx\nR12:%#018lx,R13:%#018lx\nR14:%#018lx,R15:%#018lx\n", regs->r8, regs->r9, regs->r10, regs->r11, regs->r12, regs->r13, regs->r14, regs->r15);
    backtrace(regs);
}
void do_divide_error(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_divide_error(0), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_debug(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_debug(1), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_nmi(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_nmi(2), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_int3(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_int3(3), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_overflow(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_overflow(4), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_bounds(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_bounds(5), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_undefined_opcode(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_undefined_opcode(6), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_dev_not_available(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_dev_not_available(7), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_double_fault(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_double_fault(8), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_coprocessor_segment_overrun(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_coprocessor_segment_overrun(9), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_invalid_TSS(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_invalid(10), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    if (error_code & 0x01)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "The exception occurred during delivery of an event external to the program, such as an interrupt or an earlier exception\n");
    }
    if (error_code & 0x02)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the IDT\n");
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the GDT or the current LDT\n");
    }
    if ((error_code & 0x02) == 0)
    {
        if (error_code & 0x04)
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a segment or gate descriptor in the LDT\n");
        }
        else
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a descriptor in the current GDT\n");
        }
    }
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Segment Selector Index:%#010x\n", error_code & 0xfff8);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_segment_not_present(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_segment_not_present(11), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    if (error_code & 0x01)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "The exception occurred during delivery of an event external to the program, such as an interrupt or an earlier exception\n");
    }
    if (error_code & 0x02)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the IDT\n");
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the GDT or the current LDT\n");
    }
    if ((error_code & 0x02) == 0)
    {
        if (error_code & 0x04)
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a segment or gate descriptor in the LDT\n");
        }
        else
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a descriptor in the current GDT\n");
        }
    }
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Segment Selector Index:%#010x\n", error_code & 0xfff8);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_stack_segment_fault(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_stack_segment_fault(12), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    if (error_code & 0x01)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "The exception occurred during delivery of an event external to the program, such as an interrupt or an earlier exception\n");
    }
    if (error_code & 0x02)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the IDT\n");
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the GDT or the current LDT\n");
    }
    if ((error_code & 0x02) == 0)
    {
        if (error_code & 0x04)
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a segment or gate descriptor in the LDT\n");
        }
        else
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a descriptor in the current GDT\n");
        }
    }
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Segment Selector Index:%#010x\n", error_code & 0xfff8);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_general_protection(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_general_protection(13), ERR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx, RDX:%#018lx\n", error_code, reg->rsp, reg->rip, reg->rdx);
    if (error_code & 0x01)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "The exception occurred during delivery of an event external to the program, such as an interrupt or an earlier exception\n");
    }
    if (error_code & 0x02)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the IDT\n");
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a gate descriptor in the GDT or the current LDT\n");
    }
    if ((error_code & 0x02) == 0)
    {
        if (error_code & 0x04)
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a segment or gate descriptor in the LDT\n");
        }
        else
        {
            DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Refers to a descriptor in the current GDT\n");
        }
    }
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Segment Selector Index:%#010x\n", error_code & 0xfff8);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_page_fault(struct stackregs *reg, u64 error_code)
{
    u64 cr2 = 0;
    asm volatile
    (
        "movq %%cr2, %0\n"
        : "=r"(cr2)
        :
        :
    );
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_page_fault(14), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    if (error_code & 0x01)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Page Not-Present,\t");
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Page-level protection throws an exception,\t");
    }
    if (error_code & 0x02)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Write Cause Fault,\t");
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Read Cause Fault,\t");
    }
    if (error_code & 0x04)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Fault in user(3)\t");
    }
    else
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Fault in supervisor(0,1,2)\t");
    }
    if (error_code & 0x08)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Reserved Bit Cause Fault\t");
    }
    if (error_code & 0x10)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "Instruction fetch Cause Fault");
    }
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "\n");
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "CR2:%#018lx CPU:%d\n", cr2, smp_cpu_id());
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_x87_FPU_error(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_x87_FPU_error(16), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_alignment_check(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_alignment_check(17), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_machine_check(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_machine_check(18), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_SIMD_exception(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_SIMD_exception(19), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}
void do_virtualization_exception(struct stackregs *reg, u64 error_code)
{
    DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "do_virtualization_exception(20), ERROR_CODE:%#018lx, RSP:%#018lx, RIP:%#018lx\n", error_code, reg->rsp, reg->rip);
    display_regs(reg);
    while (1)
    {
        hlt();
    }
}

// ist为1,均进行栈切换
void sys_vector_init()
{
    set_trap_gate(0, 0, divide_error);
    set_trap_gate(1, 0, debug);
    set_intr_gate(2, 0, nmi);
    set_system_trap_gate(3, 0, int3);
    set_system_trap_gate(4, 0, overflow);
    set_system_trap_gate(5, 0, bounds);
    set_trap_gate(6, 0, undefined_opcode);
    set_trap_gate(7, 0, dev_not_available);
    set_trap_gate(8, 0, double_fault);
    set_trap_gate(9, 0, coprocessor_segment_overrun);
    set_trap_gate(10, 0, invalid_TSS);
    set_trap_gate(11, 0, segment_not_present);
    set_trap_gate(12, 0, stack_segment_fault);
    set_trap_gate(13, 0, general_protection);
    set_trap_gate(14, 0, page_fault);

    set_trap_gate(16, 0, x87_FPU_error);
    set_trap_gate(17, 0, alignment_check);
    set_trap_gate(18, 0, machine_check);
    set_trap_gate(19, 0, SIMD_exception);
    set_trap_gate(20, 0, virtualization_exception);
    return;
}