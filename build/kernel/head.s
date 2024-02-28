# 0 "src/head.S"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "src/head.S"
# 1 "./include/linkage.h" 1
# 2 "src/head.S" 2

.section .text




.global _start; _start:
 mov %ss, %ax
 mov %ax, %ds
 mov %ax, %es
 mov %ax, %fs
 mov %ax, %ss
 mov $0x7E00, %esp
 movq $0x101000, %rax
 movq %rax, %cr3


 lgdt gdt_pointer(%rip)

 lidt idt_pointer(%rip)

 mov $0x10, %ax
 mov %ax, %ds
 mov %ax, %es
 mov %ax, %fs
 mov %ax, %gs
 mov %ax, %ss

 movq _stack_start_(%rip), %rsp

    movq $0x101000, %rax
    movq %rax, %cr3
    movq switch_seg(%rip), %rax
    pushq $0x08
    pushq %rax
    lretq

switch_seg:
 .quad entry64
entry64:
 movq $0x10, %rax
 movq %rax, %ds
 movq %rax, %es
 movq %rax, %gs
 movq %rax, %ss
 movq _stack_start_(%rip), %rsp
 movq $0x1b, %rcx
 rdmsr
 bt $8, %rax
 jnc smp_start

setup_idt:
 leaq ignore_int(%rip), %rdx
 movq $(0x08 << 16), %rax
 movw %dx, %ax
 movq $(0x8E00 << 32), %rcx
 addq %rcx, %rax
 movl %edx, %ecx
 shrl $16, %ecx
 shlq $48, %rcx
 addq %rcx, %rax
 shrq $32, %rdx
 leaq idt_table(%rip), %rdi
 movq $256, %rcx
rp_set_idt:
 movq %rax, (%rdi)
 movq %rdx, 8(%rdi)
 addq $0x10, %rdi
 dec %rcx
    cmp $0, %rcx
 jne rp_set_idt

setup_tss64:
 leaq init_tss(%rip), %rdx
 xorq %rax, %rax
 xorq %rcx, %rcx
 movq $0x89, %rax
 shlq $40, %rax
 movl %edx, %ecx
 shrl $24, %ecx
 shlq $56, %rcx
 addq %rcx, %rax
 xorq %rcx, %rcx
 movl %edx, %ecx
 andl $0xffffff, %ecx
 shlq $16, %rcx
 addq %rcx, %rax
 addq $103, %rax
 leaq gdt_table(%rip), %rdi
 movq %rax, 80(%rdi)
 shrq $32, %rdx
 movq %rdx, 88(%rdi)

 movq go_to_kernel(%rip), %rax
 pushq $0x08
 pushq %rax
 lretq

smp_start:
 movq go_to_smp_kernel(%rip), %rax
 pushq $0x08
 pushq %rax
 lretq
go_to_smp_kernel:
 .quad start_smp

go_to_kernel:
 .quad kernel



ignore_int:
 iretq

.global _stack_start_; _stack_start_:
 .quad init_task_stack + 32768



.align 8
.org 0x1000
__PML4E:
 .quad 0x102003
 .fill 255,8,0
 .quad 0x102003
 .fill 255,8,0
.org 0x2000
__PDPTE:
 .quad 0x103003
 .fill 511,8,0
.org 0x3000
__PDE:
 .quad 0x000083
 .quad 0x200083
 .quad 0x400083
 .quad 0x600083
 .quad 0x800083
 .quad 0xa00083
 .quad 0xc00083
 .quad 0xe00083
 .quad 0x1000083
 .quad 0x1200083
 .quad 0x1400083
 .quad 0x1600083
 .quad 0x1800083
 .quad 0x1a00083
 .quad 0x1c00083
 .quad 0x1e00083
 .quad 0x2000083
 .quad 0x2200083
 .quad 0x2400083
 .quad 0x2600083
 .quad 0x2800083
 .quad 0x2a00083
 .quad 0x2c00083
 .quad 0x2e00083

 .fill 488,8,0




.section .data



.globl gdt_table
.align 8
gdt_table:
 .quad 0x0000000000000000
 .quad 0x0020980000000000
 .quad 0x0000920000000000
 .quad 0x0000000000000000
 .quad 0x0000000000000000
 .quad 0x0020f80000000000
 .quad 0x0000f20000000000
 .quad 0x00cf9a000000ffff
 .quad 0x00cf92000000ffff
 .quad 0x0000000000000000
 .fill 100,8,0
gdt_end:
gdt_pointer:
gdt_limit: .word gdt_end - gdt_table - 1
gdt_base: .quad gdt_table




.globl idt_table
.align 8
idt_table:
 .fill 512,8,0
idt_end:
idt_pointer:
idt_limit: .word idt_end - idt_table - 1
idt_base: .quad idt_table
