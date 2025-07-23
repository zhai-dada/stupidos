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
	adr	x0, bss_start
	adr	x1, bss_end
	sub	x1, x1, x0
	bl 	memzero

	mov sp, #0x40000
	bl early_uart_init

	ldr x0, =myteststr
	bl early_uart_put_string

	bl kernel_main

.section ".data"

.align 3
myteststr:
	.string "[test early_uart] : Hello AARCH64\r\n" 