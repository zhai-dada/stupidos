#include <linkage.h>

.balign 0x1000
.text
.code16
ENTRY(apu_boot_start)
apu_boot_base = .
    cli
    wbinvd
    mov %cs, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    mov %ax, %fs
    mov %ax, %gs

    movl $(apu_boot_tmp_stack_end - apu_boot_base), %esp

    mov %cs, %ax
    movzx %ax, %esi
    shll $4, %esi
    leal (apu_code32 - apu_boot_base)(%esi), %eax
    movl %eax, apu_code32_vector - apu_boot_base
    leal (apu_code64 - apu_boot_base)(%esi), %eax
    movl %eax, apu_code64_vector - apu_boot_base
    leal (apu_tmp_gdt - apu_boot_base)(%esi), %eax
    movl %eax, (apu_tmp_gdt - apu_boot_base + 2)
    lidtl apu_tmp_idt - apu_boot_base
    lgdtl apu_tmp_gdt - apu_boot_base
    smsw %ax
    bts $0, %ax
    lmsw %ax
    ljmpl *(apu_code32_vector - apu_boot_base)
.code32
.balign 4
apu_code32:
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    mov %ax, %fs
    mov %ax, %gs
    leal (apu_boot_tmp_stack_end - apu_boot_base)(%esi), %eax
    movl %eax, %esp
    movl %cr4, %eax
    bts $5, %eax
    movl %eax, %cr4
    movl $0x101000, %eax
    movl %eax, %cr3
    movl $0xc0000080, %ecx
    rdmsr
    bts $8, %eax
    wrmsr
    movl %cr0, %eax
    bts $0, %eax
    bts $31, %eax
    movl %eax, %cr0
    ljmp *(apu_code64_vector - apu_boot_base)(%esi)
.code64
.balign 4
apu_code64:
    movq $0x20, %rax
    movq %rax, %ds

    movq $0x100000, %rax
    jmpq *%rax
    hlt

.balign 4
apu_tmp_idt:
    .word 0
    .word 0, 0
apu_tmp_idt_end:


.balign 4
apu_tmp_gdt:
    .short apu_tmp_gdt_end - apu_tmp_gdt - 1
    .long apu_tmp_gdt - apu_boot_base
    .short 0
    .quad 0x00cf9a000000ffff
    .quad 0x00cf92000000ffff
    .quad 0x0020980000000000
    .quad 0x0000920000000000
apu_tmp_gdt_end:


.balign 4
apu_code32_vector:
    .long apu_code32 - apu_boot_base
    .word 0x08, 0



.balign 4
apu_code64_vector:
    .long apu_code64 - apu_boot_base
    .word 0x18, 0



.balign 4
apu_boot_tmp_stack_start:
    .org 0x400
apu_boot_tmp_stack_end:

ENTRY(apu_boot_end)