#include <linkage.h>

R15	            =	0x00
R14	            =	0x08
R13	            =	0x10
R12 	        =	0x18
R11 	        =	0x20
R10 	        =	0x28
R9	            =	0x30
R8	            =	0x38
RBX	            =	0x40
RCX	            =	0x48
RDX	            =	0x50
RSI	            =	0x58
RDI	            =	0x60
RBP	            =	0x68
DS	            =	0x70
ES	            =	0x78
RAX	            =	0x80
FUNC	        =	0x88
ERRCODE	        =	0x90
RIP	            =	0x98
CS	            =	0xa0
RFLAGS	        =	0xa8
OLD_RSP	        =	0xb0
OLD_SS	        =	0xb8

TASK_STATE      =   0x00
TASK_FLAGS      =   0x08
TASK_PREEMPT    =   0x10
TASK_SIGNAL     =   0x18
TASK_CPUID  =   0x20

restore_all:
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rbx
    popq %rcx
    popq %rdx
    popq %rsi
    popq %rdi
    popq %rbp
    popq %rax
    movq %rax, %ds
    popq %rax
    movq %rax, %es
    popq %rax
    addq $0x10, %rsp //skip FUNC and ERRCODE
    iretq

#define GET_CURRENT(reg)    \
    movq	$-65536, reg;	\
	andq	%rsp,	reg

ret_from_exception:
ENTRY(ret_from_intr)
    movq $-1, %rcx
    testq softirq_status(%rip), %rcx // 如果存在需要执行的软中断 -> softirq_handle
    jnz softirq_handle
    GET_CURRENT(%rbx)   // 获取current task
    movq TASK_FLAGS(%rbx), %rcx
    testq $2, %rcx
    jnz reschedule
    jmp restore_all
softirq_handle:
    callq do_softirq
    GET_CURRENT(%rbx)   // 获取current task
    movq TASK_FLAGS(%rbx), %rcx
    testq $2, %rcx
    jnz reschedule
    jmp restore_all
reschedule:
    callq schedule
    jmp restore_all


ENTRY(system_call)
    sti
    subq $0x38, %rsp
    cld
    pushq %rax
    movq %es, %rax
    pushq %rax
    xorq %rax, %rax
    movq %ds, %rax
    pushq %rax
    xorq %rax, %rax
    pushq %rbp
    pushq %rdi
    pushq %rsi
    pushq %rdx
    pushq %rcx
    pushq %rbx
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    movq $0x10, %rax
    movq %rax, %ds
    movq %rax, %es
    movq RAX(%rsp), %rax
    leaq system_call_table(%rip), %rbx
    callq *(%rbx, %rax, 8)
    movq %rax, RAX(%rsp)
ENTRY(system_ret)
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rbx
    popq %rcx
    popq %rdx
    popq %rsi
    popq %rdi
    popq %rbp
    popq %rax
    movq %rax, %ds
    popq %rax
    movq %rax, %es
    popq %rax
    addq $0x38, %rsp
    xchgq %rdx, %r10
    xchgq %rcx, %r11
    sti
    sysexitq


error_code:
    pushq %rax

    movq %es, %rax
    pushq %rax
    movq %ds, %rax
    pushq %rax
    xorq %rax, %rax

    pushq %rbp
    pushq %rdi
    pushq %rsi
    pushq %rdx
    pushq %rcx
    pushq %rbx
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    cld
    movq ERRCODE(%rsp), %rsi
    movq FUNC(%rsp), %rdx
    movq $0x10, %rdi
    movq %rdi, %ds
    movq %rdi, %es
    movq %rsp, %rdi
    callq *%rdx
    jmp ret_from_exception


ENTRY(debug)
    pushq $0
    pushq %rax
    leaq do_debug(%rip), %rax
    xchgq %rax, (%rsp)
    jmp error_code
ENTRY(divide_error)
    pushq $0
    pushq %rax
    leaq do_divide_error(%rip), %rax
    xchgq %rax, (%rsp)
    jmp error_code
ENTRY(nmi)
    pushq %rax
    cld
    pushq %rax

    pushq %rax
    movq %es, %rax
    pushq %rax
	movq %ds, %rax
	pushq %rax
	xorq %rax, %rax
    pushq %rbp
    pushq %rdi
    pushq %rsi
    pushq %rdx
    pushq %rcx
    pushq %rbx
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    movq $0x10, %rax
    movq %rax, %ds
    movq %rax, %es
    movq %rsp, %rdi
    movq $0, %rsi
    callq do_nmi
    jmp restore_all
ENTRY(int3)
    pushq $0
    pushq %rax
    leaq do_int3(%rip), %rax
    xchgq %rax, (%rsp)
    jmp error_code
ENTRY(overflow)
    pushq $0
    pushq %rax
    leaq do_overflow(%rip), %rax
    xchgq %rax, (%rsp)
    jmp error_code
ENTRY(bounds)
    pushq $0
    pushq %rax
    leaq do_bounds(%rip), %rax
    xchgq %rax, (%rsp)
    jmp error_code
ENTRY(undefined_opcode)
    pushq $0
    pushq %rax
    leaq do_undefined_opcode(%rip), %rax
    xchgq %rax, (%rsp)
    jmp error_code
ENTRY(dev_not_available)
    pushq $0
    pushq %rax
    leaq do_dev_not_available(%rip), %rax
    xchgq %rax, (%rsp)
    jmp error_code
ENTRY(double_fault)
	pushq %rax
	leaq do_double_fault(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(coprocessor_segment_overrun)
	pushq $0
	pushq %rax
	leaq do_coprocessor_segment_overrun(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(invalid_tss)
	pushq %rax
	leaq do_invalid_tss(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(segment_not_present)
	pushq %rax
	leaq do_segment_not_present(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(stack_segment_fault)
	pushq %rax
	leaq do_stack_segment_fault(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(general_protection)
	pushq %rax
	leaq do_general_protection(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(page_fault)
	pushq %rax
	leaq do_page_fault(%rip), %rax
	xchgq %rax,	(%rsp)
	jmp	error_code
ENTRY(x87_FPU_error)
	pushq $0
	pushq %rax
	leaq do_x87_FPU_error(%rip), %rax
	xchgq %rax,	(%rsp)
	jmp	error_code
ENTRY(alignment_check)
	pushq %rax
	leaq do_alignment_check(%rip), %rax
	xchgq %rax,	(%rsp)
	jmp	error_code
ENTRY(machine_check)
	pushq $0
	pushq %rax
	leaq do_machine_check(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(SIMD_exception)
	pushq $0
	pushq %rax
	leaq do_SIMD_exception(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
ENTRY(virtualization_exception)
	pushq $0
	pushq %rax
	leaq do_virtualization_exception(%rip), %rax
	xchgq %rax, (%rsp)
	jmp	error_code
       