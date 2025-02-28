#include <linkage.h>

.section .text

/**
 * uefi 启动之后，数据段索引无法确定，可以使用栈段充当临时的数据段（ss在uefi环境下正好可以改）
 */
ENTRY(_start)
	mov	%ss, %ax
	mov	%ax, %ds
	mov	%ax, %es
	mov	%ax, %fs
	mov	%ax, %ss
	mov	$0x7E00, %rsp
	movq $0x101000, %rax
	movq %rax, %cr3

	lgdt	gdt_pointer(%rip)
	lidt	idt_pointer(%rip)
	
	mov	$0x10,	%ax
	mov	%ax,	%ds
	mov	%ax,	%es
	mov	%ax,	%fs
	mov	%ax,	%gs
	mov	%ax,	%ss

	movq _stack_start_(%rip), %rsp

    movq switch_seg(%rip), %rax
    pushq $0x08
    pushq %rax
    lretq
//=======	64-bit mode code
switch_seg:
	.quad	entry64
entry64:
	movq	$0x10,	%rax
	movq	%rax,	%ds
	movq	%rax,	%es
	movq	%rax,	%gs
	movq	%rax,	%ss
	movq	_stack_start_(%rip),	%rsp		/* rsp address */
	movq $0x1b, %rcx
	rdmsr
	bt $8, %rax
	jnc smp_start
	
setup_idt:							
	leaq	ignore_int(%rip),	%rdx
	movq	$(0x08 << 16),	%rax
	movw	%dx,	%ax
	movq	$(0x8E00 << 32),	%rcx		
	addq	%rcx,	%rax
	movl	%edx,	%ecx
	shrl	$16,	%ecx
	shlq	$48,	%rcx
	addq	%rcx,	%rax
	shrq	$32,	%rdx
	leaq	idt_table(%rip), %rdi
	movq    $256,	%rcx
rp_set_idt:
	movq	%rax,	(%rdi)
	movq	%rdx,	8(%rdi)
	addq	$0x10,	%rdi
	dec	%rcx
    cmp $0, %rcx
	jne	rp_set_idt

setup_tss64:
	leaq	init_tss(%rip),	%rdx
	xorq	%rax,	%rax
	xorq	%rcx,	%rcx
	movq	$0x89,	%rax
	shlq	$40,	%rax
	movl	%edx,	%ecx
	shrl	$24,	%ecx
	shlq	$56,	%rcx
	addq	%rcx,	%rax
	xorq	%rcx,	%rcx
	movl	%edx,	%ecx
	andl	$0xffffff,	%ecx
	shlq	$16,	%rcx
	addq	%rcx,	%rax
	addq	$103,	%rax
	leaq	gdt_table(%rip),	%rdi
	movq	%rax,	80(%rdi)
	shrq	$32,	%rdx
	movq	%rdx,	88(%rdi)

	movq	go_to_kernel(%rip),	%rax
	pushq	$0x08
	pushq	%rax
	lretq

smp_start:
	movq go_to_smp_kernel(%rip), %rax
	pushq $0x08
	pushq %rax
	lretq
go_to_smp_kernel:
	.quad start_smp

go_to_kernel:
	.quad	kernel


//=======	ignore_int
ignore_int:
	iretq

/*
* 内存分页
*/

.align 8
.org	0x1000
__PML4E:
	.quad	0x102003
	.fill	255,8,0
	.quad	0x102003
	.fill	255,8,0
.org	0x2000
__PDPTE:
	.quad	0x103003
	.fill	511,8,0
.org	0x3000
__PDE:
	.quad	0x000083
	.quad	0x200083
	.quad	0x400083
	.quad	0x600083
	.quad	0x800083
	.quad	0xa00083
	.quad	0xc00083
	.quad	0xe00083
	.quad	0x1000083
	.quad	0x1200083
	.quad	0x1400083
	.quad	0x1600083
	.quad	0x1800083
	.quad	0x1a00083
	.quad	0x1c00083
	.quad	0x1e00083
	.quad	0x2000083
	.quad	0x2200083
	.quad	0x2400083
	.quad	0x2600083
	.quad	0x2800083
	.quad	0x2a00083
	.quad	0x2c00083
	.quad	0x2e00083
	.fill	488,8,0


/**
* 数据段
*/
.section .data

ENTRY(_stack_start_)
	.quad init_task_stack + 65536
/*
* GDT TABLE 全局描述符表 是写死的，因为sysexit以及syscall需要按照一定的计算方式寻找描述符
*/
.globl gdt_table
.align 8
gdt_table:
	.quad	0x0000000000000000			/*0	NULL descriptor		       			00*/
	.quad	0x0020980000000000			/*1	KERNEL	Code	64-bit	Segment		08*/
	.quad	0x0000920000000000			/*2	KERNEL	Data	64-bit	Segment		10*/
	.quad	0x0000000000000000			/*3	USER	Code	32-bit	Segment 	18*/
	.quad	0x0000000000000000			/*4	USER	Data	32-bit	Segment 	20*/
	.quad	0x0020f80000000000			/*5	USER	Code	64-bit	Segment		28*/
	.quad	0x0000f20000000000			/*6	USER	Data	64-bit	Segment		30*/
	.quad	0x00cf9a000000ffff			/*7	KERNEL	Code	32-bit	Segment		38*/
	.quad	0x00cf92000000ffff			/*8	KERNEL	Data	32-bit	Segment		40*/
	.quad	0x0000000000000000			/*9 NULL descriptor						48*/
	.fill	100,8,0						/*10 ~ 11 TSS (jmp one segment <9>) 	50*/
gdt_end:
gdt_pointer:
gdt_limit:	.word	gdt_end - gdt_table - 1
gdt_base:	.quad	gdt_table

/*
* IDT TABLE 中断描述符表
*/
.globl idt_table
.align 8
idt_table:
	.fill  512,8,0
idt_end:
idt_pointer:
idt_limit:	.word	idt_end - idt_table - 1
idt_base:	.quad	idt_table


