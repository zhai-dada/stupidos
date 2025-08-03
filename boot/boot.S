#include <sysreg.h>

.section ".text.boot"

.globl _start
_start:
	mrs	x0, mpidr_el1		// mpidr_el1 表示CPU的编号
	and	x0, x0, #0xFF		// 检查处理器核心ID
 	cbz	x0, master		    // 除了CPU0其他CPU都会在这里死循环等待
	b proc_hang

proc_hang:
	b proc_hang

master:
	bl early_uart_init

	ldr x0, =myteststr
	bl early_uart_put_string
	
	mrs x5, CurrentEL
	cmp x5, #CurrentEL_EL3 // 是EL3
	b.eq el3_entry
	b el2_entry


el3_entry:
	eret

el2_entry:

	bl print_el
	ldr x0, =HCR_EL2_RW_AARCH64
	msr hcr_el2, x0

	ldr x0, =SCTLR_LL_MMU_DISABLE
	msr sctlr_el1, x0

	ldr x0, =SPSR_EL1h
	msr spsr_el2, x0

	adr x0, el1_entry
	msr elr_el2, x0

	eret

el1_entry:
	bl print_el

	// bss memset to 0
	adr	x0, bss_start
	adr	x1, bss_end
	sub	x1, x1, x0
	bl 	memzero

	mov sp, #0x100000	// 1MB
	bl kernel_main

print_el:
	mov x10, x30

	adrp x0, getcurrentel
	add x0, x0, #:lo12:getcurrentel
	bl early_uart_put_string

	mrs x0, currentel
	lsr x0, x0, 2
	add x0, x0, #48
	bl early_uart_put_char

	adrp x0, nextline
	add x0, x0, #:lo12:nextline
	bl early_uart_put_string
	
	mov x30, x10

	ret

.section ".data"
.align 3
myteststr:
	.string "[test early_uart] : Hello AARCH64\r\n" 

.align 3
getcurrentel:
	.string "[get currentel  ] : Booting as EL "

.align 3
nextline:
	.string "\r\n"