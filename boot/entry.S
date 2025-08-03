#define BAD_SYNC        0
#define BAD_IRQ         1
#define BAD_FIQ         2
#define BAD_ERROR       3

// 处理无效的异常向量
.macro inv_entry el, reason
    mov x0, sp
    mov x1, #\reason
    mrs x2, esr_el1
    b bad_mode
.endm

// vector table entry每个表项是128字节， align 7表示128字节对齐
.macro vtentry label
.align 7
    b \label
.endm

// 四个表，每个有四项，每项128占字节
// 2048字节对齐
.align 11
.global vectors
vectors:
    /* Current EL with SP0当前系统运行在EL1时使用EL0的栈指针SP这是一种异常错误的类型*/
    vtentry el1_sync_invalid
    vtentry el1_irq_invalid
    vtentry el1_fiq_invalid
    vtentry el1_error_invalid

    /* Current EL with SPx当前系统运行在EL1时使用EL1的栈指针SP这说明系统在内核态发生了异常*/
    vtentry el1_sync_invalid
    vtentry el1_irq_invalid
    vtentry el1_fiq_invalid
    vtentry el1_error_invalid

    /* Lower EL using AArch64在用户态的aarch64的程序发生了异常*/
    vtentry el0_sync_invalid
    vtentry el0_irq_invalid
    vtentry el0_fiq_invalid
    vtentry el0_error_invalid

    /* Lower EL using AArch32在用户态的aarch32的程序发生了异常*/
    vtentry el0_sync_invalid
    vtentry el0_irq_invalid
    vtentry el0_fiq_invalid
    vtentry el0_error_invalid

el1_sync_invalid:
	inv_entry 1, BAD_SYNC
el1_irq_invalid:
	inv_entry 1, BAD_IRQ
el1_fiq_invalid:
	inv_entry 1, BAD_FIQ
el1_error_invalid:
	inv_entry 1, BAD_ERROR

el0_sync_invalid:
	inv_entry 0, BAD_SYNC
el0_irq_invalid:
	inv_entry 0, BAD_IRQ
el0_fiq_invalid:
	inv_entry 0, BAD_FIQ
el0_error_invalid:
	inv_entry 0, BAD_ERROR

.string "t"
.global trigger_alignment
trigger_alignment:
	ldr x0, =0x80002
	ldr x1, [x0]
	ret