
./build/kernel/osImage:     file format elf64-x86-64


Disassembly of section .text:

ffff800000100000 <_start>:
ffff800000100000:	66 8c d0             	mov    %ss,%ax
ffff800000100003:	8e d8                	mov    %eax,%ds
ffff800000100005:	8e c0                	mov    %eax,%es
ffff800000100007:	8e e0                	mov    %eax,%fs
ffff800000100009:	8e d0                	mov    %eax,%ss
ffff80000010000b:	48 c7 c4 00 7e 00 00 	mov    $0x7e00,%rsp
ffff800000100012:	48 c7 c0 00 10 10 00 	mov    $0x101000,%rax
ffff800000100019:	0f 22 d8             	mov    %rax,%cr3
ffff80000010001c:	0f 01 15 8d 8d 00 00 	lgdt   0x8d8d(%rip)        # ffff800000108db0 <gdt_end>
ffff800000100023:	0f 01 1d 96 9d 00 00 	lidt   0x9d96(%rip)        # ffff800000109dc0 <idt_end>
ffff80000010002a:	66 b8 10 00          	mov    $0x10,%ax
ffff80000010002e:	8e d8                	mov    %eax,%ds
ffff800000100030:	8e c0                	mov    %eax,%es
ffff800000100032:	8e e0                	mov    %eax,%fs
ffff800000100034:	8e e8                	mov    %eax,%gs
ffff800000100036:	8e d0                	mov    %eax,%ss
ffff800000100038:	48 8b 05 05 00 00 00 	mov    0x5(%rip),%rax        # ffff800000100044 <switch_seg>
ffff80000010003f:	6a 08                	push   $0x8
ffff800000100041:	50                   	push   %rax
ffff800000100042:	48 cb                	lretq  

ffff800000100044 <switch_seg>:
ffff800000100044:	4c 00 10             	rex.WR add %r10b,(%rax)
ffff800000100047:	00 00                	add    %al,(%rax)
ffff800000100049:	80 ff ff             	cmp    $0xff,%bh

ffff80000010004c <entry>:
ffff80000010004c:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
ffff800000100053:	48 8e d8             	mov    %rax,%ds
ffff800000100056:	48 8e c0             	mov    %rax,%es
ffff800000100059:	48 8e e8             	mov    %rax,%gs
ffff80000010005c:	48 8e d0             	mov    %rax,%ss

ffff80000010005f <setup_idt>:
ffff80000010005f:	48 8d 15 5d 00 00 00 	lea    0x5d(%rip),%rdx        # ffff8000001000c3 <ignore_int>
ffff800000100066:	48 c7 c0 00 00 08 00 	mov    $0x80000,%rax
ffff80000010006d:	66 89 d0             	mov    %dx,%ax
ffff800000100070:	48 b9 00 00 00 00 00 	movabs $0x8e0000000000,%rcx
ffff800000100077:	8e 00 00 
ffff80000010007a:	48 01 c8             	add    %rcx,%rax
ffff80000010007d:	89 d1                	mov    %edx,%ecx
ffff80000010007f:	c1 e9 10             	shr    $0x10,%ecx
ffff800000100082:	48 c1 e1 30          	shl    $0x30,%rcx
ffff800000100086:	48 01 c8             	add    %rcx,%rax
ffff800000100089:	48 c1 ea 20          	shr    $0x20,%rdx
ffff80000010008d:	48 8d 3d 2c 8d 00 00 	lea    0x8d2c(%rip),%rdi        # ffff800000108dc0 <idt_table>
ffff800000100094:	48 c7 c1 00 01 00 00 	mov    $0x100,%rcx

ffff80000010009b <repeat_set_idt>:
ffff80000010009b:	48 89 07             	mov    %rax,(%rdi)
ffff80000010009e:	48 89 57 08          	mov    %rdx,0x8(%rdi)
ffff8000001000a2:	48 83 c7 10          	add    $0x10,%rdi
ffff8000001000a6:	48 ff c9             	dec    %rcx
ffff8000001000a9:	48 83 f9 00          	cmp    $0x0,%rcx
ffff8000001000ad:	75 ec                	jne    ffff80000010009b <repeat_set_idt>
ffff8000001000af:	48 8b 05 05 00 00 00 	mov    0x5(%rip),%rax        # ffff8000001000bb <go_to_kernel>
ffff8000001000b6:	6a 08                	push   $0x8
ffff8000001000b8:	50                   	push   %rax
ffff8000001000b9:	48 cb                	lretq  

ffff8000001000bb <go_to_kernel>:
ffff8000001000bb:	f8                   	clc    
ffff8000001000bc:	88 10                	mov    %dl,(%rax)
ffff8000001000be:	00 00                	add    %al,(%rax)
ffff8000001000c0:	80 ff ff             	cmp    $0xff,%bh

ffff8000001000c3 <ignore_int>:
ffff8000001000c3:	48 cf                	iretq  
ffff8000001000c5:	0f 1f 00             	nopl   (%rax)
	...

ffff800000101000 <__PML4E>:
ffff800000101000:	03 20                	add    (%rax),%esp
ffff800000101002:	10 00                	adc    %al,(%rax)
	...
ffff800000101800:	03 20                	add    (%rax),%esp
ffff800000101802:	10 00                	adc    %al,(%rax)
	...

ffff800000102000 <__PDPTE>:
ffff800000102000:	03 30                	add    (%rax),%esi
ffff800000102002:	10 00                	adc    %al,(%rax)
	...

ffff800000103000 <__PDE>:
ffff800000103000:	83 00 00             	addl   $0x0,(%rax)
ffff800000103003:	00 00                	add    %al,(%rax)
ffff800000103005:	00 00                	add    %al,(%rax)
ffff800000103007:	00 83 00 20 00 00    	add    %al,0x2000(%rbx)
ffff80000010300d:	00 00                	add    %al,(%rax)
ffff80000010300f:	00 83 00 40 00 00    	add    %al,0x4000(%rbx)
ffff800000103015:	00 00                	add    %al,(%rax)
ffff800000103017:	00 83 00 60 00 00    	add    %al,0x6000(%rbx)
ffff80000010301d:	00 00                	add    %al,(%rax)
ffff80000010301f:	00 83 00 80 00 00    	add    %al,0x8000(%rbx)
ffff800000103025:	00 00                	add    %al,(%rax)
ffff800000103027:	00 83 00 a0 00 00    	add    %al,0xa000(%rbx)
ffff80000010302d:	00 00                	add    %al,(%rax)
ffff80000010302f:	00 83 00 c0 00 00    	add    %al,0xc000(%rbx)
ffff800000103035:	00 00                	add    %al,(%rax)
ffff800000103037:	00 83 00 e0 00 00    	add    %al,0xe000(%rbx)
ffff80000010303d:	00 00                	add    %al,(%rax)
ffff80000010303f:	00 83 00 00 01 00    	add    %al,0x10000(%rbx)
ffff800000103045:	00 00                	add    %al,(%rax)
ffff800000103047:	00 83 00 20 01 00    	add    %al,0x12000(%rbx)
ffff80000010304d:	00 00                	add    %al,(%rax)
ffff80000010304f:	00 83 00 40 01 00    	add    %al,0x14000(%rbx)
ffff800000103055:	00 00                	add    %al,(%rax)
ffff800000103057:	00 83 00 60 01 00    	add    %al,0x16000(%rbx)
ffff80000010305d:	00 00                	add    %al,(%rax)
ffff80000010305f:	00 83 00 80 01 00    	add    %al,0x18000(%rbx)
ffff800000103065:	00 00                	add    %al,(%rax)
ffff800000103067:	00 83 00 a0 01 00    	add    %al,0x1a000(%rbx)
ffff80000010306d:	00 00                	add    %al,(%rax)
ffff80000010306f:	00 83 00 c0 01 00    	add    %al,0x1c000(%rbx)
ffff800000103075:	00 00                	add    %al,(%rax)
ffff800000103077:	00 83 00 e0 01 00    	add    %al,0x1e000(%rbx)
ffff80000010307d:	00 00                	add    %al,(%rax)
ffff80000010307f:	00 83 00 00 02 00    	add    %al,0x20000(%rbx)
ffff800000103085:	00 00                	add    %al,(%rax)
ffff800000103087:	00 83 00 20 02 00    	add    %al,0x22000(%rbx)
ffff80000010308d:	00 00                	add    %al,(%rax)
ffff80000010308f:	00 83 00 40 02 00    	add    %al,0x24000(%rbx)
ffff800000103095:	00 00                	add    %al,(%rax)
ffff800000103097:	00 83 00 60 02 00    	add    %al,0x26000(%rbx)
ffff80000010309d:	00 00                	add    %al,(%rax)
ffff80000010309f:	00 83 00 80 02 00    	add    %al,0x28000(%rbx)
ffff8000001030a5:	00 00                	add    %al,(%rax)
ffff8000001030a7:	00 83 00 a0 02 00    	add    %al,0x2a000(%rbx)
ffff8000001030ad:	00 00                	add    %al,(%rax)
ffff8000001030af:	00 83 00 c0 02 00    	add    %al,0x2c000(%rbx)
ffff8000001030b5:	00 00                	add    %al,(%rax)
ffff8000001030b7:	00 83 00 e0 02 00    	add    %al,0x2e000(%rbx)
	...

ffff800000104000 <restore_all>:
ffff800000104000:	41 5f                	pop    %r15
ffff800000104002:	41 5e                	pop    %r14
ffff800000104004:	41 5d                	pop    %r13
ffff800000104006:	41 5c                	pop    %r12
ffff800000104008:	41 5b                	pop    %r11
ffff80000010400a:	41 5a                	pop    %r10
ffff80000010400c:	41 59                	pop    %r9
ffff80000010400e:	41 58                	pop    %r8
ffff800000104010:	5b                   	pop    %rbx
ffff800000104011:	59                   	pop    %rcx
ffff800000104012:	5a                   	pop    %rdx
ffff800000104013:	5e                   	pop    %rsi
ffff800000104014:	5f                   	pop    %rdi
ffff800000104015:	5d                   	pop    %rbp
ffff800000104016:	58                   	pop    %rax
ffff800000104017:	48 8e d8             	mov    %rax,%ds
ffff80000010401a:	58                   	pop    %rax
ffff80000010401b:	48 8e c0             	mov    %rax,%es
ffff80000010401e:	58                   	pop    %rax
ffff80000010401f:	48 83 c4 10          	add    $0x10,%rsp
ffff800000104023:	48 cf                	iretq  

ffff800000104025 <ret_from_intr>:
ffff800000104025:	eb d9                	jmp    ffff800000104000 <restore_all>

ffff800000104027 <error_code>:
ffff800000104027:	50                   	push   %rax
ffff800000104028:	48 8c c0             	mov    %es,%rax
ffff80000010402b:	50                   	push   %rax
ffff80000010402c:	48 8c d8             	mov    %ds,%rax
ffff80000010402f:	50                   	push   %rax
ffff800000104030:	48 31 c0             	xor    %rax,%rax
ffff800000104033:	55                   	push   %rbp
ffff800000104034:	57                   	push   %rdi
ffff800000104035:	56                   	push   %rsi
ffff800000104036:	52                   	push   %rdx
ffff800000104037:	51                   	push   %rcx
ffff800000104038:	53                   	push   %rbx
ffff800000104039:	41 50                	push   %r8
ffff80000010403b:	41 51                	push   %r9
ffff80000010403d:	41 52                	push   %r10
ffff80000010403f:	41 53                	push   %r11
ffff800000104041:	41 54                	push   %r12
ffff800000104043:	41 55                	push   %r13
ffff800000104045:	41 56                	push   %r14
ffff800000104047:	41 57                	push   %r15
ffff800000104049:	fc                   	cld    
ffff80000010404a:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
ffff800000104051:	00 
ffff800000104052:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
ffff800000104059:	00 
ffff80000010405a:	48 c7 c7 10 00 00 00 	mov    $0x10,%rdi
ffff800000104061:	48 8e df             	mov    %rdi,%ds
ffff800000104064:	48 8e c7             	mov    %rdi,%es
ffff800000104067:	48 89 e7             	mov    %rsp,%rdi
ffff80000010406a:	ff d2                	call   *%rdx
ffff80000010406c:	eb b7                	jmp    ffff800000104025 <ret_from_intr>

ffff80000010406e <debug>:
ffff80000010406e:	6a 00                	push   $0x0
ffff800000104070:	50                   	push   %rax
ffff800000104071:	48 8d 05 1f 2b 00 00 	lea    0x2b1f(%rip),%rax        # ffff800000106b97 <do_debug>
ffff800000104078:	48 87 04 24          	xchg   %rax,(%rsp)
ffff80000010407c:	eb a9                	jmp    ffff800000104027 <error_code>

ffff80000010407e <divide_error>:
ffff80000010407e:	6a 00                	push   $0x0
ffff800000104080:	50                   	push   %rax
ffff800000104081:	48 8d 05 89 2a 00 00 	lea    0x2a89(%rip),%rax        # ffff800000106b11 <do_divide_error>
ffff800000104088:	48 87 04 24          	xchg   %rax,(%rsp)
ffff80000010408c:	eb 99                	jmp    ffff800000104027 <error_code>

ffff80000010408e <nmi>:
ffff80000010408e:	50                   	push   %rax
ffff80000010408f:	fc                   	cld    
ffff800000104090:	50                   	push   %rax
ffff800000104091:	50                   	push   %rax
ffff800000104092:	48 8c c0             	mov    %es,%rax
ffff800000104095:	50                   	push   %rax
ffff800000104096:	48 8c d8             	mov    %ds,%rax
ffff800000104099:	50                   	push   %rax
ffff80000010409a:	48 31 c0             	xor    %rax,%rax
ffff80000010409d:	55                   	push   %rbp
ffff80000010409e:	57                   	push   %rdi
ffff80000010409f:	56                   	push   %rsi
ffff8000001040a0:	52                   	push   %rdx
ffff8000001040a1:	51                   	push   %rcx
ffff8000001040a2:	53                   	push   %rbx
ffff8000001040a3:	41 50                	push   %r8
ffff8000001040a5:	41 51                	push   %r9
ffff8000001040a7:	41 52                	push   %r10
ffff8000001040a9:	41 53                	push   %r11
ffff8000001040ab:	41 54                	push   %r12
ffff8000001040ad:	41 55                	push   %r13
ffff8000001040af:	41 56                	push   %r14
ffff8000001040b1:	41 57                	push   %r15
ffff8000001040b3:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
ffff8000001040ba:	48 8e d8             	mov    %rax,%ds
ffff8000001040bd:	48 8e c0             	mov    %rax,%es
ffff8000001040c0:	48 89 e7             	mov    %rsp,%rdi
ffff8000001040c3:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
ffff8000001040ca:	e8 4e 2b 00 00       	call   ffff800000106c1d <do_nmi>
ffff8000001040cf:	e9 2c ff ff ff       	jmp    ffff800000104000 <restore_all>

ffff8000001040d4 <int3>:
ffff8000001040d4:	6a 00                	push   $0x0
ffff8000001040d6:	50                   	push   %rax
ffff8000001040d7:	48 8d 05 c5 2b 00 00 	lea    0x2bc5(%rip),%rax        # ffff800000106ca3 <do_int3>
ffff8000001040de:	48 87 04 24          	xchg   %rax,(%rsp)
ffff8000001040e2:	e9 40 ff ff ff       	jmp    ffff800000104027 <error_code>

ffff8000001040e7 <overflow>:
ffff8000001040e7:	6a 00                	push   $0x0
ffff8000001040e9:	50                   	push   %rax
ffff8000001040ea:	48 8d 05 38 2c 00 00 	lea    0x2c38(%rip),%rax        # ffff800000106d29 <do_overflow>
ffff8000001040f1:	48 87 04 24          	xchg   %rax,(%rsp)
ffff8000001040f5:	e9 2d ff ff ff       	jmp    ffff800000104027 <error_code>

ffff8000001040fa <bounds>:
ffff8000001040fa:	6a 00                	push   $0x0
ffff8000001040fc:	50                   	push   %rax
ffff8000001040fd:	48 8d 05 ab 2c 00 00 	lea    0x2cab(%rip),%rax        # ffff800000106daf <do_bounds>
ffff800000104104:	48 87 04 24          	xchg   %rax,(%rsp)
ffff800000104108:	e9 1a ff ff ff       	jmp    ffff800000104027 <error_code>

ffff80000010410d <undefined_opcode>:
ffff80000010410d:	6a 00                	push   $0x0
ffff80000010410f:	50                   	push   %rax
ffff800000104110:	48 8d 05 1e 2d 00 00 	lea    0x2d1e(%rip),%rax        # ffff800000106e35 <do_undefined_opcode>
ffff800000104117:	48 87 04 24          	xchg   %rax,(%rsp)
ffff80000010411b:	e9 07 ff ff ff       	jmp    ffff800000104027 <error_code>

ffff800000104120 <dev_not_available>:
ffff800000104120:	6a 00                	push   $0x0
ffff800000104122:	50                   	push   %rax
ffff800000104123:	48 8d 05 91 2d 00 00 	lea    0x2d91(%rip),%rax        # ffff800000106ebb <do_dev_not_available>
ffff80000010412a:	48 87 04 24          	xchg   %rax,(%rsp)
ffff80000010412e:	e9 f4 fe ff ff       	jmp    ffff800000104027 <error_code>

ffff800000104133 <double_fault>:
ffff800000104133:	50                   	push   %rax
ffff800000104134:	48 8d 05 06 2e 00 00 	lea    0x2e06(%rip),%rax        # ffff800000106f41 <do_double_fault>
ffff80000010413b:	48 87 04 24          	xchg   %rax,(%rsp)
ffff80000010413f:	e9 e3 fe ff ff       	jmp    ffff800000104027 <error_code>

ffff800000104144 <coprocessor_segment_overrun>:
ffff800000104144:	6a 00                	push   $0x0
ffff800000104146:	50                   	push   %rax
ffff800000104147:	48 8d 05 79 2e 00 00 	lea    0x2e79(%rip),%rax        # ffff800000106fc7 <do_coprocessor_segment_overrun>
ffff80000010414e:	48 87 04 24          	xchg   %rax,(%rsp)
ffff800000104152:	e9 d0 fe ff ff       	jmp    ffff800000104027 <error_code>

ffff800000104157 <invalid_tss>:
ffff800000104157:	50                   	push   %rax
ffff800000104158:	48 8d 05 ee 2e 00 00 	lea    0x2eee(%rip),%rax        # ffff80000010704d <do_invalid_tss>
ffff80000010415f:	48 87 04 24          	xchg   %rax,(%rsp)
ffff800000104163:	e9 bf fe ff ff       	jmp    ffff800000104027 <error_code>

ffff800000104168 <segment_not_present>:
ffff800000104168:	50                   	push   %rax
ffff800000104169:	48 8d 05 f4 30 00 00 	lea    0x30f4(%rip),%rax        # ffff800000107264 <do_segment_not_present>
ffff800000104170:	48 87 04 24          	xchg   %rax,(%rsp)
ffff800000104174:	e9 ae fe ff ff       	jmp    ffff800000104027 <error_code>

ffff800000104179 <stack_segment_fault>:
ffff800000104179:	50                   	push   %rax
ffff80000010417a:	48 8d 05 fa 32 00 00 	lea    0x32fa(%rip),%rax        # ffff80000010747b <do_stack_segment_fault>
ffff800000104181:	48 87 04 24          	xchg   %rax,(%rsp)
ffff800000104185:	e9 9d fe ff ff       	jmp    ffff800000104027 <error_code>

ffff80000010418a <general_protection>:
ffff80000010418a:	50                   	push   %rax
ffff80000010418b:	48 8d 05 00 35 00 00 	lea    0x3500(%rip),%rax        # ffff800000107692 <do_general_protection>
ffff800000104192:	48 87 04 24          	xchg   %rax,(%rsp)
ffff800000104196:	e9 8c fe ff ff       	jmp    ffff800000104027 <error_code>

ffff80000010419b <page_fault>:
ffff80000010419b:	50                   	push   %rax
ffff80000010419c:	48 8d 05 17 37 00 00 	lea    0x3717(%rip),%rax        # ffff8000001078ba <do_page_fault>
ffff8000001041a3:	48 87 04 24          	xchg   %rax,(%rsp)
ffff8000001041a7:	e9 7b fe ff ff       	jmp    ffff800000104027 <error_code>

ffff8000001041ac <x87_FPU_error>:
ffff8000001041ac:	6a 00                	push   $0x0
ffff8000001041ae:	50                   	push   %rax
ffff8000001041af:	48 8d 05 d3 39 00 00 	lea    0x39d3(%rip),%rax        # ffff800000107b89 <do_x87_FPU_error>
ffff8000001041b6:	48 87 04 24          	xchg   %rax,(%rsp)
ffff8000001041ba:	e9 68 fe ff ff       	jmp    ffff800000104027 <error_code>

ffff8000001041bf <alignment_check>:
ffff8000001041bf:	50                   	push   %rax
ffff8000001041c0:	48 8d 05 48 3a 00 00 	lea    0x3a48(%rip),%rax        # ffff800000107c0f <do_alignment_check>
ffff8000001041c7:	48 87 04 24          	xchg   %rax,(%rsp)
ffff8000001041cb:	e9 57 fe ff ff       	jmp    ffff800000104027 <error_code>

ffff8000001041d0 <machine_check>:
ffff8000001041d0:	6a 00                	push   $0x0
ffff8000001041d2:	50                   	push   %rax
ffff8000001041d3:	48 8d 05 bb 3a 00 00 	lea    0x3abb(%rip),%rax        # ffff800000107c95 <do_machine_check>
ffff8000001041da:	48 87 04 24          	xchg   %rax,(%rsp)
ffff8000001041de:	e9 44 fe ff ff       	jmp    ffff800000104027 <error_code>

ffff8000001041e3 <SIMD_exception>:
ffff8000001041e3:	6a 00                	push   $0x0
ffff8000001041e5:	50                   	push   %rax
ffff8000001041e6:	48 8d 05 2e 3b 00 00 	lea    0x3b2e(%rip),%rax        # ffff800000107d1b <do_SIMD_exception>
ffff8000001041ed:	48 87 04 24          	xchg   %rax,(%rsp)
ffff8000001041f1:	e9 31 fe ff ff       	jmp    ffff800000104027 <error_code>

ffff8000001041f6 <virtualization_exception>:
ffff8000001041f6:	6a 00                	push   $0x0
ffff8000001041f8:	50                   	push   %rax
ffff8000001041f9:	48 8d 05 a1 3b 00 00 	lea    0x3ba1(%rip),%rax        # ffff800000107da1 <do_virtualization_exception>
ffff800000104200:	48 87 04 24          	xchg   %rax,(%rsp)
ffff800000104204:	e9 1e fe ff ff       	jmp    ffff800000104027 <error_code>

ffff800000104209 <min8>:
ffff800000104209:	f3 0f 1e fa          	endbr64 
ffff80000010420d:	55                   	push   %rbp
ffff80000010420e:	48 89 e5             	mov    %rsp,%rbp
ffff800000104211:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000104215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104219:	0f b6 00             	movzbl (%rax),%eax
ffff80000010421c:	5d                   	pop    %rbp
ffff80000010421d:	c3                   	ret    

ffff80000010421e <min16>:
ffff80000010421e:	f3 0f 1e fa          	endbr64 
ffff800000104222:	55                   	push   %rbp
ffff800000104223:	48 89 e5             	mov    %rsp,%rbp
ffff800000104226:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010422a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010422e:	0f b7 00             	movzwl (%rax),%eax
ffff800000104231:	5d                   	pop    %rbp
ffff800000104232:	c3                   	ret    

ffff800000104233 <min32>:
ffff800000104233:	f3 0f 1e fa          	endbr64 
ffff800000104237:	55                   	push   %rbp
ffff800000104238:	48 89 e5             	mov    %rsp,%rbp
ffff80000010423b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010423f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104243:	8b 00                	mov    (%rax),%eax
ffff800000104245:	5d                   	pop    %rbp
ffff800000104246:	c3                   	ret    

ffff800000104247 <min64>:
ffff800000104247:	f3 0f 1e fa          	endbr64 
ffff80000010424b:	55                   	push   %rbp
ffff80000010424c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010424f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000104253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104257:	48 8b 00             	mov    (%rax),%rax
ffff80000010425a:	5d                   	pop    %rbp
ffff80000010425b:	c3                   	ret    

ffff80000010425c <mout8>:
ffff80000010425c:	f3 0f 1e fa          	endbr64 
ffff800000104260:	55                   	push   %rbp
ffff800000104261:	48 89 e5             	mov    %rsp,%rbp
ffff800000104264:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000104268:	89 f0                	mov    %esi,%eax
ffff80000010426a:	88 45 f4             	mov    %al,-0xc(%rbp)
ffff80000010426d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104271:	0f b6 55 f4          	movzbl -0xc(%rbp),%edx
ffff800000104275:	88 10                	mov    %dl,(%rax)
ffff800000104277:	90                   	nop
ffff800000104278:	5d                   	pop    %rbp
ffff800000104279:	c3                   	ret    

ffff80000010427a <mout16>:
ffff80000010427a:	f3 0f 1e fa          	endbr64 
ffff80000010427e:	55                   	push   %rbp
ffff80000010427f:	48 89 e5             	mov    %rsp,%rbp
ffff800000104282:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000104286:	89 f0                	mov    %esi,%eax
ffff800000104288:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
ffff80000010428c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104290:	0f b7 55 f4          	movzwl -0xc(%rbp),%edx
ffff800000104294:	66 89 10             	mov    %dx,(%rax)
ffff800000104297:	90                   	nop
ffff800000104298:	5d                   	pop    %rbp
ffff800000104299:	c3                   	ret    

ffff80000010429a <mout32>:
ffff80000010429a:	f3 0f 1e fa          	endbr64 
ffff80000010429e:	55                   	push   %rbp
ffff80000010429f:	48 89 e5             	mov    %rsp,%rbp
ffff8000001042a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001042a6:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffff8000001042a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001042ad:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffff8000001042b0:	89 10                	mov    %edx,(%rax)
ffff8000001042b2:	90                   	nop
ffff8000001042b3:	5d                   	pop    %rbp
ffff8000001042b4:	c3                   	ret    

ffff8000001042b5 <mout64>:
ffff8000001042b5:	f3 0f 1e fa          	endbr64 
ffff8000001042b9:	55                   	push   %rbp
ffff8000001042ba:	48 89 e5             	mov    %rsp,%rbp
ffff8000001042bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001042c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001042c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001042c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001042cd:	48 89 10             	mov    %rdx,(%rax)
ffff8000001042d0:	90                   	nop
ffff8000001042d1:	5d                   	pop    %rbp
ffff8000001042d2:	c3                   	ret    

ffff8000001042d3 <port_in8>:
ffff8000001042d3:	f3 0f 1e fa          	endbr64 
ffff8000001042d7:	55                   	push   %rbp
ffff8000001042d8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001042db:	89 f8                	mov    %edi,%eax
ffff8000001042dd:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
ffff8000001042e1:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)
ffff8000001042e5:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff8000001042e9:	89 c2                	mov    %eax,%edx
ffff8000001042eb:	ec                   	in     (%dx),%al
ffff8000001042ec:	0f ae f0             	mfence 
ffff8000001042ef:	88 45 ff             	mov    %al,-0x1(%rbp)
ffff8000001042f2:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
ffff8000001042f6:	5d                   	pop    %rbp
ffff8000001042f7:	c3                   	ret    

ffff8000001042f8 <port_in32>:
ffff8000001042f8:	f3 0f 1e fa          	endbr64 
ffff8000001042fc:	55                   	push   %rbp
ffff8000001042fd:	48 89 e5             	mov    %rsp,%rbp
ffff800000104300:	89 f8                	mov    %edi,%eax
ffff800000104302:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
ffff800000104306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff80000010430d:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffff800000104311:	89 c2                	mov    %eax,%edx
ffff800000104313:	ed                   	in     (%dx),%eax
ffff800000104314:	0f ae f0             	mfence 
ffff800000104317:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff80000010431a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010431d:	5d                   	pop    %rbp
ffff80000010431e:	c3                   	ret    

ffff80000010431f <port_out8>:
ffff80000010431f:	f3 0f 1e fa          	endbr64 
ffff800000104323:	55                   	push   %rbp
ffff800000104324:	48 89 e5             	mov    %rsp,%rbp
ffff800000104327:	89 f8                	mov    %edi,%eax
ffff800000104329:	89 f2                	mov    %esi,%edx
ffff80000010432b:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff80000010432f:	89 d0                	mov    %edx,%eax
ffff800000104331:	88 45 f8             	mov    %al,-0x8(%rbp)
ffff800000104334:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff800000104338:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010433c:	ee                   	out    %al,(%dx)
ffff80000010433d:	0f ae f0             	mfence 
ffff800000104340:	90                   	nop
ffff800000104341:	5d                   	pop    %rbp
ffff800000104342:	c3                   	ret    

ffff800000104343 <port_out32>:
ffff800000104343:	f3 0f 1e fa          	endbr64 
ffff800000104347:	55                   	push   %rbp
ffff800000104348:	48 89 e5             	mov    %rsp,%rbp
ffff80000010434b:	89 f8                	mov    %edi,%eax
ffff80000010434d:	89 75 f8             	mov    %esi,-0x8(%rbp)
ffff800000104350:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
ffff800000104354:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000104357:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffff80000010435b:	ef                   	out    %eax,(%dx)
ffff80000010435c:	0f ae f0             	mfence 
ffff80000010435f:	90                   	nop
ffff800000104360:	5d                   	pop    %rbp
ffff800000104361:	c3                   	ret    

ffff800000104362 <list_init>:
ffff800000104362:	f3 0f 1e fa          	endbr64 
ffff800000104366:	55                   	push   %rbp
ffff800000104367:	48 89 e5             	mov    %rsp,%rbp
ffff80000010436a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010436e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104372:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104376:	48 89 10             	mov    %rdx,(%rax)
ffff800000104379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010437d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104381:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff800000104385:	90                   	nop
ffff800000104386:	5d                   	pop    %rbp
ffff800000104387:	c3                   	ret    

ffff800000104388 <list_add_behind>:
ffff800000104388:	f3 0f 1e fa          	endbr64 
ffff80000010438c:	55                   	push   %rbp
ffff80000010438d:	48 89 e5             	mov    %rsp,%rbp
ffff800000104390:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000104394:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000104398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010439c:	48 8b 50 08          	mov    0x8(%rax),%rdx
ffff8000001043a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001043a4:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff8000001043a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001043ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001043b0:	48 89 10             	mov    %rdx,(%rax)
ffff8000001043b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001043b7:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001043bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001043bf:	48 89 10             	mov    %rdx,(%rax)
ffff8000001043c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001043c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001043ca:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff8000001043ce:	90                   	nop
ffff8000001043cf:	5d                   	pop    %rbp
ffff8000001043d0:	c3                   	ret    

ffff8000001043d1 <list_add_before>:
ffff8000001043d1:	f3 0f 1e fa          	endbr64 
ffff8000001043d5:	55                   	push   %rbp
ffff8000001043d6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001043d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001043dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001043e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001043e5:	48 8b 00             	mov    (%rax),%rax
ffff8000001043e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001043ec:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff8000001043f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001043f4:	48 8b 10             	mov    (%rax),%rdx
ffff8000001043f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001043fb:	48 89 10             	mov    %rdx,(%rax)
ffff8000001043fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104402:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000104406:	48 89 10             	mov    %rdx,(%rax)
ffff800000104409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010440d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104411:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff800000104415:	90                   	nop
ffff800000104416:	5d                   	pop    %rbp
ffff800000104417:	c3                   	ret    

ffff800000104418 <list_delete>:
ffff800000104418:	f3 0f 1e fa          	endbr64 
ffff80000010441c:	55                   	push   %rbp
ffff80000010441d:	48 89 e5             	mov    %rsp,%rbp
ffff800000104420:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000104424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104428:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010442c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104430:	48 8b 12             	mov    (%rdx),%rdx
ffff800000104433:	48 89 10             	mov    %rdx,(%rax)
ffff800000104436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010443a:	48 8b 00             	mov    (%rax),%rax
ffff80000010443d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000104441:	48 8b 52 08          	mov    0x8(%rdx),%rdx
ffff800000104445:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff800000104449:	90                   	nop
ffff80000010444a:	5d                   	pop    %rbp
ffff80000010444b:	c3                   	ret    

ffff80000010444c <list_is_empty>:
ffff80000010444c:	f3 0f 1e fa          	endbr64 
ffff800000104450:	55                   	push   %rbp
ffff800000104451:	48 89 e5             	mov    %rsp,%rbp
ffff800000104454:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000104458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010445c:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104460:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000104464:	75 14                	jne    ffff80000010447a <list_is_empty+0x2e>
ffff800000104466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010446a:	48 8b 00             	mov    (%rax),%rax
ffff80000010446d:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff800000104471:	75 07                	jne    ffff80000010447a <list_is_empty+0x2e>
ffff800000104473:	b8 01 00 00 00       	mov    $0x1,%eax
ffff800000104478:	eb 05                	jmp    ffff80000010447f <list_is_empty+0x33>
ffff80000010447a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010447f:	5d                   	pop    %rbp
ffff800000104480:	c3                   	ret    

ffff800000104481 <list_prev>:
ffff800000104481:	f3 0f 1e fa          	endbr64 
ffff800000104485:	55                   	push   %rbp
ffff800000104486:	48 89 e5             	mov    %rsp,%rbp
ffff800000104489:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010448d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104491:	48 8b 00             	mov    (%rax),%rax
ffff800000104494:	48 85 c0             	test   %rax,%rax
ffff800000104497:	74 09                	je     ffff8000001044a2 <list_prev+0x21>
ffff800000104499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010449d:	48 8b 00             	mov    (%rax),%rax
ffff8000001044a0:	eb 05                	jmp    ffff8000001044a7 <list_prev+0x26>
ffff8000001044a2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001044a7:	5d                   	pop    %rbp
ffff8000001044a8:	c3                   	ret    

ffff8000001044a9 <list_next>:
ffff8000001044a9:	f3 0f 1e fa          	endbr64 
ffff8000001044ad:	55                   	push   %rbp
ffff8000001044ae:	48 89 e5             	mov    %rsp,%rbp
ffff8000001044b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001044b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001044b9:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001044bd:	48 85 c0             	test   %rax,%rax
ffff8000001044c0:	74 0a                	je     ffff8000001044cc <list_next+0x23>
ffff8000001044c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001044c6:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001044ca:	eb 05                	jmp    ffff8000001044d1 <list_next+0x28>
ffff8000001044cc:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001044d1:	5d                   	pop    %rbp
ffff8000001044d2:	c3                   	ret    

ffff8000001044d3 <list_size>:
ffff8000001044d3:	f3 0f 1e fa          	endbr64 
ffff8000001044d7:	55                   	push   %rbp
ffff8000001044d8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001044db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001044df:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff8000001044e6:	00 
ffff8000001044e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001044eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001044ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001044f3:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001044f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff8000001044fb:	eb 11                	jmp    ffff80000010450e <list_size+0x3b>
ffff8000001044fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000104502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104506:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010450a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010450e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104512:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffff800000104516:	75 e5                	jne    ffff8000001044fd <list_size+0x2a>
ffff800000104518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010451c:	5d                   	pop    %rbp
ffff80000010451d:	c3                   	ret    

ffff80000010451e <number>:
ffff80000010451e:	f3 0f 1e fa          	endbr64 
ffff800000104522:	55                   	push   %rbp
ffff800000104523:	48 89 e5             	mov    %rsp,%rbp
ffff800000104526:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
ffff80000010452a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
ffff80000010452e:	89 55 9c             	mov    %edx,-0x64(%rbp)
ffff800000104531:	89 4d 98             	mov    %ecx,-0x68(%rbp)
ffff800000104534:	44 89 45 94          	mov    %r8d,-0x6c(%rbp)
ffff800000104538:	44 89 4d 90          	mov    %r9d,-0x70(%rbp)
ffff80000010453c:	48 b8 80 c4 10 00 00 	movabs $0xffff80000010c480,%rax
ffff800000104543:	80 ff ff 
ffff800000104546:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010454a:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff80000010454d:	83 e0 40             	and    $0x40,%eax
ffff800000104550:	85 c0                	test   %eax,%eax
ffff800000104552:	74 0e                	je     ffff800000104562 <number+0x44>
ffff800000104554:	48 b8 a8 c4 10 00 00 	movabs $0xffff80000010c4a8,%rax
ffff80000010455b:	80 ff ff 
ffff80000010455e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000104562:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff800000104565:	83 e0 10             	and    $0x10,%eax
ffff800000104568:	85 c0                	test   %eax,%eax
ffff80000010456a:	74 04                	je     ffff800000104570 <number+0x52>
ffff80000010456c:	83 65 90 fe          	andl   $0xfffffffe,-0x70(%rbp)
ffff800000104570:	83 7d 9c 01          	cmpl   $0x1,-0x64(%rbp)
ffff800000104574:	7e 06                	jle    ffff80000010457c <number+0x5e>
ffff800000104576:	83 7d 9c 24          	cmpl   $0x24,-0x64(%rbp)
ffff80000010457a:	7e 0a                	jle    ffff800000104586 <number+0x68>
ffff80000010457c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000104581:	e9 13 02 00 00       	jmp    ffff800000104799 <number+0x27b>
ffff800000104586:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff800000104589:	83 e0 01             	and    $0x1,%eax
ffff80000010458c:	85 c0                	test   %eax,%eax
ffff80000010458e:	74 07                	je     ffff800000104597 <number+0x79>
ffff800000104590:	b8 30 00 00 00       	mov    $0x30,%eax
ffff800000104595:	eb 05                	jmp    ffff80000010459c <number+0x7e>
ffff800000104597:	b8 20 00 00 00       	mov    $0x20,%eax
ffff80000010459c:	88 45 eb             	mov    %al,-0x15(%rbp)
ffff80000010459f:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)
ffff8000001045a3:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff8000001045a6:	83 e0 02             	and    $0x2,%eax
ffff8000001045a9:	85 c0                	test   %eax,%eax
ffff8000001045ab:	74 11                	je     ffff8000001045be <number+0xa0>
ffff8000001045ad:	48 83 7d a0 00       	cmpq   $0x0,-0x60(%rbp)
ffff8000001045b2:	79 0a                	jns    ffff8000001045be <number+0xa0>
ffff8000001045b4:	c6 45 ff 2d          	movb   $0x2d,-0x1(%rbp)
ffff8000001045b8:	48 f7 5d a0          	negq   -0x60(%rbp)
ffff8000001045bc:	eb 1d                	jmp    ffff8000001045db <number+0xbd>
ffff8000001045be:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff8000001045c1:	83 e0 04             	and    $0x4,%eax
ffff8000001045c4:	85 c0                	test   %eax,%eax
ffff8000001045c6:	75 0b                	jne    ffff8000001045d3 <number+0xb5>
ffff8000001045c8:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff8000001045cb:	c1 e0 02             	shl    $0x2,%eax
ffff8000001045ce:	83 e0 20             	and    $0x20,%eax
ffff8000001045d1:	eb 05                	jmp    ffff8000001045d8 <number+0xba>
ffff8000001045d3:	b8 2b 00 00 00       	mov    $0x2b,%eax
ffff8000001045d8:	88 45 ff             	mov    %al,-0x1(%rbp)
ffff8000001045db:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
ffff8000001045df:	74 04                	je     ffff8000001045e5 <number+0xc7>
ffff8000001045e1:	83 6d 98 01          	subl   $0x1,-0x68(%rbp)
ffff8000001045e5:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff8000001045e8:	83 e0 20             	and    $0x20,%eax
ffff8000001045eb:	85 c0                	test   %eax,%eax
ffff8000001045ed:	74 16                	je     ffff800000104605 <number+0xe7>
ffff8000001045ef:	83 7d 9c 10          	cmpl   $0x10,-0x64(%rbp)
ffff8000001045f3:	75 06                	jne    ffff8000001045fb <number+0xdd>
ffff8000001045f5:	83 6d 98 02          	subl   $0x2,-0x68(%rbp)
ffff8000001045f9:	eb 0a                	jmp    ffff800000104605 <number+0xe7>
ffff8000001045fb:	83 7d 9c 08          	cmpl   $0x8,-0x64(%rbp)
ffff8000001045ff:	75 04                	jne    ffff800000104605 <number+0xe7>
ffff800000104601:	83 6d 98 01          	subl   $0x1,-0x68(%rbp)
ffff800000104605:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff80000010460c:	48 83 7d a0 00       	cmpq   $0x0,-0x60(%rbp)
ffff800000104611:	75 48                	jne    ffff80000010465b <number+0x13d>
ffff800000104613:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104616:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000104619:	89 55 ec             	mov    %edx,-0x14(%rbp)
ffff80000010461c:	48 98                	cltq   
ffff80000010461e:	c6 44 05 b0 30       	movb   $0x30,-0x50(%rbp,%rax,1)
ffff800000104623:	eb 3d                	jmp    ffff800000104662 <number+0x144>
ffff800000104625:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
ffff800000104629:	ba 00 00 00 00       	mov    $0x0,%edx
ffff80000010462e:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
ffff800000104631:	48 f7 f1             	div    %rcx
ffff800000104634:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
ffff800000104638:	89 55 e4             	mov    %edx,-0x1c(%rbp)
ffff80000010463b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff80000010463e:	48 63 d0             	movslq %eax,%rdx
ffff800000104641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104645:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffff800000104649:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010464c:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010464f:	89 55 ec             	mov    %edx,-0x14(%rbp)
ffff800000104652:	0f b6 11             	movzbl (%rcx),%edx
ffff800000104655:	48 98                	cltq   
ffff800000104657:	88 54 05 b0          	mov    %dl,-0x50(%rbp,%rax,1)
ffff80000010465b:	48 83 7d a0 00       	cmpq   $0x0,-0x60(%rbp)
ffff800000104660:	75 c3                	jne    ffff800000104625 <number+0x107>
ffff800000104662:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104665:	3b 45 94             	cmp    -0x6c(%rbp),%eax
ffff800000104668:	7e 06                	jle    ffff800000104670 <number+0x152>
ffff80000010466a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010466d:	89 45 94             	mov    %eax,-0x6c(%rbp)
ffff800000104670:	8b 45 94             	mov    -0x6c(%rbp),%eax
ffff800000104673:	29 45 98             	sub    %eax,-0x68(%rbp)
ffff800000104676:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff800000104679:	83 e0 11             	and    $0x11,%eax
ffff80000010467c:	85 c0                	test   %eax,%eax
ffff80000010467e:	75 1e                	jne    ffff80000010469e <number+0x180>
ffff800000104680:	eb 0f                	jmp    ffff800000104691 <number+0x173>
ffff800000104682:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff800000104686:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff80000010468a:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff80000010468e:	c6 00 20             	movb   $0x20,(%rax)
ffff800000104691:	8b 45 98             	mov    -0x68(%rbp),%eax
ffff800000104694:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000104697:	89 55 98             	mov    %edx,-0x68(%rbp)
ffff80000010469a:	85 c0                	test   %eax,%eax
ffff80000010469c:	7f e4                	jg     ffff800000104682 <number+0x164>
ffff80000010469e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
ffff8000001046a2:	74 12                	je     ffff8000001046b6 <number+0x198>
ffff8000001046a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff8000001046a8:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001046ac:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff8000001046b0:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
ffff8000001046b4:	88 10                	mov    %dl,(%rax)
ffff8000001046b6:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff8000001046b9:	83 e0 20             	and    $0x20,%eax
ffff8000001046bc:	85 c0                	test   %eax,%eax
ffff8000001046be:	74 45                	je     ffff800000104705 <number+0x1e7>
ffff8000001046c0:	83 7d 9c 08          	cmpl   $0x8,-0x64(%rbp)
ffff8000001046c4:	75 11                	jne    ffff8000001046d7 <number+0x1b9>
ffff8000001046c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff8000001046ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001046ce:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff8000001046d2:	c6 00 30             	movb   $0x30,(%rax)
ffff8000001046d5:	eb 2e                	jmp    ffff800000104705 <number+0x1e7>
ffff8000001046d7:	83 7d 9c 10          	cmpl   $0x10,-0x64(%rbp)
ffff8000001046db:	75 28                	jne    ffff800000104705 <number+0x1e7>
ffff8000001046dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff8000001046e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001046e5:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff8000001046e9:	c6 00 30             	movb   $0x30,(%rax)
ffff8000001046ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001046f0:	48 8d 48 21          	lea    0x21(%rax),%rcx
ffff8000001046f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff8000001046f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001046fc:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff800000104700:	0f b6 11             	movzbl (%rcx),%edx
ffff800000104703:	88 10                	mov    %dl,(%rax)
ffff800000104705:	8b 45 90             	mov    -0x70(%rbp),%eax
ffff800000104708:	83 e0 10             	and    $0x10,%eax
ffff80000010470b:	85 c0                	test   %eax,%eax
ffff80000010470d:	75 32                	jne    ffff800000104741 <number+0x223>
ffff80000010470f:	eb 12                	jmp    ffff800000104723 <number+0x205>
ffff800000104711:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff800000104715:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104719:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff80000010471d:	0f b6 55 eb          	movzbl -0x15(%rbp),%edx
ffff800000104721:	88 10                	mov    %dl,(%rax)
ffff800000104723:	8b 45 98             	mov    -0x68(%rbp),%eax
ffff800000104726:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000104729:	89 55 98             	mov    %edx,-0x68(%rbp)
ffff80000010472c:	85 c0                	test   %eax,%eax
ffff80000010472e:	7f e1                	jg     ffff800000104711 <number+0x1f3>
ffff800000104730:	eb 0f                	jmp    ffff800000104741 <number+0x223>
ffff800000104732:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff800000104736:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff80000010473a:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff80000010473e:	c6 00 30             	movb   $0x30,(%rax)
ffff800000104741:	8b 45 94             	mov    -0x6c(%rbp),%eax
ffff800000104744:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000104747:	89 55 94             	mov    %edx,-0x6c(%rbp)
ffff80000010474a:	39 45 ec             	cmp    %eax,-0x14(%rbp)
ffff80000010474d:	7c e3                	jl     ffff800000104732 <number+0x214>
ffff80000010474f:	eb 19                	jmp    ffff80000010476a <number+0x24c>
ffff800000104751:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff800000104755:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104759:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff80000010475d:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffff800000104760:	48 63 d2             	movslq %edx,%rdx
ffff800000104763:	0f b6 54 15 b0       	movzbl -0x50(%rbp,%rdx,1),%edx
ffff800000104768:	88 10                	mov    %dl,(%rax)
ffff80000010476a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010476d:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000104770:	89 55 ec             	mov    %edx,-0x14(%rbp)
ffff800000104773:	85 c0                	test   %eax,%eax
ffff800000104775:	7f da                	jg     ffff800000104751 <number+0x233>
ffff800000104777:	eb 0f                	jmp    ffff800000104788 <number+0x26a>
ffff800000104779:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff80000010477d:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104781:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
ffff800000104785:	c6 00 20             	movb   $0x20,(%rax)
ffff800000104788:	8b 45 98             	mov    -0x68(%rbp),%eax
ffff80000010478b:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff80000010478e:	89 55 98             	mov    %edx,-0x68(%rbp)
ffff800000104791:	85 c0                	test   %eax,%eax
ffff800000104793:	7f e4                	jg     ffff800000104779 <number+0x25b>
ffff800000104795:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
ffff800000104799:	5d                   	pop    %rbp
ffff80000010479a:	c3                   	ret    

ffff80000010479b <skip_atoi>:
ffff80000010479b:	f3 0f 1e fa          	endbr64 
ffff80000010479f:	55                   	push   %rbp
ffff8000001047a0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001047a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001047a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001047ae:	eb 2e                	jmp    ffff8000001047de <skip_atoi+0x43>
ffff8000001047b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001047b3:	89 d0                	mov    %edx,%eax
ffff8000001047b5:	c1 e0 02             	shl    $0x2,%eax
ffff8000001047b8:	01 d0                	add    %edx,%eax
ffff8000001047ba:	01 c0                	add    %eax,%eax
ffff8000001047bc:	89 c6                	mov    %eax,%esi
ffff8000001047be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001047c2:	48 8b 00             	mov    (%rax),%rax
ffff8000001047c5:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff8000001047c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffff8000001047cd:	48 89 0a             	mov    %rcx,(%rdx)
ffff8000001047d0:	0f b6 00             	movzbl (%rax),%eax
ffff8000001047d3:	0f be c0             	movsbl %al,%eax
ffff8000001047d6:	01 f0                	add    %esi,%eax
ffff8000001047d8:	83 e8 30             	sub    $0x30,%eax
ffff8000001047db:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffff8000001047de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001047e2:	48 8b 00             	mov    (%rax),%rax
ffff8000001047e5:	0f b6 00             	movzbl (%rax),%eax
ffff8000001047e8:	3c 2f                	cmp    $0x2f,%al
ffff8000001047ea:	7e 0e                	jle    ffff8000001047fa <skip_atoi+0x5f>
ffff8000001047ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001047f0:	48 8b 00             	mov    (%rax),%rax
ffff8000001047f3:	0f b6 00             	movzbl (%rax),%eax
ffff8000001047f6:	3c 39                	cmp    $0x39,%al
ffff8000001047f8:	7e b6                	jle    ffff8000001047b0 <skip_atoi+0x15>
ffff8000001047fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001047fd:	5d                   	pop    %rbp
ffff8000001047fe:	c3                   	ret    

ffff8000001047ff <vsprintf>:
ffff8000001047ff:	f3 0f 1e fa          	endbr64 
ffff800000104803:	55                   	push   %rbp
ffff800000104804:	48 89 e5             	mov    %rsp,%rbp
ffff800000104807:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
ffff80000010480b:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
ffff80000010480f:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
ffff800000104813:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
ffff800000104817:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffff80000010481b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010481f:	e9 ad 0a 00 00       	jmp    ffff8000001052d1 <vsprintf+0xad2>
ffff800000104824:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104828:	0f b6 00             	movzbl (%rax),%eax
ffff80000010482b:	3c 25                	cmp    $0x25,%al
ffff80000010482d:	74 1a                	je     ffff800000104849 <vsprintf+0x4a>
ffff80000010482f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
ffff800000104833:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104837:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff80000010483b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
ffff80000010483f:	0f b6 12             	movzbl (%rdx),%edx
ffff800000104842:	88 10                	mov    %dl,(%rax)
ffff800000104844:	e9 7c 0a 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104849:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffff800000104850:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104854:	48 83 c0 01          	add    $0x1,%rax
ffff800000104858:	48 89 45 90          	mov    %rax,-0x70(%rbp)
ffff80000010485c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104860:	0f b6 00             	movzbl (%rax),%eax
ffff800000104863:	0f be c0             	movsbl %al,%eax
ffff800000104866:	83 e8 20             	sub    $0x20,%eax
ffff800000104869:	83 f8 10             	cmp    $0x10,%eax
ffff80000010486c:	77 3b                	ja     ffff8000001048a9 <vsprintf+0xaa>
ffff80000010486e:	89 c0                	mov    %eax,%eax
ffff800000104870:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000104877:	00 
ffff800000104878:	48 b8 d0 c4 10 00 00 	movabs $0xffff80000010c4d0,%rax
ffff80000010487f:	80 ff ff 
ffff800000104882:	48 01 d0             	add    %rdx,%rax
ffff800000104885:	48 8b 00             	mov    (%rax),%rax
ffff800000104888:	3e ff e0             	notrack jmp *%rax
ffff80000010488b:	83 4d ec 10          	orl    $0x10,-0x14(%rbp)
ffff80000010488f:	eb bf                	jmp    ffff800000104850 <vsprintf+0x51>
ffff800000104891:	83 4d ec 04          	orl    $0x4,-0x14(%rbp)
ffff800000104895:	eb b9                	jmp    ffff800000104850 <vsprintf+0x51>
ffff800000104897:	83 4d ec 08          	orl    $0x8,-0x14(%rbp)
ffff80000010489b:	eb b3                	jmp    ffff800000104850 <vsprintf+0x51>
ffff80000010489d:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
ffff8000001048a1:	eb ad                	jmp    ffff800000104850 <vsprintf+0x51>
ffff8000001048a3:	83 4d ec 01          	orl    $0x1,-0x14(%rbp)
ffff8000001048a7:	eb a7                	jmp    ffff800000104850 <vsprintf+0x51>
ffff8000001048a9:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
ffff8000001048b0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001048b4:	0f b6 00             	movzbl (%rax),%eax
ffff8000001048b7:	3c 2f                	cmp    $0x2f,%al
ffff8000001048b9:	7e 23                	jle    ffff8000001048de <vsprintf+0xdf>
ffff8000001048bb:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001048bf:	0f b6 00             	movzbl (%rax),%eax
ffff8000001048c2:	3c 39                	cmp    $0x39,%al
ffff8000001048c4:	7f 18                	jg     ffff8000001048de <vsprintf+0xdf>
ffff8000001048c6:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffff8000001048ca:	48 89 c7             	mov    %rax,%rdi
ffff8000001048cd:	48 b8 9b 47 10 00 00 	movabs $0xffff80000010479b,%rax
ffff8000001048d4:	80 ff ff 
ffff8000001048d7:	ff d0                	call   *%rax
ffff8000001048d9:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff8000001048dc:	eb 6c                	jmp    ffff80000010494a <vsprintf+0x14b>
ffff8000001048de:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001048e2:	0f b6 00             	movzbl (%rax),%eax
ffff8000001048e5:	3c 2a                	cmp    $0x2a,%al
ffff8000001048e7:	75 61                	jne    ffff80000010494a <vsprintf+0x14b>
ffff8000001048e9:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001048ed:	48 83 c0 01          	add    $0x1,%rax
ffff8000001048f1:	48 89 45 90          	mov    %rax,-0x70(%rbp)
ffff8000001048f5:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001048f9:	8b 00                	mov    (%rax),%eax
ffff8000001048fb:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001048fe:	77 24                	ja     ffff800000104924 <vsprintf+0x125>
ffff800000104900:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104904:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104908:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010490c:	8b 00                	mov    (%rax),%eax
ffff80000010490e:	89 c0                	mov    %eax,%eax
ffff800000104910:	48 01 d0             	add    %rdx,%rax
ffff800000104913:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104917:	8b 12                	mov    (%rdx),%edx
ffff800000104919:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff80000010491c:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104920:	89 0a                	mov    %ecx,(%rdx)
ffff800000104922:	eb 14                	jmp    ffff800000104938 <vsprintf+0x139>
ffff800000104924:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104928:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010492c:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104930:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104934:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104938:	8b 00                	mov    (%rax),%eax
ffff80000010493a:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffff80000010493d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff800000104941:	79 07                	jns    ffff80000010494a <vsprintf+0x14b>
ffff800000104943:	f7 5d e8             	negl   -0x18(%rbp)
ffff800000104946:	83 4d ec 10          	orl    $0x10,-0x14(%rbp)
ffff80000010494a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
ffff800000104951:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104955:	0f b6 00             	movzbl (%rax),%eax
ffff800000104958:	3c 2e                	cmp    $0x2e,%al
ffff80000010495a:	0f 85 a6 00 00 00    	jne    ffff800000104a06 <vsprintf+0x207>
ffff800000104960:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104964:	48 83 c0 01          	add    $0x1,%rax
ffff800000104968:	48 89 45 90          	mov    %rax,-0x70(%rbp)
ffff80000010496c:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104970:	0f b6 00             	movzbl (%rax),%eax
ffff800000104973:	3c 2f                	cmp    $0x2f,%al
ffff800000104975:	7e 23                	jle    ffff80000010499a <vsprintf+0x19b>
ffff800000104977:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff80000010497b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010497e:	3c 39                	cmp    $0x39,%al
ffff800000104980:	7f 18                	jg     ffff80000010499a <vsprintf+0x19b>
ffff800000104982:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffff800000104986:	48 89 c7             	mov    %rax,%rdi
ffff800000104989:	48 b8 9b 47 10 00 00 	movabs $0xffff80000010479b,%rax
ffff800000104990:	80 ff ff 
ffff800000104993:	ff d0                	call   *%rax
ffff800000104995:	89 45 e4             	mov    %eax,-0x1c(%rbp)
ffff800000104998:	eb 5f                	jmp    ffff8000001049f9 <vsprintf+0x1fa>
ffff80000010499a:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff80000010499e:	0f b6 00             	movzbl (%rax),%eax
ffff8000001049a1:	3c 2a                	cmp    $0x2a,%al
ffff8000001049a3:	75 54                	jne    ffff8000001049f9 <vsprintf+0x1fa>
ffff8000001049a5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001049a9:	48 83 c0 01          	add    $0x1,%rax
ffff8000001049ad:	48 89 45 90          	mov    %rax,-0x70(%rbp)
ffff8000001049b1:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001049b5:	8b 00                	mov    (%rax),%eax
ffff8000001049b7:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001049ba:	77 24                	ja     ffff8000001049e0 <vsprintf+0x1e1>
ffff8000001049bc:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001049c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff8000001049c4:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001049c8:	8b 00                	mov    (%rax),%eax
ffff8000001049ca:	89 c0                	mov    %eax,%eax
ffff8000001049cc:	48 01 d0             	add    %rdx,%rax
ffff8000001049cf:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001049d3:	8b 12                	mov    (%rdx),%edx
ffff8000001049d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff8000001049d8:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001049dc:	89 0a                	mov    %ecx,(%rdx)
ffff8000001049de:	eb 14                	jmp    ffff8000001049f4 <vsprintf+0x1f5>
ffff8000001049e0:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001049e4:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001049e8:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff8000001049ec:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001049f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff8000001049f4:	8b 00                	mov    (%rax),%eax
ffff8000001049f6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
ffff8000001049f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff8000001049fd:	79 07                	jns    ffff800000104a06 <vsprintf+0x207>
ffff8000001049ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
ffff800000104a06:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
ffff800000104a0d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104a11:	0f b6 00             	movzbl (%rax),%eax
ffff800000104a14:	3c 68                	cmp    $0x68,%al
ffff800000104a16:	74 21                	je     ffff800000104a39 <vsprintf+0x23a>
ffff800000104a18:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104a1c:	0f b6 00             	movzbl (%rax),%eax
ffff800000104a1f:	3c 6c                	cmp    $0x6c,%al
ffff800000104a21:	74 16                	je     ffff800000104a39 <vsprintf+0x23a>
ffff800000104a23:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104a27:	0f b6 00             	movzbl (%rax),%eax
ffff800000104a2a:	3c 4c                	cmp    $0x4c,%al
ffff800000104a2c:	74 0b                	je     ffff800000104a39 <vsprintf+0x23a>
ffff800000104a2e:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104a32:	0f b6 00             	movzbl (%rax),%eax
ffff800000104a35:	3c 5a                	cmp    $0x5a,%al
ffff800000104a37:	75 19                	jne    ffff800000104a52 <vsprintf+0x253>
ffff800000104a39:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104a3d:	0f b6 00             	movzbl (%rax),%eax
ffff800000104a40:	0f be c0             	movsbl %al,%eax
ffff800000104a43:	89 45 d8             	mov    %eax,-0x28(%rbp)
ffff800000104a46:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104a4a:	48 83 c0 01          	add    $0x1,%rax
ffff800000104a4e:	48 89 45 90          	mov    %rax,-0x70(%rbp)
ffff800000104a52:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff800000104a56:	0f b6 00             	movzbl (%rax),%eax
ffff800000104a59:	0f be c0             	movsbl %al,%eax
ffff800000104a5c:	83 e8 25             	sub    $0x25,%eax
ffff800000104a5f:	83 f8 53             	cmp    $0x53,%eax
ffff800000104a62:	0f 87 1f 08 00 00    	ja     ffff800000105287 <vsprintf+0xa88>
ffff800000104a68:	89 c0                	mov    %eax,%eax
ffff800000104a6a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000104a71:	00 
ffff800000104a72:	48 b8 58 c5 10 00 00 	movabs $0xffff80000010c558,%rax
ffff800000104a79:	80 ff ff 
ffff800000104a7c:	48 01 d0             	add    %rdx,%rax
ffff800000104a7f:	48 8b 00             	mov    (%rax),%rax
ffff800000104a82:	3e ff e0             	notrack jmp *%rax
ffff800000104a85:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104a88:	83 e0 10             	and    $0x10,%eax
ffff800000104a8b:	85 c0                	test   %eax,%eax
ffff800000104a8d:	75 1b                	jne    ffff800000104aaa <vsprintf+0x2ab>
ffff800000104a8f:	eb 0f                	jmp    ffff800000104aa0 <vsprintf+0x2a1>
ffff800000104a91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104a95:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104a99:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
ffff800000104a9d:	c6 00 20             	movb   $0x20,(%rax)
ffff800000104aa0:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
ffff800000104aa4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff800000104aa8:	7f e7                	jg     ffff800000104a91 <vsprintf+0x292>
ffff800000104aaa:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104aae:	8b 00                	mov    (%rax),%eax
ffff800000104ab0:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104ab3:	77 24                	ja     ffff800000104ad9 <vsprintf+0x2da>
ffff800000104ab5:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104ab9:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104abd:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104ac1:	8b 00                	mov    (%rax),%eax
ffff800000104ac3:	89 c0                	mov    %eax,%eax
ffff800000104ac5:	48 01 d0             	add    %rdx,%rax
ffff800000104ac8:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104acc:	8b 12                	mov    (%rdx),%edx
ffff800000104ace:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104ad1:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104ad5:	89 0a                	mov    %ecx,(%rdx)
ffff800000104ad7:	eb 14                	jmp    ffff800000104aed <vsprintf+0x2ee>
ffff800000104ad9:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104add:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104ae1:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104ae5:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104ae9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104aed:	8b 08                	mov    (%rax),%ecx
ffff800000104aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104af3:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104af7:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
ffff800000104afb:	89 ca                	mov    %ecx,%edx
ffff800000104afd:	88 10                	mov    %dl,(%rax)
ffff800000104aff:	eb 0f                	jmp    ffff800000104b10 <vsprintf+0x311>
ffff800000104b01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104b05:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104b09:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
ffff800000104b0d:	c6 00 20             	movb   $0x20,(%rax)
ffff800000104b10:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
ffff800000104b14:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
ffff800000104b18:	7f e7                	jg     ffff800000104b01 <vsprintf+0x302>
ffff800000104b1a:	e9 a6 07 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104b1f:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104b23:	8b 00                	mov    (%rax),%eax
ffff800000104b25:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104b28:	77 24                	ja     ffff800000104b4e <vsprintf+0x34f>
ffff800000104b2a:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104b2e:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104b32:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104b36:	8b 00                	mov    (%rax),%eax
ffff800000104b38:	89 c0                	mov    %eax,%eax
ffff800000104b3a:	48 01 d0             	add    %rdx,%rax
ffff800000104b3d:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104b41:	8b 12                	mov    (%rdx),%edx
ffff800000104b43:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104b46:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104b4a:	89 0a                	mov    %ecx,(%rdx)
ffff800000104b4c:	eb 14                	jmp    ffff800000104b62 <vsprintf+0x363>
ffff800000104b4e:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104b52:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104b56:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104b5a:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104b5e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104b62:	48 8b 00             	mov    (%rax),%rax
ffff800000104b65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000104b69:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffff800000104b6e:	75 08                	jne    ffff800000104b78 <vsprintf+0x379>
ffff800000104b70:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff800000104b77:	00 
ffff800000104b78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000104b7c:	48 89 c7             	mov    %rax,%rdi
ffff800000104b7f:	48 b8 ba 53 10 00 00 	movabs $0xffff8000001053ba,%rax
ffff800000104b86:	80 ff ff 
ffff800000104b89:	ff d0                	call   *%rax
ffff800000104b8b:	89 45 e0             	mov    %eax,-0x20(%rbp)
ffff800000104b8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffff800000104b92:	79 08                	jns    ffff800000104b9c <vsprintf+0x39d>
ffff800000104b94:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104b97:	89 45 e4             	mov    %eax,-0x1c(%rbp)
ffff800000104b9a:	eb 0e                	jmp    ffff800000104baa <vsprintf+0x3ab>
ffff800000104b9c:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000104b9f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffff800000104ba2:	7e 06                	jle    ffff800000104baa <vsprintf+0x3ab>
ffff800000104ba4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000104ba7:	89 45 e0             	mov    %eax,-0x20(%rbp)
ffff800000104baa:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000104bad:	83 e0 10             	and    $0x10,%eax
ffff800000104bb0:	85 c0                	test   %eax,%eax
ffff800000104bb2:	75 1f                	jne    ffff800000104bd3 <vsprintf+0x3d4>
ffff800000104bb4:	eb 0f                	jmp    ffff800000104bc5 <vsprintf+0x3c6>
ffff800000104bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104bba:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104bbe:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
ffff800000104bc2:	c6 00 20             	movb   $0x20,(%rax)
ffff800000104bc5:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104bc8:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000104bcb:	89 55 e8             	mov    %edx,-0x18(%rbp)
ffff800000104bce:	39 45 e0             	cmp    %eax,-0x20(%rbp)
ffff800000104bd1:	7c e3                	jl     ffff800000104bb6 <vsprintf+0x3b7>
ffff800000104bd3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
ffff800000104bda:	eb 21                	jmp    ffff800000104bfd <vsprintf+0x3fe>
ffff800000104bdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000104be0:	48 8d 42 01          	lea    0x1(%rdx),%rax
ffff800000104be4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000104be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104bec:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff800000104bf0:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
ffff800000104bf4:	0f b6 12             	movzbl (%rdx),%edx
ffff800000104bf7:	88 10                	mov    %dl,(%rax)
ffff800000104bf9:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
ffff800000104bfd:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffff800000104c00:	3b 45 e0             	cmp    -0x20(%rbp),%eax
ffff800000104c03:	7c d7                	jl     ffff800000104bdc <vsprintf+0x3dd>
ffff800000104c05:	eb 0f                	jmp    ffff800000104c16 <vsprintf+0x417>
ffff800000104c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104c0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff800000104c0f:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
ffff800000104c13:	c6 00 20             	movb   $0x20,(%rax)
ffff800000104c16:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000104c19:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000104c1c:	89 55 e8             	mov    %edx,-0x18(%rbp)
ffff800000104c1f:	39 45 e0             	cmp    %eax,-0x20(%rbp)
ffff800000104c22:	7c e3                	jl     ffff800000104c07 <vsprintf+0x408>
ffff800000104c24:	e9 9c 06 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104c29:	83 7d d8 6c          	cmpl   $0x6c,-0x28(%rbp)
ffff800000104c2d:	75 7e                	jne    ffff800000104cad <vsprintf+0x4ae>
ffff800000104c2f:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104c33:	8b 00                	mov    (%rax),%eax
ffff800000104c35:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104c38:	77 24                	ja     ffff800000104c5e <vsprintf+0x45f>
ffff800000104c3a:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104c3e:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104c42:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104c46:	8b 00                	mov    (%rax),%eax
ffff800000104c48:	89 c0                	mov    %eax,%eax
ffff800000104c4a:	48 01 d0             	add    %rdx,%rax
ffff800000104c4d:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104c51:	8b 12                	mov    (%rdx),%edx
ffff800000104c53:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104c56:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104c5a:	89 0a                	mov    %ecx,(%rdx)
ffff800000104c5c:	eb 14                	jmp    ffff800000104c72 <vsprintf+0x473>
ffff800000104c5e:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104c62:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104c66:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104c6a:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104c6e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104c72:	48 8b 00             	mov    (%rax),%rax
ffff800000104c75:	48 89 c7             	mov    %rax,%rdi
ffff800000104c78:	8b 75 ec             	mov    -0x14(%rbp),%esi
ffff800000104c7b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff800000104c7e:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000104c81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104c85:	41 89 f1             	mov    %esi,%r9d
ffff800000104c88:	41 89 c8             	mov    %ecx,%r8d
ffff800000104c8b:	89 d1                	mov    %edx,%ecx
ffff800000104c8d:	ba 08 00 00 00       	mov    $0x8,%edx
ffff800000104c92:	48 89 fe             	mov    %rdi,%rsi
ffff800000104c95:	48 89 c7             	mov    %rax,%rdi
ffff800000104c98:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000104c9f:	80 ff ff 
ffff800000104ca2:	ff d0                	call   *%rax
ffff800000104ca4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000104ca8:	e9 18 06 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104cad:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104cb1:	8b 00                	mov    (%rax),%eax
ffff800000104cb3:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104cb6:	77 24                	ja     ffff800000104cdc <vsprintf+0x4dd>
ffff800000104cb8:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104cbc:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104cc0:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104cc4:	8b 00                	mov    (%rax),%eax
ffff800000104cc6:	89 c0                	mov    %eax,%eax
ffff800000104cc8:	48 01 d0             	add    %rdx,%rax
ffff800000104ccb:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104ccf:	8b 12                	mov    (%rdx),%edx
ffff800000104cd1:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104cd4:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104cd8:	89 0a                	mov    %ecx,(%rdx)
ffff800000104cda:	eb 14                	jmp    ffff800000104cf0 <vsprintf+0x4f1>
ffff800000104cdc:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104ce0:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104ce4:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104ce8:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104cec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104cf0:	8b 00                	mov    (%rax),%eax
ffff800000104cf2:	89 c7                	mov    %eax,%edi
ffff800000104cf4:	8b 75 ec             	mov    -0x14(%rbp),%esi
ffff800000104cf7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff800000104cfa:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000104cfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104d01:	41 89 f1             	mov    %esi,%r9d
ffff800000104d04:	41 89 c8             	mov    %ecx,%r8d
ffff800000104d07:	89 d1                	mov    %edx,%ecx
ffff800000104d09:	ba 08 00 00 00       	mov    $0x8,%edx
ffff800000104d0e:	48 89 fe             	mov    %rdi,%rsi
ffff800000104d11:	48 89 c7             	mov    %rax,%rdi
ffff800000104d14:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000104d1b:	80 ff ff 
ffff800000104d1e:	ff d0                	call   *%rax
ffff800000104d20:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000104d24:	e9 9c 05 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104d29:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%rbp)
ffff800000104d2d:	75 0b                	jne    ffff800000104d3a <vsprintf+0x53b>
ffff800000104d2f:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
ffff800000104d36:	83 4d ec 01          	orl    $0x1,-0x14(%rbp)
ffff800000104d3a:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104d3e:	8b 00                	mov    (%rax),%eax
ffff800000104d40:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104d43:	77 24                	ja     ffff800000104d69 <vsprintf+0x56a>
ffff800000104d45:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104d49:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104d4d:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104d51:	8b 00                	mov    (%rax),%eax
ffff800000104d53:	89 c0                	mov    %eax,%eax
ffff800000104d55:	48 01 d0             	add    %rdx,%rax
ffff800000104d58:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104d5c:	8b 12                	mov    (%rdx),%edx
ffff800000104d5e:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104d61:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104d65:	89 0a                	mov    %ecx,(%rdx)
ffff800000104d67:	eb 14                	jmp    ffff800000104d7d <vsprintf+0x57e>
ffff800000104d69:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104d6d:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104d71:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104d75:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104d79:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104d7d:	48 8b 00             	mov    (%rax),%rax
ffff800000104d80:	48 89 c7             	mov    %rax,%rdi
ffff800000104d83:	8b 75 ec             	mov    -0x14(%rbp),%esi
ffff800000104d86:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff800000104d89:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000104d8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104d90:	41 89 f1             	mov    %esi,%r9d
ffff800000104d93:	41 89 c8             	mov    %ecx,%r8d
ffff800000104d96:	89 d1                	mov    %edx,%ecx
ffff800000104d98:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000104d9d:	48 89 fe             	mov    %rdi,%rsi
ffff800000104da0:	48 89 c7             	mov    %rax,%rdi
ffff800000104da3:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000104daa:	80 ff ff 
ffff800000104dad:	ff d0                	call   *%rax
ffff800000104daf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000104db3:	e9 0d 05 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104db8:	83 4d ec 40          	orl    $0x40,-0x14(%rbp)
ffff800000104dbc:	83 7d d8 6c          	cmpl   $0x6c,-0x28(%rbp)
ffff800000104dc0:	75 7e                	jne    ffff800000104e40 <vsprintf+0x641>
ffff800000104dc2:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104dc6:	8b 00                	mov    (%rax),%eax
ffff800000104dc8:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104dcb:	77 24                	ja     ffff800000104df1 <vsprintf+0x5f2>
ffff800000104dcd:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104dd1:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104dd5:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104dd9:	8b 00                	mov    (%rax),%eax
ffff800000104ddb:	89 c0                	mov    %eax,%eax
ffff800000104ddd:	48 01 d0             	add    %rdx,%rax
ffff800000104de0:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104de4:	8b 12                	mov    (%rdx),%edx
ffff800000104de6:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104de9:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104ded:	89 0a                	mov    %ecx,(%rdx)
ffff800000104def:	eb 14                	jmp    ffff800000104e05 <vsprintf+0x606>
ffff800000104df1:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104df5:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104df9:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104dfd:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104e01:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104e05:	48 8b 00             	mov    (%rax),%rax
ffff800000104e08:	48 89 c7             	mov    %rax,%rdi
ffff800000104e0b:	8b 75 ec             	mov    -0x14(%rbp),%esi
ffff800000104e0e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff800000104e11:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000104e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104e18:	41 89 f1             	mov    %esi,%r9d
ffff800000104e1b:	41 89 c8             	mov    %ecx,%r8d
ffff800000104e1e:	89 d1                	mov    %edx,%ecx
ffff800000104e20:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000104e25:	48 89 fe             	mov    %rdi,%rsi
ffff800000104e28:	48 89 c7             	mov    %rax,%rdi
ffff800000104e2b:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000104e32:	80 ff ff 
ffff800000104e35:	ff d0                	call   *%rax
ffff800000104e37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000104e3b:	e9 85 04 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104e40:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104e44:	8b 00                	mov    (%rax),%eax
ffff800000104e46:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104e49:	77 24                	ja     ffff800000104e6f <vsprintf+0x670>
ffff800000104e4b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104e4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104e53:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104e57:	8b 00                	mov    (%rax),%eax
ffff800000104e59:	89 c0                	mov    %eax,%eax
ffff800000104e5b:	48 01 d0             	add    %rdx,%rax
ffff800000104e5e:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104e62:	8b 12                	mov    (%rdx),%edx
ffff800000104e64:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104e67:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104e6b:	89 0a                	mov    %ecx,(%rdx)
ffff800000104e6d:	eb 14                	jmp    ffff800000104e83 <vsprintf+0x684>
ffff800000104e6f:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104e73:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104e77:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104e7b:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104e7f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104e83:	8b 00                	mov    (%rax),%eax
ffff800000104e85:	89 c7                	mov    %eax,%edi
ffff800000104e87:	8b 75 ec             	mov    -0x14(%rbp),%esi
ffff800000104e8a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff800000104e8d:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000104e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104e94:	41 89 f1             	mov    %esi,%r9d
ffff800000104e97:	41 89 c8             	mov    %ecx,%r8d
ffff800000104e9a:	89 d1                	mov    %edx,%ecx
ffff800000104e9c:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000104ea1:	48 89 fe             	mov    %rdi,%rsi
ffff800000104ea4:	48 89 c7             	mov    %rax,%rdi
ffff800000104ea7:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000104eae:	80 ff ff 
ffff800000104eb1:	ff d0                	call   *%rax
ffff800000104eb3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000104eb7:	e9 09 04 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104ebc:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
ffff800000104ec0:	83 7d d8 6c          	cmpl   $0x6c,-0x28(%rbp)
ffff800000104ec4:	75 7e                	jne    ffff800000104f44 <vsprintf+0x745>
ffff800000104ec6:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104eca:	8b 00                	mov    (%rax),%eax
ffff800000104ecc:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104ecf:	77 24                	ja     ffff800000104ef5 <vsprintf+0x6f6>
ffff800000104ed1:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104ed5:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104ed9:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104edd:	8b 00                	mov    (%rax),%eax
ffff800000104edf:	89 c0                	mov    %eax,%eax
ffff800000104ee1:	48 01 d0             	add    %rdx,%rax
ffff800000104ee4:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104ee8:	8b 12                	mov    (%rdx),%edx
ffff800000104eea:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104eed:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104ef1:	89 0a                	mov    %ecx,(%rdx)
ffff800000104ef3:	eb 14                	jmp    ffff800000104f09 <vsprintf+0x70a>
ffff800000104ef5:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104ef9:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104efd:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104f01:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104f05:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104f09:	48 8b 00             	mov    (%rax),%rax
ffff800000104f0c:	48 89 c7             	mov    %rax,%rdi
ffff800000104f0f:	8b 75 ec             	mov    -0x14(%rbp),%esi
ffff800000104f12:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff800000104f15:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000104f18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104f1c:	41 89 f1             	mov    %esi,%r9d
ffff800000104f1f:	41 89 c8             	mov    %ecx,%r8d
ffff800000104f22:	89 d1                	mov    %edx,%ecx
ffff800000104f24:	ba 0a 00 00 00       	mov    $0xa,%edx
ffff800000104f29:	48 89 fe             	mov    %rdi,%rsi
ffff800000104f2c:	48 89 c7             	mov    %rax,%rdi
ffff800000104f2f:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000104f36:	80 ff ff 
ffff800000104f39:	ff d0                	call   *%rax
ffff800000104f3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000104f3f:	e9 81 03 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104f44:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104f48:	8b 00                	mov    (%rax),%eax
ffff800000104f4a:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104f4d:	77 24                	ja     ffff800000104f73 <vsprintf+0x774>
ffff800000104f4f:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104f53:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104f57:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104f5b:	8b 00                	mov    (%rax),%eax
ffff800000104f5d:	89 c0                	mov    %eax,%eax
ffff800000104f5f:	48 01 d0             	add    %rdx,%rax
ffff800000104f62:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104f66:	8b 12                	mov    (%rdx),%edx
ffff800000104f68:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104f6b:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104f6f:	89 0a                	mov    %ecx,(%rdx)
ffff800000104f71:	eb 14                	jmp    ffff800000104f87 <vsprintf+0x788>
ffff800000104f73:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104f77:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104f7b:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000104f7f:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104f83:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000104f87:	8b 00                	mov    (%rax),%eax
ffff800000104f89:	89 c7                	mov    %eax,%edi
ffff800000104f8b:	8b 75 ec             	mov    -0x14(%rbp),%esi
ffff800000104f8e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff800000104f91:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000104f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000104f98:	41 89 f1             	mov    %esi,%r9d
ffff800000104f9b:	41 89 c8             	mov    %ecx,%r8d
ffff800000104f9e:	89 d1                	mov    %edx,%ecx
ffff800000104fa0:	ba 0a 00 00 00       	mov    $0xa,%edx
ffff800000104fa5:	48 89 fe             	mov    %rdi,%rsi
ffff800000104fa8:	48 89 c7             	mov    %rax,%rdi
ffff800000104fab:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000104fb2:	80 ff ff 
ffff800000104fb5:	ff d0                	call   *%rax
ffff800000104fb7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000104fbb:	e9 05 03 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000104fc0:	83 7d d8 6c          	cmpl   $0x6c,-0x28(%rbp)
ffff800000104fc4:	75 61                	jne    ffff800000105027 <vsprintf+0x828>
ffff800000104fc6:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104fca:	8b 00                	mov    (%rax),%eax
ffff800000104fcc:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000104fcf:	77 24                	ja     ffff800000104ff5 <vsprintf+0x7f6>
ffff800000104fd1:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104fd5:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000104fd9:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104fdd:	8b 00                	mov    (%rax),%eax
ffff800000104fdf:	89 c0                	mov    %eax,%eax
ffff800000104fe1:	48 01 d0             	add    %rdx,%rax
ffff800000104fe4:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104fe8:	8b 12                	mov    (%rdx),%edx
ffff800000104fea:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff800000104fed:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000104ff1:	89 0a                	mov    %ecx,(%rdx)
ffff800000104ff3:	eb 14                	jmp    ffff800000105009 <vsprintf+0x80a>
ffff800000104ff5:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000104ff9:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff800000104ffd:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000105001:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000105005:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000105009:	48 8b 00             	mov    (%rax),%rax
ffff80000010500c:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
ffff800000105010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105014:	48 2b 45 98          	sub    -0x68(%rbp),%rax
ffff800000105018:	48 89 c2             	mov    %rax,%rdx
ffff80000010501b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
ffff80000010501f:	48 89 10             	mov    %rdx,(%rax)
ffff800000105022:	e9 9e 02 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000105027:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010502b:	8b 00                	mov    (%rax),%eax
ffff80000010502d:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000105030:	77 24                	ja     ffff800000105056 <vsprintf+0x857>
ffff800000105032:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000105036:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff80000010503a:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010503e:	8b 00                	mov    (%rax),%eax
ffff800000105040:	89 c0                	mov    %eax,%eax
ffff800000105042:	48 01 d0             	add    %rdx,%rax
ffff800000105045:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000105049:	8b 12                	mov    (%rdx),%edx
ffff80000010504b:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff80000010504e:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000105052:	89 0a                	mov    %ecx,(%rdx)
ffff800000105054:	eb 14                	jmp    ffff80000010506a <vsprintf+0x86b>
ffff800000105056:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010505a:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010505e:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000105062:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000105066:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff80000010506a:	48 8b 00             	mov    (%rax),%rax
ffff80000010506d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
ffff800000105071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105075:	48 2b 45 98          	sub    -0x68(%rbp),%rax
ffff800000105079:	89 c2                	mov    %eax,%edx
ffff80000010507b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff80000010507f:	89 10                	mov    %edx,(%rax)
ffff800000105081:	e9 3f 02 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000105086:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010508a:	8b 00                	mov    (%rax),%eax
ffff80000010508c:	83 f8 2f             	cmp    $0x2f,%eax
ffff80000010508f:	77 24                	ja     ffff8000001050b5 <vsprintf+0x8b6>
ffff800000105091:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000105095:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff800000105099:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010509d:	8b 00                	mov    (%rax),%eax
ffff80000010509f:	89 c0                	mov    %eax,%eax
ffff8000001050a1:	48 01 d0             	add    %rdx,%rax
ffff8000001050a4:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001050a8:	8b 12                	mov    (%rdx),%edx
ffff8000001050aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff8000001050ad:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001050b1:	89 0a                	mov    %ecx,(%rdx)
ffff8000001050b3:	eb 14                	jmp    ffff8000001050c9 <vsprintf+0x8ca>
ffff8000001050b5:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001050b9:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001050bd:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff8000001050c1:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001050c5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff8000001050c9:	48 8b 00             	mov    (%rax),%rax
ffff8000001050cc:	89 45 a8             	mov    %eax,-0x58(%rbp)
ffff8000001050cf:	8b 75 a8             	mov    -0x58(%rbp),%esi
ffff8000001050d2:	8b 7d ec             	mov    -0x14(%rbp),%edi
ffff8000001050d5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff8000001050d8:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff8000001050db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001050df:	41 89 f9             	mov    %edi,%r9d
ffff8000001050e2:	41 89 c8             	mov    %ecx,%r8d
ffff8000001050e5:	89 d1                	mov    %edx,%ecx
ffff8000001050e7:	ba 02 00 00 00       	mov    $0x2,%edx
ffff8000001050ec:	48 89 c7             	mov    %rax,%rdi
ffff8000001050ef:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff8000001050f6:	80 ff ff 
ffff8000001050f9:	ff d0                	call   *%rax
ffff8000001050fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001050ff:	e9 c1 01 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000105104:	83 4d ec 41          	orl    $0x41,-0x14(%rbp)
ffff800000105108:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010510c:	8b 00                	mov    (%rax),%eax
ffff80000010510e:	83 f8 2f             	cmp    $0x2f,%eax
ffff800000105111:	77 24                	ja     ffff800000105137 <vsprintf+0x938>
ffff800000105113:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff800000105117:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff80000010511b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010511f:	8b 00                	mov    (%rax),%eax
ffff800000105121:	89 c0                	mov    %eax,%eax
ffff800000105123:	48 01 d0             	add    %rdx,%rax
ffff800000105126:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff80000010512a:	8b 12                	mov    (%rdx),%edx
ffff80000010512c:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff80000010512f:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000105133:	89 0a                	mov    %ecx,(%rdx)
ffff800000105135:	eb 14                	jmp    ffff80000010514b <vsprintf+0x94c>
ffff800000105137:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff80000010513b:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010513f:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000105143:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000105147:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff80000010514b:	48 8b 00             	mov    (%rax),%rax
ffff80000010514e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff800000105152:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
ffff800000105159:	eb 55                	jmp    ffff8000001051b0 <vsprintf+0x9b1>
ffff80000010515b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010515f:	0f b6 00             	movzbl (%rax),%eax
ffff800000105162:	0f b6 c0             	movzbl %al,%eax
ffff800000105165:	89 45 ac             	mov    %eax,-0x54(%rbp)
ffff800000105168:	8b 45 ac             	mov    -0x54(%rbp),%eax
ffff80000010516b:	48 63 f0             	movslq %eax,%rsi
ffff80000010516e:	8b 4d ec             	mov    -0x14(%rbp),%ecx
ffff800000105171:	8b 55 e4             	mov    -0x1c(%rbp),%edx
ffff800000105174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105178:	41 89 c9             	mov    %ecx,%r9d
ffff80000010517b:	41 89 d0             	mov    %edx,%r8d
ffff80000010517e:	b9 02 00 00 00       	mov    $0x2,%ecx
ffff800000105183:	ba 10 00 00 00       	mov    $0x10,%edx
ffff800000105188:	48 89 c7             	mov    %rax,%rdi
ffff80000010518b:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff800000105192:	80 ff ff 
ffff800000105195:	ff d0                	call   *%rax
ffff800000105197:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010519b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010519f:	c6 00 3a             	movb   $0x3a,(%rax)
ffff8000001051a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff8000001051a7:	83 45 cc 01          	addl   $0x1,-0x34(%rbp)
ffff8000001051ab:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
ffff8000001051b0:	83 7d cc 05          	cmpl   $0x5,-0x34(%rbp)
ffff8000001051b4:	76 a5                	jbe    ffff80000010515b <vsprintf+0x95c>
ffff8000001051b6:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffff8000001051bb:	e9 05 01 00 00       	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff8000001051c0:	83 4d ec 40          	orl    $0x40,-0x14(%rbp)
ffff8000001051c4:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001051c8:	8b 00                	mov    (%rax),%eax
ffff8000001051ca:	83 f8 2f             	cmp    $0x2f,%eax
ffff8000001051cd:	77 24                	ja     ffff8000001051f3 <vsprintf+0x9f4>
ffff8000001051cf:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001051d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffff8000001051d7:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001051db:	8b 00                	mov    (%rax),%eax
ffff8000001051dd:	89 c0                	mov    %eax,%eax
ffff8000001051df:	48 01 d0             	add    %rdx,%rax
ffff8000001051e2:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001051e6:	8b 12                	mov    (%rdx),%edx
ffff8000001051e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
ffff8000001051eb:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff8000001051ef:	89 0a                	mov    %ecx,(%rdx)
ffff8000001051f1:	eb 14                	jmp    ffff800000105207 <vsprintf+0xa08>
ffff8000001051f3:	48 8b 45 88          	mov    -0x78(%rbp),%rax
ffff8000001051f7:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001051fb:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff8000001051ff:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
ffff800000105203:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
ffff800000105207:	48 8b 00             	mov    (%rax),%rax
ffff80000010520a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff80000010520e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%rbp)
ffff800000105215:	eb 52                	jmp    ffff800000105269 <vsprintf+0xa6a>
ffff800000105217:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010521b:	0f b6 00             	movzbl (%rax),%eax
ffff80000010521e:	0f b6 c0             	movzbl %al,%eax
ffff800000105221:	89 45 c4             	mov    %eax,-0x3c(%rbp)
ffff800000105224:	8b 75 c4             	mov    -0x3c(%rbp),%esi
ffff800000105227:	8b 7d ec             	mov    -0x14(%rbp),%edi
ffff80000010522a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
ffff80000010522d:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffff800000105230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105234:	41 89 f9             	mov    %edi,%r9d
ffff800000105237:	41 89 c8             	mov    %ecx,%r8d
ffff80000010523a:	89 d1                	mov    %edx,%ecx
ffff80000010523c:	ba 0a 00 00 00       	mov    $0xa,%edx
ffff800000105241:	48 89 c7             	mov    %rax,%rdi
ffff800000105244:	48 b8 1e 45 10 00 00 	movabs $0xffff80000010451e,%rax
ffff80000010524b:	80 ff ff 
ffff80000010524e:	ff d0                	call   *%rax
ffff800000105250:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105258:	c6 00 2e             	movb   $0x2e,(%rax)
ffff80000010525b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000105260:	83 45 c8 01          	addl   $0x1,-0x38(%rbp)
ffff800000105264:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
ffff800000105269:	83 7d c8 03          	cmpl   $0x3,-0x38(%rbp)
ffff80000010526d:	76 a8                	jbe    ffff800000105217 <vsprintf+0xa18>
ffff80000010526f:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffff800000105274:	eb 4f                	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000105276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010527a:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff80000010527e:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
ffff800000105282:	c6 00 25             	movb   $0x25,(%rax)
ffff800000105285:	eb 3e                	jmp    ffff8000001052c5 <vsprintf+0xac6>
ffff800000105287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010528b:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff80000010528f:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
ffff800000105293:	c6 00 25             	movb   $0x25,(%rax)
ffff800000105296:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff80000010529a:	0f b6 00             	movzbl (%rax),%eax
ffff80000010529d:	84 c0                	test   %al,%al
ffff80000010529f:	74 17                	je     ffff8000001052b8 <vsprintf+0xab9>
ffff8000001052a1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
ffff8000001052a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001052a9:	48 8d 48 01          	lea    0x1(%rax),%rcx
ffff8000001052ad:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
ffff8000001052b1:	0f b6 12             	movzbl (%rdx),%edx
ffff8000001052b4:	88 10                	mov    %dl,(%rax)
ffff8000001052b6:	eb 0c                	jmp    ffff8000001052c4 <vsprintf+0xac5>
ffff8000001052b8:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001052bc:	48 83 e8 01          	sub    $0x1,%rax
ffff8000001052c0:	48 89 45 90          	mov    %rax,-0x70(%rbp)
ffff8000001052c4:	90                   	nop
ffff8000001052c5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001052c9:	48 83 c0 01          	add    $0x1,%rax
ffff8000001052cd:	48 89 45 90          	mov    %rax,-0x70(%rbp)
ffff8000001052d1:	48 8b 45 90          	mov    -0x70(%rbp),%rax
ffff8000001052d5:	0f b6 00             	movzbl (%rax),%eax
ffff8000001052d8:	84 c0                	test   %al,%al
ffff8000001052da:	0f 85 44 f5 ff ff    	jne    ffff800000104824 <vsprintf+0x25>
ffff8000001052e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001052e4:	c6 00 00             	movb   $0x0,(%rax)
ffff8000001052e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001052eb:	48 2b 45 98          	sub    -0x68(%rbp),%rax
ffff8000001052ef:	c9                   	leave  
ffff8000001052f0:	c3                   	ret    

ffff8000001052f1 <sprintf>:
ffff8000001052f1:	f3 0f 1e fa          	endbr64 
ffff8000001052f5:	55                   	push   %rbp
ffff8000001052f6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001052f9:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
ffff800000105300:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
ffff800000105307:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
ffff80000010530e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
ffff800000105315:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff80000010531c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff800000105323:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff80000010532a:	84 c0                	test   %al,%al
ffff80000010532c:	74 20                	je     ffff80000010534e <sprintf+0x5d>
ffff80000010532e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff800000105332:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff800000105336:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff80000010533a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff80000010533e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff800000105342:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff800000105346:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff80000010534a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
ffff80000010534e:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff800000105355:	00 00 00 
ffff800000105358:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
ffff80000010535f:	00 00 00 
ffff800000105362:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
ffff800000105369:	00 00 00 
ffff80000010536c:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff800000105370:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
ffff800000105377:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff80000010537e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
ffff800000105385:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
ffff80000010538c:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
ffff800000105393:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffff80000010539a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010539d:	48 89 c7             	mov    %rax,%rdi
ffff8000001053a0:	48 b8 ff 47 10 00 00 	movabs $0xffff8000001047ff,%rax
ffff8000001053a7:	80 ff ff 
ffff8000001053aa:	ff d0                	call   *%rax
ffff8000001053ac:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
ffff8000001053b2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff8000001053b8:	c9                   	leave  
ffff8000001053b9:	c3                   	ret    

ffff8000001053ba <strlen>:
ffff8000001053ba:	f3 0f 1e fa          	endbr64 
ffff8000001053be:	55                   	push   %rbp
ffff8000001053bf:	48 89 e5             	mov    %rsp,%rbp
ffff8000001053c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001053c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001053cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff8000001053d4:	eb 04                	jmp    ffff8000001053da <strlen+0x20>
ffff8000001053d6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001053da:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001053dd:	48 63 d0             	movslq %eax,%rdx
ffff8000001053e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001053e4:	48 01 d0             	add    %rdx,%rax
ffff8000001053e7:	0f b6 00             	movzbl (%rax),%eax
ffff8000001053ea:	84 c0                	test   %al,%al
ffff8000001053ec:	75 e8                	jne    ffff8000001053d6 <strlen+0x1c>
ffff8000001053ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001053f1:	5d                   	pop    %rbp
ffff8000001053f2:	c3                   	ret    

ffff8000001053f3 <memcpy>:
ffff8000001053f3:	f3 0f 1e fa          	endbr64 
ffff8000001053f7:	55                   	push   %rbp
ffff8000001053f8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001053fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001053ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000105403:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff800000105407:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010540b:	48 8d 50 07          	lea    0x7(%rax),%rdx
ffff80000010540f:	48 85 c0             	test   %rax,%rax
ffff800000105412:	48 0f 48 c2          	cmovs  %rdx,%rax
ffff800000105416:	48 c1 f8 03          	sar    $0x3,%rax
ffff80000010541a:	48 89 c1             	mov    %rax,%rcx
ffff80000010541d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105421:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105425:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
ffff800000105429:	48 89 d7             	mov    %rdx,%rdi
ffff80000010542c:	fc                   	cld    
ffff80000010542d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
ffff800000105430:	a8 04                	test   $0x4,%al
ffff800000105432:	74 01                	je     ffff800000105435 <memcpy+0x42>
ffff800000105434:	a5                   	movsl  %ds:(%rsi),%es:(%rdi)
ffff800000105435:	a8 02                	test   $0x2,%al
ffff800000105437:	74 02                	je     ffff80000010543b <memcpy+0x48>
ffff800000105439:	66 a5                	movsw  %ds:(%rsi),%es:(%rdi)
ffff80000010543b:	a8 01                	test   $0x1,%al
ffff80000010543d:	74 01                	je     ffff800000105440 <memcpy+0x4d>
ffff80000010543f:	a4                   	movsb  %ds:(%rsi),%es:(%rdi)
ffff800000105440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105444:	5d                   	pop    %rbp
ffff800000105445:	c3                   	ret    

ffff800000105446 <memset>:
ffff800000105446:	f3 0f 1e fa          	endbr64 
ffff80000010544a:	55                   	push   %rbp
ffff80000010544b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010544e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105452:	89 f0                	mov    %esi,%eax
ffff800000105454:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffff800000105458:	88 45 e4             	mov    %al,-0x1c(%rbp)
ffff80000010545b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010545f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff80000010546a:	eb 13                	jmp    ffff80000010547f <memset+0x39>
ffff80000010546c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105470:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
ffff800000105474:	88 10                	mov    %dl,(%rax)
ffff800000105476:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff80000010547a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff80000010547f:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000105482:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
ffff800000105486:	7f e4                	jg     ffff80000010546c <memset+0x26>
ffff800000105488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010548c:	5d                   	pop    %rbp
ffff80000010548d:	c3                   	ret    

ffff80000010548e <assert_failure>:
ffff80000010548e:	f3 0f 1e fa          	endbr64 
ffff800000105492:	55                   	push   %rbp
ffff800000105493:	48 89 e5             	mov    %rsp,%rbp
ffff800000105496:	48 83 ec 30          	sub    $0x30,%rsp
ffff80000010549a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010549e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001054a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff8000001054a6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
ffff8000001054aa:	44 89 45 dc          	mov    %r8d,-0x24(%rbp)
ffff8000001054ae:	48 b8 f8 c7 10 00 00 	movabs $0xffff80000010c7f8,%rax
ffff8000001054b5:	80 ff ff 
ffff8000001054b8:	48 89 c2             	mov    %rax,%rdx
ffff8000001054bb:	48 b8 02 c8 10 00 00 	movabs $0xffff80000010c802,%rax
ffff8000001054c2:	80 ff ff 
ffff8000001054c5:	48 89 c6             	mov    %rax,%rsi
ffff8000001054c8:	48 b8 08 c8 10 00 00 	movabs $0xffff80000010c808,%rax
ffff8000001054cf:	80 ff ff 
ffff8000001054d2:	48 89 c7             	mov    %rax,%rdi
ffff8000001054d5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001054da:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001054e1:	80 ff ff 
ffff8000001054e4:	ff d1                	call   *%rcx
ffff8000001054e6:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
ffff8000001054ea:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffff8000001054ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001054f2:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffff8000001054f5:	52                   	push   %rdx
ffff8000001054f6:	ff 75 e0             	push   -0x20(%rbp)
ffff8000001054f9:	49 89 f1             	mov    %rsi,%r9
ffff8000001054fc:	49 89 c8             	mov    %rcx,%r8
ffff8000001054ff:	48 89 c1             	mov    %rax,%rcx
ffff800000105502:	48 b8 10 c8 10 00 00 	movabs $0xffff80000010c810,%rax
ffff800000105509:	80 ff ff 
ffff80000010550c:	48 89 c2             	mov    %rax,%rdx
ffff80000010550f:	48 b8 02 c8 10 00 00 	movabs $0xffff80000010c802,%rax
ffff800000105516:	80 ff ff 
ffff800000105519:	48 89 c6             	mov    %rax,%rsi
ffff80000010551c:	48 b8 08 c8 10 00 00 	movabs $0xffff80000010c808,%rax
ffff800000105523:	80 ff ff 
ffff800000105526:	48 89 c7             	mov    %rax,%rdi
ffff800000105529:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010552e:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000105535:	80 ff ff 
ffff800000105538:	41 ff d2             	call   *%r10
ffff80000010553b:	48 83 c4 10          	add    $0x10,%rsp
ffff80000010553f:	90                   	nop
ffff800000105540:	c9                   	leave  
ffff800000105541:	c3                   	ret    

ffff800000105542 <serial_send>:
ffff800000105542:	f3 0f 1e fa          	endbr64 
ffff800000105546:	55                   	push   %rbp
ffff800000105547:	48 89 e5             	mov    %rsp,%rbp
ffff80000010554a:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010554e:	89 f8                	mov    %edi,%eax
ffff800000105550:	88 45 fc             	mov    %al,-0x4(%rbp)
ffff800000105553:	90                   	nop
ffff800000105554:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff800000105559:	48 b8 d3 42 10 00 00 	movabs $0xffff8000001042d3,%rax
ffff800000105560:	80 ff ff 
ffff800000105563:	ff d0                	call   *%rax
ffff800000105565:	0f b6 c0             	movzbl %al,%eax
ffff800000105568:	83 e0 20             	and    $0x20,%eax
ffff80000010556b:	83 f8 20             	cmp    $0x20,%eax
ffff80000010556e:	75 e4                	jne    ffff800000105554 <serial_send+0x12>
ffff800000105570:	0f b6 45 fc          	movzbl -0x4(%rbp),%eax
ffff800000105574:	89 c6                	mov    %eax,%esi
ffff800000105576:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff80000010557b:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff800000105582:	80 ff ff 
ffff800000105585:	ff d0                	call   *%rax
ffff800000105587:	90                   	nop
ffff800000105588:	c9                   	leave  
ffff800000105589:	c3                   	ret    

ffff80000010558a <serial_recv>:
ffff80000010558a:	f3 0f 1e fa          	endbr64 
ffff80000010558e:	55                   	push   %rbp
ffff80000010558f:	48 89 e5             	mov    %rsp,%rbp
ffff800000105592:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000105596:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010559a:	90                   	nop
ffff80000010559b:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffff8000001055a0:	48 b8 d3 42 10 00 00 	movabs $0xffff8000001042d3,%rax
ffff8000001055a7:	80 ff ff 
ffff8000001055aa:	ff d0                	call   *%rax
ffff8000001055ac:	0f b6 c0             	movzbl %al,%eax
ffff8000001055af:	83 e0 01             	and    $0x1,%eax
ffff8000001055b2:	83 f8 01             	cmp    $0x1,%eax
ffff8000001055b5:	75 e4                	jne    ffff80000010559b <serial_recv+0x11>
ffff8000001055b7:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff8000001055bc:	48 b8 d3 42 10 00 00 	movabs $0xffff8000001042d3,%rax
ffff8000001055c3:	80 ff ff 
ffff8000001055c6:	ff d0                	call   *%rax
ffff8000001055c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff8000001055cc:	88 02                	mov    %al,(%rdx)
ffff8000001055ce:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001055d3:	c9                   	leave  
ffff8000001055d4:	c3                   	ret    

ffff8000001055d5 <serial_putchar>:
ffff8000001055d5:	f3 0f 1e fa          	endbr64 
ffff8000001055d9:	55                   	push   %rbp
ffff8000001055da:	48 89 e5             	mov    %rsp,%rbp
ffff8000001055dd:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001055e1:	89 f8                	mov    %edi,%eax
ffff8000001055e3:	88 45 fc             	mov    %al,-0x4(%rbp)
ffff8000001055e6:	80 7d fc 0a          	cmpb   $0xa,-0x4(%rbp)
ffff8000001055ea:	75 11                	jne    ffff8000001055fd <serial_putchar+0x28>
ffff8000001055ec:	bf 0d 00 00 00       	mov    $0xd,%edi
ffff8000001055f1:	48 b8 42 55 10 00 00 	movabs $0xffff800000105542,%rax
ffff8000001055f8:	80 ff ff 
ffff8000001055fb:	ff d0                	call   *%rax
ffff8000001055fd:	0f b6 45 fc          	movzbl -0x4(%rbp),%eax
ffff800000105601:	89 c7                	mov    %eax,%edi
ffff800000105603:	48 b8 42 55 10 00 00 	movabs $0xffff800000105542,%rax
ffff80000010560a:	80 ff ff 
ffff80000010560d:	ff d0                	call   *%rax
ffff80000010560f:	90                   	nop
ffff800000105610:	c9                   	leave  
ffff800000105611:	c3                   	ret    

ffff800000105612 <serial_string>:
ffff800000105612:	f3 0f 1e fa          	endbr64 
ffff800000105616:	55                   	push   %rbp
ffff800000105617:	48 89 e5             	mov    %rsp,%rbp
ffff80000010561a:	48 83 ec 20          	sub    $0x20,%rsp
ffff80000010561e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff800000105622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000105629:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffff80000010562e:	74 3c                	je     ffff80000010566c <serial_string+0x5a>
ffff800000105630:	eb 25                	jmp    ffff800000105657 <serial_string+0x45>
ffff800000105632:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000105635:	48 63 d0             	movslq %eax,%rdx
ffff800000105638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010563c:	48 01 d0             	add    %rdx,%rax
ffff80000010563f:	0f b6 00             	movzbl (%rax),%eax
ffff800000105642:	0f b6 c0             	movzbl %al,%eax
ffff800000105645:	89 c7                	mov    %eax,%edi
ffff800000105647:	48 b8 d5 55 10 00 00 	movabs $0xffff8000001055d5,%rax
ffff80000010564e:	80 ff ff 
ffff800000105651:	ff d0                	call   *%rax
ffff800000105653:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff800000105657:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010565a:	48 63 d0             	movslq %eax,%rdx
ffff80000010565d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105661:	48 01 d0             	add    %rdx,%rax
ffff800000105664:	0f b6 00             	movzbl (%rax),%eax
ffff800000105667:	84 c0                	test   %al,%al
ffff800000105669:	75 c7                	jne    ffff800000105632 <serial_string+0x20>
ffff80000010566b:	90                   	nop
ffff80000010566c:	90                   	nop
ffff80000010566d:	c9                   	leave  
ffff80000010566e:	c3                   	ret    

ffff80000010566f <serial_printf>:
ffff80000010566f:	f3 0f 1e fa          	endbr64 
ffff800000105673:	55                   	push   %rbp
ffff800000105674:	48 89 e5             	mov    %rsp,%rbp
ffff800000105677:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
ffff80000010567e:	48 89 bd 18 fd ff ff 	mov    %rdi,-0x2e8(%rbp)
ffff800000105685:	48 89 b5 10 fd ff ff 	mov    %rsi,-0x2f0(%rbp)
ffff80000010568c:	48 89 95 08 fd ff ff 	mov    %rdx,-0x2f8(%rbp)
ffff800000105693:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff80000010569a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff8000001056a1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff8000001056a8:	84 c0                	test   %al,%al
ffff8000001056aa:	74 20                	je     ffff8000001056cc <serial_printf+0x5d>
ffff8000001056ac:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff8000001056b0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff8000001056b4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff8000001056b8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff8000001056bc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff8000001056c0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff8000001056c4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff8000001056c8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
ffff8000001056cc:	48 c7 85 40 fd ff ff 	movq   $0x0,-0x2c0(%rbp)
ffff8000001056d3:	00 00 00 00 
ffff8000001056d7:	48 c7 85 48 fd ff ff 	movq   $0x0,-0x2b8(%rbp)
ffff8000001056de:	00 00 00 00 
ffff8000001056e2:	48 8d 95 50 fd ff ff 	lea    -0x2b0(%rbp),%rdx
ffff8000001056e9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001056ee:	b9 3e 00 00 00       	mov    $0x3e,%ecx
ffff8000001056f3:	48 89 d7             	mov    %rdx,%rdi
ffff8000001056f6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
ffff8000001056f9:	48 c7 85 48 ff ff ff 	movq   $0x0,-0xb8(%rbp)
ffff800000105700:	00 00 00 00 
ffff800000105704:	c7 85 44 ff ff ff 00 	movl   $0x0,-0xbc(%rbp)
ffff80000010570b:	00 00 00 
ffff80000010570e:	c7 85 28 fd ff ff 18 	movl   $0x18,-0x2d8(%rbp)
ffff800000105715:	00 00 00 
ffff800000105718:	c7 85 2c fd ff ff 30 	movl   $0x30,-0x2d4(%rbp)
ffff80000010571f:	00 00 00 
ffff800000105722:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff800000105726:	48 89 85 30 fd ff ff 	mov    %rax,-0x2d0(%rbp)
ffff80000010572d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff800000105734:	48 89 85 38 fd ff ff 	mov    %rax,-0x2c8(%rbp)
ffff80000010573b:	48 8d 95 28 fd ff ff 	lea    -0x2d8(%rbp),%rdx
ffff800000105742:	48 8b 8d 08 fd ff ff 	mov    -0x2f8(%rbp),%rcx
ffff800000105749:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
ffff800000105750:	48 89 ce             	mov    %rcx,%rsi
ffff800000105753:	48 89 c7             	mov    %rax,%rdi
ffff800000105756:	48 b8 ff 47 10 00 00 	movabs $0xffff8000001047ff,%rax
ffff80000010575d:	80 ff ff 
ffff800000105760:	ff d0                	call   *%rax
ffff800000105762:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%rbp)
ffff800000105768:	48 8b 85 18 fd ff ff 	mov    -0x2e8(%rbp),%rax
ffff80000010576f:	48 89 c7             	mov    %rax,%rdi
ffff800000105772:	48 b8 12 56 10 00 00 	movabs $0xffff800000105612,%rax
ffff800000105779:	80 ff ff 
ffff80000010577c:	ff d0                	call   *%rax
ffff80000010577e:	48 8b 85 10 fd ff ff 	mov    -0x2f0(%rbp),%rax
ffff800000105785:	48 89 c7             	mov    %rax,%rdi
ffff800000105788:	48 b8 12 56 10 00 00 	movabs $0xffff800000105612,%rax
ffff80000010578f:	80 ff ff 
ffff800000105792:	ff d0                	call   *%rax
ffff800000105794:	48 8d 85 40 fd ff ff 	lea    -0x2c0(%rbp),%rax
ffff80000010579b:	48 89 c7             	mov    %rax,%rdi
ffff80000010579e:	48 b8 12 56 10 00 00 	movabs $0xffff800000105612,%rax
ffff8000001057a5:	80 ff ff 
ffff8000001057a8:	ff d0                	call   *%rax
ffff8000001057aa:	48 b8 3e c8 10 00 00 	movabs $0xffff80000010c83e,%rax
ffff8000001057b1:	80 ff ff 
ffff8000001057b4:	48 89 c7             	mov    %rax,%rdi
ffff8000001057b7:	48 b8 12 56 10 00 00 	movabs $0xffff800000105612,%rax
ffff8000001057be:	80 ff ff 
ffff8000001057c1:	ff d0                	call   *%rax
ffff8000001057c3:	8b 85 44 ff ff ff    	mov    -0xbc(%rbp),%eax
ffff8000001057c9:	c9                   	leave  
ffff8000001057ca:	c3                   	ret    

ffff8000001057cb <serial_init>:
ffff8000001057cb:	f3 0f 1e fa          	endbr64 
ffff8000001057cf:	55                   	push   %rbp
ffff8000001057d0:	48 89 e5             	mov    %rsp,%rbp
ffff8000001057d3:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001057d8:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff8000001057dd:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff8000001057e4:	80 ff ff 
ffff8000001057e7:	ff d0                	call   *%rax
ffff8000001057e9:	be 80 00 00 00       	mov    $0x80,%esi
ffff8000001057ee:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff8000001057f3:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff8000001057fa:	80 ff ff 
ffff8000001057fd:	ff d0                	call   *%rax
ffff8000001057ff:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000105804:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffff800000105809:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff800000105810:	80 ff ff 
ffff800000105813:	ff d0                	call   *%rax
ffff800000105815:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010581a:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff80000010581f:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff800000105826:	80 ff ff 
ffff800000105829:	ff d0                	call   *%rax
ffff80000010582b:	be 03 00 00 00       	mov    $0x3,%esi
ffff800000105830:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffff800000105835:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff80000010583c:	80 ff ff 
ffff80000010583f:	ff d0                	call   *%rax
ffff800000105841:	be 07 00 00 00       	mov    $0x7,%esi
ffff800000105846:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffff80000010584b:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff800000105852:	80 ff ff 
ffff800000105855:	ff d0                	call   *%rax
ffff800000105857:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010585c:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffff800000105861:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff800000105868:	80 ff ff 
ffff80000010586b:	ff d0                	call   *%rax
ffff80000010586d:	be 0b 00 00 00       	mov    $0xb,%esi
ffff800000105872:	bf fc 03 00 00       	mov    $0x3fc,%edi
ffff800000105877:	48 b8 1f 43 10 00 00 	movabs $0xffff80000010431f,%rax
ffff80000010587e:	80 ff ff 
ffff800000105881:	ff d0                	call   *%rax
ffff800000105883:	90                   	nop
ffff800000105884:	5d                   	pop    %rbp
ffff800000105885:	c3                   	ret    

ffff800000105886 <vbe_init>:
ffff800000105886:	f3 0f 1e fa          	endbr64 
ffff80000010588a:	55                   	push   %rbp
ffff80000010588b:	48 89 e5             	mov    %rsp,%rbp
ffff80000010588e:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000105892:	48 b8 00 00 00 03 00 	movabs $0xffff800003000000,%rax
ffff800000105899:	80 ff ff 
ffff80000010589c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001058a0:	48 b8 e0 ad 10 00 00 	movabs $0xffff80000010ade0,%rax
ffff8000001058a7:	80 ff ff 
ffff8000001058aa:	48 8b 00             	mov    (%rax),%rax
ffff8000001058ad:	8b 00                	mov    (%rax),%eax
ffff8000001058af:	89 c2                	mov    %eax,%edx
ffff8000001058b1:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff8000001058b8:	80 ff ff 
ffff8000001058bb:	89 10                	mov    %edx,(%rax)
ffff8000001058bd:	48 b8 e0 ad 10 00 00 	movabs $0xffff80000010ade0,%rax
ffff8000001058c4:	80 ff ff 
ffff8000001058c7:	48 8b 00             	mov    (%rax),%rax
ffff8000001058ca:	8b 40 04             	mov    0x4(%rax),%eax
ffff8000001058cd:	89 c2                	mov    %eax,%edx
ffff8000001058cf:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff8000001058d6:	80 ff ff 
ffff8000001058d9:	89 50 04             	mov    %edx,0x4(%rax)
ffff8000001058dc:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff8000001058e3:	80 ff ff 
ffff8000001058e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
ffff8000001058ed:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff8000001058f4:	80 ff ff 
ffff8000001058f7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%rax)
ffff8000001058fe:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105905:	80 ff ff 
ffff800000105908:	c7 40 10 08 00 00 00 	movl   $0x8,0x10(%rax)
ffff80000010590f:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105916:	80 ff ff 
ffff800000105919:	c7 40 14 10 00 00 00 	movl   $0x10,0x14(%rax)
ffff800000105920:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff800000105927:	80 ff ff 
ffff80000010592a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010592e:	48 89 42 18          	mov    %rax,0x18(%rdx)
ffff800000105932:	48 b8 e0 ad 10 00 00 	movabs $0xffff80000010ade0,%rax
ffff800000105939:	80 ff ff 
ffff80000010593c:	48 8b 00             	mov    (%rax),%rax
ffff80000010593f:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000105943:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff80000010594a:	80 ff ff 
ffff80000010594d:	48 89 42 20          	mov    %rax,0x20(%rdx)
ffff800000105951:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105958:	80 ff ff 
ffff80000010595b:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff80000010595f:	48 89 c2             	mov    %rax,%rdx
ffff800000105962:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105969:	80 ff ff 
ffff80000010596c:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000105970:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000105975:	48 89 c7             	mov    %rax,%rdi
ffff800000105978:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff80000010597f:	80 ff ff 
ffff800000105982:	ff d0                	call   *%rax
ffff800000105984:	90                   	nop
ffff800000105985:	c9                   	leave  
ffff800000105986:	c3                   	ret    

ffff800000105987 <vbe_putchar>:
ffff800000105987:	f3 0f 1e fa          	endbr64 
ffff80000010598b:	55                   	push   %rbp
ffff80000010598c:	48 89 e5             	mov    %rsp,%rbp
ffff80000010598f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffff800000105993:	89 75 d4             	mov    %esi,-0x2c(%rbp)
ffff800000105996:	89 55 d0             	mov    %edx,-0x30(%rbp)
ffff800000105999:	89 4d cc             	mov    %ecx,-0x34(%rbp)
ffff80000010599c:	44 89 45 c8          	mov    %r8d,-0x38(%rbp)
ffff8000001059a0:	44 89 4d c4          	mov    %r9d,-0x3c(%rbp)
ffff8000001059a4:	8b 45 10             	mov    0x10(%rbp),%eax
ffff8000001059a7:	88 45 c0             	mov    %al,-0x40(%rbp)
ffff8000001059aa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff8000001059b1:	00 
ffff8000001059b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff8000001059b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffff8000001059c0:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
ffff8000001059c7:	00 
ffff8000001059c8:	0f b6 45 c0          	movzbl -0x40(%rbp),%eax
ffff8000001059cc:	48 98                	cltq   
ffff8000001059ce:	48 c1 e0 04          	shl    $0x4,%rax
ffff8000001059d2:	48 89 c2             	mov    %rax,%rdx
ffff8000001059d5:	48 b8 e0 9d 10 00 00 	movabs $0xffff800000109de0,%rax
ffff8000001059dc:	80 ff ff 
ffff8000001059df:	48 01 d0             	add    %rdx,%rax
ffff8000001059e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff8000001059e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffff8000001059ed:	eb 7d                	jmp    ffff800000105a6c <vbe_putchar+0xe5>
ffff8000001059ef:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffff8000001059f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff8000001059f5:	01 d0                	add    %edx,%eax
ffff8000001059f7:	0f af 45 d4          	imul   -0x2c(%rbp),%eax
ffff8000001059fb:	48 63 d0             	movslq %eax,%rdx
ffff8000001059fe:	8b 45 d0             	mov    -0x30(%rbp),%eax
ffff800000105a01:	48 98                	cltq   
ffff800000105a03:	48 01 d0             	add    %rdx,%rax
ffff800000105a06:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffff800000105a0d:	00 
ffff800000105a0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000105a12:	48 01 d0             	add    %rdx,%rax
ffff800000105a15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105a19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffff800000105a20:	eb 3b                	jmp    ffff800000105a5d <vbe_putchar+0xd6>
ffff800000105a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105a26:	0f b6 00             	movzbl (%rax),%eax
ffff800000105a29:	0f b6 d0             	movzbl %al,%edx
ffff800000105a2c:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffff800000105a2f:	be 80 00 00 00       	mov    $0x80,%esi
ffff800000105a34:	89 c1                	mov    %eax,%ecx
ffff800000105a36:	d3 fe                	sar    %cl,%esi
ffff800000105a38:	89 f0                	mov    %esi,%eax
ffff800000105a3a:	21 d0                	and    %edx,%eax
ffff800000105a3c:	85 c0                	test   %eax,%eax
ffff800000105a3e:	74 0b                	je     ffff800000105a4b <vbe_putchar+0xc4>
ffff800000105a40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a44:	8b 55 c8             	mov    -0x38(%rbp),%edx
ffff800000105a47:	89 10                	mov    %edx,(%rax)
ffff800000105a49:	eb 09                	jmp    ffff800000105a54 <vbe_putchar+0xcd>
ffff800000105a4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105a4f:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffff800000105a52:	89 10                	mov    %edx,(%rax)
ffff800000105a54:	48 83 45 f8 04       	addq   $0x4,-0x8(%rbp)
ffff800000105a59:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
ffff800000105a5d:	83 7d f0 07          	cmpl   $0x7,-0x10(%rbp)
ffff800000105a61:	7e bf                	jle    ffff800000105a22 <vbe_putchar+0x9b>
ffff800000105a63:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
ffff800000105a68:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffff800000105a6c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
ffff800000105a70:	0f 8e 79 ff ff ff    	jle    ffff8000001059ef <vbe_putchar+0x68>
ffff800000105a76:	90                   	nop
ffff800000105a77:	5d                   	pop    %rbp
ffff800000105a78:	c3                   	ret    

ffff800000105a79 <roll_screen>:
ffff800000105a79:	f3 0f 1e fa          	endbr64 
ffff800000105a7d:	55                   	push   %rbp
ffff800000105a7e:	48 89 e5             	mov    %rsp,%rbp
ffff800000105a81:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105a88:	80 ff ff 
ffff800000105a8b:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000105a8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000105a93:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105a9a:	80 ff ff 
ffff800000105a9d:	8b 10                	mov    (%rax),%edx
ffff800000105a9f:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105aa6:	80 ff ff 
ffff800000105aa9:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000105aac:	0f af c2             	imul   %edx,%eax
ffff800000105aaf:	c1 e0 02             	shl    $0x2,%eax
ffff800000105ab2:	48 63 d0             	movslq %eax,%rdx
ffff800000105ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105ab9:	48 01 d0             	add    %rdx,%rax
ffff800000105abc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105ac0:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ac7:	80 ff ff 
ffff800000105aca:	48 8b 70 18          	mov    0x18(%rax),%rsi
ffff800000105ace:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ad5:	80 ff ff 
ffff800000105ad8:	8b 08                	mov    (%rax),%ecx
ffff800000105ada:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ae1:	80 ff ff 
ffff800000105ae4:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105ae7:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff800000105aee:	80 ff ff 
ffff800000105af1:	8b 7a 14             	mov    0x14(%rdx),%edi
ffff800000105af4:	99                   	cltd   
ffff800000105af5:	f7 ff                	idiv   %edi
ffff800000105af7:	83 e8 01             	sub    $0x1,%eax
ffff800000105afa:	0f af c8             	imul   %eax,%ecx
ffff800000105afd:	89 ca                	mov    %ecx,%edx
ffff800000105aff:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105b06:	80 ff ff 
ffff800000105b09:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000105b0c:	0f af c2             	imul   %edx,%eax
ffff800000105b0f:	c1 e0 02             	shl    $0x2,%eax
ffff800000105b12:	48 98                	cltq   
ffff800000105b14:	48 01 f0             	add    %rsi,%rax
ffff800000105b17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff800000105b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105b1f:	48 2b 45 f0          	sub    -0x10(%rbp),%rax
ffff800000105b23:	89 45 e4             	mov    %eax,-0x1c(%rbp)
ffff800000105b26:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105b2d:	80 ff ff 
ffff800000105b30:	48 8b 50 18          	mov    0x18(%rax),%rdx
ffff800000105b34:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105b3b:	80 ff ff 
ffff800000105b3e:	48 8b 40 20          	mov    0x20(%rax),%rax
ffff800000105b42:	48 01 d0             	add    %rdx,%rax
ffff800000105b45:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff800000105b49:	c6 45 d7 00          	movb   $0x0,-0x29(%rbp)
ffff800000105b4d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000105b50:	8d 50 07             	lea    0x7(%rax),%edx
ffff800000105b53:	85 c0                	test   %eax,%eax
ffff800000105b55:	0f 48 c2             	cmovs  %edx,%eax
ffff800000105b58:	c1 f8 03             	sar    $0x3,%eax
ffff800000105b5b:	89 c1                	mov    %eax,%ecx
ffff800000105b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000105b61:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff800000105b65:	48 89 c7             	mov    %rax,%rdi
ffff800000105b68:	48 89 d6             	mov    %rdx,%rsi
ffff800000105b6b:	fc                   	cld    
ffff800000105b6c:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
ffff800000105b6f:	0f ae f0             	mfence 
ffff800000105b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000105b76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff800000105b7a:	eb 0c                	jmp    ffff800000105b88 <roll_screen+0x10f>
ffff800000105b7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b80:	c6 00 00             	movb   $0x0,(%rax)
ffff800000105b83:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff800000105b88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000105b8c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff800000105b90:	72 ea                	jb     ffff800000105b7c <roll_screen+0x103>
ffff800000105b92:	0f ae f0             	mfence 
ffff800000105b95:	90                   	nop
ffff800000105b96:	5d                   	pop    %rbp
ffff800000105b97:	c3                   	ret    

ffff800000105b98 <color_printk>:
ffff800000105b98:	f3 0f 1e fa          	endbr64 
ffff800000105b9c:	55                   	push   %rbp
ffff800000105b9d:	48 89 e5             	mov    %rsp,%rbp
ffff800000105ba0:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
ffff800000105ba7:	89 bd 0c ff ff ff    	mov    %edi,-0xf4(%rbp)
ffff800000105bad:	89 b5 08 ff ff ff    	mov    %esi,-0xf8(%rbp)
ffff800000105bb3:	48 89 95 00 ff ff ff 	mov    %rdx,-0x100(%rbp)
ffff800000105bba:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffff800000105bc1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffff800000105bc8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffff800000105bcf:	84 c0                	test   %al,%al
ffff800000105bd1:	74 20                	je     ffff800000105bf3 <color_printk+0x5b>
ffff800000105bd3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffff800000105bd7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffff800000105bdb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffff800000105bdf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffff800000105be3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffff800000105be7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffff800000105beb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffff800000105bef:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
ffff800000105bf3:	c7 85 44 ff ff ff 00 	movl   $0x0,-0xbc(%rbp)
ffff800000105bfa:	00 00 00 
ffff800000105bfd:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff800000105c04:	00 00 00 
ffff800000105c07:	c7 85 48 ff ff ff 00 	movl   $0x0,-0xb8(%rbp)
ffff800000105c0e:	00 00 00 
ffff800000105c11:	48 c7 85 38 ff ff ff 	movq   $0x0,-0xc8(%rbp)
ffff800000105c18:	00 00 00 00 
ffff800000105c1c:	c7 85 18 ff ff ff 18 	movl   $0x18,-0xe8(%rbp)
ffff800000105c23:	00 00 00 
ffff800000105c26:	c7 85 1c ff ff ff 30 	movl   $0x30,-0xe4(%rbp)
ffff800000105c2d:	00 00 00 
ffff800000105c30:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffff800000105c34:	48 89 85 20 ff ff ff 	mov    %rax,-0xe0(%rbp)
ffff800000105c3b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffff800000105c42:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
ffff800000105c49:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
ffff800000105c50:	48 8b 85 00 ff ff ff 	mov    -0x100(%rbp),%rax
ffff800000105c57:	48 89 c6             	mov    %rax,%rsi
ffff800000105c5a:	48 b8 c0 db 10 00 00 	movabs $0xffff80000010dbc0,%rax
ffff800000105c61:	80 ff ff 
ffff800000105c64:	48 89 c7             	mov    %rax,%rdi
ffff800000105c67:	48 b8 ff 47 10 00 00 	movabs $0xffff8000001047ff,%rax
ffff800000105c6e:	80 ff ff 
ffff800000105c71:	ff d0                	call   *%rax
ffff800000105c73:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%rbp)
ffff800000105c79:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffff800000105c80:	00 00 00 
ffff800000105c83:	e9 52 04 00 00       	jmp    ffff8000001060da <color_printk+0x542>
ffff800000105c88:	83 bd 48 ff ff ff 00 	cmpl   $0x0,-0xb8(%rbp)
ffff800000105c8f:	7e 0c                	jle    ffff800000105c9d <color_printk+0x105>
ffff800000105c91:	83 ad 4c ff ff ff 01 	subl   $0x1,-0xb4(%rbp)
ffff800000105c98:	e9 1b 02 00 00       	jmp    ffff800000105eb8 <color_printk+0x320>
ffff800000105c9d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000105ca3:	48 98                	cltq   
ffff800000105ca5:	48 ba c0 db 10 00 00 	movabs $0xffff80000010dbc0,%rdx
ffff800000105cac:	80 ff ff 
ffff800000105caf:	48 01 d0             	add    %rdx,%rax
ffff800000105cb2:	0f b6 00             	movzbl (%rax),%eax
ffff800000105cb5:	3c 0a                	cmp    $0xa,%al
ffff800000105cb7:	75 33                	jne    ffff800000105cec <color_printk+0x154>
ffff800000105cb9:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105cc0:	80 ff ff 
ffff800000105cc3:	8b 40 0c             	mov    0xc(%rax),%eax
ffff800000105cc6:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105cc9:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105cd0:	80 ff ff 
ffff800000105cd3:	89 50 0c             	mov    %edx,0xc(%rax)
ffff800000105cd6:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105cdd:	80 ff ff 
ffff800000105ce0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
ffff800000105ce7:	e9 35 03 00 00       	jmp    ffff800000106021 <color_printk+0x489>
ffff800000105cec:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000105cf2:	48 98                	cltq   
ffff800000105cf4:	48 ba c0 db 10 00 00 	movabs $0xffff80000010dbc0,%rdx
ffff800000105cfb:	80 ff ff 
ffff800000105cfe:	48 01 d0             	add    %rdx,%rax
ffff800000105d01:	0f b6 00             	movzbl (%rax),%eax
ffff800000105d04:	3c 08                	cmp    $0x8,%al
ffff800000105d06:	0f 85 60 01 00 00    	jne    ffff800000105e6c <color_printk+0x2d4>
ffff800000105d0c:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d13:	80 ff ff 
ffff800000105d16:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000105d19:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000105d1c:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d23:	80 ff ff 
ffff800000105d26:	89 50 08             	mov    %edx,0x8(%rax)
ffff800000105d29:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d30:	80 ff ff 
ffff800000105d33:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000105d36:	85 c0                	test   %eax,%eax
ffff800000105d38:	0f 89 a7 00 00 00    	jns    ffff800000105de5 <color_printk+0x24d>
ffff800000105d3e:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d45:	80 ff ff 
ffff800000105d48:	8b 00                	mov    (%rax),%eax
ffff800000105d4a:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff800000105d51:	80 ff ff 
ffff800000105d54:	8b 72 10             	mov    0x10(%rdx),%esi
ffff800000105d57:	99                   	cltd   
ffff800000105d58:	f7 fe                	idiv   %esi
ffff800000105d5a:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000105d5d:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d64:	80 ff ff 
ffff800000105d67:	8b 40 10             	mov    0x10(%rax),%eax
ffff800000105d6a:	0f af c2             	imul   %edx,%eax
ffff800000105d6d:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff800000105d74:	80 ff ff 
ffff800000105d77:	89 42 08             	mov    %eax,0x8(%rdx)
ffff800000105d7a:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d81:	80 ff ff 
ffff800000105d84:	8b 40 0c             	mov    0xc(%rax),%eax
ffff800000105d87:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000105d8a:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d91:	80 ff ff 
ffff800000105d94:	89 50 0c             	mov    %edx,0xc(%rax)
ffff800000105d97:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105d9e:	80 ff ff 
ffff800000105da1:	8b 40 0c             	mov    0xc(%rax),%eax
ffff800000105da4:	85 c0                	test   %eax,%eax
ffff800000105da6:	79 3d                	jns    ffff800000105de5 <color_printk+0x24d>
ffff800000105da8:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105daf:	80 ff ff 
ffff800000105db2:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000105db5:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff800000105dbc:	80 ff ff 
ffff800000105dbf:	8b 7a 14             	mov    0x14(%rdx),%edi
ffff800000105dc2:	99                   	cltd   
ffff800000105dc3:	f7 ff                	idiv   %edi
ffff800000105dc5:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff800000105dc8:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105dcf:	80 ff ff 
ffff800000105dd2:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000105dd5:	0f af c2             	imul   %edx,%eax
ffff800000105dd8:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff800000105ddf:	80 ff ff 
ffff800000105de2:	89 42 0c             	mov    %eax,0xc(%rdx)
ffff800000105de5:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105dec:	80 ff ff 
ffff800000105def:	8b 50 0c             	mov    0xc(%rax),%edx
ffff800000105df2:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105df9:	80 ff ff 
ffff800000105dfc:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000105dff:	89 d1                	mov    %edx,%ecx
ffff800000105e01:	0f af c8             	imul   %eax,%ecx
ffff800000105e04:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105e0b:	80 ff ff 
ffff800000105e0e:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000105e11:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105e18:	80 ff ff 
ffff800000105e1b:	8b 40 10             	mov    0x10(%rax),%eax
ffff800000105e1e:	0f af d0             	imul   %eax,%edx
ffff800000105e21:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105e28:	80 ff ff 
ffff800000105e2b:	8b 30                	mov    (%rax),%esi
ffff800000105e2d:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105e34:	80 ff ff 
ffff800000105e37:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000105e3b:	44 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%r8d
ffff800000105e42:	8b bd 0c ff ff ff    	mov    -0xf4(%rbp),%edi
ffff800000105e48:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105e4c:	6a 20                	push   $0x20
ffff800000105e4e:	45 89 c1             	mov    %r8d,%r9d
ffff800000105e51:	41 89 f8             	mov    %edi,%r8d
ffff800000105e54:	48 89 c7             	mov    %rax,%rdi
ffff800000105e57:	48 b8 87 59 10 00 00 	movabs $0xffff800000105987,%rax
ffff800000105e5e:	80 ff ff 
ffff800000105e61:	ff d0                	call   *%rax
ffff800000105e63:	48 83 c4 10          	add    $0x10,%rsp
ffff800000105e67:	e9 b5 01 00 00       	jmp    ffff800000106021 <color_printk+0x489>
ffff800000105e6c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000105e72:	48 98                	cltq   
ffff800000105e74:	48 ba c0 db 10 00 00 	movabs $0xffff80000010dbc0,%rdx
ffff800000105e7b:	80 ff ff 
ffff800000105e7e:	48 01 d0             	add    %rdx,%rax
ffff800000105e81:	0f b6 00             	movzbl (%rax),%eax
ffff800000105e84:	3c 09                	cmp    $0x9,%al
ffff800000105e86:	0f 85 d7 00 00 00    	jne    ffff800000105f63 <color_printk+0x3cb>
ffff800000105e8c:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105e93:	80 ff ff 
ffff800000105e96:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000105e99:	83 c0 08             	add    $0x8,%eax
ffff800000105e9c:	83 e0 f8             	and    $0xfffffff8,%eax
ffff800000105e9f:	89 c2                	mov    %eax,%edx
ffff800000105ea1:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ea8:	80 ff ff 
ffff800000105eab:	8b 48 08             	mov    0x8(%rax),%ecx
ffff800000105eae:	89 d0                	mov    %edx,%eax
ffff800000105eb0:	29 c8                	sub    %ecx,%eax
ffff800000105eb2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%rbp)
ffff800000105eb8:	83 ad 48 ff ff ff 01 	subl   $0x1,-0xb8(%rbp)
ffff800000105ebf:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ec6:	80 ff ff 
ffff800000105ec9:	8b 50 0c             	mov    0xc(%rax),%edx
ffff800000105ecc:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ed3:	80 ff ff 
ffff800000105ed6:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000105ed9:	89 d1                	mov    %edx,%ecx
ffff800000105edb:	0f af c8             	imul   %eax,%ecx
ffff800000105ede:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ee5:	80 ff ff 
ffff800000105ee8:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000105eeb:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105ef2:	80 ff ff 
ffff800000105ef5:	8b 40 10             	mov    0x10(%rax),%eax
ffff800000105ef8:	0f af d0             	imul   %eax,%edx
ffff800000105efb:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105f02:	80 ff ff 
ffff800000105f05:	8b 30                	mov    (%rax),%esi
ffff800000105f07:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105f0e:	80 ff ff 
ffff800000105f11:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000105f15:	44 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%r8d
ffff800000105f1c:	8b bd 0c ff ff ff    	mov    -0xf4(%rbp),%edi
ffff800000105f22:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105f26:	6a 20                	push   $0x20
ffff800000105f28:	45 89 c1             	mov    %r8d,%r9d
ffff800000105f2b:	41 89 f8             	mov    %edi,%r8d
ffff800000105f2e:	48 89 c7             	mov    %rax,%rdi
ffff800000105f31:	48 b8 87 59 10 00 00 	movabs $0xffff800000105987,%rax
ffff800000105f38:	80 ff ff 
ffff800000105f3b:	ff d0                	call   *%rax
ffff800000105f3d:	48 83 c4 10          	add    $0x10,%rsp
ffff800000105f41:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105f48:	80 ff ff 
ffff800000105f4b:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000105f4e:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000105f51:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105f58:	80 ff ff 
ffff800000105f5b:	89 50 08             	mov    %edx,0x8(%rax)
ffff800000105f5e:	e9 be 00 00 00       	jmp    ffff800000106021 <color_printk+0x489>
ffff800000105f63:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff800000105f69:	48 98                	cltq   
ffff800000105f6b:	48 ba c0 db 10 00 00 	movabs $0xffff80000010dbc0,%rdx
ffff800000105f72:	80 ff ff 
ffff800000105f75:	48 01 d0             	add    %rdx,%rax
ffff800000105f78:	0f b6 00             	movzbl (%rax),%eax
ffff800000105f7b:	88 85 37 ff ff ff    	mov    %al,-0xc9(%rbp)
ffff800000105f81:	0f b6 bd 37 ff ff ff 	movzbl -0xc9(%rbp),%edi
ffff800000105f88:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105f8f:	80 ff ff 
ffff800000105f92:	8b 50 0c             	mov    0xc(%rax),%edx
ffff800000105f95:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105f9c:	80 ff ff 
ffff800000105f9f:	8b 40 14             	mov    0x14(%rax),%eax
ffff800000105fa2:	89 d1                	mov    %edx,%ecx
ffff800000105fa4:	0f af c8             	imul   %eax,%ecx
ffff800000105fa7:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105fae:	80 ff ff 
ffff800000105fb1:	8b 50 08             	mov    0x8(%rax),%edx
ffff800000105fb4:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105fbb:	80 ff ff 
ffff800000105fbe:	8b 40 10             	mov    0x10(%rax),%eax
ffff800000105fc1:	0f af d0             	imul   %eax,%edx
ffff800000105fc4:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105fcb:	80 ff ff 
ffff800000105fce:	8b 30                	mov    (%rax),%esi
ffff800000105fd0:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000105fd7:	80 ff ff 
ffff800000105fda:	48 8b 40 18          	mov    0x18(%rax),%rax
ffff800000105fde:	44 8b 8d 08 ff ff ff 	mov    -0xf8(%rbp),%r9d
ffff800000105fe5:	44 8b 85 0c ff ff ff 	mov    -0xf4(%rbp),%r8d
ffff800000105fec:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000105ff0:	57                   	push   %rdi
ffff800000105ff1:	48 89 c7             	mov    %rax,%rdi
ffff800000105ff4:	48 b8 87 59 10 00 00 	movabs $0xffff800000105987,%rax
ffff800000105ffb:	80 ff ff 
ffff800000105ffe:	ff d0                	call   *%rax
ffff800000106000:	48 83 c4 10          	add    $0x10,%rsp
ffff800000106004:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff80000010600b:	80 ff ff 
ffff80000010600e:	8b 40 08             	mov    0x8(%rax),%eax
ffff800000106011:	8d 50 01             	lea    0x1(%rax),%edx
ffff800000106014:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff80000010601b:	80 ff ff 
ffff80000010601e:	89 50 08             	mov    %edx,0x8(%rax)
ffff800000106021:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000106028:	80 ff ff 
ffff80000010602b:	8b 48 08             	mov    0x8(%rax),%ecx
ffff80000010602e:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000106035:	80 ff ff 
ffff800000106038:	8b 00                	mov    (%rax),%eax
ffff80000010603a:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff800000106041:	80 ff ff 
ffff800000106044:	8b 72 10             	mov    0x10(%rdx),%esi
ffff800000106047:	99                   	cltd   
ffff800000106048:	f7 fe                	idiv   %esi
ffff80000010604a:	39 c1                	cmp    %eax,%ecx
ffff80000010604c:	7c 2e                	jl     ffff80000010607c <color_printk+0x4e4>
ffff80000010604e:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000106055:	80 ff ff 
ffff800000106058:	8b 40 0c             	mov    0xc(%rax),%eax
ffff80000010605b:	8d 50 01             	lea    0x1(%rax),%edx
ffff80000010605e:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000106065:	80 ff ff 
ffff800000106068:	89 50 0c             	mov    %edx,0xc(%rax)
ffff80000010606b:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000106072:	80 ff ff 
ffff800000106075:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
ffff80000010607c:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000106083:	80 ff ff 
ffff800000106086:	8b 48 0c             	mov    0xc(%rax),%ecx
ffff800000106089:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff800000106090:	80 ff ff 
ffff800000106093:	8b 40 04             	mov    0x4(%rax),%eax
ffff800000106096:	48 ba 80 db 10 00 00 	movabs $0xffff80000010db80,%rdx
ffff80000010609d:	80 ff ff 
ffff8000001060a0:	8b 7a 14             	mov    0x14(%rdx),%edi
ffff8000001060a3:	99                   	cltd   
ffff8000001060a4:	f7 ff                	idiv   %edi
ffff8000001060a6:	39 c1                	cmp    %eax,%ecx
ffff8000001060a8:	7c 29                	jl     ffff8000001060d3 <color_printk+0x53b>
ffff8000001060aa:	48 b8 79 5a 10 00 00 	movabs $0xffff800000105a79,%rax
ffff8000001060b1:	80 ff ff 
ffff8000001060b4:	ff d0                	call   *%rax
ffff8000001060b6:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff8000001060bd:	80 ff ff 
ffff8000001060c0:	8b 40 0c             	mov    0xc(%rax),%eax
ffff8000001060c3:	8d 50 ff             	lea    -0x1(%rax),%edx
ffff8000001060c6:	48 b8 80 db 10 00 00 	movabs $0xffff80000010db80,%rax
ffff8000001060cd:	80 ff ff 
ffff8000001060d0:	89 50 0c             	mov    %edx,0xc(%rax)
ffff8000001060d3:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffff8000001060da:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffff8000001060e0:	3b 85 44 ff ff ff    	cmp    -0xbc(%rbp),%eax
ffff8000001060e6:	0f 8c 9c fb ff ff    	jl     ffff800000105c88 <color_printk+0xf0>
ffff8000001060ec:	83 bd 48 ff ff ff 00 	cmpl   $0x0,-0xb8(%rbp)
ffff8000001060f3:	0f 85 8f fb ff ff    	jne    ffff800000105c88 <color_printk+0xf0>
ffff8000001060f9:	8b 85 44 ff ff ff    	mov    -0xbc(%rbp),%eax
ffff8000001060ff:	c9                   	leave  
ffff800000106100:	c3                   	ret    

ffff800000106101 <cpuid>:
ffff800000106101:	f3 0f 1e fa          	endbr64 
ffff800000106105:	55                   	push   %rbp
ffff800000106106:	48 89 e5             	mov    %rsp,%rbp
ffff800000106109:	53                   	push   %rbx
ffff80000010610a:	89 7d f4             	mov    %edi,-0xc(%rbp)
ffff80000010610d:	89 75 f0             	mov    %esi,-0x10(%rbp)
ffff800000106110:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff800000106114:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
ffff800000106118:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
ffff80000010611c:	4c 89 4d d0          	mov    %r9,-0x30(%rbp)
ffff800000106120:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffff800000106123:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffff800000106126:	89 d1                	mov    %edx,%ecx
ffff800000106128:	0f a2                	cpuid  
ffff80000010612a:	89 de                	mov    %ebx,%esi
ffff80000010612c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
ffff800000106130:	89 07                	mov    %eax,(%rdi)
ffff800000106132:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000106136:	89 30                	mov    %esi,(%rax)
ffff800000106138:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010613c:	89 08                	mov    %ecx,(%rax)
ffff80000010613e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff800000106142:	89 10                	mov    %edx,(%rax)
ffff800000106144:	90                   	nop
ffff800000106145:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
ffff800000106149:	c9                   	leave  
ffff80000010614a:	c3                   	ret    

ffff80000010614b <get_cpuinfo>:
ffff80000010614b:	f3 0f 1e fa          	endbr64 
ffff80000010614f:	55                   	push   %rbp
ffff800000106150:	48 89 e5             	mov    %rsp,%rbp
ffff800000106153:	48 83 ec 40          	sub    $0x40,%rsp
ffff800000106157:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
ffff80000010615e:	00 
ffff80000010615f:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
ffff800000106166:	00 
ffff800000106167:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
ffff80000010616e:	00 
ffff80000010616f:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
ffff800000106176:	00 
ffff800000106177:	66 c7 45 d0 00 00    	movw   $0x0,-0x30(%rbp)
ffff80000010617d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106181:	48 8d 70 0c          	lea    0xc(%rax),%rsi
ffff800000106185:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106189:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff80000010618d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106191:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000106195:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106199:	49 89 f1             	mov    %rsi,%r9
ffff80000010619c:	49 89 c8             	mov    %rcx,%r8
ffff80000010619f:	48 89 d1             	mov    %rdx,%rcx
ffff8000001061a2:	48 89 c2             	mov    %rax,%rdx
ffff8000001061a5:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001061aa:	bf 00 00 00 00       	mov    $0x0,%edi
ffff8000001061af:	48 b8 01 61 10 00 00 	movabs $0xffff800000106101,%rax
ffff8000001061b6:	80 ff ff 
ffff8000001061b9:	ff d0                	call   *%rax
ffff8000001061bb:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff8000001061bf:	8b 55 e4             	mov    -0x1c(%rbp),%edx
ffff8000001061c2:	89 10                	mov    %edx,(%rax)
ffff8000001061c4:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff8000001061c8:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff8000001061cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff8000001061cf:	89 02                	mov    %eax,(%rdx)
ffff8000001061d1:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff8000001061d5:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff8000001061d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff8000001061dc:	89 02                	mov    %eax,(%rdx)
ffff8000001061de:	c6 45 cc 00          	movb   $0x0,-0x34(%rbp)
ffff8000001061e2:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff8000001061e6:	48 89 c1             	mov    %rax,%rcx
ffff8000001061e9:	48 b8 48 c8 10 00 00 	movabs $0xffff80000010c848,%rax
ffff8000001061f0:	80 ff ff 
ffff8000001061f3:	48 89 c2             	mov    %rax,%rdx
ffff8000001061f6:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff8000001061fd:	80 ff ff 
ffff800000106200:	48 89 c6             	mov    %rax,%rsi
ffff800000106203:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff80000010620a:	80 ff ff 
ffff80000010620d:	48 89 c7             	mov    %rax,%rdi
ffff800000106210:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106215:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff80000010621c:	80 ff ff 
ffff80000010621f:	41 ff d0             	call   *%r8
ffff800000106222:	b8 02 00 00 80       	mov    $0x80000002,%eax
ffff800000106227:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010622b:	e9 b8 00 00 00       	jmp    ffff8000001062e8 <get_cpuinfo+0x19d>
ffff800000106230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106234:	89 c7                	mov    %eax,%edi
ffff800000106236:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff80000010623a:	48 8d 70 0c          	lea    0xc(%rax),%rsi
ffff80000010623e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106242:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000106246:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff80000010624a:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff80000010624e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106252:	49 89 f1             	mov    %rsi,%r9
ffff800000106255:	49 89 c8             	mov    %rcx,%r8
ffff800000106258:	48 89 d1             	mov    %rdx,%rcx
ffff80000010625b:	48 89 c2             	mov    %rax,%rdx
ffff80000010625e:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000106263:	48 b8 01 61 10 00 00 	movabs $0xffff800000106101,%rax
ffff80000010626a:	80 ff ff 
ffff80000010626d:	ff d0                	call   *%rax
ffff80000010626f:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000106273:	8b 55 e0             	mov    -0x20(%rbp),%edx
ffff800000106276:	89 10                	mov    %edx,(%rax)
ffff800000106278:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff80000010627c:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000106280:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000106283:	89 02                	mov    %eax,(%rdx)
ffff800000106285:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000106289:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffff80000010628d:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffff800000106290:	89 02                	mov    %eax,(%rdx)
ffff800000106292:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff800000106296:	48 8d 50 0c          	lea    0xc(%rax),%rdx
ffff80000010629a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010629d:	89 02                	mov    %eax,(%rdx)
ffff80000010629f:	c6 45 d0 00          	movb   $0x0,-0x30(%rbp)
ffff8000001062a3:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffff8000001062a7:	48 89 c1             	mov    %rax,%rcx
ffff8000001062aa:	48 b8 58 c8 10 00 00 	movabs $0xffff80000010c858,%rax
ffff8000001062b1:	80 ff ff 
ffff8000001062b4:	48 89 c2             	mov    %rax,%rdx
ffff8000001062b7:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff8000001062be:	80 ff ff 
ffff8000001062c1:	48 89 c6             	mov    %rax,%rsi
ffff8000001062c4:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff8000001062cb:	80 ff ff 
ffff8000001062ce:	48 89 c7             	mov    %rax,%rdi
ffff8000001062d1:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001062d6:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff8000001062dd:	80 ff ff 
ffff8000001062e0:	41 ff d0             	call   *%r8
ffff8000001062e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffff8000001062e8:	b8 04 00 00 80       	mov    $0x80000004,%eax
ffff8000001062ed:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffff8000001062f1:	0f 86 39 ff ff ff    	jbe    ffff800000106230 <get_cpuinfo+0xe5>
ffff8000001062f7:	48 b8 5b c8 10 00 00 	movabs $0xffff80000010c85b,%rax
ffff8000001062fe:	80 ff ff 
ffff800000106301:	48 89 c2             	mov    %rax,%rdx
ffff800000106304:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff80000010630b:	80 ff ff 
ffff80000010630e:	48 89 c6             	mov    %rax,%rsi
ffff800000106311:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff800000106318:	80 ff ff 
ffff80000010631b:	48 89 c7             	mov    %rax,%rdi
ffff80000010631e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106323:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff80000010632a:	80 ff ff 
ffff80000010632d:	ff d1                	call   *%rcx
ffff80000010632f:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106333:	48 8d 70 0c          	lea    0xc(%rax),%rsi
ffff800000106337:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff80000010633b:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff80000010633f:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106343:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000106347:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff80000010634b:	49 89 f1             	mov    %rsi,%r9
ffff80000010634e:	49 89 c8             	mov    %rcx,%r8
ffff800000106351:	48 89 d1             	mov    %rdx,%rcx
ffff800000106354:	48 89 c2             	mov    %rax,%rdx
ffff800000106357:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010635c:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000106361:	48 b8 01 61 10 00 00 	movabs $0xffff800000106101,%rax
ffff800000106368:	80 ff ff 
ffff80000010636b:	ff d0                	call   *%rax
ffff80000010636d:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000106370:	83 e0 0f             	and    $0xf,%eax
ffff800000106373:	89 c6                	mov    %eax,%esi
ffff800000106375:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000106378:	c1 e8 0c             	shr    $0xc,%eax
ffff80000010637b:	83 e0 03             	and    $0x3,%eax
ffff80000010637e:	89 c1                	mov    %eax,%ecx
ffff800000106380:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000106383:	c1 e8 10             	shr    $0x10,%eax
ffff800000106386:	83 e0 0f             	and    $0xf,%eax
ffff800000106389:	89 c2                	mov    %eax,%edx
ffff80000010638b:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff80000010638e:	c1 e8 04             	shr    $0x4,%eax
ffff800000106391:	83 e0 0f             	and    $0xf,%eax
ffff800000106394:	41 89 c0             	mov    %eax,%r8d
ffff800000106397:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff80000010639a:	c1 e8 14             	shr    $0x14,%eax
ffff80000010639d:	0f b6 f8             	movzbl %al,%edi
ffff8000001063a0:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001063a3:	c1 e8 08             	shr    $0x8,%eax
ffff8000001063a6:	83 e0 0f             	and    $0xf,%eax
ffff8000001063a9:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001063ad:	56                   	push   %rsi
ffff8000001063ae:	51                   	push   %rcx
ffff8000001063af:	52                   	push   %rdx
ffff8000001063b0:	45 89 c1             	mov    %r8d,%r9d
ffff8000001063b3:	41 89 f8             	mov    %edi,%r8d
ffff8000001063b6:	89 c1                	mov    %eax,%ecx
ffff8000001063b8:	48 b8 60 c8 10 00 00 	movabs $0xffff80000010c860,%rax
ffff8000001063bf:	80 ff ff 
ffff8000001063c2:	48 89 c2             	mov    %rax,%rdx
ffff8000001063c5:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff8000001063cc:	80 ff ff 
ffff8000001063cf:	48 89 c6             	mov    %rax,%rsi
ffff8000001063d2:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff8000001063d9:	80 ff ff 
ffff8000001063dc:	48 89 c7             	mov    %rax,%rdi
ffff8000001063df:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001063e4:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff8000001063eb:	80 ff ff 
ffff8000001063ee:	41 ff d2             	call   *%r10
ffff8000001063f1:	48 83 c4 20          	add    $0x20,%rsp
ffff8000001063f5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff8000001063f8:	c1 e8 18             	shr    $0x18,%eax
ffff8000001063fb:	89 c2                	mov    %eax,%edx
ffff8000001063fd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000106400:	c1 e8 10             	shr    $0x10,%eax
ffff800000106403:	0f b6 c0             	movzbl %al,%eax
ffff800000106406:	41 89 d0             	mov    %edx,%r8d
ffff800000106409:	89 c1                	mov    %eax,%ecx
ffff80000010640b:	48 b8 b0 c8 10 00 00 	movabs $0xffff80000010c8b0,%rax
ffff800000106412:	80 ff ff 
ffff800000106415:	48 89 c2             	mov    %rax,%rdx
ffff800000106418:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff80000010641f:	80 ff ff 
ffff800000106422:	48 89 c6             	mov    %rax,%rsi
ffff800000106425:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff80000010642c:	80 ff ff 
ffff80000010642f:	48 89 c7             	mov    %rax,%rdi
ffff800000106432:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106437:	49 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%r9
ffff80000010643e:	80 ff ff 
ffff800000106441:	41 ff d1             	call   *%r9
ffff800000106444:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff800000106447:	c1 e8 10             	shr    $0x10,%eax
ffff80000010644a:	0f b6 c0             	movzbl %al,%eax
ffff80000010644d:	48 ba c0 eb 10 00 00 	movabs $0xffff80000010ebc0,%rdx
ffff800000106454:	80 ff ff 
ffff800000106457:	89 02                	mov    %eax,(%rdx)
ffff800000106459:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffff80000010645c:	c1 e8 18             	shr    $0x18,%eax
ffff80000010645f:	89 c2                	mov    %eax,%edx
ffff800000106461:	48 b8 c4 eb 10 00 00 	movabs $0xffff80000010ebc4,%rax
ffff800000106468:	80 ff ff 
ffff80000010646b:	89 10                	mov    %edx,(%rax)
ffff80000010646d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106471:	48 8d 70 0c          	lea    0xc(%rax),%rsi
ffff800000106475:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106479:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff80000010647d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106481:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000106485:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106489:	49 89 f1             	mov    %rsi,%r9
ffff80000010648c:	49 89 c8             	mov    %rcx,%r8
ffff80000010648f:	48 89 d1             	mov    %rdx,%rcx
ffff800000106492:	48 89 c2             	mov    %rax,%rdx
ffff800000106495:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010649a:	bf 08 00 00 80       	mov    $0x80000008,%edi
ffff80000010649f:	48 b8 01 61 10 00 00 	movabs $0xffff800000106101,%rax
ffff8000001064a6:	80 ff ff 
ffff8000001064a9:	ff d0                	call   *%rax
ffff8000001064ab:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001064ae:	c1 e8 08             	shr    $0x8,%eax
ffff8000001064b1:	0f b6 d0             	movzbl %al,%edx
ffff8000001064b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001064b7:	0f b6 c0             	movzbl %al,%eax
ffff8000001064ba:	41 89 d0             	mov    %edx,%r8d
ffff8000001064bd:	89 c1                	mov    %eax,%ecx
ffff8000001064bf:	48 b8 d8 c8 10 00 00 	movabs $0xffff80000010c8d8,%rax
ffff8000001064c6:	80 ff ff 
ffff8000001064c9:	48 89 c2             	mov    %rax,%rdx
ffff8000001064cc:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff8000001064d3:	80 ff ff 
ffff8000001064d6:	48 89 c6             	mov    %rax,%rsi
ffff8000001064d9:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff8000001064e0:	80 ff ff 
ffff8000001064e3:	48 89 c7             	mov    %rax,%rdi
ffff8000001064e6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001064eb:	49 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%r9
ffff8000001064f2:	80 ff ff 
ffff8000001064f5:	41 ff d1             	call   *%r9
ffff8000001064f8:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff8000001064fc:	48 8d 70 0c          	lea    0xc(%rax),%rsi
ffff800000106500:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106504:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000106508:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff80000010650c:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff800000106510:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106514:	49 89 f1             	mov    %rsi,%r9
ffff800000106517:	49 89 c8             	mov    %rcx,%r8
ffff80000010651a:	48 89 d1             	mov    %rdx,%rcx
ffff80000010651d:	48 89 c2             	mov    %rax,%rdx
ffff800000106520:	be 00 00 00 00       	mov    $0x0,%esi
ffff800000106525:	bf 00 00 00 00       	mov    $0x0,%edi
ffff80000010652a:	48 b8 01 61 10 00 00 	movabs $0xffff800000106101,%rax
ffff800000106531:	80 ff ff 
ffff800000106534:	ff d0                	call   *%rax
ffff800000106536:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff800000106539:	89 c1                	mov    %eax,%ecx
ffff80000010653b:	48 b8 0b c9 10 00 00 	movabs $0xffff80000010c90b,%rax
ffff800000106542:	80 ff ff 
ffff800000106545:	48 89 c2             	mov    %rax,%rdx
ffff800000106548:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff80000010654f:	80 ff ff 
ffff800000106552:	48 89 c6             	mov    %rax,%rsi
ffff800000106555:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff80000010655c:	80 ff ff 
ffff80000010655f:	48 89 c7             	mov    %rax,%rdi
ffff800000106562:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106567:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff80000010656e:	80 ff ff 
ffff800000106571:	41 ff d0             	call   *%r8
ffff800000106574:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106578:	48 8d 70 0c          	lea    0xc(%rax),%rsi
ffff80000010657c:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106580:	48 8d 48 08          	lea    0x8(%rax),%rcx
ffff800000106584:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106588:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff80000010658c:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffff800000106590:	49 89 f1             	mov    %rsi,%r9
ffff800000106593:	49 89 c8             	mov    %rcx,%r8
ffff800000106596:	48 89 d1             	mov    %rdx,%rcx
ffff800000106599:	48 89 c2             	mov    %rax,%rdx
ffff80000010659c:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001065a1:	bf 00 00 00 80       	mov    $0x80000000,%edi
ffff8000001065a6:	48 b8 01 61 10 00 00 	movabs $0xffff800000106101,%rax
ffff8000001065ad:	80 ff ff 
ffff8000001065b0:	ff d0                	call   *%rax
ffff8000001065b2:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffff8000001065b5:	89 c1                	mov    %eax,%ecx
ffff8000001065b7:	48 b8 21 c9 10 00 00 	movabs $0xffff80000010c921,%rax
ffff8000001065be:	80 ff ff 
ffff8000001065c1:	48 89 c2             	mov    %rax,%rdx
ffff8000001065c4:	48 b8 4c c8 10 00 00 	movabs $0xffff80000010c84c,%rax
ffff8000001065cb:	80 ff ff 
ffff8000001065ce:	48 89 c6             	mov    %rax,%rsi
ffff8000001065d1:	48 b8 52 c8 10 00 00 	movabs $0xffff80000010c852,%rax
ffff8000001065d8:	80 ff ff 
ffff8000001065db:	48 89 c7             	mov    %rax,%rdi
ffff8000001065de:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001065e3:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff8000001065ea:	80 ff ff 
ffff8000001065ed:	41 ff d0             	call   *%r8
ffff8000001065f0:	90                   	nop
ffff8000001065f1:	c9                   	leave  
ffff8000001065f2:	c3                   	ret    

ffff8000001065f3 <set_gate>:
ffff8000001065f3:	f3 0f 1e fa          	endbr64 
ffff8000001065f7:	55                   	push   %rbp
ffff8000001065f8:	48 89 e5             	mov    %rsp,%rbp
ffff8000001065fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001065ff:	89 d0                	mov    %edx,%eax
ffff800000106601:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
ffff800000106605:	89 f2                	mov    %esi,%edx
ffff800000106607:	88 55 e4             	mov    %dl,-0x1c(%rbp)
ffff80000010660a:	88 45 e0             	mov    %al,-0x20(%rbp)
ffff80000010660d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff800000106614:	00 
ffff800000106615:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff80000010661c:	00 
ffff80000010661d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000106621:	25 ff ff 00 00       	and    $0xffff,%eax
ffff800000106626:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff80000010662a:	48 81 4d f8 00 00 08 	orq    $0x80000,-0x8(%rbp)
ffff800000106631:	00 
ffff800000106632:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
ffff800000106636:	48 c1 e0 28          	shl    $0x28,%rax
ffff80000010663a:	48 09 45 f8          	or     %rax,-0x8(%rbp)
ffff80000010663e:	0f b6 45 e0          	movzbl -0x20(%rbp),%eax
ffff800000106642:	48 c1 e0 20          	shl    $0x20,%rax
ffff800000106646:	48 89 c2             	mov    %rax,%rdx
ffff800000106649:	48 b8 00 00 00 00 07 	movabs $0x700000000,%rax
ffff800000106650:	00 00 00 
ffff800000106653:	48 21 d0             	and    %rdx,%rax
ffff800000106656:	48 09 45 f8          	or     %rax,-0x8(%rbp)
ffff80000010665a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010665e:	48 c1 e8 10          	shr    $0x10,%rax
ffff800000106662:	48 c1 e0 30          	shl    $0x30,%rax
ffff800000106666:	48 09 45 f8          	or     %rax,-0x8(%rbp)
ffff80000010666a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010666e:	48 c1 e8 20          	shr    $0x20,%rax
ffff800000106672:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff800000106676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010667a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffff80000010667e:	48 89 10             	mov    %rdx,(%rax)
ffff800000106681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000106685:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106689:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff80000010668d:	90                   	nop
ffff80000010668e:	5d                   	pop    %rbp
ffff80000010668f:	c3                   	ret    

ffff800000106690 <set_intr_gate>:
ffff800000106690:	f3 0f 1e fa          	endbr64 
ffff800000106694:	55                   	push   %rbp
ffff800000106695:	48 89 e5             	mov    %rsp,%rbp
ffff800000106698:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010669c:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff80000010669f:	89 f0                	mov    %esi,%eax
ffff8000001066a1:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
ffff8000001066a5:	88 45 f8             	mov    %al,-0x8(%rbp)
ffff8000001066a8:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff8000001066ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001066af:	48 89 d1             	mov    %rdx,%rcx
ffff8000001066b2:	48 c1 e1 04          	shl    $0x4,%rcx
ffff8000001066b6:	48 ba c0 8d 10 00 00 	movabs $0xffff800000108dc0,%rdx
ffff8000001066bd:	80 ff ff 
ffff8000001066c0:	48 8d 3c 11          	lea    (%rcx,%rdx,1),%rdi
ffff8000001066c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001066c8:	48 89 d1             	mov    %rdx,%rcx
ffff8000001066cb:	89 c2                	mov    %eax,%edx
ffff8000001066cd:	be 8e 00 00 00       	mov    $0x8e,%esi
ffff8000001066d2:	48 b8 f3 65 10 00 00 	movabs $0xffff8000001065f3,%rax
ffff8000001066d9:	80 ff ff 
ffff8000001066dc:	ff d0                	call   *%rax
ffff8000001066de:	90                   	nop
ffff8000001066df:	c9                   	leave  
ffff8000001066e0:	c3                   	ret    

ffff8000001066e1 <set_trap_gate>:
ffff8000001066e1:	f3 0f 1e fa          	endbr64 
ffff8000001066e5:	55                   	push   %rbp
ffff8000001066e6:	48 89 e5             	mov    %rsp,%rbp
ffff8000001066e9:	48 83 ec 10          	sub    $0x10,%rsp
ffff8000001066ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff8000001066f0:	89 f0                	mov    %esi,%eax
ffff8000001066f2:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
ffff8000001066f6:	88 45 f8             	mov    %al,-0x8(%rbp)
ffff8000001066f9:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff8000001066fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000106700:	48 89 d1             	mov    %rdx,%rcx
ffff800000106703:	48 c1 e1 04          	shl    $0x4,%rcx
ffff800000106707:	48 ba c0 8d 10 00 00 	movabs $0xffff800000108dc0,%rdx
ffff80000010670e:	80 ff ff 
ffff800000106711:	48 8d 3c 11          	lea    (%rcx,%rdx,1),%rdi
ffff800000106715:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000106719:	48 89 d1             	mov    %rdx,%rcx
ffff80000010671c:	89 c2                	mov    %eax,%edx
ffff80000010671e:	be 8f 00 00 00       	mov    $0x8f,%esi
ffff800000106723:	48 b8 f3 65 10 00 00 	movabs $0xffff8000001065f3,%rax
ffff80000010672a:	80 ff ff 
ffff80000010672d:	ff d0                	call   *%rax
ffff80000010672f:	90                   	nop
ffff800000106730:	c9                   	leave  
ffff800000106731:	c3                   	ret    

ffff800000106732 <set_system_intr_gate>:
ffff800000106732:	f3 0f 1e fa          	endbr64 
ffff800000106736:	55                   	push   %rbp
ffff800000106737:	48 89 e5             	mov    %rsp,%rbp
ffff80000010673a:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010673e:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000106741:	89 f0                	mov    %esi,%eax
ffff800000106743:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
ffff800000106747:	88 45 f8             	mov    %al,-0x8(%rbp)
ffff80000010674a:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010674e:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff800000106751:	48 89 d1             	mov    %rdx,%rcx
ffff800000106754:	48 c1 e1 04          	shl    $0x4,%rcx
ffff800000106758:	48 ba c0 8d 10 00 00 	movabs $0xffff800000108dc0,%rdx
ffff80000010675f:	80 ff ff 
ffff800000106762:	48 8d 3c 11          	lea    (%rcx,%rdx,1),%rdi
ffff800000106766:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff80000010676a:	48 89 d1             	mov    %rdx,%rcx
ffff80000010676d:	89 c2                	mov    %eax,%edx
ffff80000010676f:	be ee 00 00 00       	mov    $0xee,%esi
ffff800000106774:	48 b8 f3 65 10 00 00 	movabs $0xffff8000001065f3,%rax
ffff80000010677b:	80 ff ff 
ffff80000010677e:	ff d0                	call   *%rax
ffff800000106780:	90                   	nop
ffff800000106781:	c9                   	leave  
ffff800000106782:	c3                   	ret    

ffff800000106783 <set_system_trap_gate>:
ffff800000106783:	f3 0f 1e fa          	endbr64 
ffff800000106787:	55                   	push   %rbp
ffff800000106788:	48 89 e5             	mov    %rsp,%rbp
ffff80000010678b:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010678f:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffff800000106792:	89 f0                	mov    %esi,%eax
ffff800000106794:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
ffff800000106798:	88 45 f8             	mov    %al,-0x8(%rbp)
ffff80000010679b:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffff80000010679f:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffff8000001067a2:	48 89 d1             	mov    %rdx,%rcx
ffff8000001067a5:	48 c1 e1 04          	shl    $0x4,%rcx
ffff8000001067a9:	48 ba c0 8d 10 00 00 	movabs $0xffff800000108dc0,%rdx
ffff8000001067b0:	80 ff ff 
ffff8000001067b3:	48 8d 3c 11          	lea    (%rcx,%rdx,1),%rdi
ffff8000001067b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff8000001067bb:	48 89 d1             	mov    %rdx,%rcx
ffff8000001067be:	89 c2                	mov    %eax,%edx
ffff8000001067c0:	be ef 00 00 00       	mov    $0xef,%esi
ffff8000001067c5:	48 b8 f3 65 10 00 00 	movabs $0xffff8000001065f3,%rax
ffff8000001067cc:	80 ff ff 
ffff8000001067cf:	ff d0                	call   *%rax
ffff8000001067d1:	90                   	nop
ffff8000001067d2:	c9                   	leave  
ffff8000001067d3:	c3                   	ret    

ffff8000001067d4 <set_tss64>:
ffff8000001067d4:	f3 0f 1e fa          	endbr64 
ffff8000001067d8:	55                   	push   %rbp
ffff8000001067d9:	48 89 e5             	mov    %rsp,%rbp
ffff8000001067dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001067e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001067e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffff8000001067e8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
ffff8000001067ec:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
ffff8000001067f0:	4c 89 4d d0          	mov    %r9,-0x30(%rbp)
ffff8000001067f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001067f8:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffff8000001067fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106800:	48 89 02             	mov    %rax,(%rdx)
ffff800000106803:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106807:	48 8d 50 0c          	lea    0xc(%rax),%rdx
ffff80000010680b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010680f:	48 89 02             	mov    %rax,(%rdx)
ffff800000106812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106816:	48 8d 50 14          	lea    0x14(%rax),%rdx
ffff80000010681a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010681e:	48 89 02             	mov    %rax,(%rdx)
ffff800000106821:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106825:	48 8d 50 24          	lea    0x24(%rax),%rdx
ffff800000106829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff80000010682d:	48 89 02             	mov    %rax,(%rdx)
ffff800000106830:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106834:	48 8d 50 2c          	lea    0x2c(%rax),%rdx
ffff800000106838:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010683c:	48 89 02             	mov    %rax,(%rdx)
ffff80000010683f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106843:	48 8d 50 34          	lea    0x34(%rax),%rdx
ffff800000106847:	48 8b 45 10          	mov    0x10(%rbp),%rax
ffff80000010684b:	48 89 02             	mov    %rax,(%rdx)
ffff80000010684e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106852:	48 8d 50 3c          	lea    0x3c(%rax),%rdx
ffff800000106856:	48 8b 45 18          	mov    0x18(%rbp),%rax
ffff80000010685a:	48 89 02             	mov    %rax,(%rdx)
ffff80000010685d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106861:	48 8d 50 44          	lea    0x44(%rax),%rdx
ffff800000106865:	48 8b 45 20          	mov    0x20(%rbp),%rax
ffff800000106869:	48 89 02             	mov    %rax,(%rdx)
ffff80000010686c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106870:	48 8d 50 4c          	lea    0x4c(%rax),%rdx
ffff800000106874:	48 8b 45 28          	mov    0x28(%rbp),%rax
ffff800000106878:	48 89 02             	mov    %rax,(%rdx)
ffff80000010687b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010687f:	48 8d 50 54          	lea    0x54(%rax),%rdx
ffff800000106883:	48 8b 45 30          	mov    0x30(%rbp),%rax
ffff800000106887:	48 89 02             	mov    %rax,(%rdx)
ffff80000010688a:	90                   	nop
ffff80000010688b:	5d                   	pop    %rbp
ffff80000010688c:	c3                   	ret    

ffff80000010688d <set_tss_descriptor>:
ffff80000010688d:	f3 0f 1e fa          	endbr64 
ffff800000106891:	55                   	push   %rbp
ffff800000106892:	48 89 e5             	mov    %rsp,%rbp
ffff800000106895:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffff800000106898:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff80000010689c:	48 c7 45 f8 67 00 00 	movq   $0x67,-0x8(%rbp)
ffff8000001068a3:	00 
ffff8000001068a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001068a8:	0f b7 d0             	movzwl %ax,%edx
ffff8000001068ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001068af:	48 c1 e0 10          	shl    $0x10,%rax
ffff8000001068b3:	89 c0                	mov    %eax,%eax
ffff8000001068b5:	48 09 c2             	or     %rax,%rdx
ffff8000001068b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001068bc:	48 c1 e8 10          	shr    $0x10,%rax
ffff8000001068c0:	48 c1 e0 20          	shl    $0x20,%rax
ffff8000001068c4:	48 89 c1             	mov    %rax,%rcx
ffff8000001068c7:	48 b8 00 00 00 00 ff 	movabs $0xff00000000,%rax
ffff8000001068ce:	00 00 00 
ffff8000001068d1:	48 21 c8             	and    %rcx,%rax
ffff8000001068d4:	48 09 c2             	or     %rax,%rdx
ffff8000001068d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001068db:	48 c1 e8 10          	shr    $0x10,%rax
ffff8000001068df:	48 c1 e0 30          	shl    $0x30,%rax
ffff8000001068e3:	48 89 c1             	mov    %rax,%rcx
ffff8000001068e6:	48 b8 00 00 00 00 00 	movabs $0xf000000000000,%rax
ffff8000001068ed:	00 0f 00 
ffff8000001068f0:	48 21 c8             	and    %rcx,%rax
ffff8000001068f3:	48 09 c2             	or     %rax,%rdx
ffff8000001068f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001068fa:	48 c1 e8 18          	shr    $0x18,%rax
ffff8000001068fe:	48 c1 e0 38          	shl    $0x38,%rax
ffff800000106902:	48 89 d1             	mov    %rdx,%rcx
ffff800000106905:	48 09 c1             	or     %rax,%rcx
ffff800000106908:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff80000010690b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffff800000106912:	00 
ffff800000106913:	48 b8 40 8a 10 00 00 	movabs $0xffff800000108a40,%rax
ffff80000010691a:	80 ff ff 
ffff80000010691d:	48 01 d0             	add    %rdx,%rax
ffff800000106920:	48 ba 00 00 00 00 00 	movabs $0x890000000000,%rdx
ffff800000106927:	89 00 00 
ffff80000010692a:	48 09 ca             	or     %rcx,%rdx
ffff80000010692d:	48 89 10             	mov    %rdx,(%rax)
ffff800000106930:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffff800000106934:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffff800000106937:	48 83 c0 01          	add    $0x1,%rax
ffff80000010693b:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
ffff800000106942:	00 
ffff800000106943:	48 b8 40 8a 10 00 00 	movabs $0xffff800000108a40,%rax
ffff80000010694a:	80 ff ff 
ffff80000010694d:	48 01 c8             	add    %rcx,%rax
ffff800000106950:	48 c1 ea 20          	shr    $0x20,%rdx
ffff800000106954:	48 89 10             	mov    %rdx,(%rax)
ffff800000106957:	90                   	nop
ffff800000106958:	5d                   	pop    %rbp
ffff800000106959:	c3                   	ret    

ffff80000010695a <display_regs>:
ffff80000010695a:	f3 0f 1e fa          	endbr64 
ffff80000010695e:	55                   	push   %rbp
ffff80000010695f:	48 89 e5             	mov    %rsp,%rbp
ffff800000106962:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106966:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010696a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010696e:	48 8b 88 a8 00 00 00 	mov    0xa8(%rax),%rcx
ffff800000106975:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106979:	48 8b 50 78          	mov    0x78(%rax),%rdx
ffff80000010697d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106981:	48 8b 78 70          	mov    0x70(%rax),%rdi
ffff800000106985:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106989:	48 8b b0 b8 00 00 00 	mov    0xb8(%rax),%rsi
ffff800000106990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106994:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
ffff80000010699b:	51                   	push   %rcx
ffff80000010699c:	52                   	push   %rdx
ffff80000010699d:	49 89 f9             	mov    %rdi,%r9
ffff8000001069a0:	49 89 f0             	mov    %rsi,%r8
ffff8000001069a3:	48 89 c1             	mov    %rax,%rcx
ffff8000001069a6:	48 b8 40 c9 10 00 00 	movabs $0xffff80000010c940,%rax
ffff8000001069ad:	80 ff ff 
ffff8000001069b0:	48 89 c2             	mov    %rax,%rdx
ffff8000001069b3:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001069ba:	80 ff ff 
ffff8000001069bd:	48 89 c6             	mov    %rax,%rsi
ffff8000001069c0:	48 b8 7e c9 10 00 00 	movabs $0xffff80000010c97e,%rax
ffff8000001069c7:	80 ff ff 
ffff8000001069ca:	48 89 c7             	mov    %rax,%rdi
ffff8000001069cd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001069d2:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff8000001069d9:	80 ff ff 
ffff8000001069dc:	41 ff d2             	call   *%r10
ffff8000001069df:	48 83 c4 10          	add    $0x10,%rsp
ffff8000001069e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001069e7:	4c 8b 48 60          	mov    0x60(%rax),%r9
ffff8000001069eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001069ef:	4c 8b 40 58          	mov    0x58(%rax),%r8
ffff8000001069f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001069f7:	48 8b b8 98 00 00 00 	mov    0x98(%rax),%rdi
ffff8000001069fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a02:	48 8b 70 68          	mov    0x68(%rax),%rsi
ffff800000106a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a0a:	48 8b 88 b0 00 00 00 	mov    0xb0(%rax),%rcx
ffff800000106a11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a15:	48 8b 50 50          	mov    0x50(%rax),%rdx
ffff800000106a19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a1d:	4c 8b 58 48          	mov    0x48(%rax),%r11
ffff800000106a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a25:	4c 8b 50 40          	mov    0x40(%rax),%r10
ffff800000106a29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a2d:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
ffff800000106a34:	41 51                	push   %r9
ffff800000106a36:	41 50                	push   %r8
ffff800000106a38:	57                   	push   %rdi
ffff800000106a39:	56                   	push   %rsi
ffff800000106a3a:	51                   	push   %rcx
ffff800000106a3b:	52                   	push   %rdx
ffff800000106a3c:	4d 89 d9             	mov    %r11,%r9
ffff800000106a3f:	4d 89 d0             	mov    %r10,%r8
ffff800000106a42:	48 89 c1             	mov    %rax,%rcx
ffff800000106a45:	48 b8 88 c9 10 00 00 	movabs $0xffff80000010c988,%rax
ffff800000106a4c:	80 ff ff 
ffff800000106a4f:	48 89 c2             	mov    %rax,%rdx
ffff800000106a52:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106a59:	80 ff ff 
ffff800000106a5c:	48 89 c6             	mov    %rax,%rsi
ffff800000106a5f:	48 b8 7e c9 10 00 00 	movabs $0xffff80000010c97e,%rax
ffff800000106a66:	80 ff ff 
ffff800000106a69:	48 89 c7             	mov    %rax,%rdi
ffff800000106a6c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106a71:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106a78:	80 ff ff 
ffff800000106a7b:	41 ff d2             	call   *%r10
ffff800000106a7e:	48 83 c4 30          	add    $0x30,%rsp
ffff800000106a82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a86:	4c 8b 00             	mov    (%rax),%r8
ffff800000106a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a8d:	48 8b 78 08          	mov    0x8(%rax),%rdi
ffff800000106a91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a95:	48 8b 70 10          	mov    0x10(%rax),%rsi
ffff800000106a99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106a9d:	48 8b 48 18          	mov    0x18(%rax),%rcx
ffff800000106aa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106aa5:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffff800000106aa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106aad:	4c 8b 48 28          	mov    0x28(%rax),%r9
ffff800000106ab1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ab5:	4c 8b 50 30          	mov    0x30(%rax),%r10
ffff800000106ab9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106abd:	48 8b 40 38          	mov    0x38(%rax),%rax
ffff800000106ac1:	48 83 ec 08          	sub    $0x8,%rsp
ffff800000106ac5:	41 50                	push   %r8
ffff800000106ac7:	57                   	push   %rdi
ffff800000106ac8:	56                   	push   %rsi
ffff800000106ac9:	51                   	push   %rcx
ffff800000106aca:	52                   	push   %rdx
ffff800000106acb:	4d 89 d0             	mov    %r10,%r8
ffff800000106ace:	48 89 c1             	mov    %rax,%rcx
ffff800000106ad1:	48 b8 f8 c9 10 00 00 	movabs $0xffff80000010c9f8,%rax
ffff800000106ad8:	80 ff ff 
ffff800000106adb:	48 89 c2             	mov    %rax,%rdx
ffff800000106ade:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106ae5:	80 ff ff 
ffff800000106ae8:	48 89 c6             	mov    %rax,%rsi
ffff800000106aeb:	48 b8 7e c9 10 00 00 	movabs $0xffff80000010c97e,%rax
ffff800000106af2:	80 ff ff 
ffff800000106af5:	48 89 c7             	mov    %rax,%rdi
ffff800000106af8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106afd:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106b04:	80 ff ff 
ffff800000106b07:	41 ff d2             	call   *%r10
ffff800000106b0a:	48 83 c4 30          	add    $0x30,%rsp
ffff800000106b0e:	90                   	nop
ffff800000106b0f:	c9                   	leave  
ffff800000106b10:	c3                   	ret    

ffff800000106b11 <do_divide_error>:
ffff800000106b11:	f3 0f 1e fa          	endbr64 
ffff800000106b15:	55                   	push   %rbp
ffff800000106b16:	48 89 e5             	mov    %rsp,%rbp
ffff800000106b19:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106b1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106b21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b29:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b34:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106b3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106b3f:	49 89 c9             	mov    %rcx,%r9
ffff800000106b42:	49 89 d0             	mov    %rdx,%r8
ffff800000106b45:	48 89 c1             	mov    %rax,%rcx
ffff800000106b48:	48 b8 60 ca 10 00 00 	movabs $0xffff80000010ca60,%rax
ffff800000106b4f:	80 ff ff 
ffff800000106b52:	48 89 c2             	mov    %rax,%rdx
ffff800000106b55:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106b5c:	80 ff ff 
ffff800000106b5f:	48 89 c6             	mov    %rax,%rsi
ffff800000106b62:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106b69:	80 ff ff 
ffff800000106b6c:	48 89 c7             	mov    %rax,%rdi
ffff800000106b6f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106b74:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106b7b:	80 ff ff 
ffff800000106b7e:	41 ff d2             	call   *%r10
ffff800000106b81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106b85:	48 89 c7             	mov    %rax,%rdi
ffff800000106b88:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106b8f:	80 ff ff 
ffff800000106b92:	ff d0                	call   *%rax
ffff800000106b94:	f4                   	hlt    
ffff800000106b95:	eb fd                	jmp    ffff800000106b94 <do_divide_error+0x83>

ffff800000106b97 <do_debug>:
ffff800000106b97:	f3 0f 1e fa          	endbr64 
ffff800000106b9b:	55                   	push   %rbp
ffff800000106b9c:	48 89 e5             	mov    %rsp,%rbp
ffff800000106b9f:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106ba3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106ba7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106baf:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106bba:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106bc5:	49 89 c9             	mov    %rcx,%r9
ffff800000106bc8:	49 89 d0             	mov    %rdx,%r8
ffff800000106bcb:	48 89 c1             	mov    %rax,%rcx
ffff800000106bce:	48 b8 a8 ca 10 00 00 	movabs $0xffff80000010caa8,%rax
ffff800000106bd5:	80 ff ff 
ffff800000106bd8:	48 89 c2             	mov    %rax,%rdx
ffff800000106bdb:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106be2:	80 ff ff 
ffff800000106be5:	48 89 c6             	mov    %rax,%rsi
ffff800000106be8:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106bef:	80 ff ff 
ffff800000106bf2:	48 89 c7             	mov    %rax,%rdi
ffff800000106bf5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106bfa:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106c01:	80 ff ff 
ffff800000106c04:	41 ff d2             	call   *%r10
ffff800000106c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106c0b:	48 89 c7             	mov    %rax,%rdi
ffff800000106c0e:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106c15:	80 ff ff 
ffff800000106c18:	ff d0                	call   *%rax
ffff800000106c1a:	f4                   	hlt    
ffff800000106c1b:	eb fd                	jmp    ffff800000106c1a <do_debug+0x83>

ffff800000106c1d <do_nmi>:
ffff800000106c1d:	f3 0f 1e fa          	endbr64 
ffff800000106c21:	55                   	push   %rbp
ffff800000106c22:	48 89 e5             	mov    %rsp,%rbp
ffff800000106c25:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106c29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106c2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106c31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106c35:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106c40:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106c4b:	49 89 c9             	mov    %rcx,%r9
ffff800000106c4e:	49 89 d0             	mov    %rdx,%r8
ffff800000106c51:	48 89 c1             	mov    %rax,%rcx
ffff800000106c54:	48 b8 e8 ca 10 00 00 	movabs $0xffff80000010cae8,%rax
ffff800000106c5b:	80 ff ff 
ffff800000106c5e:	48 89 c2             	mov    %rax,%rdx
ffff800000106c61:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106c68:	80 ff ff 
ffff800000106c6b:	48 89 c6             	mov    %rax,%rsi
ffff800000106c6e:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106c75:	80 ff ff 
ffff800000106c78:	48 89 c7             	mov    %rax,%rdi
ffff800000106c7b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106c80:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106c87:	80 ff ff 
ffff800000106c8a:	41 ff d2             	call   *%r10
ffff800000106c8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106c91:	48 89 c7             	mov    %rax,%rdi
ffff800000106c94:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106c9b:	80 ff ff 
ffff800000106c9e:	ff d0                	call   *%rax
ffff800000106ca0:	f4                   	hlt    
ffff800000106ca1:	eb fd                	jmp    ffff800000106ca0 <do_nmi+0x83>

ffff800000106ca3 <do_int3>:
ffff800000106ca3:	f3 0f 1e fa          	endbr64 
ffff800000106ca7:	55                   	push   %rbp
ffff800000106ca8:	48 89 e5             	mov    %rsp,%rbp
ffff800000106cab:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106caf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106cb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106cb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106cbb:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106cc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106cc6:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106cd1:	49 89 c9             	mov    %rcx,%r9
ffff800000106cd4:	49 89 d0             	mov    %rdx,%r8
ffff800000106cd7:	48 89 c1             	mov    %rax,%rcx
ffff800000106cda:	48 b8 28 cb 10 00 00 	movabs $0xffff80000010cb28,%rax
ffff800000106ce1:	80 ff ff 
ffff800000106ce4:	48 89 c2             	mov    %rax,%rdx
ffff800000106ce7:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106cee:	80 ff ff 
ffff800000106cf1:	48 89 c6             	mov    %rax,%rsi
ffff800000106cf4:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106cfb:	80 ff ff 
ffff800000106cfe:	48 89 c7             	mov    %rax,%rdi
ffff800000106d01:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106d06:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106d0d:	80 ff ff 
ffff800000106d10:	41 ff d2             	call   *%r10
ffff800000106d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d17:	48 89 c7             	mov    %rax,%rdi
ffff800000106d1a:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106d21:	80 ff ff 
ffff800000106d24:	ff d0                	call   *%rax
ffff800000106d26:	f4                   	hlt    
ffff800000106d27:	eb fd                	jmp    ffff800000106d26 <do_int3+0x83>

ffff800000106d29 <do_overflow>:
ffff800000106d29:	f3 0f 1e fa          	endbr64 
ffff800000106d2d:	55                   	push   %rbp
ffff800000106d2e:	48 89 e5             	mov    %rsp,%rbp
ffff800000106d31:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106d35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106d39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106d3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d41:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d4c:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106d57:	49 89 c9             	mov    %rcx,%r9
ffff800000106d5a:	49 89 d0             	mov    %rdx,%r8
ffff800000106d5d:	48 89 c1             	mov    %rax,%rcx
ffff800000106d60:	48 b8 68 cb 10 00 00 	movabs $0xffff80000010cb68,%rax
ffff800000106d67:	80 ff ff 
ffff800000106d6a:	48 89 c2             	mov    %rax,%rdx
ffff800000106d6d:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106d74:	80 ff ff 
ffff800000106d77:	48 89 c6             	mov    %rax,%rsi
ffff800000106d7a:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106d81:	80 ff ff 
ffff800000106d84:	48 89 c7             	mov    %rax,%rdi
ffff800000106d87:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106d8c:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106d93:	80 ff ff 
ffff800000106d96:	41 ff d2             	call   *%r10
ffff800000106d99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106d9d:	48 89 c7             	mov    %rax,%rdi
ffff800000106da0:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106da7:	80 ff ff 
ffff800000106daa:	ff d0                	call   *%rax
ffff800000106dac:	f4                   	hlt    
ffff800000106dad:	eb fd                	jmp    ffff800000106dac <do_overflow+0x83>

ffff800000106daf <do_bounds>:
ffff800000106daf:	f3 0f 1e fa          	endbr64 
ffff800000106db3:	55                   	push   %rbp
ffff800000106db4:	48 89 e5             	mov    %rsp,%rbp
ffff800000106db7:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106dbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106dbf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106dc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106dc7:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106dd2:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106ddd:	49 89 c9             	mov    %rcx,%r9
ffff800000106de0:	49 89 d0             	mov    %rdx,%r8
ffff800000106de3:	48 89 c1             	mov    %rax,%rcx
ffff800000106de6:	48 b8 a8 cb 10 00 00 	movabs $0xffff80000010cba8,%rax
ffff800000106ded:	80 ff ff 
ffff800000106df0:	48 89 c2             	mov    %rax,%rdx
ffff800000106df3:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106dfa:	80 ff ff 
ffff800000106dfd:	48 89 c6             	mov    %rax,%rsi
ffff800000106e00:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106e07:	80 ff ff 
ffff800000106e0a:	48 89 c7             	mov    %rax,%rdi
ffff800000106e0d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106e12:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106e19:	80 ff ff 
ffff800000106e1c:	41 ff d2             	call   *%r10
ffff800000106e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e23:	48 89 c7             	mov    %rax,%rdi
ffff800000106e26:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106e2d:	80 ff ff 
ffff800000106e30:	ff d0                	call   *%rax
ffff800000106e32:	f4                   	hlt    
ffff800000106e33:	eb fd                	jmp    ffff800000106e32 <do_bounds+0x83>

ffff800000106e35 <do_undefined_opcode>:
ffff800000106e35:	f3 0f 1e fa          	endbr64 
ffff800000106e39:	55                   	push   %rbp
ffff800000106e3a:	48 89 e5             	mov    %rsp,%rbp
ffff800000106e3d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106e41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106e45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106e49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e4d:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106e54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106e58:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106e63:	49 89 c9             	mov    %rcx,%r9
ffff800000106e66:	49 89 d0             	mov    %rdx,%r8
ffff800000106e69:	48 89 c1             	mov    %rax,%rcx
ffff800000106e6c:	48 b8 e8 cb 10 00 00 	movabs $0xffff80000010cbe8,%rax
ffff800000106e73:	80 ff ff 
ffff800000106e76:	48 89 c2             	mov    %rax,%rdx
ffff800000106e79:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106e80:	80 ff ff 
ffff800000106e83:	48 89 c6             	mov    %rax,%rsi
ffff800000106e86:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106e8d:	80 ff ff 
ffff800000106e90:	48 89 c7             	mov    %rax,%rdi
ffff800000106e93:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106e98:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106e9f:	80 ff ff 
ffff800000106ea2:	41 ff d2             	call   *%r10
ffff800000106ea5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ea9:	48 89 c7             	mov    %rax,%rdi
ffff800000106eac:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106eb3:	80 ff ff 
ffff800000106eb6:	ff d0                	call   *%rax
ffff800000106eb8:	f4                   	hlt    
ffff800000106eb9:	eb fd                	jmp    ffff800000106eb8 <do_undefined_opcode+0x83>

ffff800000106ebb <do_dev_not_available>:
ffff800000106ebb:	f3 0f 1e fa          	endbr64 
ffff800000106ebf:	55                   	push   %rbp
ffff800000106ec0:	48 89 e5             	mov    %rsp,%rbp
ffff800000106ec3:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106ec7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106ecb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ed3:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106ede:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106ee9:	49 89 c9             	mov    %rcx,%r9
ffff800000106eec:	49 89 d0             	mov    %rdx,%r8
ffff800000106eef:	48 89 c1             	mov    %rax,%rcx
ffff800000106ef2:	48 b8 30 cc 10 00 00 	movabs $0xffff80000010cc30,%rax
ffff800000106ef9:	80 ff ff 
ffff800000106efc:	48 89 c2             	mov    %rax,%rdx
ffff800000106eff:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106f06:	80 ff ff 
ffff800000106f09:	48 89 c6             	mov    %rax,%rsi
ffff800000106f0c:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106f13:	80 ff ff 
ffff800000106f16:	48 89 c7             	mov    %rax,%rdi
ffff800000106f19:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106f1e:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106f25:	80 ff ff 
ffff800000106f28:	41 ff d2             	call   *%r10
ffff800000106f2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106f2f:	48 89 c7             	mov    %rax,%rdi
ffff800000106f32:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106f39:	80 ff ff 
ffff800000106f3c:	ff d0                	call   *%rax
ffff800000106f3e:	f4                   	hlt    
ffff800000106f3f:	eb fd                	jmp    ffff800000106f3e <do_dev_not_available+0x83>

ffff800000106f41 <do_double_fault>:
ffff800000106f41:	f3 0f 1e fa          	endbr64 
ffff800000106f45:	55                   	push   %rbp
ffff800000106f46:	48 89 e5             	mov    %rsp,%rbp
ffff800000106f49:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106f4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106f51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106f55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106f59:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106f60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106f64:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106f6f:	49 89 c9             	mov    %rcx,%r9
ffff800000106f72:	49 89 d0             	mov    %rdx,%r8
ffff800000106f75:	48 89 c1             	mov    %rax,%rcx
ffff800000106f78:	48 b8 78 cc 10 00 00 	movabs $0xffff80000010cc78,%rax
ffff800000106f7f:	80 ff ff 
ffff800000106f82:	48 89 c2             	mov    %rax,%rdx
ffff800000106f85:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000106f8c:	80 ff ff 
ffff800000106f8f:	48 89 c6             	mov    %rax,%rsi
ffff800000106f92:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000106f99:	80 ff ff 
ffff800000106f9c:	48 89 c7             	mov    %rax,%rdi
ffff800000106f9f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000106fa4:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000106fab:	80 ff ff 
ffff800000106fae:	41 ff d2             	call   *%r10
ffff800000106fb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106fb5:	48 89 c7             	mov    %rax,%rdi
ffff800000106fb8:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000106fbf:	80 ff ff 
ffff800000106fc2:	ff d0                	call   *%rax
ffff800000106fc4:	f4                   	hlt    
ffff800000106fc5:	eb fd                	jmp    ffff800000106fc4 <do_double_fault+0x83>

ffff800000106fc7 <do_coprocessor_segment_overrun>:
ffff800000106fc7:	f3 0f 1e fa          	endbr64 
ffff800000106fcb:	55                   	push   %rbp
ffff800000106fcc:	48 89 e5             	mov    %rsp,%rbp
ffff800000106fcf:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000106fd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000106fd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000106fdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106fdf:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000106fe6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000106fea:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000106ff1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000106ff5:	49 89 c9             	mov    %rcx,%r9
ffff800000106ff8:	49 89 d0             	mov    %rdx,%r8
ffff800000106ffb:	48 89 c1             	mov    %rax,%rcx
ffff800000106ffe:	48 b8 c0 cc 10 00 00 	movabs $0xffff80000010ccc0,%rax
ffff800000107005:	80 ff ff 
ffff800000107008:	48 89 c2             	mov    %rax,%rdx
ffff80000010700b:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107012:	80 ff ff 
ffff800000107015:	48 89 c6             	mov    %rax,%rsi
ffff800000107018:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff80000010701f:	80 ff ff 
ffff800000107022:	48 89 c7             	mov    %rax,%rdi
ffff800000107025:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010702a:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107031:	80 ff ff 
ffff800000107034:	41 ff d2             	call   *%r10
ffff800000107037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010703b:	48 89 c7             	mov    %rax,%rdi
ffff80000010703e:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107045:	80 ff ff 
ffff800000107048:	ff d0                	call   *%rax
ffff80000010704a:	f4                   	hlt    
ffff80000010704b:	eb fd                	jmp    ffff80000010704a <do_coprocessor_segment_overrun+0x83>

ffff80000010704d <do_invalid_tss>:
ffff80000010704d:	f3 0f 1e fa          	endbr64 
ffff800000107051:	55                   	push   %rbp
ffff800000107052:	48 89 e5             	mov    %rsp,%rbp
ffff800000107055:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107059:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010705d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107065:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff80000010706c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107070:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000107077:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010707b:	49 89 c9             	mov    %rcx,%r9
ffff80000010707e:	49 89 d0             	mov    %rdx,%r8
ffff800000107081:	48 89 c1             	mov    %rax,%rcx
ffff800000107084:	48 b8 18 cd 10 00 00 	movabs $0xffff80000010cd18,%rax
ffff80000010708b:	80 ff ff 
ffff80000010708e:	48 89 c2             	mov    %rax,%rdx
ffff800000107091:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107098:	80 ff ff 
ffff80000010709b:	48 89 c6             	mov    %rax,%rsi
ffff80000010709e:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001070a5:	80 ff ff 
ffff8000001070a8:	48 89 c7             	mov    %rax,%rdi
ffff8000001070ab:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001070b0:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff8000001070b7:	80 ff ff 
ffff8000001070ba:	41 ff d2             	call   *%r10
ffff8000001070bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001070c1:	83 e0 01             	and    $0x1,%eax
ffff8000001070c4:	48 85 c0             	test   %rax,%rax
ffff8000001070c7:	74 38                	je     ffff800000107101 <do_invalid_tss+0xb4>
ffff8000001070c9:	48 b8 58 cd 10 00 00 	movabs $0xffff80000010cd58,%rax
ffff8000001070d0:	80 ff ff 
ffff8000001070d3:	48 89 c2             	mov    %rax,%rdx
ffff8000001070d6:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001070dd:	80 ff ff 
ffff8000001070e0:	48 89 c6             	mov    %rax,%rsi
ffff8000001070e3:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001070ea:	80 ff ff 
ffff8000001070ed:	48 89 c7             	mov    %rax,%rdi
ffff8000001070f0:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001070f5:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001070fc:	80 ff ff 
ffff8000001070ff:	ff d1                	call   *%rcx
ffff800000107101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107105:	83 e0 02             	and    $0x2,%eax
ffff800000107108:	48 85 c0             	test   %rax,%rax
ffff80000010710b:	74 3a                	je     ffff800000107147 <do_invalid_tss+0xfa>
ffff80000010710d:	48 b8 d8 cd 10 00 00 	movabs $0xffff80000010cdd8,%rax
ffff800000107114:	80 ff ff 
ffff800000107117:	48 89 c2             	mov    %rax,%rdx
ffff80000010711a:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107121:	80 ff ff 
ffff800000107124:	48 89 c6             	mov    %rax,%rsi
ffff800000107127:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff80000010712e:	80 ff ff 
ffff800000107131:	48 89 c7             	mov    %rax,%rdi
ffff800000107134:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107139:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107140:	80 ff ff 
ffff800000107143:	ff d1                	call   *%rcx
ffff800000107145:	eb 38                	jmp    ffff80000010717f <do_invalid_tss+0x132>
ffff800000107147:	48 b8 00 ce 10 00 00 	movabs $0xffff80000010ce00,%rax
ffff80000010714e:	80 ff ff 
ffff800000107151:	48 89 c2             	mov    %rax,%rdx
ffff800000107154:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff80000010715b:	80 ff ff 
ffff80000010715e:	48 89 c6             	mov    %rax,%rsi
ffff800000107161:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107168:	80 ff ff 
ffff80000010716b:	48 89 c7             	mov    %rax,%rdi
ffff80000010716e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107173:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff80000010717a:	80 ff ff 
ffff80000010717d:	ff d1                	call   *%rcx
ffff80000010717f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107183:	83 e0 02             	and    $0x2,%eax
ffff800000107186:	48 85 c0             	test   %rax,%rax
ffff800000107189:	75 7e                	jne    ffff800000107209 <do_invalid_tss+0x1bc>
ffff80000010718b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010718f:	83 e0 04             	and    $0x4,%eax
ffff800000107192:	48 85 c0             	test   %rax,%rax
ffff800000107195:	74 3a                	je     ffff8000001071d1 <do_invalid_tss+0x184>
ffff800000107197:	48 b8 40 ce 10 00 00 	movabs $0xffff80000010ce40,%rax
ffff80000010719e:	80 ff ff 
ffff8000001071a1:	48 89 c2             	mov    %rax,%rdx
ffff8000001071a4:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001071ab:	80 ff ff 
ffff8000001071ae:	48 89 c6             	mov    %rax,%rsi
ffff8000001071b1:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001071b8:	80 ff ff 
ffff8000001071bb:	48 89 c7             	mov    %rax,%rdi
ffff8000001071be:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001071c3:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001071ca:	80 ff ff 
ffff8000001071cd:	ff d1                	call   *%rcx
ffff8000001071cf:	eb 38                	jmp    ffff800000107209 <do_invalid_tss+0x1bc>
ffff8000001071d1:	48 b8 78 ce 10 00 00 	movabs $0xffff80000010ce78,%rax
ffff8000001071d8:	80 ff ff 
ffff8000001071db:	48 89 c2             	mov    %rax,%rdx
ffff8000001071de:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001071e5:	80 ff ff 
ffff8000001071e8:	48 89 c6             	mov    %rax,%rsi
ffff8000001071eb:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001071f2:	80 ff ff 
ffff8000001071f5:	48 89 c7             	mov    %rax,%rdi
ffff8000001071f8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001071fd:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107204:	80 ff ff 
ffff800000107207:	ff d1                	call   *%rcx
ffff800000107209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010720d:	25 f8 ff 00 00       	and    $0xfff8,%eax
ffff800000107212:	48 89 c1             	mov    %rax,%rcx
ffff800000107215:	48 b8 a8 ce 10 00 00 	movabs $0xffff80000010cea8,%rax
ffff80000010721c:	80 ff ff 
ffff80000010721f:	48 89 c2             	mov    %rax,%rdx
ffff800000107222:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107229:	80 ff ff 
ffff80000010722c:	48 89 c6             	mov    %rax,%rsi
ffff80000010722f:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107236:	80 ff ff 
ffff800000107239:	48 89 c7             	mov    %rax,%rdi
ffff80000010723c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107241:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff800000107248:	80 ff ff 
ffff80000010724b:	41 ff d0             	call   *%r8
ffff80000010724e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107252:	48 89 c7             	mov    %rax,%rdi
ffff800000107255:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff80000010725c:	80 ff ff 
ffff80000010725f:	ff d0                	call   *%rax
ffff800000107261:	f4                   	hlt    
ffff800000107262:	eb fd                	jmp    ffff800000107261 <do_invalid_tss+0x214>

ffff800000107264 <do_segment_not_present>:
ffff800000107264:	f3 0f 1e fa          	endbr64 
ffff800000107268:	55                   	push   %rbp
ffff800000107269:	48 89 e5             	mov    %rsp,%rbp
ffff80000010726c:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107270:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107274:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010727c:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000107283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107287:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff80000010728e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107292:	49 89 c9             	mov    %rcx,%r9
ffff800000107295:	49 89 d0             	mov    %rdx,%r8
ffff800000107298:	48 89 c1             	mov    %rax,%rcx
ffff80000010729b:	48 b8 c8 ce 10 00 00 	movabs $0xffff80000010cec8,%rax
ffff8000001072a2:	80 ff ff 
ffff8000001072a5:	48 89 c2             	mov    %rax,%rdx
ffff8000001072a8:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001072af:	80 ff ff 
ffff8000001072b2:	48 89 c6             	mov    %rax,%rsi
ffff8000001072b5:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001072bc:	80 ff ff 
ffff8000001072bf:	48 89 c7             	mov    %rax,%rdi
ffff8000001072c2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001072c7:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff8000001072ce:	80 ff ff 
ffff8000001072d1:	41 ff d2             	call   *%r10
ffff8000001072d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001072d8:	83 e0 01             	and    $0x1,%eax
ffff8000001072db:	48 85 c0             	test   %rax,%rax
ffff8000001072de:	74 38                	je     ffff800000107318 <do_segment_not_present+0xb4>
ffff8000001072e0:	48 b8 58 cd 10 00 00 	movabs $0xffff80000010cd58,%rax
ffff8000001072e7:	80 ff ff 
ffff8000001072ea:	48 89 c2             	mov    %rax,%rdx
ffff8000001072ed:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001072f4:	80 ff ff 
ffff8000001072f7:	48 89 c6             	mov    %rax,%rsi
ffff8000001072fa:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107301:	80 ff ff 
ffff800000107304:	48 89 c7             	mov    %rax,%rdi
ffff800000107307:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010730c:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107313:	80 ff ff 
ffff800000107316:	ff d1                	call   *%rcx
ffff800000107318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010731c:	83 e0 02             	and    $0x2,%eax
ffff80000010731f:	48 85 c0             	test   %rax,%rax
ffff800000107322:	74 3a                	je     ffff80000010735e <do_segment_not_present+0xfa>
ffff800000107324:	48 b8 d8 cd 10 00 00 	movabs $0xffff80000010cdd8,%rax
ffff80000010732b:	80 ff ff 
ffff80000010732e:	48 89 c2             	mov    %rax,%rdx
ffff800000107331:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107338:	80 ff ff 
ffff80000010733b:	48 89 c6             	mov    %rax,%rsi
ffff80000010733e:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107345:	80 ff ff 
ffff800000107348:	48 89 c7             	mov    %rax,%rdi
ffff80000010734b:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107350:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107357:	80 ff ff 
ffff80000010735a:	ff d1                	call   *%rcx
ffff80000010735c:	eb 38                	jmp    ffff800000107396 <do_segment_not_present+0x132>
ffff80000010735e:	48 b8 00 ce 10 00 00 	movabs $0xffff80000010ce00,%rax
ffff800000107365:	80 ff ff 
ffff800000107368:	48 89 c2             	mov    %rax,%rdx
ffff80000010736b:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107372:	80 ff ff 
ffff800000107375:	48 89 c6             	mov    %rax,%rsi
ffff800000107378:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff80000010737f:	80 ff ff 
ffff800000107382:	48 89 c7             	mov    %rax,%rdi
ffff800000107385:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010738a:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107391:	80 ff ff 
ffff800000107394:	ff d1                	call   *%rcx
ffff800000107396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010739a:	83 e0 02             	and    $0x2,%eax
ffff80000010739d:	48 85 c0             	test   %rax,%rax
ffff8000001073a0:	75 7e                	jne    ffff800000107420 <do_segment_not_present+0x1bc>
ffff8000001073a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001073a6:	83 e0 04             	and    $0x4,%eax
ffff8000001073a9:	48 85 c0             	test   %rax,%rax
ffff8000001073ac:	74 3a                	je     ffff8000001073e8 <do_segment_not_present+0x184>
ffff8000001073ae:	48 b8 40 ce 10 00 00 	movabs $0xffff80000010ce40,%rax
ffff8000001073b5:	80 ff ff 
ffff8000001073b8:	48 89 c2             	mov    %rax,%rdx
ffff8000001073bb:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001073c2:	80 ff ff 
ffff8000001073c5:	48 89 c6             	mov    %rax,%rsi
ffff8000001073c8:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001073cf:	80 ff ff 
ffff8000001073d2:	48 89 c7             	mov    %rax,%rdi
ffff8000001073d5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001073da:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001073e1:	80 ff ff 
ffff8000001073e4:	ff d1                	call   *%rcx
ffff8000001073e6:	eb 38                	jmp    ffff800000107420 <do_segment_not_present+0x1bc>
ffff8000001073e8:	48 b8 78 ce 10 00 00 	movabs $0xffff80000010ce78,%rax
ffff8000001073ef:	80 ff ff 
ffff8000001073f2:	48 89 c2             	mov    %rax,%rdx
ffff8000001073f5:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001073fc:	80 ff ff 
ffff8000001073ff:	48 89 c6             	mov    %rax,%rsi
ffff800000107402:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107409:	80 ff ff 
ffff80000010740c:	48 89 c7             	mov    %rax,%rdi
ffff80000010740f:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107414:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff80000010741b:	80 ff ff 
ffff80000010741e:	ff d1                	call   *%rcx
ffff800000107420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107424:	25 f8 ff 00 00       	and    $0xfff8,%eax
ffff800000107429:	48 89 c1             	mov    %rax,%rcx
ffff80000010742c:	48 b8 a8 ce 10 00 00 	movabs $0xffff80000010cea8,%rax
ffff800000107433:	80 ff ff 
ffff800000107436:	48 89 c2             	mov    %rax,%rdx
ffff800000107439:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107440:	80 ff ff 
ffff800000107443:	48 89 c6             	mov    %rax,%rsi
ffff800000107446:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff80000010744d:	80 ff ff 
ffff800000107450:	48 89 c7             	mov    %rax,%rdi
ffff800000107453:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107458:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff80000010745f:	80 ff ff 
ffff800000107462:	41 ff d0             	call   *%r8
ffff800000107465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107469:	48 89 c7             	mov    %rax,%rdi
ffff80000010746c:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107473:	80 ff ff 
ffff800000107476:	ff d0                	call   *%rax
ffff800000107478:	f4                   	hlt    
ffff800000107479:	eb fd                	jmp    ffff800000107478 <do_segment_not_present+0x214>

ffff80000010747b <do_stack_segment_fault>:
ffff80000010747b:	f3 0f 1e fa          	endbr64 
ffff80000010747f:	55                   	push   %rbp
ffff800000107480:	48 89 e5             	mov    %rsp,%rbp
ffff800000107483:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107487:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff80000010748b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff80000010748f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107493:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff80000010749a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff80000010749e:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff8000001074a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001074a9:	49 89 c9             	mov    %rcx,%r9
ffff8000001074ac:	49 89 d0             	mov    %rdx,%r8
ffff8000001074af:	48 89 c1             	mov    %rax,%rcx
ffff8000001074b2:	48 b8 18 cf 10 00 00 	movabs $0xffff80000010cf18,%rax
ffff8000001074b9:	80 ff ff 
ffff8000001074bc:	48 89 c2             	mov    %rax,%rdx
ffff8000001074bf:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001074c6:	80 ff ff 
ffff8000001074c9:	48 89 c6             	mov    %rax,%rsi
ffff8000001074cc:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001074d3:	80 ff ff 
ffff8000001074d6:	48 89 c7             	mov    %rax,%rdi
ffff8000001074d9:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001074de:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff8000001074e5:	80 ff ff 
ffff8000001074e8:	41 ff d2             	call   *%r10
ffff8000001074eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001074ef:	83 e0 01             	and    $0x1,%eax
ffff8000001074f2:	48 85 c0             	test   %rax,%rax
ffff8000001074f5:	74 38                	je     ffff80000010752f <do_stack_segment_fault+0xb4>
ffff8000001074f7:	48 b8 58 cd 10 00 00 	movabs $0xffff80000010cd58,%rax
ffff8000001074fe:	80 ff ff 
ffff800000107501:	48 89 c2             	mov    %rax,%rdx
ffff800000107504:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff80000010750b:	80 ff ff 
ffff80000010750e:	48 89 c6             	mov    %rax,%rsi
ffff800000107511:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107518:	80 ff ff 
ffff80000010751b:	48 89 c7             	mov    %rax,%rdi
ffff80000010751e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107523:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff80000010752a:	80 ff ff 
ffff80000010752d:	ff d1                	call   *%rcx
ffff80000010752f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107533:	83 e0 02             	and    $0x2,%eax
ffff800000107536:	48 85 c0             	test   %rax,%rax
ffff800000107539:	74 3a                	je     ffff800000107575 <do_stack_segment_fault+0xfa>
ffff80000010753b:	48 b8 d8 cd 10 00 00 	movabs $0xffff80000010cdd8,%rax
ffff800000107542:	80 ff ff 
ffff800000107545:	48 89 c2             	mov    %rax,%rdx
ffff800000107548:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff80000010754f:	80 ff ff 
ffff800000107552:	48 89 c6             	mov    %rax,%rsi
ffff800000107555:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff80000010755c:	80 ff ff 
ffff80000010755f:	48 89 c7             	mov    %rax,%rdi
ffff800000107562:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107567:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff80000010756e:	80 ff ff 
ffff800000107571:	ff d1                	call   *%rcx
ffff800000107573:	eb 38                	jmp    ffff8000001075ad <do_stack_segment_fault+0x132>
ffff800000107575:	48 b8 00 ce 10 00 00 	movabs $0xffff80000010ce00,%rax
ffff80000010757c:	80 ff ff 
ffff80000010757f:	48 89 c2             	mov    %rax,%rdx
ffff800000107582:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107589:	80 ff ff 
ffff80000010758c:	48 89 c6             	mov    %rax,%rsi
ffff80000010758f:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107596:	80 ff ff 
ffff800000107599:	48 89 c7             	mov    %rax,%rdi
ffff80000010759c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001075a1:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001075a8:	80 ff ff 
ffff8000001075ab:	ff d1                	call   *%rcx
ffff8000001075ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001075b1:	83 e0 02             	and    $0x2,%eax
ffff8000001075b4:	48 85 c0             	test   %rax,%rax
ffff8000001075b7:	75 7e                	jne    ffff800000107637 <do_stack_segment_fault+0x1bc>
ffff8000001075b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001075bd:	83 e0 04             	and    $0x4,%eax
ffff8000001075c0:	48 85 c0             	test   %rax,%rax
ffff8000001075c3:	74 3a                	je     ffff8000001075ff <do_stack_segment_fault+0x184>
ffff8000001075c5:	48 b8 40 ce 10 00 00 	movabs $0xffff80000010ce40,%rax
ffff8000001075cc:	80 ff ff 
ffff8000001075cf:	48 89 c2             	mov    %rax,%rdx
ffff8000001075d2:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001075d9:	80 ff ff 
ffff8000001075dc:	48 89 c6             	mov    %rax,%rsi
ffff8000001075df:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001075e6:	80 ff ff 
ffff8000001075e9:	48 89 c7             	mov    %rax,%rdi
ffff8000001075ec:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001075f1:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001075f8:	80 ff ff 
ffff8000001075fb:	ff d1                	call   *%rcx
ffff8000001075fd:	eb 38                	jmp    ffff800000107637 <do_stack_segment_fault+0x1bc>
ffff8000001075ff:	48 b8 78 ce 10 00 00 	movabs $0xffff80000010ce78,%rax
ffff800000107606:	80 ff ff 
ffff800000107609:	48 89 c2             	mov    %rax,%rdx
ffff80000010760c:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107613:	80 ff ff 
ffff800000107616:	48 89 c6             	mov    %rax,%rsi
ffff800000107619:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107620:	80 ff ff 
ffff800000107623:	48 89 c7             	mov    %rax,%rdi
ffff800000107626:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010762b:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107632:	80 ff ff 
ffff800000107635:	ff d1                	call   *%rcx
ffff800000107637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010763b:	25 f8 ff 00 00       	and    $0xfff8,%eax
ffff800000107640:	48 89 c1             	mov    %rax,%rcx
ffff800000107643:	48 b8 a8 ce 10 00 00 	movabs $0xffff80000010cea8,%rax
ffff80000010764a:	80 ff ff 
ffff80000010764d:	48 89 c2             	mov    %rax,%rdx
ffff800000107650:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107657:	80 ff ff 
ffff80000010765a:	48 89 c6             	mov    %rax,%rsi
ffff80000010765d:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107664:	80 ff ff 
ffff800000107667:	48 89 c7             	mov    %rax,%rdi
ffff80000010766a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010766f:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff800000107676:	80 ff ff 
ffff800000107679:	41 ff d0             	call   *%r8
ffff80000010767c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107680:	48 89 c7             	mov    %rax,%rdi
ffff800000107683:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff80000010768a:	80 ff ff 
ffff80000010768d:	ff d0                	call   *%rax
ffff80000010768f:	f4                   	hlt    
ffff800000107690:	eb fd                	jmp    ffff80000010768f <do_stack_segment_fault+0x214>

ffff800000107692 <do_general_protection>:
ffff800000107692:	f3 0f 1e fa          	endbr64 
ffff800000107696:	55                   	push   %rbp
ffff800000107697:	48 89 e5             	mov    %rsp,%rbp
ffff80000010769a:	48 83 ec 10          	sub    $0x10,%rsp
ffff80000010769e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff8000001076a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff8000001076a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076aa:	48 8b 50 50          	mov    0x50(%rax),%rdx
ffff8000001076ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076b2:	48 8b b0 98 00 00 00 	mov    0x98(%rax),%rsi
ffff8000001076b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001076bd:	48 8b 88 b0 00 00 00 	mov    0xb0(%rax),%rcx
ffff8000001076c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001076c8:	48 83 ec 08          	sub    $0x8,%rsp
ffff8000001076cc:	52                   	push   %rdx
ffff8000001076cd:	49 89 f1             	mov    %rsi,%r9
ffff8000001076d0:	49 89 c8             	mov    %rcx,%r8
ffff8000001076d3:	48 89 c1             	mov    %rax,%rcx
ffff8000001076d6:	48 b8 68 cf 10 00 00 	movabs $0xffff80000010cf68,%rax
ffff8000001076dd:	80 ff ff 
ffff8000001076e0:	48 89 c2             	mov    %rax,%rdx
ffff8000001076e3:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001076ea:	80 ff ff 
ffff8000001076ed:	48 89 c6             	mov    %rax,%rsi
ffff8000001076f0:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001076f7:	80 ff ff 
ffff8000001076fa:	48 89 c7             	mov    %rax,%rdi
ffff8000001076fd:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107702:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107709:	80 ff ff 
ffff80000010770c:	41 ff d2             	call   *%r10
ffff80000010770f:	48 83 c4 10          	add    $0x10,%rsp
ffff800000107713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107717:	83 e0 01             	and    $0x1,%eax
ffff80000010771a:	48 85 c0             	test   %rax,%rax
ffff80000010771d:	74 38                	je     ffff800000107757 <do_general_protection+0xc5>
ffff80000010771f:	48 b8 58 cd 10 00 00 	movabs $0xffff80000010cd58,%rax
ffff800000107726:	80 ff ff 
ffff800000107729:	48 89 c2             	mov    %rax,%rdx
ffff80000010772c:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107733:	80 ff ff 
ffff800000107736:	48 89 c6             	mov    %rax,%rsi
ffff800000107739:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107740:	80 ff ff 
ffff800000107743:	48 89 c7             	mov    %rax,%rdi
ffff800000107746:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010774b:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107752:	80 ff ff 
ffff800000107755:	ff d1                	call   *%rcx
ffff800000107757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010775b:	83 e0 02             	and    $0x2,%eax
ffff80000010775e:	48 85 c0             	test   %rax,%rax
ffff800000107761:	74 3a                	je     ffff80000010779d <do_general_protection+0x10b>
ffff800000107763:	48 b8 d8 cd 10 00 00 	movabs $0xffff80000010cdd8,%rax
ffff80000010776a:	80 ff ff 
ffff80000010776d:	48 89 c2             	mov    %rax,%rdx
ffff800000107770:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107777:	80 ff ff 
ffff80000010777a:	48 89 c6             	mov    %rax,%rsi
ffff80000010777d:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107784:	80 ff ff 
ffff800000107787:	48 89 c7             	mov    %rax,%rdi
ffff80000010778a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010778f:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107796:	80 ff ff 
ffff800000107799:	ff d1                	call   *%rcx
ffff80000010779b:	eb 38                	jmp    ffff8000001077d5 <do_general_protection+0x143>
ffff80000010779d:	48 b8 00 ce 10 00 00 	movabs $0xffff80000010ce00,%rax
ffff8000001077a4:	80 ff ff 
ffff8000001077a7:	48 89 c2             	mov    %rax,%rdx
ffff8000001077aa:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001077b1:	80 ff ff 
ffff8000001077b4:	48 89 c6             	mov    %rax,%rsi
ffff8000001077b7:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001077be:	80 ff ff 
ffff8000001077c1:	48 89 c7             	mov    %rax,%rdi
ffff8000001077c4:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001077c9:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001077d0:	80 ff ff 
ffff8000001077d3:	ff d1                	call   *%rcx
ffff8000001077d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001077d9:	83 e0 02             	and    $0x2,%eax
ffff8000001077dc:	48 85 c0             	test   %rax,%rax
ffff8000001077df:	75 7e                	jne    ffff80000010785f <do_general_protection+0x1cd>
ffff8000001077e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff8000001077e5:	83 e0 04             	and    $0x4,%eax
ffff8000001077e8:	48 85 c0             	test   %rax,%rax
ffff8000001077eb:	74 3a                	je     ffff800000107827 <do_general_protection+0x195>
ffff8000001077ed:	48 b8 40 ce 10 00 00 	movabs $0xffff80000010ce40,%rax
ffff8000001077f4:	80 ff ff 
ffff8000001077f7:	48 89 c2             	mov    %rax,%rdx
ffff8000001077fa:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107801:	80 ff ff 
ffff800000107804:	48 89 c6             	mov    %rax,%rsi
ffff800000107807:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff80000010780e:	80 ff ff 
ffff800000107811:	48 89 c7             	mov    %rax,%rdi
ffff800000107814:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107819:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107820:	80 ff ff 
ffff800000107823:	ff d1                	call   *%rcx
ffff800000107825:	eb 38                	jmp    ffff80000010785f <do_general_protection+0x1cd>
ffff800000107827:	48 b8 78 ce 10 00 00 	movabs $0xffff80000010ce78,%rax
ffff80000010782e:	80 ff ff 
ffff800000107831:	48 89 c2             	mov    %rax,%rdx
ffff800000107834:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff80000010783b:	80 ff ff 
ffff80000010783e:	48 89 c6             	mov    %rax,%rsi
ffff800000107841:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107848:	80 ff ff 
ffff80000010784b:	48 89 c7             	mov    %rax,%rdi
ffff80000010784e:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107853:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff80000010785a:	80 ff ff 
ffff80000010785d:	ff d1                	call   *%rcx
ffff80000010785f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107863:	25 f8 ff 00 00       	and    $0xfff8,%eax
ffff800000107868:	48 89 c1             	mov    %rax,%rcx
ffff80000010786b:	48 b8 a8 ce 10 00 00 	movabs $0xffff80000010cea8,%rax
ffff800000107872:	80 ff ff 
ffff800000107875:	48 89 c2             	mov    %rax,%rdx
ffff800000107878:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff80000010787f:	80 ff ff 
ffff800000107882:	48 89 c6             	mov    %rax,%rsi
ffff800000107885:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff80000010788c:	80 ff ff 
ffff80000010788f:	48 89 c7             	mov    %rax,%rdi
ffff800000107892:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107897:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff80000010789e:	80 ff ff 
ffff8000001078a1:	41 ff d0             	call   *%r8
ffff8000001078a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff8000001078a8:	48 89 c7             	mov    %rax,%rdi
ffff8000001078ab:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff8000001078b2:	80 ff ff 
ffff8000001078b5:	ff d0                	call   *%rax
ffff8000001078b7:	f4                   	hlt    
ffff8000001078b8:	eb fd                	jmp    ffff8000001078b7 <do_general_protection+0x225>

ffff8000001078ba <do_page_fault>:
ffff8000001078ba:	f3 0f 1e fa          	endbr64 
ffff8000001078be:	55                   	push   %rbp
ffff8000001078bf:	48 89 e5             	mov    %rsp,%rbp
ffff8000001078c2:	48 83 ec 20          	sub    $0x20,%rsp
ffff8000001078c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffff8000001078ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffff8000001078ce:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffff8000001078d5:	00 
ffff8000001078d6:	0f 20 d0             	mov    %cr2,%rax
ffff8000001078d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffff8000001078dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001078e1:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff8000001078e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001078ec:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff8000001078f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001078f7:	49 89 c9             	mov    %rcx,%r9
ffff8000001078fa:	49 89 d0             	mov    %rdx,%r8
ffff8000001078fd:	48 89 c1             	mov    %rax,%rcx
ffff800000107900:	48 b8 c0 cf 10 00 00 	movabs $0xffff80000010cfc0,%rax
ffff800000107907:	80 ff ff 
ffff80000010790a:	48 89 c2             	mov    %rax,%rdx
ffff80000010790d:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107914:	80 ff ff 
ffff800000107917:	48 89 c6             	mov    %rax,%rsi
ffff80000010791a:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107921:	80 ff ff 
ffff800000107924:	48 89 c7             	mov    %rax,%rdi
ffff800000107927:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010792c:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107933:	80 ff ff 
ffff800000107936:	41 ff d2             	call   *%r10
ffff800000107939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010793d:	83 e0 01             	and    $0x1,%eax
ffff800000107940:	48 85 c0             	test   %rax,%rax
ffff800000107943:	74 3a                	je     ffff80000010797f <do_page_fault+0xc5>
ffff800000107945:	48 b8 01 d0 10 00 00 	movabs $0xffff80000010d001,%rax
ffff80000010794c:	80 ff ff 
ffff80000010794f:	48 89 c2             	mov    %rax,%rdx
ffff800000107952:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107959:	80 ff ff 
ffff80000010795c:	48 89 c6             	mov    %rax,%rsi
ffff80000010795f:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107966:	80 ff ff 
ffff800000107969:	48 89 c7             	mov    %rax,%rdi
ffff80000010796c:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107971:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107978:	80 ff ff 
ffff80000010797b:	ff d1                	call   *%rcx
ffff80000010797d:	eb 38                	jmp    ffff8000001079b7 <do_page_fault+0xfd>
ffff80000010797f:	48 b8 18 d0 10 00 00 	movabs $0xffff80000010d018,%rax
ffff800000107986:	80 ff ff 
ffff800000107989:	48 89 c2             	mov    %rax,%rdx
ffff80000010798c:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107993:	80 ff ff 
ffff800000107996:	48 89 c6             	mov    %rax,%rsi
ffff800000107999:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001079a0:	80 ff ff 
ffff8000001079a3:	48 89 c7             	mov    %rax,%rdi
ffff8000001079a6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001079ab:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001079b2:	80 ff ff 
ffff8000001079b5:	ff d1                	call   *%rcx
ffff8000001079b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001079bb:	83 e0 02             	and    $0x2,%eax
ffff8000001079be:	48 85 c0             	test   %rax,%rax
ffff8000001079c1:	74 3a                	je     ffff8000001079fd <do_page_fault+0x143>
ffff8000001079c3:	48 b8 44 d0 10 00 00 	movabs $0xffff80000010d044,%rax
ffff8000001079ca:	80 ff ff 
ffff8000001079cd:	48 89 c2             	mov    %rax,%rdx
ffff8000001079d0:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff8000001079d7:	80 ff ff 
ffff8000001079da:	48 89 c6             	mov    %rax,%rsi
ffff8000001079dd:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff8000001079e4:	80 ff ff 
ffff8000001079e7:	48 89 c7             	mov    %rax,%rdi
ffff8000001079ea:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001079ef:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff8000001079f6:	80 ff ff 
ffff8000001079f9:	ff d1                	call   *%rcx
ffff8000001079fb:	eb 38                	jmp    ffff800000107a35 <do_page_fault+0x17b>
ffff8000001079fd:	48 b8 58 d0 10 00 00 	movabs $0xffff80000010d058,%rax
ffff800000107a04:	80 ff ff 
ffff800000107a07:	48 89 c2             	mov    %rax,%rdx
ffff800000107a0a:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107a11:	80 ff ff 
ffff800000107a14:	48 89 c6             	mov    %rax,%rsi
ffff800000107a17:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107a1e:	80 ff ff 
ffff800000107a21:	48 89 c7             	mov    %rax,%rdi
ffff800000107a24:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107a29:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107a30:	80 ff ff 
ffff800000107a33:	ff d1                	call   *%rcx
ffff800000107a35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107a39:	83 e0 04             	and    $0x4,%eax
ffff800000107a3c:	48 85 c0             	test   %rax,%rax
ffff800000107a3f:	74 3a                	je     ffff800000107a7b <do_page_fault+0x1c1>
ffff800000107a41:	48 b8 6b d0 10 00 00 	movabs $0xffff80000010d06b,%rax
ffff800000107a48:	80 ff ff 
ffff800000107a4b:	48 89 c2             	mov    %rax,%rdx
ffff800000107a4e:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107a55:	80 ff ff 
ffff800000107a58:	48 89 c6             	mov    %rax,%rsi
ffff800000107a5b:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107a62:	80 ff ff 
ffff800000107a65:	48 89 c7             	mov    %rax,%rdi
ffff800000107a68:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107a6d:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107a74:	80 ff ff 
ffff800000107a77:	ff d1                	call   *%rcx
ffff800000107a79:	eb 38                	jmp    ffff800000107ab3 <do_page_fault+0x1f9>
ffff800000107a7b:	48 b8 7d d0 10 00 00 	movabs $0xffff80000010d07d,%rax
ffff800000107a82:	80 ff ff 
ffff800000107a85:	48 89 c2             	mov    %rax,%rdx
ffff800000107a88:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107a8f:	80 ff ff 
ffff800000107a92:	48 89 c6             	mov    %rax,%rsi
ffff800000107a95:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107a9c:	80 ff ff 
ffff800000107a9f:	48 89 c7             	mov    %rax,%rdi
ffff800000107aa2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107aa7:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107aae:	80 ff ff 
ffff800000107ab1:	ff d1                	call   *%rcx
ffff800000107ab3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107ab7:	83 e0 08             	and    $0x8,%eax
ffff800000107aba:	48 85 c0             	test   %rax,%rax
ffff800000107abd:	74 38                	je     ffff800000107af7 <do_page_fault+0x23d>
ffff800000107abf:	48 b8 99 d0 10 00 00 	movabs $0xffff80000010d099,%rax
ffff800000107ac6:	80 ff ff 
ffff800000107ac9:	48 89 c2             	mov    %rax,%rdx
ffff800000107acc:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107ad3:	80 ff ff 
ffff800000107ad6:	48 89 c6             	mov    %rax,%rsi
ffff800000107ad9:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107ae0:	80 ff ff 
ffff800000107ae3:	48 89 c7             	mov    %rax,%rdi
ffff800000107ae6:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107aeb:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107af2:	80 ff ff 
ffff800000107af5:	ff d1                	call   *%rcx
ffff800000107af7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff800000107afb:	83 e0 10             	and    $0x10,%eax
ffff800000107afe:	48 85 c0             	test   %rax,%rax
ffff800000107b01:	74 38                	je     ffff800000107b3b <do_page_fault+0x281>
ffff800000107b03:	48 b8 b3 d0 10 00 00 	movabs $0xffff80000010d0b3,%rax
ffff800000107b0a:	80 ff ff 
ffff800000107b0d:	48 89 c2             	mov    %rax,%rdx
ffff800000107b10:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107b17:	80 ff ff 
ffff800000107b1a:	48 89 c6             	mov    %rax,%rsi
ffff800000107b1d:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107b24:	80 ff ff 
ffff800000107b27:	48 89 c7             	mov    %rax,%rdi
ffff800000107b2a:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107b2f:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107b36:	80 ff ff 
ffff800000107b39:	ff d1                	call   *%rcx
ffff800000107b3b:	48 b8 d1 d0 10 00 00 	movabs $0xffff80000010d0d1,%rax
ffff800000107b42:	80 ff ff 
ffff800000107b45:	48 89 c2             	mov    %rax,%rdx
ffff800000107b48:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107b4f:	80 ff ff 
ffff800000107b52:	48 89 c6             	mov    %rax,%rsi
ffff800000107b55:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107b5c:	80 ff ff 
ffff800000107b5f:	48 89 c7             	mov    %rax,%rdi
ffff800000107b62:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107b67:	48 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%rcx
ffff800000107b6e:	80 ff ff 
ffff800000107b71:	ff d1                	call   *%rcx
ffff800000107b73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000107b77:	48 89 c7             	mov    %rax,%rdi
ffff800000107b7a:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107b81:	80 ff ff 
ffff800000107b84:	ff d0                	call   *%rax
ffff800000107b86:	f4                   	hlt    
ffff800000107b87:	eb fd                	jmp    ffff800000107b86 <do_page_fault+0x2cc>

ffff800000107b89 <do_x87_FPU_error>:
ffff800000107b89:	f3 0f 1e fa          	endbr64 
ffff800000107b8d:	55                   	push   %rbp
ffff800000107b8e:	48 89 e5             	mov    %rsp,%rbp
ffff800000107b91:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107b95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107b99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107b9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107ba1:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000107ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107bac:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000107bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107bb7:	49 89 c9             	mov    %rcx,%r9
ffff800000107bba:	49 89 d0             	mov    %rdx,%r8
ffff800000107bbd:	48 89 c1             	mov    %rax,%rcx
ffff800000107bc0:	48 b8 d8 d0 10 00 00 	movabs $0xffff80000010d0d8,%rax
ffff800000107bc7:	80 ff ff 
ffff800000107bca:	48 89 c2             	mov    %rax,%rdx
ffff800000107bcd:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107bd4:	80 ff ff 
ffff800000107bd7:	48 89 c6             	mov    %rax,%rsi
ffff800000107bda:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107be1:	80 ff ff 
ffff800000107be4:	48 89 c7             	mov    %rax,%rdi
ffff800000107be7:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107bec:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107bf3:	80 ff ff 
ffff800000107bf6:	41 ff d2             	call   *%r10
ffff800000107bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107bfd:	48 89 c7             	mov    %rax,%rdi
ffff800000107c00:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107c07:	80 ff ff 
ffff800000107c0a:	ff d0                	call   *%rax
ffff800000107c0c:	f4                   	hlt    
ffff800000107c0d:	eb fd                	jmp    ffff800000107c0c <do_x87_FPU_error+0x83>

ffff800000107c0f <do_alignment_check>:
ffff800000107c0f:	f3 0f 1e fa          	endbr64 
ffff800000107c13:	55                   	push   %rbp
ffff800000107c14:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c17:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107c1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107c1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c27:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000107c2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c32:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000107c39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107c3d:	49 89 c9             	mov    %rcx,%r9
ffff800000107c40:	49 89 d0             	mov    %rdx,%r8
ffff800000107c43:	48 89 c1             	mov    %rax,%rcx
ffff800000107c46:	48 b8 20 d1 10 00 00 	movabs $0xffff80000010d120,%rax
ffff800000107c4d:	80 ff ff 
ffff800000107c50:	48 89 c2             	mov    %rax,%rdx
ffff800000107c53:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107c5a:	80 ff ff 
ffff800000107c5d:	48 89 c6             	mov    %rax,%rsi
ffff800000107c60:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107c67:	80 ff ff 
ffff800000107c6a:	48 89 c7             	mov    %rax,%rdi
ffff800000107c6d:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107c72:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107c79:	80 ff ff 
ffff800000107c7c:	41 ff d2             	call   *%r10
ffff800000107c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107c83:	48 89 c7             	mov    %rax,%rdi
ffff800000107c86:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107c8d:	80 ff ff 
ffff800000107c90:	ff d0                	call   *%rax
ffff800000107c92:	f4                   	hlt    
ffff800000107c93:	eb fd                	jmp    ffff800000107c92 <do_alignment_check+0x83>

ffff800000107c95 <do_machine_check>:
ffff800000107c95:	f3 0f 1e fa          	endbr64 
ffff800000107c99:	55                   	push   %rbp
ffff800000107c9a:	48 89 e5             	mov    %rsp,%rbp
ffff800000107c9d:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107ca1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107ca5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107ca9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107cad:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000107cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107cb8:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000107cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107cc3:	49 89 c9             	mov    %rcx,%r9
ffff800000107cc6:	49 89 d0             	mov    %rdx,%r8
ffff800000107cc9:	48 89 c1             	mov    %rax,%rcx
ffff800000107ccc:	48 b8 68 d1 10 00 00 	movabs $0xffff80000010d168,%rax
ffff800000107cd3:	80 ff ff 
ffff800000107cd6:	48 89 c2             	mov    %rax,%rdx
ffff800000107cd9:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107ce0:	80 ff ff 
ffff800000107ce3:	48 89 c6             	mov    %rax,%rsi
ffff800000107ce6:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107ced:	80 ff ff 
ffff800000107cf0:	48 89 c7             	mov    %rax,%rdi
ffff800000107cf3:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107cf8:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107cff:	80 ff ff 
ffff800000107d02:	41 ff d2             	call   *%r10
ffff800000107d05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d09:	48 89 c7             	mov    %rax,%rdi
ffff800000107d0c:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107d13:	80 ff ff 
ffff800000107d16:	ff d0                	call   *%rax
ffff800000107d18:	f4                   	hlt    
ffff800000107d19:	eb fd                	jmp    ffff800000107d18 <do_machine_check+0x83>

ffff800000107d1b <do_SIMD_exception>:
ffff800000107d1b:	f3 0f 1e fa          	endbr64 
ffff800000107d1f:	55                   	push   %rbp
ffff800000107d20:	48 89 e5             	mov    %rsp,%rbp
ffff800000107d23:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107d27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107d2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d33:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000107d3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d3e:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000107d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107d49:	49 89 c9             	mov    %rcx,%r9
ffff800000107d4c:	49 89 d0             	mov    %rdx,%r8
ffff800000107d4f:	48 89 c1             	mov    %rax,%rcx
ffff800000107d52:	48 b8 b0 d1 10 00 00 	movabs $0xffff80000010d1b0,%rax
ffff800000107d59:	80 ff ff 
ffff800000107d5c:	48 89 c2             	mov    %rax,%rdx
ffff800000107d5f:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107d66:	80 ff ff 
ffff800000107d69:	48 89 c6             	mov    %rax,%rsi
ffff800000107d6c:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107d73:	80 ff ff 
ffff800000107d76:	48 89 c7             	mov    %rax,%rdi
ffff800000107d79:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107d7e:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107d85:	80 ff ff 
ffff800000107d88:	41 ff d2             	call   *%r10
ffff800000107d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107d8f:	48 89 c7             	mov    %rax,%rdi
ffff800000107d92:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107d99:	80 ff ff 
ffff800000107d9c:	ff d0                	call   *%rax
ffff800000107d9e:	f4                   	hlt    
ffff800000107d9f:	eb fd                	jmp    ffff800000107d9e <do_SIMD_exception+0x83>

ffff800000107da1 <do_virtualization_exception>:
ffff800000107da1:	f3 0f 1e fa          	endbr64 
ffff800000107da5:	55                   	push   %rbp
ffff800000107da6:	48 89 e5             	mov    %rsp,%rbp
ffff800000107da9:	48 83 ec 10          	sub    $0x10,%rsp
ffff800000107dad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffff800000107db1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffff800000107db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107db9:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
ffff800000107dc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107dc4:	48 8b 90 b0 00 00 00 	mov    0xb0(%rax),%rdx
ffff800000107dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000107dcf:	49 89 c9             	mov    %rcx,%r9
ffff800000107dd2:	49 89 d0             	mov    %rdx,%r8
ffff800000107dd5:	48 89 c1             	mov    %rax,%rcx
ffff800000107dd8:	48 b8 f8 d1 10 00 00 	movabs $0xffff80000010d1f8,%rax
ffff800000107ddf:	80 ff ff 
ffff800000107de2:	48 89 c2             	mov    %rax,%rdx
ffff800000107de5:	48 b8 78 c9 10 00 00 	movabs $0xffff80000010c978,%rax
ffff800000107dec:	80 ff ff 
ffff800000107def:	48 89 c6             	mov    %rax,%rsi
ffff800000107df2:	48 b8 a2 ca 10 00 00 	movabs $0xffff80000010caa2,%rax
ffff800000107df9:	80 ff ff 
ffff800000107dfc:	48 89 c7             	mov    %rax,%rdi
ffff800000107dff:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000107e04:	49 ba 6f 56 10 00 00 	movabs $0xffff80000010566f,%r10
ffff800000107e0b:	80 ff ff 
ffff800000107e0e:	41 ff d2             	call   *%r10
ffff800000107e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffff800000107e15:	48 89 c7             	mov    %rax,%rdi
ffff800000107e18:	48 b8 5a 69 10 00 00 	movabs $0xffff80000010695a,%rax
ffff800000107e1f:	80 ff ff 
ffff800000107e22:	ff d0                	call   *%rax
ffff800000107e24:	f4                   	hlt    
ffff800000107e25:	eb fd                	jmp    ffff800000107e24 <do_virtualization_exception+0x83>

ffff800000107e27 <sys_vector_init>:
ffff800000107e27:	f3 0f 1e fa          	endbr64 
ffff800000107e2b:	55                   	push   %rbp
ffff800000107e2c:	48 89 e5             	mov    %rsp,%rbp
ffff800000107e2f:	48 b8 7e 40 10 00 00 	movabs $0xffff80000010407e,%rax
ffff800000107e36:	80 ff ff 
ffff800000107e39:	48 89 c2             	mov    %rax,%rdx
ffff800000107e3c:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107e41:	bf 00 00 00 00       	mov    $0x0,%edi
ffff800000107e46:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107e4d:	80 ff ff 
ffff800000107e50:	ff d0                	call   *%rax
ffff800000107e52:	48 b8 6e 40 10 00 00 	movabs $0xffff80000010406e,%rax
ffff800000107e59:	80 ff ff 
ffff800000107e5c:	48 89 c2             	mov    %rax,%rdx
ffff800000107e5f:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107e64:	bf 01 00 00 00       	mov    $0x1,%edi
ffff800000107e69:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107e70:	80 ff ff 
ffff800000107e73:	ff d0                	call   *%rax
ffff800000107e75:	48 b8 8e 40 10 00 00 	movabs $0xffff80000010408e,%rax
ffff800000107e7c:	80 ff ff 
ffff800000107e7f:	48 89 c2             	mov    %rax,%rdx
ffff800000107e82:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107e87:	bf 02 00 00 00       	mov    $0x2,%edi
ffff800000107e8c:	48 b8 90 66 10 00 00 	movabs $0xffff800000106690,%rax
ffff800000107e93:	80 ff ff 
ffff800000107e96:	ff d0                	call   *%rax
ffff800000107e98:	48 b8 d4 40 10 00 00 	movabs $0xffff8000001040d4,%rax
ffff800000107e9f:	80 ff ff 
ffff800000107ea2:	48 89 c2             	mov    %rax,%rdx
ffff800000107ea5:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107eaa:	bf 03 00 00 00       	mov    $0x3,%edi
ffff800000107eaf:	48 b8 83 67 10 00 00 	movabs $0xffff800000106783,%rax
ffff800000107eb6:	80 ff ff 
ffff800000107eb9:	ff d0                	call   *%rax
ffff800000107ebb:	48 b8 e7 40 10 00 00 	movabs $0xffff8000001040e7,%rax
ffff800000107ec2:	80 ff ff 
ffff800000107ec5:	48 89 c2             	mov    %rax,%rdx
ffff800000107ec8:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107ecd:	bf 04 00 00 00       	mov    $0x4,%edi
ffff800000107ed2:	48 b8 83 67 10 00 00 	movabs $0xffff800000106783,%rax
ffff800000107ed9:	80 ff ff 
ffff800000107edc:	ff d0                	call   *%rax
ffff800000107ede:	48 b8 fa 40 10 00 00 	movabs $0xffff8000001040fa,%rax
ffff800000107ee5:	80 ff ff 
ffff800000107ee8:	48 89 c2             	mov    %rax,%rdx
ffff800000107eeb:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107ef0:	bf 05 00 00 00       	mov    $0x5,%edi
ffff800000107ef5:	48 b8 83 67 10 00 00 	movabs $0xffff800000106783,%rax
ffff800000107efc:	80 ff ff 
ffff800000107eff:	ff d0                	call   *%rax
ffff800000107f01:	48 b8 0d 41 10 00 00 	movabs $0xffff80000010410d,%rax
ffff800000107f08:	80 ff ff 
ffff800000107f0b:	48 89 c2             	mov    %rax,%rdx
ffff800000107f0e:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107f13:	bf 06 00 00 00       	mov    $0x6,%edi
ffff800000107f18:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107f1f:	80 ff ff 
ffff800000107f22:	ff d0                	call   *%rax
ffff800000107f24:	48 b8 20 41 10 00 00 	movabs $0xffff800000104120,%rax
ffff800000107f2b:	80 ff ff 
ffff800000107f2e:	48 89 c2             	mov    %rax,%rdx
ffff800000107f31:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107f36:	bf 07 00 00 00       	mov    $0x7,%edi
ffff800000107f3b:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107f42:	80 ff ff 
ffff800000107f45:	ff d0                	call   *%rax
ffff800000107f47:	48 b8 33 41 10 00 00 	movabs $0xffff800000104133,%rax
ffff800000107f4e:	80 ff ff 
ffff800000107f51:	48 89 c2             	mov    %rax,%rdx
ffff800000107f54:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107f59:	bf 08 00 00 00       	mov    $0x8,%edi
ffff800000107f5e:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107f65:	80 ff ff 
ffff800000107f68:	ff d0                	call   *%rax
ffff800000107f6a:	48 b8 44 41 10 00 00 	movabs $0xffff800000104144,%rax
ffff800000107f71:	80 ff ff 
ffff800000107f74:	48 89 c2             	mov    %rax,%rdx
ffff800000107f77:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107f7c:	bf 09 00 00 00       	mov    $0x9,%edi
ffff800000107f81:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107f88:	80 ff ff 
ffff800000107f8b:	ff d0                	call   *%rax
ffff800000107f8d:	48 b8 57 41 10 00 00 	movabs $0xffff800000104157,%rax
ffff800000107f94:	80 ff ff 
ffff800000107f97:	48 89 c2             	mov    %rax,%rdx
ffff800000107f9a:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107f9f:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff800000107fa4:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107fab:	80 ff ff 
ffff800000107fae:	ff d0                	call   *%rax
ffff800000107fb0:	48 b8 68 41 10 00 00 	movabs $0xffff800000104168,%rax
ffff800000107fb7:	80 ff ff 
ffff800000107fba:	48 89 c2             	mov    %rax,%rdx
ffff800000107fbd:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107fc2:	bf 0b 00 00 00       	mov    $0xb,%edi
ffff800000107fc7:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107fce:	80 ff ff 
ffff800000107fd1:	ff d0                	call   *%rax
ffff800000107fd3:	48 b8 79 41 10 00 00 	movabs $0xffff800000104179,%rax
ffff800000107fda:	80 ff ff 
ffff800000107fdd:	48 89 c2             	mov    %rax,%rdx
ffff800000107fe0:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000107fe5:	bf 0c 00 00 00       	mov    $0xc,%edi
ffff800000107fea:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000107ff1:	80 ff ff 
ffff800000107ff4:	ff d0                	call   *%rax
ffff800000107ff6:	48 b8 8a 41 10 00 00 	movabs $0xffff80000010418a,%rax
ffff800000107ffd:	80 ff ff 
ffff800000108000:	48 89 c2             	mov    %rax,%rdx
ffff800000108003:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000108008:	bf 0d 00 00 00       	mov    $0xd,%edi
ffff80000010800d:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000108014:	80 ff ff 
ffff800000108017:	ff d0                	call   *%rax
ffff800000108019:	48 b8 9b 41 10 00 00 	movabs $0xffff80000010419b,%rax
ffff800000108020:	80 ff ff 
ffff800000108023:	48 89 c2             	mov    %rax,%rdx
ffff800000108026:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010802b:	bf 0e 00 00 00       	mov    $0xe,%edi
ffff800000108030:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff800000108037:	80 ff ff 
ffff80000010803a:	ff d0                	call   *%rax
ffff80000010803c:	48 b8 ac 41 10 00 00 	movabs $0xffff8000001041ac,%rax
ffff800000108043:	80 ff ff 
ffff800000108046:	48 89 c2             	mov    %rax,%rdx
ffff800000108049:	be 01 00 00 00       	mov    $0x1,%esi
ffff80000010804e:	bf 10 00 00 00       	mov    $0x10,%edi
ffff800000108053:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff80000010805a:	80 ff ff 
ffff80000010805d:	ff d0                	call   *%rax
ffff80000010805f:	48 b8 bf 41 10 00 00 	movabs $0xffff8000001041bf,%rax
ffff800000108066:	80 ff ff 
ffff800000108069:	48 89 c2             	mov    %rax,%rdx
ffff80000010806c:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000108071:	bf 11 00 00 00       	mov    $0x11,%edi
ffff800000108076:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff80000010807d:	80 ff ff 
ffff800000108080:	ff d0                	call   *%rax
ffff800000108082:	48 b8 d0 41 10 00 00 	movabs $0xffff8000001041d0,%rax
ffff800000108089:	80 ff ff 
ffff80000010808c:	48 89 c2             	mov    %rax,%rdx
ffff80000010808f:	be 01 00 00 00       	mov    $0x1,%esi
ffff800000108094:	bf 12 00 00 00       	mov    $0x12,%edi
ffff800000108099:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff8000001080a0:	80 ff ff 
ffff8000001080a3:	ff d0                	call   *%rax
ffff8000001080a5:	48 b8 e3 41 10 00 00 	movabs $0xffff8000001041e3,%rax
ffff8000001080ac:	80 ff ff 
ffff8000001080af:	48 89 c2             	mov    %rax,%rdx
ffff8000001080b2:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001080b7:	bf 13 00 00 00       	mov    $0x13,%edi
ffff8000001080bc:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff8000001080c3:	80 ff ff 
ffff8000001080c6:	ff d0                	call   *%rax
ffff8000001080c8:	48 b8 f6 41 10 00 00 	movabs $0xffff8000001041f6,%rax
ffff8000001080cf:	80 ff ff 
ffff8000001080d2:	48 89 c2             	mov    %rax,%rdx
ffff8000001080d5:	be 01 00 00 00       	mov    $0x1,%esi
ffff8000001080da:	bf 14 00 00 00       	mov    $0x14,%edi
ffff8000001080df:	48 b8 e1 66 10 00 00 	movabs $0xffff8000001066e1,%rax
ffff8000001080e6:	80 ff ff 
ffff8000001080e9:	ff d0                	call   *%rax
ffff8000001080eb:	90                   	nop
ffff8000001080ec:	5d                   	pop    %rbp
ffff8000001080ed:	c3                   	ret    

ffff8000001080ee <mm_init>:
ffff8000001080ee:	f3 0f 1e fa          	endbr64 
ffff8000001080f2:	55                   	push   %rbp
ffff8000001080f3:	48 89 e5             	mov    %rsp,%rbp
ffff8000001080f6:	48 83 ec 50          	sub    $0x50,%rsp
ffff8000001080fa:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff800000108101:	00 
ffff800000108102:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
ffff800000108109:	00 
ffff80000010810a:	48 b8 e0 ad 10 00 00 	movabs $0xffff80000010ade0,%rax
ffff800000108111:	80 ff ff 
ffff800000108114:	48 8b 00             	mov    (%rax),%rax
ffff800000108117:	48 83 c0 24          	add    $0x24,%rax
ffff80000010811b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffff80000010811f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000108126:	e9 f2 00 00 00       	jmp    ffff80000010821d <mm_init+0x12f>
ffff80000010812b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010812f:	8b 40 10             	mov    0x10(%rax),%eax
ffff800000108132:	83 f8 01             	cmp    $0x1,%eax
ffff800000108135:	75 0e                	jne    ffff800000108145 <mm_init+0x57>
ffff800000108137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff80000010813b:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010813f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
ffff800000108143:	eb 30                	jmp    ffff800000108175 <mm_init+0x87>
ffff800000108145:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108149:	8b 40 10             	mov    0x10(%rax),%eax
ffff80000010814c:	83 f8 04             	cmp    $0x4,%eax
ffff80000010814f:	0f 87 e3 00 00 00    	ja     ffff800000108238 <mm_init+0x14a>
ffff800000108155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108159:	8b 40 10             	mov    0x10(%rax),%eax
ffff80000010815c:	85 c0                	test   %eax,%eax
ffff80000010815e:	0f 84 d4 00 00 00    	je     ffff800000108238 <mm_init+0x14a>
ffff800000108164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108168:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff80000010816c:	48 85 c0             	test   %rax,%rax
ffff80000010816f:	0f 84 c3 00 00 00    	je     ffff800000108238 <mm_init+0x14a>
ffff800000108175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff800000108179:	48 8b 10             	mov    (%rax),%rdx
ffff80000010817c:	48 be e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rsi
ffff800000108183:	80 ff ff 
ffff800000108186:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108189:	48 63 c8             	movslq %eax,%rcx
ffff80000010818c:	48 89 c8             	mov    %rcx,%rax
ffff80000010818f:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108193:	48 01 c8             	add    %rcx,%rax
ffff800000108196:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010819a:	48 01 f0             	add    %rsi,%rax
ffff80000010819d:	48 89 10             	mov    %rdx,(%rax)
ffff8000001081a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001081a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
ffff8000001081a8:	48 be e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rsi
ffff8000001081af:	80 ff ff 
ffff8000001081b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001081b5:	48 63 c8             	movslq %eax,%rcx
ffff8000001081b8:	48 89 c8             	mov    %rcx,%rax
ffff8000001081bb:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001081bf:	48 01 c8             	add    %rcx,%rax
ffff8000001081c2:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001081c6:	48 01 f0             	add    %rsi,%rax
ffff8000001081c9:	48 83 c0 08          	add    $0x8,%rax
ffff8000001081cd:	48 89 10             	mov    %rdx,(%rax)
ffff8000001081d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffff8000001081d4:	8b 50 10             	mov    0x10(%rax),%edx
ffff8000001081d7:	48 be e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rsi
ffff8000001081de:	80 ff ff 
ffff8000001081e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001081e4:	48 63 c8             	movslq %eax,%rcx
ffff8000001081e7:	48 89 c8             	mov    %rcx,%rax
ffff8000001081ea:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001081ee:	48 01 c8             	add    %rcx,%rax
ffff8000001081f1:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001081f5:	48 01 f0             	add    %rsi,%rax
ffff8000001081f8:	48 83 c0 10          	add    $0x10,%rax
ffff8000001081fc:	89 10                	mov    %edx,(%rax)
ffff8000001081fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108201:	48 98                	cltq   
ffff800000108203:	48 ba e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rdx
ffff80000010820a:	80 ff ff 
ffff80000010820d:	48 89 82 80 02 00 00 	mov    %rax,0x280(%rdx)
ffff800000108214:	48 83 45 e8 14       	addq   $0x14,-0x18(%rbp)
ffff800000108219:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010821d:	48 b8 e0 ad 10 00 00 	movabs $0xffff80000010ade0,%rax
ffff800000108224:	80 ff ff 
ffff800000108227:	48 8b 00             	mov    (%rax),%rax
ffff80000010822a:	8b 50 20             	mov    0x20(%rax),%edx
ffff80000010822d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108230:	39 c2                	cmp    %eax,%edx
ffff800000108232:	0f 87 f3 fe ff ff    	ja     ffff80000010812b <mm_init+0x3d>
ffff800000108238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff80000010823c:	48 89 c1             	mov    %rax,%rcx
ffff80000010823f:	48 b8 48 d2 10 00 00 	movabs $0xffff80000010d248,%rax
ffff800000108246:	80 ff ff 
ffff800000108249:	48 89 c2             	mov    %rax,%rdx
ffff80000010824c:	48 b8 6e d2 10 00 00 	movabs $0xffff80000010d26e,%rax
ffff800000108253:	80 ff ff 
ffff800000108256:	48 89 c6             	mov    %rax,%rsi
ffff800000108259:	48 b8 74 d2 10 00 00 	movabs $0xffff80000010d274,%rax
ffff800000108260:	80 ff ff 
ffff800000108263:	48 89 c7             	mov    %rax,%rdi
ffff800000108266:	b8 00 00 00 00       	mov    $0x0,%eax
ffff80000010826b:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff800000108272:	80 ff ff 
ffff800000108275:	41 ff d0             	call   *%r8
ffff800000108278:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffff80000010827f:	00 
ffff800000108280:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000108287:	e9 e1 00 00 00       	jmp    ffff80000010836d <mm_init+0x27f>
ffff80000010828c:	48 b9 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rcx
ffff800000108293:	80 ff ff 
ffff800000108296:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108299:	48 63 d0             	movslq %eax,%rdx
ffff80000010829c:	48 89 d0             	mov    %rdx,%rax
ffff80000010829f:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001082a3:	48 01 d0             	add    %rdx,%rax
ffff8000001082a6:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001082aa:	48 01 c8             	add    %rcx,%rax
ffff8000001082ad:	48 83 c0 10          	add    $0x10,%rax
ffff8000001082b1:	8b 00                	mov    (%rax),%eax
ffff8000001082b3:	83 f8 01             	cmp    $0x1,%eax
ffff8000001082b6:	0f 85 a9 00 00 00    	jne    ffff800000108365 <mm_init+0x277>
ffff8000001082bc:	48 b9 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rcx
ffff8000001082c3:	80 ff ff 
ffff8000001082c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001082c9:	48 63 d0             	movslq %eax,%rdx
ffff8000001082cc:	48 89 d0             	mov    %rdx,%rax
ffff8000001082cf:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001082d3:	48 01 d0             	add    %rdx,%rax
ffff8000001082d6:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001082da:	48 01 c8             	add    %rcx,%rax
ffff8000001082dd:	48 8b 00             	mov    (%rax),%rax
ffff8000001082e0:	48 05 ff ff 1f 00    	add    $0x1fffff,%rax
ffff8000001082e6:	48 25 00 00 e0 ff    	and    $0xffffffffffe00000,%rax
ffff8000001082ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffff8000001082f0:	48 b9 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rcx
ffff8000001082f7:	80 ff ff 
ffff8000001082fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001082fd:	48 63 d0             	movslq %eax,%rdx
ffff800000108300:	48 89 d0             	mov    %rdx,%rax
ffff800000108303:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108307:	48 01 d0             	add    %rdx,%rax
ffff80000010830a:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010830e:	48 01 c8             	add    %rcx,%rax
ffff800000108311:	48 8b 08             	mov    (%rax),%rcx
ffff800000108314:	48 be e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rsi
ffff80000010831b:	80 ff ff 
ffff80000010831e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108321:	48 63 d0             	movslq %eax,%rdx
ffff800000108324:	48 89 d0             	mov    %rdx,%rax
ffff800000108327:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010832b:	48 01 d0             	add    %rdx,%rax
ffff80000010832e:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108332:	48 01 f0             	add    %rsi,%rax
ffff800000108335:	48 83 c0 08          	add    $0x8,%rax
ffff800000108339:	48 8b 00             	mov    (%rax),%rax
ffff80000010833c:	48 01 c8             	add    %rcx,%rax
ffff80000010833f:	48 25 00 00 e0 ff    	and    $0xffffffffffe00000,%rax
ffff800000108345:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
ffff800000108349:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff80000010834d:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
ffff800000108351:	76 15                	jbe    ffff800000108368 <mm_init+0x27a>
ffff800000108353:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffff800000108357:	48 2b 45 c0          	sub    -0x40(%rbp),%rax
ffff80000010835b:	48 c1 e8 15          	shr    $0x15,%rax
ffff80000010835f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
ffff800000108363:	eb 04                	jmp    ffff800000108369 <mm_init+0x27b>
ffff800000108365:	90                   	nop
ffff800000108366:	eb 01                	jmp    ffff800000108369 <mm_init+0x27b>
ffff800000108368:	90                   	nop
ffff800000108369:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff80000010836d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108370:	48 63 d0             	movslq %eax,%rdx
ffff800000108373:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010837a:	80 ff ff 
ffff80000010837d:	48 8b 80 80 02 00 00 	mov    0x280(%rax),%rax
ffff800000108384:	48 39 c2             	cmp    %rax,%rdx
ffff800000108387:	0f 86 ff fe ff ff    	jbe    ffff80000010828c <mm_init+0x19e>
ffff80000010838d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffff800000108391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108395:	49 89 d0             	mov    %rdx,%r8
ffff800000108398:	48 89 c1             	mov    %rax,%rcx
ffff80000010839b:	48 b8 80 d2 10 00 00 	movabs $0xffff80000010d280,%rax
ffff8000001083a2:	80 ff ff 
ffff8000001083a5:	48 89 c2             	mov    %rax,%rdx
ffff8000001083a8:	48 b8 6e d2 10 00 00 	movabs $0xffff80000010d26e,%rax
ffff8000001083af:	80 ff ff 
ffff8000001083b2:	48 89 c6             	mov    %rax,%rsi
ffff8000001083b5:	48 b8 ab d2 10 00 00 	movabs $0xffff80000010d2ab,%rax
ffff8000001083bc:	80 ff ff 
ffff8000001083bf:	48 89 c7             	mov    %rax,%rdi
ffff8000001083c2:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001083c7:	49 b9 6f 56 10 00 00 	movabs $0xffff80000010566f,%r9
ffff8000001083ce:	80 ff ff 
ffff8000001083d1:	41 ff d1             	call   *%r9
ffff8000001083d4:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001083db:	80 ff ff 
ffff8000001083de:	48 8b 90 80 02 00 00 	mov    0x280(%rax),%rdx
ffff8000001083e5:	48 b9 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rcx
ffff8000001083ec:	80 ff ff 
ffff8000001083ef:	48 89 d0             	mov    %rdx,%rax
ffff8000001083f2:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001083f6:	48 01 d0             	add    %rdx,%rax
ffff8000001083f9:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001083fd:	48 01 c8             	add    %rcx,%rax
ffff800000108400:	48 8b 08             	mov    (%rax),%rcx
ffff800000108403:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010840a:	80 ff ff 
ffff80000010840d:	48 8b 90 80 02 00 00 	mov    0x280(%rax),%rdx
ffff800000108414:	48 be e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rsi
ffff80000010841b:	80 ff ff 
ffff80000010841e:	48 89 d0             	mov    %rdx,%rax
ffff800000108421:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108425:	48 01 d0             	add    %rdx,%rax
ffff800000108428:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010842c:	48 01 f0             	add    %rsi,%rax
ffff80000010842f:	48 83 c0 08          	add    $0x8,%rax
ffff800000108433:	48 8b 00             	mov    (%rax),%rax
ffff800000108436:	48 01 c8             	add    %rcx,%rax
ffff800000108439:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffff80000010843d:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108444:	80 ff ff 
ffff800000108447:	48 8b 80 f8 02 00 00 	mov    0x2f8(%rax),%rax
ffff80000010844e:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff800000108454:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff80000010845a:	48 89 c2             	mov    %rax,%rdx
ffff80000010845d:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108464:	80 ff ff 
ffff800000108467:	48 89 90 88 02 00 00 	mov    %rdx,0x288(%rax)
ffff80000010846e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffff800000108472:	48 c1 e8 15          	shr    $0x15,%rax
ffff800000108476:	48 89 c2             	mov    %rax,%rdx
ffff800000108479:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108480:	80 ff ff 
ffff800000108483:	48 89 90 90 02 00 00 	mov    %rdx,0x290(%rax)
ffff80000010848a:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108491:	80 ff ff 
ffff800000108494:	48 8b 80 90 02 00 00 	mov    0x290(%rax),%rax
ffff80000010849b:	48 83 c0 07          	add    $0x7,%rax
ffff80000010849f:	48 c1 e8 03          	shr    $0x3,%rax
ffff8000001084a3:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffff8000001084a7:	48 89 c2             	mov    %rax,%rdx
ffff8000001084aa:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001084b1:	80 ff ff 
ffff8000001084b4:	48 89 90 98 02 00 00 	mov    %rdx,0x298(%rax)
ffff8000001084bb:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001084c2:	80 ff ff 
ffff8000001084c5:	48 8b 80 98 02 00 00 	mov    0x298(%rax),%rax
ffff8000001084cc:	48 89 c2             	mov    %rax,%rdx
ffff8000001084cf:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001084d6:	80 ff ff 
ffff8000001084d9:	48 8b 80 88 02 00 00 	mov    0x288(%rax),%rax
ffff8000001084e0:	be ff 00 00 00       	mov    $0xff,%esi
ffff8000001084e5:	48 89 c7             	mov    %rax,%rdi
ffff8000001084e8:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff8000001084ef:	80 ff ff 
ffff8000001084f2:	ff d0                	call   *%rax
ffff8000001084f4:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001084fb:	80 ff ff 
ffff8000001084fe:	48 8b 80 88 02 00 00 	mov    0x288(%rax),%rax
ffff800000108505:	48 89 c2             	mov    %rax,%rdx
ffff800000108508:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010850f:	80 ff ff 
ffff800000108512:	48 8b 80 98 02 00 00 	mov    0x298(%rax),%rax
ffff800000108519:	48 01 d0             	add    %rdx,%rax
ffff80000010851c:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff800000108522:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff800000108528:	48 89 c2             	mov    %rax,%rdx
ffff80000010852b:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108532:	80 ff ff 
ffff800000108535:	48 89 90 a0 02 00 00 	mov    %rdx,0x2a0(%rax)
ffff80000010853c:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108543:	80 ff ff 
ffff800000108546:	48 8b 80 90 02 00 00 	mov    0x290(%rax),%rax
ffff80000010854d:	48 ba e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rdx
ffff800000108554:	80 ff ff 
ffff800000108557:	48 89 82 a8 02 00 00 	mov    %rax,0x2a8(%rdx)
ffff80000010855e:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108565:	80 ff ff 
ffff800000108568:	48 8b 90 a8 02 00 00 	mov    0x2a8(%rax),%rdx
ffff80000010856f:	48 89 d0             	mov    %rdx,%rax
ffff800000108572:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108576:	48 01 d0             	add    %rdx,%rax
ffff800000108579:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010857d:	48 83 c0 07          	add    $0x7,%rax
ffff800000108581:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffff800000108585:	48 89 c2             	mov    %rax,%rdx
ffff800000108588:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010858f:	80 ff ff 
ffff800000108592:	48 89 90 b0 02 00 00 	mov    %rdx,0x2b0(%rax)
ffff800000108599:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001085a0:	80 ff ff 
ffff8000001085a3:	48 8b 80 b0 02 00 00 	mov    0x2b0(%rax),%rax
ffff8000001085aa:	48 89 c2             	mov    %rax,%rdx
ffff8000001085ad:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001085b4:	80 ff ff 
ffff8000001085b7:	48 8b 80 a0 02 00 00 	mov    0x2a0(%rax),%rax
ffff8000001085be:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001085c3:	48 89 c7             	mov    %rax,%rdi
ffff8000001085c6:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff8000001085cd:	80 ff ff 
ffff8000001085d0:	ff d0                	call   *%rax
ffff8000001085d2:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001085d9:	80 ff ff 
ffff8000001085dc:	48 8b 80 a0 02 00 00 	mov    0x2a0(%rax),%rax
ffff8000001085e3:	48 89 c2             	mov    %rax,%rdx
ffff8000001085e6:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001085ed:	80 ff ff 
ffff8000001085f0:	48 8b 80 b0 02 00 00 	mov    0x2b0(%rax),%rax
ffff8000001085f7:	48 01 d0             	add    %rdx,%rax
ffff8000001085fa:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffff800000108600:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffff800000108606:	48 89 c2             	mov    %rax,%rdx
ffff800000108609:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108610:	80 ff ff 
ffff800000108613:	48 89 90 b8 02 00 00 	mov    %rdx,0x2b8(%rax)
ffff80000010861a:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108621:	80 ff ff 
ffff800000108624:	48 c7 80 c0 02 00 00 	movq   $0x0,0x2c0(%rax)
ffff80000010862b:	00 00 00 00 
ffff80000010862f:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108636:	80 ff ff 
ffff800000108639:	48 c7 80 c8 02 00 00 	movq   $0x190,0x2c8(%rax)
ffff800000108640:	90 01 00 00 
ffff800000108644:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010864b:	80 ff ff 
ffff80000010864e:	48 8b 80 c8 02 00 00 	mov    0x2c8(%rax),%rax
ffff800000108655:	48 89 c2             	mov    %rax,%rdx
ffff800000108658:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010865f:	80 ff ff 
ffff800000108662:	48 8b 80 b8 02 00 00 	mov    0x2b8(%rax),%rax
ffff800000108669:	be 00 00 00 00       	mov    $0x0,%esi
ffff80000010866e:	48 89 c7             	mov    %rax,%rdi
ffff800000108671:	48 b8 46 54 10 00 00 	movabs $0xffff800000105446,%rax
ffff800000108678:	80 ff ff 
ffff80000010867b:	ff d0                	call   *%rax
ffff80000010867d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffff800000108684:	e9 4c 02 00 00       	jmp    ffff8000001088d5 <mm_init+0x7e7>
ffff800000108689:	48 b9 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rcx
ffff800000108690:	80 ff ff 
ffff800000108693:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff800000108696:	48 63 d0             	movslq %eax,%rdx
ffff800000108699:	48 89 d0             	mov    %rdx,%rax
ffff80000010869c:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001086a0:	48 01 d0             	add    %rdx,%rax
ffff8000001086a3:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001086a7:	48 01 c8             	add    %rcx,%rax
ffff8000001086aa:	48 83 c0 10          	add    $0x10,%rax
ffff8000001086ae:	8b 00                	mov    (%rax),%eax
ffff8000001086b0:	83 f8 01             	cmp    $0x1,%eax
ffff8000001086b3:	0f 85 14 02 00 00    	jne    ffff8000001088cd <mm_init+0x7df>
ffff8000001086b9:	48 b9 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rcx
ffff8000001086c0:	80 ff ff 
ffff8000001086c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001086c6:	48 63 d0             	movslq %eax,%rdx
ffff8000001086c9:	48 89 d0             	mov    %rdx,%rax
ffff8000001086cc:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001086d0:	48 01 d0             	add    %rdx,%rax
ffff8000001086d3:	48 c1 e0 02          	shl    $0x2,%rax
ffff8000001086d7:	48 01 c8             	add    %rcx,%rax
ffff8000001086da:	48 8b 00             	mov    (%rax),%rax
ffff8000001086dd:	48 05 ff ff 1f 00    	add    $0x1fffff,%rax
ffff8000001086e3:	48 25 00 00 e0 ff    	and    $0xffffffffffe00000,%rax
ffff8000001086e9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffff8000001086ed:	48 b9 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rcx
ffff8000001086f4:	80 ff ff 
ffff8000001086f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001086fa:	48 63 d0             	movslq %eax,%rdx
ffff8000001086fd:	48 89 d0             	mov    %rdx,%rax
ffff800000108700:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108704:	48 01 d0             	add    %rdx,%rax
ffff800000108707:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010870b:	48 01 c8             	add    %rcx,%rax
ffff80000010870e:	48 8b 08             	mov    (%rax),%rcx
ffff800000108711:	48 be e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rsi
ffff800000108718:	80 ff ff 
ffff80000010871b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff80000010871e:	48 63 d0             	movslq %eax,%rdx
ffff800000108721:	48 89 d0             	mov    %rdx,%rax
ffff800000108724:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108728:	48 01 d0             	add    %rdx,%rax
ffff80000010872b:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010872f:	48 01 f0             	add    %rsi,%rax
ffff800000108732:	48 83 c0 08          	add    $0x8,%rax
ffff800000108736:	48 8b 00             	mov    (%rax),%rax
ffff800000108739:	48 01 c8             	add    %rcx,%rax
ffff80000010873c:	48 25 00 00 e0 ff    	and    $0xffffffffffe00000,%rax
ffff800000108742:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ffff800000108746:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010874a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
ffff80000010874e:	0f 86 7c 01 00 00    	jbe    ffff8000001088d0 <mm_init+0x7e2>
ffff800000108754:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010875b:	80 ff ff 
ffff80000010875e:	48 8b 88 b8 02 00 00 	mov    0x2b8(%rax),%rcx
ffff800000108765:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff80000010876c:	80 ff ff 
ffff80000010876f:	48 8b 90 c0 02 00 00 	mov    0x2c0(%rax),%rdx
ffff800000108776:	48 89 d0             	mov    %rdx,%rax
ffff800000108779:	48 c1 e0 02          	shl    $0x2,%rax
ffff80000010877d:	48 01 d0             	add    %rdx,%rax
ffff800000108780:	48 c1 e0 04          	shl    $0x4,%rax
ffff800000108784:	48 01 c8             	add    %rcx,%rax
ffff800000108787:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffff80000010878b:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108792:	80 ff ff 
ffff800000108795:	48 8b 80 c0 02 00 00 	mov    0x2c0(%rax),%rax
ffff80000010879c:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffff8000001087a0:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001087a7:	80 ff ff 
ffff8000001087aa:	48 89 90 c0 02 00 00 	mov    %rdx,0x2c0(%rax)
ffff8000001087b1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001087b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffff8000001087b9:	48 89 50 10          	mov    %rdx,0x10(%rax)
ffff8000001087bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001087c1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffff8000001087c5:	48 89 50 18          	mov    %rdx,0x18(%rax)
ffff8000001087c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001087cd:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
ffff8000001087d1:	48 89 c2             	mov    %rax,%rdx
ffff8000001087d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001087d8:	48 89 50 20          	mov    %rdx,0x20(%rax)
ffff8000001087dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001087e0:	48 c7 40 38 00 00 00 	movq   $0x0,0x38(%rax)
ffff8000001087e7:	00 
ffff8000001087e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff8000001087ec:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
ffff8000001087f0:	48 c1 e8 15          	shr    $0x15,%rax
ffff8000001087f4:	48 89 c2             	mov    %rax,%rdx
ffff8000001087f7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001087fb:	48 89 50 40          	mov    %rdx,0x40(%rax)
ffff8000001087ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108803:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
ffff80000010880a:	00 
ffff80000010880b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010880f:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
ffff800000108816:	00 
ffff800000108817:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010881b:	48 bf e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rdi
ffff800000108822:	80 ff ff 
ffff800000108825:	48 89 78 30          	mov    %rdi,0x30(%rax)
ffff800000108829:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffff80000010882d:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
ffff800000108831:	48 c1 e8 15          	shr    $0x15,%rax
ffff800000108835:	48 89 c2             	mov    %rax,%rdx
ffff800000108838:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff80000010883c:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff800000108840:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff800000108847:	80 ff ff 
ffff80000010884a:	48 8b 88 a0 02 00 00 	mov    0x2a0(%rax),%rcx
ffff800000108851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff800000108855:	48 c1 e8 15          	shr    $0x15,%rax
ffff800000108859:	48 89 c2             	mov    %rax,%rdx
ffff80000010885c:	48 89 d0             	mov    %rdx,%rax
ffff80000010885f:	48 c1 e0 02          	shl    $0x2,%rax
ffff800000108863:	48 01 d0             	add    %rdx,%rax
ffff800000108866:	48 c1 e0 03          	shl    $0x3,%rax
ffff80000010886a:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
ffff80000010886e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108872:	48 89 10             	mov    %rdx,(%rax)
ffff800000108875:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff800000108879:	48 8b 00             	mov    (%rax),%rax
ffff80000010887c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffff800000108880:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffff800000108887:	eb 2f                	jmp    ffff8000001088b8 <mm_init+0x7ca>
ffff800000108889:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff80000010888d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffff800000108891:	48 89 10             	mov    %rdx,(%rax)
ffff800000108894:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff800000108897:	48 98                	cltq   
ffff800000108899:	48 c1 e0 15          	shl    $0x15,%rax
ffff80000010889d:	48 89 c2             	mov    %rax,%rdx
ffff8000001088a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffff8000001088a4:	48 01 c2             	add    %rax,%rdx
ffff8000001088a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffff8000001088ab:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffff8000001088af:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffff8000001088b3:	48 83 45 e0 28       	addq   $0x28,-0x20(%rbp)
ffff8000001088b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffff8000001088bb:	48 63 d0             	movslq %eax,%rdx
ffff8000001088be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffff8000001088c2:	48 8b 40 08          	mov    0x8(%rax),%rax
ffff8000001088c6:	48 39 c2             	cmp    %rax,%rdx
ffff8000001088c9:	72 be                	jb     ffff800000108889 <mm_init+0x79b>
ffff8000001088cb:	eb 04                	jmp    ffff8000001088d1 <mm_init+0x7e3>
ffff8000001088cd:	90                   	nop
ffff8000001088ce:	eb 01                	jmp    ffff8000001088d1 <mm_init+0x7e3>
ffff8000001088d0:	90                   	nop
ffff8000001088d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffff8000001088d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffff8000001088d8:	48 63 d0             	movslq %eax,%rdx
ffff8000001088db:	48 b8 e0 eb 10 00 00 	movabs $0xffff80000010ebe0,%rax
ffff8000001088e2:	80 ff ff 
ffff8000001088e5:	48 8b 80 80 02 00 00 	mov    0x280(%rax),%rax
ffff8000001088ec:	48 39 c2             	cmp    %rax,%rdx
ffff8000001088ef:	0f 86 94 fd ff ff    	jbe    ffff800000108689 <mm_init+0x59b>
ffff8000001088f5:	90                   	nop
ffff8000001088f6:	c9                   	leave  
ffff8000001088f7:	c3                   	ret    

ffff8000001088f8 <kernel>:
ffff8000001088f8:	f3 0f 1e fa          	endbr64 
ffff8000001088fc:	55                   	push   %rbp
ffff8000001088fd:	48 89 e5             	mov    %rsp,%rbp
ffff800000108900:	48 81 ec 00 02 00 00 	sub    $0x200,%rsp
ffff800000108907:	48 c7 85 00 fe ff ff 	movq   $0x0,-0x200(%rbp)
ffff80000010890e:	00 00 00 00 
ffff800000108912:	48 c7 85 08 fe ff ff 	movq   $0x0,-0x1f8(%rbp)
ffff800000108919:	00 00 00 00 
ffff80000010891d:	48 8d 95 10 fe ff ff 	lea    -0x1f0(%rbp),%rdx
ffff800000108924:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108929:	b9 3e 00 00 00       	mov    $0x3e,%ecx
ffff80000010892e:	48 89 d7             	mov    %rdx,%rdi
ffff800000108931:	f3 48 ab             	rep stos %rax,%es:(%rdi)
ffff800000108934:	48 8d 85 00 fe ff ff 	lea    -0x200(%rbp),%rax
ffff80000010893b:	ba 07 00 00 00       	mov    $0x7,%edx
ffff800000108940:	48 b9 b1 d2 10 00 00 	movabs $0xffff80000010d2b1,%rcx
ffff800000108947:	80 ff ff 
ffff80000010894a:	48 89 ce             	mov    %rcx,%rsi
ffff80000010894d:	48 89 c7             	mov    %rax,%rdi
ffff800000108950:	48 b8 f3 53 10 00 00 	movabs $0xffff8000001053f3,%rax
ffff800000108957:	80 ff ff 
ffff80000010895a:	ff d0                	call   *%rax
ffff80000010895c:	48 b8 cb 57 10 00 00 	movabs $0xffff8000001057cb,%rax
ffff800000108963:	80 ff ff 
ffff800000108966:	ff d0                	call   *%rax
ffff800000108968:	48 b8 86 58 10 00 00 	movabs $0xffff800000105886,%rax
ffff80000010896f:	80 ff ff 
ffff800000108972:	ff d0                	call   *%rax
ffff800000108974:	48 8d 85 00 fe ff ff 	lea    -0x200(%rbp),%rax
ffff80000010897b:	48 89 c1             	mov    %rax,%rcx
ffff80000010897e:	48 b8 b8 d2 10 00 00 	movabs $0xffff80000010d2b8,%rax
ffff800000108985:	80 ff ff 
ffff800000108988:	48 89 c2             	mov    %rax,%rdx
ffff80000010898b:	48 b8 bb d2 10 00 00 	movabs $0xffff80000010d2bb,%rax
ffff800000108992:	80 ff ff 
ffff800000108995:	48 89 c6             	mov    %rax,%rsi
ffff800000108998:	48 b8 c1 d2 10 00 00 	movabs $0xffff80000010d2c1,%rax
ffff80000010899f:	80 ff ff 
ffff8000001089a2:	48 89 c7             	mov    %rax,%rdi
ffff8000001089a5:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001089aa:	49 b8 6f 56 10 00 00 	movabs $0xffff80000010566f,%r8
ffff8000001089b1:	80 ff ff 
ffff8000001089b4:	41 ff d0             	call   *%r8
ffff8000001089b7:	48 8d 85 00 fe ff ff 	lea    -0x200(%rbp),%rax
ffff8000001089be:	48 89 c1             	mov    %rax,%rcx
ffff8000001089c1:	48 b8 c7 d2 10 00 00 	movabs $0xffff80000010d2c7,%rax
ffff8000001089c8:	80 ff ff 
ffff8000001089cb:	48 89 c2             	mov    %rax,%rdx
ffff8000001089ce:	be 00 00 00 00       	mov    $0x0,%esi
ffff8000001089d3:	bf 00 ff ff 00       	mov    $0xffff00,%edi
ffff8000001089d8:	b8 00 00 00 00       	mov    $0x0,%eax
ffff8000001089dd:	49 b8 98 5b 10 00 00 	movabs $0xffff800000105b98,%r8
ffff8000001089e4:	80 ff ff 
ffff8000001089e7:	41 ff d0             	call   *%r8
ffff8000001089ea:	48 b8 00 ae 10 00 00 	movabs $0xffff80000010ae00,%rax
ffff8000001089f1:	80 ff ff 
ffff8000001089f4:	48 89 c6             	mov    %rax,%rsi
ffff8000001089f7:	bf 0a 00 00 00       	mov    $0xa,%edi
ffff8000001089fc:	48 b8 8d 68 10 00 00 	movabs $0xffff80000010688d,%rax
ffff800000108a03:	80 ff ff 
ffff800000108a06:	ff d0                	call   *%rax
ffff800000108a08:	b8 50 00 00 00       	mov    $0x50,%eax
ffff800000108a0d:	0f 00 d8             	ltr    %ax
ffff800000108a10:	b8 00 00 00 00       	mov    $0x0,%eax
ffff800000108a15:	48 ba 27 7e 10 00 00 	movabs $0xffff800000107e27,%rdx
ffff800000108a1c:	80 ff ff 
ffff800000108a1f:	ff d2                	call   *%rdx
ffff800000108a21:	48 b8 4b 61 10 00 00 	movabs $0xffff80000010614b,%rax
ffff800000108a28:	80 ff ff 
ffff800000108a2b:	ff d0                	call   *%rax
ffff800000108a2d:	48 b8 ee 80 10 00 00 	movabs $0xffff8000001080ee,%rax
ffff800000108a34:	80 ff ff 
ffff800000108a37:	ff d0                	call   *%rax
ffff800000108a39:	eb fe                	jmp    ffff800000108a39 <kernel+0x141>

Disassembly of section .data:

ffff800000108a40 <_data>:
	...
ffff800000108a4c:	00 98 20 00 00 00    	add    %bl,0x20(%rax)
ffff800000108a52:	00 00                	add    %al,(%rax)
ffff800000108a54:	00 92 00 00 00 00    	add    %dl,0x0(%rdx)
	...
ffff800000108a6a:	00 00                	add    %al,(%rax)
ffff800000108a6c:	00 f8                	add    %bh,%al
ffff800000108a6e:	20 00                	and    %al,(%rax)
ffff800000108a70:	00 00                	add    %al,(%rax)
ffff800000108a72:	00 00                	add    %al,(%rax)
ffff800000108a74:	00 f2                	add    %dh,%dl
ffff800000108a76:	00 00                	add    %al,(%rax)
ffff800000108a78:	ff                   	(bad)  
ffff800000108a79:	ff 00                	incl   (%rax)
ffff800000108a7b:	00 00                	add    %al,(%rax)
ffff800000108a7d:	9a                   	(bad)  
ffff800000108a7e:	cf                   	iret   
ffff800000108a7f:	00 ff                	add    %bh,%bh
ffff800000108a81:	ff 00                	incl   (%rax)
ffff800000108a83:	00 00                	add    %al,(%rax)
ffff800000108a85:	92                   	xchg   %eax,%edx
ffff800000108a86:	cf                   	iret   
	...

ffff800000108db0 <gdt_end>:
ffff800000108db0:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff800000108db1:	03               	add    -0x76(%rax),%eax

ffff800000108db2 <gdt_base>:
ffff800000108db2:	40 8a 10             	rex mov (%rax),%dl
ffff800000108db5:	00 00                	add    %al,(%rax)
ffff800000108db7:	80 ff ff             	cmp    $0xff,%bh
ffff800000108dba:	00 00                	add    %al,(%rax)
ffff800000108dbc:	00 00                	add    %al,(%rax)
	...

ffff800000108dc0 <idt_table>:
	...

ffff800000109dc0 <idt_end>:
ffff800000109dc0:	ff 0f                	decl   (%rdi)

ffff800000109dc2 <idt_base>:
ffff800000109dc2:	c0 8d 10 00 00 80 ff 	rorb   $0xff,-0x7ffffff0(%rbp)
ffff800000109dc9:	ff 00                	incl   (%rax)
	...

ffff800000109de0 <ascii_font>:
	...
ffff800000109ff0:	00 10                	add    %dl,(%rax)
ffff800000109ff2:	10 10                	adc    %dl,(%rax)
ffff800000109ff4:	10 10                	adc    %dl,(%rax)
ffff800000109ff6:	10 10                	adc    %dl,(%rax)
ffff800000109ff8:	10 10                	adc    %dl,(%rax)
ffff800000109ffa:	00 00                	add    %al,(%rax)
ffff800000109ffc:	10 10                	adc    %dl,(%rax)
ffff800000109ffe:	00 00                	add    %al,(%rax)
ffff80000010a000:	28 28                	sub    %ch,(%rax)
ffff80000010a002:	28 00                	sub    %al,(%rax)
	...
ffff80000010a010:	00 44 44 44          	add    %al,0x44(%rsp,%rax,2)
ffff80000010a014:	fe 44 44 44          	incb   0x44(%rsp,%rax,2)
ffff80000010a018:	44                   	rex.R
ffff80000010a019:	44 fe 44 44 44       	rex.R incb 0x44(%rsp,%rax,2)
ffff80000010a01e:	00 00                	add    %al,(%rax)
ffff80000010a020:	10 3a                	adc    %bh,(%rdx)
ffff80000010a022:	56                   	push   %rsi
ffff80000010a023:	92                   	xchg   %eax,%edx
ffff80000010a024:	92                   	xchg   %eax,%edx
ffff80000010a025:	90                   	nop
ffff80000010a026:	50                   	push   %rax
ffff80000010a027:	38 14 12             	cmp    %dl,(%rdx,%rdx,1)
ffff80000010a02a:	92                   	xchg   %eax,%edx
ffff80000010a02b:	92                   	xchg   %eax,%edx
ffff80000010a02c:	d4                   	(bad)  
ffff80000010a02d:	b8 10 10 62 92       	mov    $0x92621010,%eax
ffff80000010a032:	94                   	xchg   %eax,%esp
ffff80000010a033:	94                   	xchg   %eax,%esp
ffff80000010a034:	68 08 10 10 20       	push   $0x20101008
ffff80000010a039:	2c 52                	sub    $0x52,%al
ffff80000010a03b:	52                   	push   %rdx
ffff80000010a03c:	92                   	xchg   %eax,%edx
ffff80000010a03d:	8c 00                	mov    %es,(%rax)
ffff80000010a03f:	00 00                	add    %al,(%rax)
ffff80000010a041:	70 88                	jo     ffff800000109fcb <ascii_font+0x1eb>
ffff80000010a043:	88 88 90 60 47 a2    	mov    %cl,-0x5db89f70(%rax)
ffff80000010a049:	92                   	xchg   %eax,%edx
ffff80000010a04a:	8a 84 46 39 00 00 04 	mov    0x4000039(%rsi,%rax,2),%al
ffff80000010a051:	08 10                	or     %dl,(%rax)
	...
ffff80000010a05f:	00 02                	add    %al,(%rdx)
ffff80000010a061:	04 08                	add    $0x8,%al
ffff80000010a063:	08 10                	or     %dl,(%rax)
ffff80000010a065:	10 10                	adc    %dl,(%rax)
ffff80000010a067:	10 10                	adc    %dl,(%rax)
ffff80000010a069:	10 10                	adc    %dl,(%rax)
ffff80000010a06b:	08 08                	or     %cl,(%rax)
ffff80000010a06d:	04 02                	add    $0x2,%al
ffff80000010a06f:	00 80 40 20 20 10    	add    %al,0x10202040(%rax)
ffff80000010a075:	10 10                	adc    %dl,(%rax)
ffff80000010a077:	10 10                	adc    %dl,(%rax)
ffff80000010a079:	10 10                	adc    %dl,(%rax)
ffff80000010a07b:	20 20                	and    %ah,(%rax)
ffff80000010a07d:	40 80 00 00          	rex addb $0x0,(%rax)
ffff80000010a081:	00 00                	add    %al,(%rax)
ffff80000010a083:	00 00                	add    %al,(%rax)
ffff80000010a085:	10 92 54 38 54 92    	adc    %dl,-0x6dabc7ac(%rdx)
ffff80000010a08b:	10 00                	adc    %al,(%rax)
	...
ffff80000010a095:	10 10                	adc    %dl,(%rax)
ffff80000010a097:	10 fe                	adc    %bh,%dh
ffff80000010a099:	10 10                	adc    %dl,(%rax)
ffff80000010a09b:	10 00                	adc    %al,(%rax)
	...
ffff80000010a0a9:	00 00                	add    %al,(%rax)
ffff80000010a0ab:	18 18                	sbb    %bl,(%rax)
ffff80000010a0ad:	08 08                	or     %cl,(%rax)
ffff80000010a0af:	10 00                	adc    %al,(%rax)
ffff80000010a0b1:	00 00                	add    %al,(%rax)
ffff80000010a0b3:	00 00                	add    %al,(%rax)
ffff80000010a0b5:	00 00                	add    %al,(%rax)
ffff80000010a0b7:	00 fe                	add    %bh,%dh
	...
ffff80000010a0c9:	00 00                	add    %al,(%rax)
ffff80000010a0cb:	00 18                	add    %bl,(%rax)
ffff80000010a0cd:	18 00                	sbb    %al,(%rax)
ffff80000010a0cf:	00 02                	add    %al,(%rdx)
ffff80000010a0d1:	02 04 04             	add    (%rsp,%rax,1),%al
ffff80000010a0d4:	08 08                	or     %cl,(%rax)
ffff80000010a0d6:	08 10                	or     %dl,(%rax)
ffff80000010a0d8:	10 20                	adc    %ah,(%rax)
ffff80000010a0da:	20 40 40             	and    %al,0x40(%rax)
ffff80000010a0dd:	40 80 80 00 18 24 24 	rex addb $0x42,0x24241800(%rax)
ffff80000010a0e4:	42 
ffff80000010a0e5:	42                   	rex.X
ffff80000010a0e6:	42                   	rex.X
ffff80000010a0e7:	42                   	rex.X
ffff80000010a0e8:	42                   	rex.X
ffff80000010a0e9:	42                   	rex.X
ffff80000010a0ea:	42 24 24             	rex.X and $0x24,%al
ffff80000010a0ed:	18 00                	sbb    %al,(%rax)
ffff80000010a0ef:	00 00                	add    %al,(%rax)
ffff80000010a0f1:	08 18                	or     %bl,(%rax)
ffff80000010a0f3:	28 08                	sub    %cl,(%rax)
ffff80000010a0f5:	08 08                	or     %cl,(%rax)
ffff80000010a0f7:	08 08                	or     %cl,(%rax)
ffff80000010a0f9:	08 08                	or     %cl,(%rax)
ffff80000010a0fb:	08 08                	or     %cl,(%rax)
ffff80000010a0fd:	3e 00 00             	ds add %al,(%rax)
ffff80000010a100:	00 18                	add    %bl,(%rax)
ffff80000010a102:	24 42                	and    $0x42,%al
ffff80000010a104:	42 02 04 08          	add    (%rax,%r9,1),%al
ffff80000010a108:	10 20                	adc    %ah,(%rax)
ffff80000010a10a:	20 40 40             	and    %al,0x40(%rax)
ffff80000010a10d:	7e 00                	jle    ffff80000010a10f <ascii_font+0x32f>
ffff80000010a10f:	00 00                	add    %al,(%rax)
ffff80000010a111:	18 24 42             	sbb    %ah,(%rdx,%rax,2)
ffff80000010a114:	02 02                	add    (%rdx),%al
ffff80000010a116:	04 18                	add    $0x18,%al
ffff80000010a118:	04 02                	add    $0x2,%al
ffff80000010a11a:	02 42 24             	add    0x24(%rdx),%al
ffff80000010a11d:	18 00                	sbb    %al,(%rax)
ffff80000010a11f:	00 00                	add    %al,(%rax)
ffff80000010a121:	0c 0c                	or     $0xc,%al
ffff80000010a123:	0c 14                	or     $0x14,%al
ffff80000010a125:	14 14                	adc    $0x14,%al
ffff80000010a127:	24 24                	and    $0x24,%al
ffff80000010a129:	44 7e 04             	rex.R jle ffff80000010a130 <ascii_font+0x350>
ffff80000010a12c:	04 1e                	add    $0x1e,%al
ffff80000010a12e:	00 00                	add    %al,(%rax)
ffff80000010a130:	00 7c 40 40          	add    %bh,0x40(%rax,%rax,2)
ffff80000010a134:	40 58                	rex pop %rax
ffff80000010a136:	64 02 02             	add    %fs:(%rdx),%al
ffff80000010a139:	02 02                	add    (%rdx),%al
ffff80000010a13b:	42 24 18             	rex.X and $0x18,%al
ffff80000010a13e:	00 00                	add    %al,(%rax)
ffff80000010a140:	00 18                	add    %bl,(%rax)
ffff80000010a142:	24 42                	and    $0x42,%al
ffff80000010a144:	40 58                	rex pop %rax
ffff80000010a146:	64 42                	fs rex.X
ffff80000010a148:	42                   	rex.X
ffff80000010a149:	42                   	rex.X
ffff80000010a14a:	42                   	rex.X
ffff80000010a14b:	42 24 18             	rex.X and $0x18,%al
ffff80000010a14e:	00 00                	add    %al,(%rax)
ffff80000010a150:	00 7e 42             	add    %bh,0x42(%rsi)
ffff80000010a153:	42 04 04             	rex.X add $0x4,%al
ffff80000010a156:	08 08                	or     %cl,(%rax)
ffff80000010a158:	08 10                	or     %dl,(%rax)
ffff80000010a15a:	10 10                	adc    %dl,(%rax)
ffff80000010a15c:	10 38                	adc    %bh,(%rax)
ffff80000010a15e:	00 00                	add    %al,(%rax)
ffff80000010a160:	00 18                	add    %bl,(%rax)
ffff80000010a162:	24 42                	and    $0x42,%al
ffff80000010a164:	42                   	rex.X
ffff80000010a165:	42 24 18             	rex.X and $0x18,%al
ffff80000010a168:	24 42                	and    $0x42,%al
ffff80000010a16a:	42                   	rex.X
ffff80000010a16b:	42 24 18             	rex.X and $0x18,%al
ffff80000010a16e:	00 00                	add    %al,(%rax)
ffff80000010a170:	00 18                	add    %bl,(%rax)
ffff80000010a172:	24 42                	and    $0x42,%al
ffff80000010a174:	42                   	rex.X
ffff80000010a175:	42                   	rex.X
ffff80000010a176:	42                   	rex.X
ffff80000010a177:	42                   	rex.X
ffff80000010a178:	26 1a 02             	es sbb (%rdx),%al
ffff80000010a17b:	42 24 18             	rex.X and $0x18,%al
ffff80000010a17e:	00 00                	add    %al,(%rax)
ffff80000010a180:	00 00                	add    %al,(%rax)
ffff80000010a182:	00 00                	add    %al,(%rax)
ffff80000010a184:	00 18                	add    %bl,(%rax)
ffff80000010a186:	18 00                	sbb    %al,(%rax)
ffff80000010a188:	00 00                	add    %al,(%rax)
ffff80000010a18a:	00 00                	add    %al,(%rax)
ffff80000010a18c:	18 18                	sbb    %bl,(%rax)
ffff80000010a18e:	00 00                	add    %al,(%rax)
ffff80000010a190:	00 00                	add    %al,(%rax)
ffff80000010a192:	00 00                	add    %al,(%rax)
ffff80000010a194:	00 18                	add    %bl,(%rax)
ffff80000010a196:	18 00                	sbb    %al,(%rax)
ffff80000010a198:	00 00                	add    %al,(%rax)
ffff80000010a19a:	00 18                	add    %bl,(%rax)
ffff80000010a19c:	18 08                	sbb    %cl,(%rax)
ffff80000010a19e:	08 10                	or     %dl,(%rax)
ffff80000010a1a0:	00 02                	add    %al,(%rdx)
ffff80000010a1a2:	04 08                	add    $0x8,%al
ffff80000010a1a4:	10 20                	adc    %ah,(%rax)
ffff80000010a1a6:	40 80 80 40 20 10 08 	rex addb $0x4,0x8102040(%rax)
ffff80000010a1ad:	04 
ffff80000010a1ae:	02 00                	add    (%rax),%al
ffff80000010a1b0:	00 00                	add    %al,(%rax)
ffff80000010a1b2:	00 00                	add    %al,(%rax)
ffff80000010a1b4:	00 00                	add    %al,(%rax)
ffff80000010a1b6:	fe 00                	incb   (%rax)
ffff80000010a1b8:	00 fe                	add    %bh,%dh
ffff80000010a1ba:	00 00                	add    %al,(%rax)
ffff80000010a1bc:	00 00                	add    %al,(%rax)
ffff80000010a1be:	00 00                	add    %al,(%rax)
ffff80000010a1c0:	00 80 40 20 10 08    	add    %al,0x8102040(%rax)
ffff80000010a1c6:	04 02                	add    $0x2,%al
ffff80000010a1c8:	02 04 08             	add    (%rax,%rcx,1),%al
ffff80000010a1cb:	10 20                	adc    %ah,(%rax)
ffff80000010a1cd:	40 80 00 00          	rex addb $0x0,(%rax)
ffff80000010a1d1:	38 44 82 82          	cmp    %al,-0x7e(%rdx,%rax,4)
ffff80000010a1d5:	82                   	(bad)  
ffff80000010a1d6:	04 08                	add    $0x8,%al
ffff80000010a1d8:	10 10                	adc    %dl,(%rax)
ffff80000010a1da:	00 00                	add    %al,(%rax)
ffff80000010a1dc:	18 18                	sbb    %bl,(%rax)
ffff80000010a1de:	00 00                	add    %al,(%rax)
ffff80000010a1e0:	00 38                	add    %bh,(%rax)
ffff80000010a1e2:	44 82                	rex.R (bad) 
ffff80000010a1e4:	9a                   	(bad)  
ffff80000010a1e5:	aa                   	stos   %al,%es:(%rdi)
ffff80000010a1e6:	aa                   	stos   %al,%es:(%rdi)
ffff80000010a1e7:	aa                   	stos   %al,%es:(%rdi)
ffff80000010a1e8:	aa                   	stos   %al,%es:(%rdi)
ffff80000010a1e9:	aa                   	stos   %al,%es:(%rdi)
ffff80000010a1ea:	9c                   	pushf  
ffff80000010a1eb:	80 46 38 00          	addb   $0x0,0x38(%rsi)
ffff80000010a1ef:	00 00                	add    %al,(%rax)
ffff80000010a1f1:	18 18                	sbb    %bl,(%rax)
ffff80000010a1f3:	18 18                	sbb    %bl,(%rax)
ffff80000010a1f5:	24 24                	and    $0x24,%al
ffff80000010a1f7:	24 24                	and    $0x24,%al
ffff80000010a1f9:	7e 42                	jle    ffff80000010a23d <ascii_font+0x45d>
ffff80000010a1fb:	42                   	rex.X
ffff80000010a1fc:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010a1ff:	00 00                	add    %al,(%rax)
ffff80000010a201:	f0 48                	lock rex.W
ffff80000010a203:	44                   	rex.R
ffff80000010a204:	44                   	rex.R
ffff80000010a205:	44                   	rex.R
ffff80000010a206:	48 78 44             	rex.W js ffff80000010a24d <ascii_font+0x46d>
ffff80000010a209:	42                   	rex.X
ffff80000010a20a:	42                   	rex.X
ffff80000010a20b:	42                   	rex.X
ffff80000010a20c:	44 f8                	rex.R clc 
ffff80000010a20e:	00 00                	add    %al,(%rax)
ffff80000010a210:	00 3a                	add    %bh,(%rdx)
ffff80000010a212:	46                   	rex.RX
ffff80000010a213:	42 82                	rex.X (bad) 
ffff80000010a215:	80 80 80 80 80 82 42 	addb   $0x42,-0x7d7f7f80(%rax)
ffff80000010a21c:	44 38 00             	cmp    %r8b,(%rax)
ffff80000010a21f:	00 00                	add    %al,(%rax)
ffff80000010a221:	f8                   	clc    
ffff80000010a222:	44                   	rex.R
ffff80000010a223:	44                   	rex.R
ffff80000010a224:	42                   	rex.X
ffff80000010a225:	42                   	rex.X
ffff80000010a226:	42                   	rex.X
ffff80000010a227:	42                   	rex.X
ffff80000010a228:	42                   	rex.X
ffff80000010a229:	42                   	rex.X
ffff80000010a22a:	42                   	rex.X
ffff80000010a22b:	44                   	rex.R
ffff80000010a22c:	44 f8                	rex.R clc 
ffff80000010a22e:	00 00                	add    %al,(%rax)
ffff80000010a230:	00 fe                	add    %bh,%dh
ffff80000010a232:	42                   	rex.X
ffff80000010a233:	42                   	rex.X
ffff80000010a234:	40                   	rex
ffff80000010a235:	40                   	rex
ffff80000010a236:	44 7c 44             	rex.R jl ffff80000010a27d <ascii_font+0x49d>
ffff80000010a239:	40                   	rex
ffff80000010a23a:	40                   	rex
ffff80000010a23b:	42                   	rex.X
ffff80000010a23c:	42 fe 00             	rex.X incb (%rax)
ffff80000010a23f:	00 00                	add    %al,(%rax)
ffff80000010a241:	fe 42 42             	incb   0x42(%rdx)
ffff80000010a244:	40                   	rex
ffff80000010a245:	40                   	rex
ffff80000010a246:	44 7c 44             	rex.R jl ffff80000010a28d <ascii_font+0x4ad>
ffff80000010a249:	44                   	rex.R
ffff80000010a24a:	40                   	rex
ffff80000010a24b:	40                   	rex
ffff80000010a24c:	40                   	rex
ffff80000010a24d:	f0 00 00             	lock add %al,(%rax)
ffff80000010a250:	00 3a                	add    %bh,(%rdx)
ffff80000010a252:	46                   	rex.RX
ffff80000010a253:	42 82                	rex.X (bad) 
ffff80000010a255:	80 80 9e 82 82 82 42 	addb   $0x42,-0x7d7d7d62(%rax)
ffff80000010a25c:	46 38 00             	rex.RX cmp %r8b,(%rax)
ffff80000010a25f:	00 00                	add    %al,(%rax)
ffff80000010a261:	e7 42                	out    %eax,$0x42
ffff80000010a263:	42                   	rex.X
ffff80000010a264:	42                   	rex.X
ffff80000010a265:	42                   	rex.X
ffff80000010a266:	42 7e 42             	rex.X jle ffff80000010a2ab <ascii_font+0x4cb>
ffff80000010a269:	42                   	rex.X
ffff80000010a26a:	42                   	rex.X
ffff80000010a26b:	42                   	rex.X
ffff80000010a26c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010a26f:	00 00                	add    %al,(%rax)
ffff80000010a271:	7c 10                	jl     ffff80000010a283 <ascii_font+0x4a3>
ffff80000010a273:	10 10                	adc    %dl,(%rax)
ffff80000010a275:	10 10                	adc    %dl,(%rax)
ffff80000010a277:	10 10                	adc    %dl,(%rax)
ffff80000010a279:	10 10                	adc    %dl,(%rax)
ffff80000010a27b:	10 10                	adc    %dl,(%rax)
ffff80000010a27d:	7c 00                	jl     ffff80000010a27f <ascii_font+0x49f>
ffff80000010a27f:	00 00                	add    %al,(%rax)
ffff80000010a281:	1f                   	(bad)  
ffff80000010a282:	04 04                	add    $0x4,%al
ffff80000010a284:	04 04                	add    $0x4,%al
ffff80000010a286:	04 04                	add    $0x4,%al
ffff80000010a288:	04 04                	add    $0x4,%al
ffff80000010a28a:	04 04                	add    $0x4,%al
ffff80000010a28c:	84 48 30             	test   %cl,0x30(%rax)
ffff80000010a28f:	00 00                	add    %al,(%rax)
ffff80000010a291:	e7 42                	out    %eax,$0x42
ffff80000010a293:	44                   	rex.R
ffff80000010a294:	48 50                	rex.W push %rax
ffff80000010a296:	50                   	push   %rax
ffff80000010a297:	60                   	(bad)  
ffff80000010a298:	50                   	push   %rax
ffff80000010a299:	50                   	push   %rax
ffff80000010a29a:	48                   	rex.W
ffff80000010a29b:	44                   	rex.R
ffff80000010a29c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010a29f:	00 00                	add    %al,(%rax)
ffff80000010a2a1:	f0 40                	lock rex
ffff80000010a2a3:	40                   	rex
ffff80000010a2a4:	40                   	rex
ffff80000010a2a5:	40                   	rex
ffff80000010a2a6:	40                   	rex
ffff80000010a2a7:	40                   	rex
ffff80000010a2a8:	40                   	rex
ffff80000010a2a9:	40                   	rex
ffff80000010a2aa:	40                   	rex
ffff80000010a2ab:	42                   	rex.X
ffff80000010a2ac:	42 fe 00             	rex.X incb (%rax)
ffff80000010a2af:	00 00                	add    %al,(%rax)
ffff80000010a2b1:	c3                   	ret    
ffff80000010a2b2:	42                   	rex.X
ffff80000010a2b3:	66 66 66 5a          	data16 data16 pop %dx
ffff80000010a2b7:	5a                   	pop    %rdx
ffff80000010a2b8:	5a                   	pop    %rdx
ffff80000010a2b9:	42                   	rex.X
ffff80000010a2ba:	42                   	rex.X
ffff80000010a2bb:	42                   	rex.X
ffff80000010a2bc:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010a2bf:	00 00                	add    %al,(%rax)
ffff80000010a2c1:	c7 42 62 62 52 52 52 	movl   $0x52525262,0x62(%rdx)
ffff80000010a2c8:	4a                   	rex.WX
ffff80000010a2c9:	4a                   	rex.WX
ffff80000010a2ca:	4a                   	rex.WX
ffff80000010a2cb:	46                   	rex.RX
ffff80000010a2cc:	46 e2 00             	rex.RX loop ffff80000010a2cf <ascii_font+0x4ef>
ffff80000010a2cf:	00 00                	add    %al,(%rax)
ffff80000010a2d1:	38 44 82 82          	cmp    %al,-0x7e(%rdx,%rax,4)
ffff80000010a2d5:	82                   	(bad)  
ffff80000010a2d6:	82                   	(bad)  
ffff80000010a2d7:	82                   	(bad)  
ffff80000010a2d8:	82                   	(bad)  
ffff80000010a2d9:	82                   	(bad)  
ffff80000010a2da:	82                   	(bad)  
ffff80000010a2db:	82                   	(bad)  
ffff80000010a2dc:	44 38 00             	cmp    %r8b,(%rax)
ffff80000010a2df:	00 00                	add    %al,(%rax)
ffff80000010a2e1:	f8                   	clc    
ffff80000010a2e2:	44                   	rex.R
ffff80000010a2e3:	42                   	rex.X
ffff80000010a2e4:	42                   	rex.X
ffff80000010a2e5:	42                   	rex.X
ffff80000010a2e6:	44 78 40             	rex.R js ffff80000010a329 <ascii_font+0x549>
ffff80000010a2e9:	40                   	rex
ffff80000010a2ea:	40                   	rex
ffff80000010a2eb:	40                   	rex
ffff80000010a2ec:	40                   	rex
ffff80000010a2ed:	f0 00 00             	lock add %al,(%rax)
ffff80000010a2f0:	00 38                	add    %bh,(%rax)
ffff80000010a2f2:	44 82                	rex.R (bad) 
ffff80000010a2f4:	82                   	(bad)  
ffff80000010a2f5:	82                   	(bad)  
ffff80000010a2f6:	82                   	(bad)  
ffff80000010a2f7:	82                   	(bad)  
ffff80000010a2f8:	82                   	(bad)  
ffff80000010a2f9:	82                   	(bad)  
ffff80000010a2fa:	92                   	xchg   %eax,%edx
ffff80000010a2fb:	8a 44 3a 00          	mov    0x0(%rdx,%rdi,1),%al
ffff80000010a2ff:	00 00                	add    %al,(%rax)
ffff80000010a301:	fc                   	cld    
ffff80000010a302:	42                   	rex.X
ffff80000010a303:	42                   	rex.X
ffff80000010a304:	42                   	rex.X
ffff80000010a305:	42 7c 44             	rex.X jl ffff80000010a34c <ascii_font+0x56c>
ffff80000010a308:	42                   	rex.X
ffff80000010a309:	42                   	rex.X
ffff80000010a30a:	42                   	rex.X
ffff80000010a30b:	42                   	rex.X
ffff80000010a30c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010a30f:	00 00                	add    %al,(%rax)
ffff80000010a311:	3a 46 82             	cmp    -0x7e(%rsi),%al
ffff80000010a314:	82                   	(bad)  
ffff80000010a315:	80 40 38 04          	addb   $0x4,0x38(%rax)
ffff80000010a319:	02 82 82 c4 b8 00    	add    0xb8c482(%rdx),%al
ffff80000010a31f:	00 00                	add    %al,(%rax)
ffff80000010a321:	fe                   	(bad)  
ffff80000010a322:	92                   	xchg   %eax,%edx
ffff80000010a323:	92                   	xchg   %eax,%edx
ffff80000010a324:	10 10                	adc    %dl,(%rax)
ffff80000010a326:	10 10                	adc    %dl,(%rax)
ffff80000010a328:	10 10                	adc    %dl,(%rax)
ffff80000010a32a:	10 10                	adc    %dl,(%rax)
ffff80000010a32c:	10 7c 00 00          	adc    %bh,0x0(%rax,%rax,1)
ffff80000010a330:	00 e7                	add    %ah,%bh
ffff80000010a332:	42                   	rex.X
ffff80000010a333:	42                   	rex.X
ffff80000010a334:	42                   	rex.X
ffff80000010a335:	42                   	rex.X
ffff80000010a336:	42                   	rex.X
ffff80000010a337:	42                   	rex.X
ffff80000010a338:	42                   	rex.X
ffff80000010a339:	42                   	rex.X
ffff80000010a33a:	42                   	rex.X
ffff80000010a33b:	42 24 3c             	rex.X and $0x3c,%al
ffff80000010a33e:	00 00                	add    %al,(%rax)
ffff80000010a340:	00 e7                	add    %ah,%bh
ffff80000010a342:	42                   	rex.X
ffff80000010a343:	42                   	rex.X
ffff80000010a344:	42                   	rex.X
ffff80000010a345:	42 24 24             	rex.X and $0x24,%al
ffff80000010a348:	24 24                	and    $0x24,%al
ffff80000010a34a:	18 18                	sbb    %bl,(%rax)
ffff80000010a34c:	18 18                	sbb    %bl,(%rax)
ffff80000010a34e:	00 00                	add    %al,(%rax)
ffff80000010a350:	00 e7                	add    %ah,%bh
ffff80000010a352:	42                   	rex.X
ffff80000010a353:	42                   	rex.X
ffff80000010a354:	42 5a                	rex.X pop %rdx
ffff80000010a356:	5a                   	pop    %rdx
ffff80000010a357:	5a                   	pop    %rdx
ffff80000010a358:	5a                   	pop    %rdx
ffff80000010a359:	24 24                	and    $0x24,%al
ffff80000010a35b:	24 24                	and    $0x24,%al
ffff80000010a35d:	24 00                	and    $0x0,%al
ffff80000010a35f:	00 00                	add    %al,(%rax)
ffff80000010a361:	e7 42                	out    %eax,$0x42
ffff80000010a363:	42 24 24             	rex.X and $0x24,%al
ffff80000010a366:	24 18                	and    $0x18,%al
ffff80000010a368:	24 24                	and    $0x24,%al
ffff80000010a36a:	24 42                	and    $0x42,%al
ffff80000010a36c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010a36f:	00 00                	add    %al,(%rax)
ffff80000010a371:	ee                   	out    %al,(%dx)
ffff80000010a372:	44                   	rex.R
ffff80000010a373:	44                   	rex.R
ffff80000010a374:	44 28 28             	sub    %r13b,(%rax)
ffff80000010a377:	28 10                	sub    %dl,(%rax)
ffff80000010a379:	10 10                	adc    %dl,(%rax)
ffff80000010a37b:	10 10                	adc    %dl,(%rax)
ffff80000010a37d:	7c 00                	jl     ffff80000010a37f <ascii_font+0x59f>
ffff80000010a37f:	00 00                	add    %al,(%rax)
ffff80000010a381:	fe 84 84 08 08 10 10 	incb   0x10100808(%rsp,%rax,4)
ffff80000010a388:	20 20                	and    %ah,(%rax)
ffff80000010a38a:	40                   	rex
ffff80000010a38b:	42 82                	rex.X (bad) 
ffff80000010a38d:	fe 00                	incb   (%rax)
ffff80000010a38f:	00 00                	add    %al,(%rax)
ffff80000010a391:	3e 20 20             	ds and %ah,(%rax)
ffff80000010a394:	20 20                	and    %ah,(%rax)
ffff80000010a396:	20 20                	and    %ah,(%rax)
ffff80000010a398:	20 20                	and    %ah,(%rax)
ffff80000010a39a:	20 20                	and    %ah,(%rax)
ffff80000010a39c:	20 20                	and    %ah,(%rax)
ffff80000010a39e:	3e 00 80 80 40 40 20 	ds add %al,0x20404080(%rax)
ffff80000010a3a5:	20 20                	and    %ah,(%rax)
ffff80000010a3a7:	10 10                	adc    %dl,(%rax)
ffff80000010a3a9:	08 08                	or     %cl,(%rax)
ffff80000010a3ab:	04 04                	add    $0x4,%al
ffff80000010a3ad:	04 02                	add    $0x2,%al
ffff80000010a3af:	02 00                	add    (%rax),%al
ffff80000010a3b1:	7c 04                	jl     ffff80000010a3b7 <ascii_font+0x5d7>
ffff80000010a3b3:	04 04                	add    $0x4,%al
ffff80000010a3b5:	04 04                	add    $0x4,%al
ffff80000010a3b7:	04 04                	add    $0x4,%al
ffff80000010a3b9:	04 04                	add    $0x4,%al
ffff80000010a3bb:	04 04                	add    $0x4,%al
ffff80000010a3bd:	04 7c                	add    $0x7c,%al
ffff80000010a3bf:	00 00                	add    %al,(%rax)
ffff80000010a3c1:	10 28                	adc    %ch,(%rax)
ffff80000010a3c3:	44 82                	rex.R (bad) 
	...
ffff80000010a3dd:	00 fe                	add    %bh,%dh
ffff80000010a3df:	00 10                	add    %dl,(%rax)
ffff80000010a3e1:	08 04 00             	or     %al,(%rax,%rax,1)
	...
ffff80000010a3f4:	00 70 08             	add    %dh,0x8(%rax)
ffff80000010a3f7:	04 3c                	add    $0x3c,%al
ffff80000010a3f9:	44 84 84 8c 76 00 00 	test   %r8b,-0x3fffff8a(%rsp,%rcx,4)
ffff80000010a400:	c0 
ffff80000010a401:	40                   	rex
ffff80000010a402:	40                   	rex
ffff80000010a403:	40                   	rex
ffff80000010a404:	40 58                	rex pop %rax
ffff80000010a406:	64 42                	fs rex.X
ffff80000010a408:	42                   	rex.X
ffff80000010a409:	42                   	rex.X
ffff80000010a40a:	42                   	rex.X
ffff80000010a40b:	42                   	rex.X
ffff80000010a40c:	64 58                	fs pop %rax
ffff80000010a40e:	00 00                	add    %al,(%rax)
ffff80000010a410:	00 00                	add    %al,(%rax)
ffff80000010a412:	00 00                	add    %al,(%rax)
ffff80000010a414:	00 30                	add    %dh,(%rax)
ffff80000010a416:	4c 84 84 80 80 82 44 	rex.WR test %r8b,0x38448280(%rax,%rax,4)
ffff80000010a41d:	38 
ffff80000010a41e:	00 00                	add    %al,(%rax)
ffff80000010a420:	0c 04                	or     $0x4,%al
ffff80000010a422:	04 04                	add    $0x4,%al
ffff80000010a424:	04 34                	add    $0x34,%al
ffff80000010a426:	4c 84 84 84 84 84 4c 	rex.WR test %r8b,0x364c8484(%rsp,%rax,4)
ffff80000010a42d:	36 
ffff80000010a42e:	00 00                	add    %al,(%rax)
ffff80000010a430:	00 00                	add    %al,(%rax)
ffff80000010a432:	00 00                	add    %al,(%rax)
ffff80000010a434:	00 38                	add    %bh,(%rax)
ffff80000010a436:	44 82                	rex.R (bad) 
ffff80000010a438:	82                   	(bad)  
ffff80000010a439:	fc                   	cld    
ffff80000010a43a:	80 82 42 3c 00 00 0e 	addb   $0xe,0x3c42(%rdx)
ffff80000010a441:	10 10                	adc    %dl,(%rax)
ffff80000010a443:	10 10                	adc    %dl,(%rax)
ffff80000010a445:	7c 10                	jl     ffff80000010a457 <ascii_font+0x677>
ffff80000010a447:	10 10                	adc    %dl,(%rax)
ffff80000010a449:	10 10                	adc    %dl,(%rax)
ffff80000010a44b:	10 10                	adc    %dl,(%rax)
ffff80000010a44d:	7c 00                	jl     ffff80000010a44f <ascii_font+0x66f>
ffff80000010a44f:	00 00                	add    %al,(%rax)
ffff80000010a451:	00 00                	add    %al,(%rax)
ffff80000010a453:	00 00                	add    %al,(%rax)
ffff80000010a455:	36 4c 84 84 84 84 4c 	ss rex.WR test %r8b,0x4344c84(%rsp,%rax,4)
ffff80000010a45c:	34 04 
ffff80000010a45e:	04 38                	add    $0x38,%al
ffff80000010a460:	c0 40 40 40          	rolb   $0x40,0x40(%rax)
ffff80000010a464:	40 58                	rex pop %rax
ffff80000010a466:	64 42                	fs rex.X
ffff80000010a468:	42                   	rex.X
ffff80000010a469:	42                   	rex.X
ffff80000010a46a:	42                   	rex.X
ffff80000010a46b:	42                   	rex.X
ffff80000010a46c:	42 e3 00             	rex.X jrcxz ffff80000010a46f <ascii_font+0x68f>
ffff80000010a46f:	00 00                	add    %al,(%rax)
ffff80000010a471:	10 10                	adc    %dl,(%rax)
ffff80000010a473:	00 00                	add    %al,(%rax)
ffff80000010a475:	30 10                	xor    %dl,(%rax)
ffff80000010a477:	10 10                	adc    %dl,(%rax)
ffff80000010a479:	10 10                	adc    %dl,(%rax)
ffff80000010a47b:	10 10                	adc    %dl,(%rax)
ffff80000010a47d:	38 00                	cmp    %al,(%rax)
ffff80000010a47f:	00 00                	add    %al,(%rax)
ffff80000010a481:	04 04                	add    $0x4,%al
ffff80000010a483:	00 00                	add    %al,(%rax)
ffff80000010a485:	0c 04                	or     $0x4,%al
ffff80000010a487:	04 04                	add    $0x4,%al
ffff80000010a489:	04 04                	add    $0x4,%al
ffff80000010a48b:	04 04                	add    $0x4,%al
ffff80000010a48d:	08 08                	or     %cl,(%rax)
ffff80000010a48f:	30 c0                	xor    %al,%al
ffff80000010a491:	40                   	rex
ffff80000010a492:	40                   	rex
ffff80000010a493:	40                   	rex
ffff80000010a494:	40                   	rex
ffff80000010a495:	4e                   	rex.WRX
ffff80000010a496:	44                   	rex.R
ffff80000010a497:	48 50                	rex.W push %rax
ffff80000010a499:	60                   	(bad)  
ffff80000010a49a:	50                   	push   %rax
ffff80000010a49b:	48                   	rex.W
ffff80000010a49c:	44 e6 00             	rex.R out %al,$0x0
ffff80000010a49f:	00 30                	add    %dh,(%rax)
ffff80000010a4a1:	10 10                	adc    %dl,(%rax)
ffff80000010a4a3:	10 10                	adc    %dl,(%rax)
ffff80000010a4a5:	10 10                	adc    %dl,(%rax)
ffff80000010a4a7:	10 10                	adc    %dl,(%rax)
ffff80000010a4a9:	10 10                	adc    %dl,(%rax)
ffff80000010a4ab:	10 10                	adc    %dl,(%rax)
ffff80000010a4ad:	38 00                	cmp    %al,(%rax)
ffff80000010a4af:	00 00                	add    %al,(%rax)
ffff80000010a4b1:	00 00                	add    %al,(%rax)
ffff80000010a4b3:	00 00                	add    %al,(%rax)
ffff80000010a4b5:	f6 49 49 49          	testb  $0x49,0x49(%rcx)
ffff80000010a4b9:	49                   	rex.WB
ffff80000010a4ba:	49                   	rex.WB
ffff80000010a4bb:	49                   	rex.WB
ffff80000010a4bc:	49 db 00             	rex.WB fildl (%r8)
ffff80000010a4bf:	00 00                	add    %al,(%rax)
ffff80000010a4c1:	00 00                	add    %al,(%rax)
ffff80000010a4c3:	00 00                	add    %al,(%rax)
ffff80000010a4c5:	d8 64 42 42          	fsubs  0x42(%rdx,%rax,2)
ffff80000010a4c9:	42                   	rex.X
ffff80000010a4ca:	42                   	rex.X
ffff80000010a4cb:	42                   	rex.X
ffff80000010a4cc:	42 e3 00             	rex.X jrcxz ffff80000010a4cf <ascii_font+0x6ef>
ffff80000010a4cf:	00 00                	add    %al,(%rax)
ffff80000010a4d1:	00 00                	add    %al,(%rax)
ffff80000010a4d3:	00 00                	add    %al,(%rax)
ffff80000010a4d5:	38 44 82 82          	cmp    %al,-0x7e(%rdx,%rax,4)
ffff80000010a4d9:	82                   	(bad)  
ffff80000010a4da:	82                   	(bad)  
ffff80000010a4db:	82                   	(bad)  
ffff80000010a4dc:	44 38 00             	cmp    %r8b,(%rax)
ffff80000010a4df:	00 00                	add    %al,(%rax)
ffff80000010a4e1:	00 00                	add    %al,(%rax)
ffff80000010a4e3:	00 d8                	add    %bl,%al
ffff80000010a4e5:	64 42                	fs rex.X
ffff80000010a4e7:	42                   	rex.X
ffff80000010a4e8:	42                   	rex.X
ffff80000010a4e9:	42                   	rex.X
ffff80000010a4ea:	42                   	rex.X
ffff80000010a4eb:	64 58                	fs pop %rax
ffff80000010a4ed:	40                   	rex
ffff80000010a4ee:	40 e0 00             	rex loopne ffff80000010a4f1 <ascii_font+0x711>
ffff80000010a4f1:	00 00                	add    %al,(%rax)
ffff80000010a4f3:	00 34 4c             	add    %dh,(%rsp,%rcx,2)
ffff80000010a4f6:	84 84 84 84 84 4c 34 	test   %al,0x344c8484(%rsp,%rax,4)
ffff80000010a4fd:	04 04                	add    $0x4,%al
ffff80000010a4ff:	0e                   	(bad)  
ffff80000010a500:	00 00                	add    %al,(%rax)
ffff80000010a502:	00 00                	add    %al,(%rax)
ffff80000010a504:	00 dc                	add    %bl,%ah
ffff80000010a506:	62 42                	(bad)  
ffff80000010a508:	40                   	rex
ffff80000010a509:	40                   	rex
ffff80000010a50a:	40                   	rex
ffff80000010a50b:	40                   	rex
ffff80000010a50c:	40 e0 00             	rex loopne ffff80000010a50f <ascii_font+0x72f>
ffff80000010a50f:	00 00                	add    %al,(%rax)
ffff80000010a511:	00 00                	add    %al,(%rax)
ffff80000010a513:	00 00                	add    %al,(%rax)
ffff80000010a515:	7a 86                	jp     ffff80000010a49d <ascii_font+0x6bd>
ffff80000010a517:	82                   	(bad)  
ffff80000010a518:	c0 38 06             	sarb   $0x6,(%rax)
ffff80000010a51b:	82                   	(bad)  
ffff80000010a51c:	c2 bc 00             	ret    $0xbc
ffff80000010a51f:	00 00                	add    %al,(%rax)
ffff80000010a521:	00 10                	add    %dl,(%rax)
ffff80000010a523:	10 10                	adc    %dl,(%rax)
ffff80000010a525:	7c 10                	jl     ffff80000010a537 <ascii_font+0x757>
ffff80000010a527:	10 10                	adc    %dl,(%rax)
ffff80000010a529:	10 10                	adc    %dl,(%rax)
ffff80000010a52b:	10 10                	adc    %dl,(%rax)
ffff80000010a52d:	0e                   	(bad)  
ffff80000010a52e:	00 00                	add    %al,(%rax)
ffff80000010a530:	00 00                	add    %al,(%rax)
ffff80000010a532:	00 00                	add    %al,(%rax)
ffff80000010a534:	00 c6                	add    %al,%dh
ffff80000010a536:	42                   	rex.X
ffff80000010a537:	42                   	rex.X
ffff80000010a538:	42                   	rex.X
ffff80000010a539:	42                   	rex.X
ffff80000010a53a:	42                   	rex.X
ffff80000010a53b:	42                   	rex.X
ffff80000010a53c:	46 3b 00             	rex.RX cmp (%rax),%r8d
ffff80000010a53f:	00 00                	add    %al,(%rax)
ffff80000010a541:	00 00                	add    %al,(%rax)
ffff80000010a543:	00 00                	add    %al,(%rax)
ffff80000010a545:	e7 42                	out    %eax,$0x42
ffff80000010a547:	42                   	rex.X
ffff80000010a548:	42 24 24             	rex.X and $0x24,%al
ffff80000010a54b:	24 18                	and    $0x18,%al
ffff80000010a54d:	18 00                	sbb    %al,(%rax)
ffff80000010a54f:	00 00                	add    %al,(%rax)
ffff80000010a551:	00 00                	add    %al,(%rax)
ffff80000010a553:	00 00                	add    %al,(%rax)
ffff80000010a555:	e7 42                	out    %eax,$0x42
ffff80000010a557:	42 5a                	rex.X pop %rdx
ffff80000010a559:	5a                   	pop    %rdx
ffff80000010a55a:	5a                   	pop    %rdx
ffff80000010a55b:	24 24                	and    $0x24,%al
ffff80000010a55d:	24 00                	and    $0x0,%al
ffff80000010a55f:	00 00                	add    %al,(%rax)
ffff80000010a561:	00 00                	add    %al,(%rax)
ffff80000010a563:	00 00                	add    %al,(%rax)
ffff80000010a565:	c6 44 28 28 10       	movb   $0x10,0x28(%rax,%rbp,1)
ffff80000010a56a:	28 28                	sub    %ch,(%rax)
ffff80000010a56c:	44 c6 00 00          	rex.R movb $0x0,(%rax)
ffff80000010a570:	00 00                	add    %al,(%rax)
ffff80000010a572:	00 00                	add    %al,(%rax)
ffff80000010a574:	00 e7                	add    %ah,%bh
ffff80000010a576:	42                   	rex.X
ffff80000010a577:	42 24 24             	rex.X and $0x24,%al
ffff80000010a57a:	24 18                	and    $0x18,%al
ffff80000010a57c:	18 10                	sbb    %dl,(%rax)
ffff80000010a57e:	10 60 00             	adc    %ah,0x0(%rax)
ffff80000010a581:	00 00                	add    %al,(%rax)
ffff80000010a583:	00 00                	add    %al,(%rax)
ffff80000010a585:	fe 82 84 08 10 20    	incb   0x20100884(%rdx)
ffff80000010a58b:	42 82                	rex.X (bad) 
ffff80000010a58d:	fe 00                	incb   (%rax)
ffff80000010a58f:	00 00                	add    %al,(%rax)
ffff80000010a591:	06                   	(bad)  
ffff80000010a592:	08 10                	or     %dl,(%rax)
ffff80000010a594:	10 10                	adc    %dl,(%rax)
ffff80000010a596:	10 60 10             	adc    %ah,0x10(%rax)
ffff80000010a599:	10 10                	adc    %dl,(%rax)
ffff80000010a59b:	10 08                	adc    %cl,(%rax)
ffff80000010a59d:	06                   	(bad)  
ffff80000010a59e:	00 00                	add    %al,(%rax)
ffff80000010a5a0:	10 10                	adc    %dl,(%rax)
ffff80000010a5a2:	10 10                	adc    %dl,(%rax)
ffff80000010a5a4:	10 10                	adc    %dl,(%rax)
ffff80000010a5a6:	10 10                	adc    %dl,(%rax)
ffff80000010a5a8:	10 10                	adc    %dl,(%rax)
ffff80000010a5aa:	10 10                	adc    %dl,(%rax)
ffff80000010a5ac:	10 10                	adc    %dl,(%rax)
ffff80000010a5ae:	10 10                	adc    %dl,(%rax)
ffff80000010a5b0:	00 60 10             	add    %ah,0x10(%rax)
ffff80000010a5b3:	08 08                	or     %cl,(%rax)
ffff80000010a5b5:	08 08                	or     %cl,(%rax)
ffff80000010a5b7:	06                   	(bad)  
ffff80000010a5b8:	08 08                	or     %cl,(%rax)
ffff80000010a5ba:	08 08                	or     %cl,(%rax)
ffff80000010a5bc:	10 60 00             	adc    %ah,0x0(%rax)
ffff80000010a5bf:	00 00                	add    %al,(%rax)
ffff80000010a5c1:	72 8c                	jb     ffff80000010a54f <ascii_font+0x76f>
	...

ffff80000010ade0 <boot_info>:
ffff80000010ade0:	00 00                	add    %al,(%rax)
ffff80000010ade2:	06                   	(bad)  
ffff80000010ade3:	00 00                	add    %al,(%rax)
ffff80000010ade5:	80 ff ff             	cmp    $0xff,%bh
	...

ffff80000010ae00 <tss>:
ffff80000010ae00:	00 00                	add    %al,(%rax)
ffff80000010ae02:	00 00                	add    %al,(%rax)
ffff80000010ae04:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010ae08:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae0e:	00 00                	add    %al,(%rax)
ffff80000010ae10:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae16:	00 00                	add    %al,(%rax)
ffff80000010ae18:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010ae1e:	00 00                	add    %al,(%rax)
ffff80000010ae20:	00 00                	add    %al,(%rax)
ffff80000010ae22:	00 00                	add    %al,(%rax)
ffff80000010ae24:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010ae28:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae2e:	00 00                	add    %al,(%rax)
ffff80000010ae30:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae36:	00 00                	add    %al,(%rax)
ffff80000010ae38:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae3e:	00 00                	add    %al,(%rax)
ffff80000010ae40:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae46:	00 00                	add    %al,(%rax)
ffff80000010ae48:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae4e:	00 00                	add    %al,(%rax)
ffff80000010ae50:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae56:	00 00                	add    %al,(%rax)
ffff80000010ae58:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010ae6a:	00 00                	add    %al,(%rax)
ffff80000010ae6c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010ae70:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae76:	00 00                	add    %al,(%rax)
ffff80000010ae78:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae7e:	00 00                	add    %al,(%rax)
ffff80000010ae80:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010ae86:	00 00                	add    %al,(%rax)
ffff80000010ae88:	00 00                	add    %al,(%rax)
ffff80000010ae8a:	00 00                	add    %al,(%rax)
ffff80000010ae8c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010ae90:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae96:	00 00                	add    %al,(%rax)
ffff80000010ae98:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010ae9e:	00 00                	add    %al,(%rax)
ffff80000010aea0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aea6:	00 00                	add    %al,(%rax)
ffff80000010aea8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aeae:	00 00                	add    %al,(%rax)
ffff80000010aeb0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aeb6:	00 00                	add    %al,(%rax)
ffff80000010aeb8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aebe:	00 00                	add    %al,(%rax)
ffff80000010aec0:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010aed2:	00 00                	add    %al,(%rax)
ffff80000010aed4:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010aed8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aede:	00 00                	add    %al,(%rax)
ffff80000010aee0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aee6:	00 00                	add    %al,(%rax)
ffff80000010aee8:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010aeee:	00 00                	add    %al,(%rax)
ffff80000010aef0:	00 00                	add    %al,(%rax)
ffff80000010aef2:	00 00                	add    %al,(%rax)
ffff80000010aef4:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010aef8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aefe:	00 00                	add    %al,(%rax)
ffff80000010af00:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af06:	00 00                	add    %al,(%rax)
ffff80000010af08:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af0e:	00 00                	add    %al,(%rax)
ffff80000010af10:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af16:	00 00                	add    %al,(%rax)
ffff80000010af18:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af1e:	00 00                	add    %al,(%rax)
ffff80000010af20:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af26:	00 00                	add    %al,(%rax)
ffff80000010af28:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010af3a:	00 00                	add    %al,(%rax)
ffff80000010af3c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010af40:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af46:	00 00                	add    %al,(%rax)
ffff80000010af48:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af4e:	00 00                	add    %al,(%rax)
ffff80000010af50:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010af56:	00 00                	add    %al,(%rax)
ffff80000010af58:	00 00                	add    %al,(%rax)
ffff80000010af5a:	00 00                	add    %al,(%rax)
ffff80000010af5c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010af60:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af66:	00 00                	add    %al,(%rax)
ffff80000010af68:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af6e:	00 00                	add    %al,(%rax)
ffff80000010af70:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af76:	00 00                	add    %al,(%rax)
ffff80000010af78:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af7e:	00 00                	add    %al,(%rax)
ffff80000010af80:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af86:	00 00                	add    %al,(%rax)
ffff80000010af88:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010af8e:	00 00                	add    %al,(%rax)
ffff80000010af90:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010afa2:	00 00                	add    %al,(%rax)
ffff80000010afa4:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010afa8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010afae:	00 00                	add    %al,(%rax)
ffff80000010afb0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010afb6:	00 00                	add    %al,(%rax)
ffff80000010afb8:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010afbe:	00 00                	add    %al,(%rax)
ffff80000010afc0:	00 00                	add    %al,(%rax)
ffff80000010afc2:	00 00                	add    %al,(%rax)
ffff80000010afc4:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010afc8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010afce:	00 00                	add    %al,(%rax)
ffff80000010afd0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010afd6:	00 00                	add    %al,(%rax)
ffff80000010afd8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010afde:	00 00                	add    %al,(%rax)
ffff80000010afe0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010afe6:	00 00                	add    %al,(%rax)
ffff80000010afe8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010afee:	00 00                	add    %al,(%rax)
ffff80000010aff0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010aff6:	00 00                	add    %al,(%rax)
ffff80000010aff8:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b00a:	00 00                	add    %al,(%rax)
ffff80000010b00c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b010:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b016:	00 00                	add    %al,(%rax)
ffff80000010b018:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b01e:	00 00                	add    %al,(%rax)
ffff80000010b020:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b026:	00 00                	add    %al,(%rax)
ffff80000010b028:	00 00                	add    %al,(%rax)
ffff80000010b02a:	00 00                	add    %al,(%rax)
ffff80000010b02c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b030:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b036:	00 00                	add    %al,(%rax)
ffff80000010b038:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b03e:	00 00                	add    %al,(%rax)
ffff80000010b040:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b046:	00 00                	add    %al,(%rax)
ffff80000010b048:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b04e:	00 00                	add    %al,(%rax)
ffff80000010b050:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b056:	00 00                	add    %al,(%rax)
ffff80000010b058:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b05e:	00 00                	add    %al,(%rax)
ffff80000010b060:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b072:	00 00                	add    %al,(%rax)
ffff80000010b074:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b078:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b07e:	00 00                	add    %al,(%rax)
ffff80000010b080:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b086:	00 00                	add    %al,(%rax)
ffff80000010b088:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b08e:	00 00                	add    %al,(%rax)
ffff80000010b090:	00 00                	add    %al,(%rax)
ffff80000010b092:	00 00                	add    %al,(%rax)
ffff80000010b094:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b098:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b09e:	00 00                	add    %al,(%rax)
ffff80000010b0a0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b0a6:	00 00                	add    %al,(%rax)
ffff80000010b0a8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b0ae:	00 00                	add    %al,(%rax)
ffff80000010b0b0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b0b6:	00 00                	add    %al,(%rax)
ffff80000010b0b8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b0be:	00 00                	add    %al,(%rax)
ffff80000010b0c0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b0c6:	00 00                	add    %al,(%rax)
ffff80000010b0c8:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b0da:	00 00                	add    %al,(%rax)
ffff80000010b0dc:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b0e0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b0e6:	00 00                	add    %al,(%rax)
ffff80000010b0e8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b0ee:	00 00                	add    %al,(%rax)
ffff80000010b0f0:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b0f6:	00 00                	add    %al,(%rax)
ffff80000010b0f8:	00 00                	add    %al,(%rax)
ffff80000010b0fa:	00 00                	add    %al,(%rax)
ffff80000010b0fc:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b100:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b106:	00 00                	add    %al,(%rax)
ffff80000010b108:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b10e:	00 00                	add    %al,(%rax)
ffff80000010b110:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b116:	00 00                	add    %al,(%rax)
ffff80000010b118:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b11e:	00 00                	add    %al,(%rax)
ffff80000010b120:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b126:	00 00                	add    %al,(%rax)
ffff80000010b128:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b12e:	00 00                	add    %al,(%rax)
ffff80000010b130:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b142:	00 00                	add    %al,(%rax)
ffff80000010b144:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b148:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b14e:	00 00                	add    %al,(%rax)
ffff80000010b150:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b156:	00 00                	add    %al,(%rax)
ffff80000010b158:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b15e:	00 00                	add    %al,(%rax)
ffff80000010b160:	00 00                	add    %al,(%rax)
ffff80000010b162:	00 00                	add    %al,(%rax)
ffff80000010b164:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b168:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b16e:	00 00                	add    %al,(%rax)
ffff80000010b170:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b176:	00 00                	add    %al,(%rax)
ffff80000010b178:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b17e:	00 00                	add    %al,(%rax)
ffff80000010b180:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b186:	00 00                	add    %al,(%rax)
ffff80000010b188:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b18e:	00 00                	add    %al,(%rax)
ffff80000010b190:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b196:	00 00                	add    %al,(%rax)
ffff80000010b198:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b1aa:	00 00                	add    %al,(%rax)
ffff80000010b1ac:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b1b0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1b6:	00 00                	add    %al,(%rax)
ffff80000010b1b8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1be:	00 00                	add    %al,(%rax)
ffff80000010b1c0:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b1c6:	00 00                	add    %al,(%rax)
ffff80000010b1c8:	00 00                	add    %al,(%rax)
ffff80000010b1ca:	00 00                	add    %al,(%rax)
ffff80000010b1cc:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b1d0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1d6:	00 00                	add    %al,(%rax)
ffff80000010b1d8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1de:	00 00                	add    %al,(%rax)
ffff80000010b1e0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1e6:	00 00                	add    %al,(%rax)
ffff80000010b1e8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1ee:	00 00                	add    %al,(%rax)
ffff80000010b1f0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1f6:	00 00                	add    %al,(%rax)
ffff80000010b1f8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b1fe:	00 00                	add    %al,(%rax)
ffff80000010b200:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b212:	00 00                	add    %al,(%rax)
ffff80000010b214:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b218:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b21e:	00 00                	add    %al,(%rax)
ffff80000010b220:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b226:	00 00                	add    %al,(%rax)
ffff80000010b228:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b22e:	00 00                	add    %al,(%rax)
ffff80000010b230:	00 00                	add    %al,(%rax)
ffff80000010b232:	00 00                	add    %al,(%rax)
ffff80000010b234:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b238:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b23e:	00 00                	add    %al,(%rax)
ffff80000010b240:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b246:	00 00                	add    %al,(%rax)
ffff80000010b248:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b24e:	00 00                	add    %al,(%rax)
ffff80000010b250:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b256:	00 00                	add    %al,(%rax)
ffff80000010b258:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b25e:	00 00                	add    %al,(%rax)
ffff80000010b260:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b266:	00 00                	add    %al,(%rax)
ffff80000010b268:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b27a:	00 00                	add    %al,(%rax)
ffff80000010b27c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b280:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b286:	00 00                	add    %al,(%rax)
ffff80000010b288:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b28e:	00 00                	add    %al,(%rax)
ffff80000010b290:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b296:	00 00                	add    %al,(%rax)
ffff80000010b298:	00 00                	add    %al,(%rax)
ffff80000010b29a:	00 00                	add    %al,(%rax)
ffff80000010b29c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b2a0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2a6:	00 00                	add    %al,(%rax)
ffff80000010b2a8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2ae:	00 00                	add    %al,(%rax)
ffff80000010b2b0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2b6:	00 00                	add    %al,(%rax)
ffff80000010b2b8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2be:	00 00                	add    %al,(%rax)
ffff80000010b2c0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2c6:	00 00                	add    %al,(%rax)
ffff80000010b2c8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2ce:	00 00                	add    %al,(%rax)
ffff80000010b2d0:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b2e2:	00 00                	add    %al,(%rax)
ffff80000010b2e4:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b2e8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2ee:	00 00                	add    %al,(%rax)
ffff80000010b2f0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b2f6:	00 00                	add    %al,(%rax)
ffff80000010b2f8:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b2fe:	00 00                	add    %al,(%rax)
ffff80000010b300:	00 00                	add    %al,(%rax)
ffff80000010b302:	00 00                	add    %al,(%rax)
ffff80000010b304:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b308:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b30e:	00 00                	add    %al,(%rax)
ffff80000010b310:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b316:	00 00                	add    %al,(%rax)
ffff80000010b318:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b31e:	00 00                	add    %al,(%rax)
ffff80000010b320:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b326:	00 00                	add    %al,(%rax)
ffff80000010b328:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b32e:	00 00                	add    %al,(%rax)
ffff80000010b330:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b336:	00 00                	add    %al,(%rax)
ffff80000010b338:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b34a:	00 00                	add    %al,(%rax)
ffff80000010b34c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b350:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b356:	00 00                	add    %al,(%rax)
ffff80000010b358:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b35e:	00 00                	add    %al,(%rax)
ffff80000010b360:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b366:	00 00                	add    %al,(%rax)
ffff80000010b368:	00 00                	add    %al,(%rax)
ffff80000010b36a:	00 00                	add    %al,(%rax)
ffff80000010b36c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b370:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b376:	00 00                	add    %al,(%rax)
ffff80000010b378:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b37e:	00 00                	add    %al,(%rax)
ffff80000010b380:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b386:	00 00                	add    %al,(%rax)
ffff80000010b388:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b38e:	00 00                	add    %al,(%rax)
ffff80000010b390:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b396:	00 00                	add    %al,(%rax)
ffff80000010b398:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b39e:	00 00                	add    %al,(%rax)
ffff80000010b3a0:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b3b2:	00 00                	add    %al,(%rax)
ffff80000010b3b4:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b3b8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b3be:	00 00                	add    %al,(%rax)
ffff80000010b3c0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b3c6:	00 00                	add    %al,(%rax)
ffff80000010b3c8:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b3ce:	00 00                	add    %al,(%rax)
ffff80000010b3d0:	00 00                	add    %al,(%rax)
ffff80000010b3d2:	00 00                	add    %al,(%rax)
ffff80000010b3d4:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b3d8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b3de:	00 00                	add    %al,(%rax)
ffff80000010b3e0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b3e6:	00 00                	add    %al,(%rax)
ffff80000010b3e8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b3ee:	00 00                	add    %al,(%rax)
ffff80000010b3f0:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b3f6:	00 00                	add    %al,(%rax)
ffff80000010b3f8:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b3fe:	00 00                	add    %al,(%rax)
ffff80000010b400:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b406:	00 00                	add    %al,(%rax)
ffff80000010b408:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b41a:	00 00                	add    %al,(%rax)
ffff80000010b41c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b420:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b426:	00 00                	add    %al,(%rax)
ffff80000010b428:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b42e:	00 00                	add    %al,(%rax)
ffff80000010b430:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
ffff80000010b436:	00 00                	add    %al,(%rax)
ffff80000010b438:	00 00                	add    %al,(%rax)
ffff80000010b43a:	00 00                	add    %al,(%rax)
ffff80000010b43c:	00 7c 00 00          	add    %bh,0x0(%rax,%rax,1)
ffff80000010b440:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b446:	00 00                	add    %al,(%rax)
ffff80000010b448:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b44e:	00 00                	add    %al,(%rax)
ffff80000010b450:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b456:	00 00                	add    %al,(%rax)
ffff80000010b458:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b45e:	00 00                	add    %al,(%rax)
ffff80000010b460:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b466:	00 00                	add    %al,(%rax)
ffff80000010b468:	00 80 ff ff 00 7c    	add    %al,0x7c00ffff(%rax)
ffff80000010b46e:	00 00                	add    %al,(%rax)
ffff80000010b470:	00 80 ff ff 00 00    	add    %al,0xffff(%rax)
	...
ffff80000010b68e:	00 00                	add    %al,(%rax)
ffff80000010b690:	00 10                	add    %dl,(%rax)
ffff80000010b692:	10 10                	adc    %dl,(%rax)
ffff80000010b694:	10 10                	adc    %dl,(%rax)
ffff80000010b696:	10 10                	adc    %dl,(%rax)
ffff80000010b698:	10 10                	adc    %dl,(%rax)
ffff80000010b69a:	00 00                	add    %al,(%rax)
ffff80000010b69c:	10 10                	adc    %dl,(%rax)
ffff80000010b69e:	00 00                	add    %al,(%rax)
ffff80000010b6a0:	28 28                	sub    %ch,(%rax)
ffff80000010b6a2:	28 00                	sub    %al,(%rax)
	...
ffff80000010b6b0:	00 44 44 44          	add    %al,0x44(%rsp,%rax,2)
ffff80000010b6b4:	fe 44 44 44          	incb   0x44(%rsp,%rax,2)
ffff80000010b6b8:	44                   	rex.R
ffff80000010b6b9:	44 fe 44 44 44       	rex.R incb 0x44(%rsp,%rax,2)
ffff80000010b6be:	00 00                	add    %al,(%rax)
ffff80000010b6c0:	10 3a                	adc    %bh,(%rdx)
ffff80000010b6c2:	56                   	push   %rsi
ffff80000010b6c3:	92                   	xchg   %eax,%edx
ffff80000010b6c4:	92                   	xchg   %eax,%edx
ffff80000010b6c5:	90                   	nop
ffff80000010b6c6:	50                   	push   %rax
ffff80000010b6c7:	38 14 12             	cmp    %dl,(%rdx,%rdx,1)
ffff80000010b6ca:	92                   	xchg   %eax,%edx
ffff80000010b6cb:	92                   	xchg   %eax,%edx
ffff80000010b6cc:	d4                   	(bad)  
ffff80000010b6cd:	b8 10 10 62 92       	mov    $0x92621010,%eax
ffff80000010b6d2:	94                   	xchg   %eax,%esp
ffff80000010b6d3:	94                   	xchg   %eax,%esp
ffff80000010b6d4:	68 08 10 10 20       	push   $0x20101008
ffff80000010b6d9:	2c 52                	sub    $0x52,%al
ffff80000010b6db:	52                   	push   %rdx
ffff80000010b6dc:	92                   	xchg   %eax,%edx
ffff80000010b6dd:	8c 00                	mov    %es,(%rax)
ffff80000010b6df:	00 00                	add    %al,(%rax)
ffff80000010b6e1:	70 88                	jo     ffff80000010b66b <tss+0x86b>
ffff80000010b6e3:	88 88 90 60 47 a2    	mov    %cl,-0x5db89f70(%rax)
ffff80000010b6e9:	92                   	xchg   %eax,%edx
ffff80000010b6ea:	8a 84 46 39 00 00 04 	mov    0x4000039(%rsi,%rax,2),%al
ffff80000010b6f1:	08 10                	or     %dl,(%rax)
	...
ffff80000010b6ff:	00 02                	add    %al,(%rdx)
ffff80000010b701:	04 08                	add    $0x8,%al
ffff80000010b703:	08 10                	or     %dl,(%rax)
ffff80000010b705:	10 10                	adc    %dl,(%rax)
ffff80000010b707:	10 10                	adc    %dl,(%rax)
ffff80000010b709:	10 10                	adc    %dl,(%rax)
ffff80000010b70b:	08 08                	or     %cl,(%rax)
ffff80000010b70d:	04 02                	add    $0x2,%al
ffff80000010b70f:	00 80 40 20 20 10    	add    %al,0x10202040(%rax)
ffff80000010b715:	10 10                	adc    %dl,(%rax)
ffff80000010b717:	10 10                	adc    %dl,(%rax)
ffff80000010b719:	10 10                	adc    %dl,(%rax)
ffff80000010b71b:	20 20                	and    %ah,(%rax)
ffff80000010b71d:	40 80 00 00          	rex addb $0x0,(%rax)
ffff80000010b721:	00 00                	add    %al,(%rax)
ffff80000010b723:	00 00                	add    %al,(%rax)
ffff80000010b725:	10 92 54 38 54 92    	adc    %dl,-0x6dabc7ac(%rdx)
ffff80000010b72b:	10 00                	adc    %al,(%rax)
	...
ffff80000010b735:	10 10                	adc    %dl,(%rax)
ffff80000010b737:	10 fe                	adc    %bh,%dh
ffff80000010b739:	10 10                	adc    %dl,(%rax)
ffff80000010b73b:	10 00                	adc    %al,(%rax)
	...
ffff80000010b749:	00 00                	add    %al,(%rax)
ffff80000010b74b:	18 18                	sbb    %bl,(%rax)
ffff80000010b74d:	08 08                	or     %cl,(%rax)
ffff80000010b74f:	10 00                	adc    %al,(%rax)
ffff80000010b751:	00 00                	add    %al,(%rax)
ffff80000010b753:	00 00                	add    %al,(%rax)
ffff80000010b755:	00 00                	add    %al,(%rax)
ffff80000010b757:	00 fe                	add    %bh,%dh
	...
ffff80000010b769:	00 00                	add    %al,(%rax)
ffff80000010b76b:	00 18                	add    %bl,(%rax)
ffff80000010b76d:	18 00                	sbb    %al,(%rax)
ffff80000010b76f:	00 02                	add    %al,(%rdx)
ffff80000010b771:	02 04 04             	add    (%rsp,%rax,1),%al
ffff80000010b774:	08 08                	or     %cl,(%rax)
ffff80000010b776:	08 10                	or     %dl,(%rax)
ffff80000010b778:	10 20                	adc    %ah,(%rax)
ffff80000010b77a:	20 40 40             	and    %al,0x40(%rax)
ffff80000010b77d:	40 80 80 00 18 24 24 	rex addb $0x42,0x24241800(%rax)
ffff80000010b784:	42 
ffff80000010b785:	42                   	rex.X
ffff80000010b786:	42                   	rex.X
ffff80000010b787:	42                   	rex.X
ffff80000010b788:	42                   	rex.X
ffff80000010b789:	42                   	rex.X
ffff80000010b78a:	42 24 24             	rex.X and $0x24,%al
ffff80000010b78d:	18 00                	sbb    %al,(%rax)
ffff80000010b78f:	00 00                	add    %al,(%rax)
ffff80000010b791:	08 18                	or     %bl,(%rax)
ffff80000010b793:	28 08                	sub    %cl,(%rax)
ffff80000010b795:	08 08                	or     %cl,(%rax)
ffff80000010b797:	08 08                	or     %cl,(%rax)
ffff80000010b799:	08 08                	or     %cl,(%rax)
ffff80000010b79b:	08 08                	or     %cl,(%rax)
ffff80000010b79d:	3e 00 00             	ds add %al,(%rax)
ffff80000010b7a0:	00 18                	add    %bl,(%rax)
ffff80000010b7a2:	24 42                	and    $0x42,%al
ffff80000010b7a4:	42 02 04 08          	add    (%rax,%r9,1),%al
ffff80000010b7a8:	10 20                	adc    %ah,(%rax)
ffff80000010b7aa:	20 40 40             	and    %al,0x40(%rax)
ffff80000010b7ad:	7e 00                	jle    ffff80000010b7af <tss+0x9af>
ffff80000010b7af:	00 00                	add    %al,(%rax)
ffff80000010b7b1:	18 24 42             	sbb    %ah,(%rdx,%rax,2)
ffff80000010b7b4:	02 02                	add    (%rdx),%al
ffff80000010b7b6:	04 18                	add    $0x18,%al
ffff80000010b7b8:	04 02                	add    $0x2,%al
ffff80000010b7ba:	02 42 24             	add    0x24(%rdx),%al
ffff80000010b7bd:	18 00                	sbb    %al,(%rax)
ffff80000010b7bf:	00 00                	add    %al,(%rax)
ffff80000010b7c1:	0c 0c                	or     $0xc,%al
ffff80000010b7c3:	0c 14                	or     $0x14,%al
ffff80000010b7c5:	14 14                	adc    $0x14,%al
ffff80000010b7c7:	24 24                	and    $0x24,%al
ffff80000010b7c9:	44 7e 04             	rex.R jle ffff80000010b7d0 <tss+0x9d0>
ffff80000010b7cc:	04 1e                	add    $0x1e,%al
ffff80000010b7ce:	00 00                	add    %al,(%rax)
ffff80000010b7d0:	00 7c 40 40          	add    %bh,0x40(%rax,%rax,2)
ffff80000010b7d4:	40 58                	rex pop %rax
ffff80000010b7d6:	64 02 02             	add    %fs:(%rdx),%al
ffff80000010b7d9:	02 02                	add    (%rdx),%al
ffff80000010b7db:	42 24 18             	rex.X and $0x18,%al
ffff80000010b7de:	00 00                	add    %al,(%rax)
ffff80000010b7e0:	00 18                	add    %bl,(%rax)
ffff80000010b7e2:	24 42                	and    $0x42,%al
ffff80000010b7e4:	40 58                	rex pop %rax
ffff80000010b7e6:	64 42                	fs rex.X
ffff80000010b7e8:	42                   	rex.X
ffff80000010b7e9:	42                   	rex.X
ffff80000010b7ea:	42                   	rex.X
ffff80000010b7eb:	42 24 18             	rex.X and $0x18,%al
ffff80000010b7ee:	00 00                	add    %al,(%rax)
ffff80000010b7f0:	00 7e 42             	add    %bh,0x42(%rsi)
ffff80000010b7f3:	42 04 04             	rex.X add $0x4,%al
ffff80000010b7f6:	08 08                	or     %cl,(%rax)
ffff80000010b7f8:	08 10                	or     %dl,(%rax)
ffff80000010b7fa:	10 10                	adc    %dl,(%rax)
ffff80000010b7fc:	10 38                	adc    %bh,(%rax)
ffff80000010b7fe:	00 00                	add    %al,(%rax)
ffff80000010b800:	00 18                	add    %bl,(%rax)
ffff80000010b802:	24 42                	and    $0x42,%al
ffff80000010b804:	42                   	rex.X
ffff80000010b805:	42 24 18             	rex.X and $0x18,%al
ffff80000010b808:	24 42                	and    $0x42,%al
ffff80000010b80a:	42                   	rex.X
ffff80000010b80b:	42 24 18             	rex.X and $0x18,%al
ffff80000010b80e:	00 00                	add    %al,(%rax)
ffff80000010b810:	00 18                	add    %bl,(%rax)
ffff80000010b812:	24 42                	and    $0x42,%al
ffff80000010b814:	42                   	rex.X
ffff80000010b815:	42                   	rex.X
ffff80000010b816:	42                   	rex.X
ffff80000010b817:	42                   	rex.X
ffff80000010b818:	26 1a 02             	es sbb (%rdx),%al
ffff80000010b81b:	42 24 18             	rex.X and $0x18,%al
ffff80000010b81e:	00 00                	add    %al,(%rax)
ffff80000010b820:	00 00                	add    %al,(%rax)
ffff80000010b822:	00 00                	add    %al,(%rax)
ffff80000010b824:	00 18                	add    %bl,(%rax)
ffff80000010b826:	18 00                	sbb    %al,(%rax)
ffff80000010b828:	00 00                	add    %al,(%rax)
ffff80000010b82a:	00 00                	add    %al,(%rax)
ffff80000010b82c:	18 18                	sbb    %bl,(%rax)
ffff80000010b82e:	00 00                	add    %al,(%rax)
ffff80000010b830:	00 00                	add    %al,(%rax)
ffff80000010b832:	00 00                	add    %al,(%rax)
ffff80000010b834:	00 18                	add    %bl,(%rax)
ffff80000010b836:	18 00                	sbb    %al,(%rax)
ffff80000010b838:	00 00                	add    %al,(%rax)
ffff80000010b83a:	00 18                	add    %bl,(%rax)
ffff80000010b83c:	18 08                	sbb    %cl,(%rax)
ffff80000010b83e:	08 10                	or     %dl,(%rax)
ffff80000010b840:	00 02                	add    %al,(%rdx)
ffff80000010b842:	04 08                	add    $0x8,%al
ffff80000010b844:	10 20                	adc    %ah,(%rax)
ffff80000010b846:	40 80 80 40 20 10 08 	rex addb $0x4,0x8102040(%rax)
ffff80000010b84d:	04 
ffff80000010b84e:	02 00                	add    (%rax),%al
ffff80000010b850:	00 00                	add    %al,(%rax)
ffff80000010b852:	00 00                	add    %al,(%rax)
ffff80000010b854:	00 00                	add    %al,(%rax)
ffff80000010b856:	fe 00                	incb   (%rax)
ffff80000010b858:	00 fe                	add    %bh,%dh
ffff80000010b85a:	00 00                	add    %al,(%rax)
ffff80000010b85c:	00 00                	add    %al,(%rax)
ffff80000010b85e:	00 00                	add    %al,(%rax)
ffff80000010b860:	00 80 40 20 10 08    	add    %al,0x8102040(%rax)
ffff80000010b866:	04 02                	add    $0x2,%al
ffff80000010b868:	02 04 08             	add    (%rax,%rcx,1),%al
ffff80000010b86b:	10 20                	adc    %ah,(%rax)
ffff80000010b86d:	40 80 00 00          	rex addb $0x0,(%rax)
ffff80000010b871:	38 44 82 82          	cmp    %al,-0x7e(%rdx,%rax,4)
ffff80000010b875:	82                   	(bad)  
ffff80000010b876:	04 08                	add    $0x8,%al
ffff80000010b878:	10 10                	adc    %dl,(%rax)
ffff80000010b87a:	00 00                	add    %al,(%rax)
ffff80000010b87c:	18 18                	sbb    %bl,(%rax)
ffff80000010b87e:	00 00                	add    %al,(%rax)
ffff80000010b880:	00 38                	add    %bh,(%rax)
ffff80000010b882:	44 82                	rex.R (bad) 
ffff80000010b884:	9a                   	(bad)  
ffff80000010b885:	aa                   	stos   %al,%es:(%rdi)
ffff80000010b886:	aa                   	stos   %al,%es:(%rdi)
ffff80000010b887:	aa                   	stos   %al,%es:(%rdi)
ffff80000010b888:	aa                   	stos   %al,%es:(%rdi)
ffff80000010b889:	aa                   	stos   %al,%es:(%rdi)
ffff80000010b88a:	9c                   	pushf  
ffff80000010b88b:	80 46 38 00          	addb   $0x0,0x38(%rsi)
ffff80000010b88f:	00 00                	add    %al,(%rax)
ffff80000010b891:	18 18                	sbb    %bl,(%rax)
ffff80000010b893:	18 18                	sbb    %bl,(%rax)
ffff80000010b895:	24 24                	and    $0x24,%al
ffff80000010b897:	24 24                	and    $0x24,%al
ffff80000010b899:	7e 42                	jle    ffff80000010b8dd <tss+0xadd>
ffff80000010b89b:	42                   	rex.X
ffff80000010b89c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010b89f:	00 00                	add    %al,(%rax)
ffff80000010b8a1:	f0 48                	lock rex.W
ffff80000010b8a3:	44                   	rex.R
ffff80000010b8a4:	44                   	rex.R
ffff80000010b8a5:	44                   	rex.R
ffff80000010b8a6:	48 78 44             	rex.W js ffff80000010b8ed <tss+0xaed>
ffff80000010b8a9:	42                   	rex.X
ffff80000010b8aa:	42                   	rex.X
ffff80000010b8ab:	42                   	rex.X
ffff80000010b8ac:	44 f8                	rex.R clc 
ffff80000010b8ae:	00 00                	add    %al,(%rax)
ffff80000010b8b0:	00 3a                	add    %bh,(%rdx)
ffff80000010b8b2:	46                   	rex.RX
ffff80000010b8b3:	42 82                	rex.X (bad) 
ffff80000010b8b5:	80 80 80 80 80 82 42 	addb   $0x42,-0x7d7f7f80(%rax)
ffff80000010b8bc:	44 38 00             	cmp    %r8b,(%rax)
ffff80000010b8bf:	00 00                	add    %al,(%rax)
ffff80000010b8c1:	f8                   	clc    
ffff80000010b8c2:	44                   	rex.R
ffff80000010b8c3:	44                   	rex.R
ffff80000010b8c4:	42                   	rex.X
ffff80000010b8c5:	42                   	rex.X
ffff80000010b8c6:	42                   	rex.X
ffff80000010b8c7:	42                   	rex.X
ffff80000010b8c8:	42                   	rex.X
ffff80000010b8c9:	42                   	rex.X
ffff80000010b8ca:	42                   	rex.X
ffff80000010b8cb:	44                   	rex.R
ffff80000010b8cc:	44 f8                	rex.R clc 
ffff80000010b8ce:	00 00                	add    %al,(%rax)
ffff80000010b8d0:	00 fe                	add    %bh,%dh
ffff80000010b8d2:	42                   	rex.X
ffff80000010b8d3:	42                   	rex.X
ffff80000010b8d4:	40                   	rex
ffff80000010b8d5:	40                   	rex
ffff80000010b8d6:	44 7c 44             	rex.R jl ffff80000010b91d <tss+0xb1d>
ffff80000010b8d9:	40                   	rex
ffff80000010b8da:	40                   	rex
ffff80000010b8db:	42                   	rex.X
ffff80000010b8dc:	42 fe 00             	rex.X incb (%rax)
ffff80000010b8df:	00 00                	add    %al,(%rax)
ffff80000010b8e1:	fe 42 42             	incb   0x42(%rdx)
ffff80000010b8e4:	40                   	rex
ffff80000010b8e5:	40                   	rex
ffff80000010b8e6:	44 7c 44             	rex.R jl ffff80000010b92d <tss+0xb2d>
ffff80000010b8e9:	44                   	rex.R
ffff80000010b8ea:	40                   	rex
ffff80000010b8eb:	40                   	rex
ffff80000010b8ec:	40                   	rex
ffff80000010b8ed:	f0 00 00             	lock add %al,(%rax)
ffff80000010b8f0:	00 3a                	add    %bh,(%rdx)
ffff80000010b8f2:	46                   	rex.RX
ffff80000010b8f3:	42 82                	rex.X (bad) 
ffff80000010b8f5:	80 80 9e 82 82 82 42 	addb   $0x42,-0x7d7d7d62(%rax)
ffff80000010b8fc:	46 38 00             	rex.RX cmp %r8b,(%rax)
ffff80000010b8ff:	00 00                	add    %al,(%rax)
ffff80000010b901:	e7 42                	out    %eax,$0x42
ffff80000010b903:	42                   	rex.X
ffff80000010b904:	42                   	rex.X
ffff80000010b905:	42                   	rex.X
ffff80000010b906:	42 7e 42             	rex.X jle ffff80000010b94b <tss+0xb4b>
ffff80000010b909:	42                   	rex.X
ffff80000010b90a:	42                   	rex.X
ffff80000010b90b:	42                   	rex.X
ffff80000010b90c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010b90f:	00 00                	add    %al,(%rax)
ffff80000010b911:	7c 10                	jl     ffff80000010b923 <tss+0xb23>
ffff80000010b913:	10 10                	adc    %dl,(%rax)
ffff80000010b915:	10 10                	adc    %dl,(%rax)
ffff80000010b917:	10 10                	adc    %dl,(%rax)
ffff80000010b919:	10 10                	adc    %dl,(%rax)
ffff80000010b91b:	10 10                	adc    %dl,(%rax)
ffff80000010b91d:	7c 00                	jl     ffff80000010b91f <tss+0xb1f>
ffff80000010b91f:	00 00                	add    %al,(%rax)
ffff80000010b921:	1f                   	(bad)  
ffff80000010b922:	04 04                	add    $0x4,%al
ffff80000010b924:	04 04                	add    $0x4,%al
ffff80000010b926:	04 04                	add    $0x4,%al
ffff80000010b928:	04 04                	add    $0x4,%al
ffff80000010b92a:	04 04                	add    $0x4,%al
ffff80000010b92c:	84 48 30             	test   %cl,0x30(%rax)
ffff80000010b92f:	00 00                	add    %al,(%rax)
ffff80000010b931:	e7 42                	out    %eax,$0x42
ffff80000010b933:	44                   	rex.R
ffff80000010b934:	48 50                	rex.W push %rax
ffff80000010b936:	50                   	push   %rax
ffff80000010b937:	60                   	(bad)  
ffff80000010b938:	50                   	push   %rax
ffff80000010b939:	50                   	push   %rax
ffff80000010b93a:	48                   	rex.W
ffff80000010b93b:	44                   	rex.R
ffff80000010b93c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010b93f:	00 00                	add    %al,(%rax)
ffff80000010b941:	f0 40                	lock rex
ffff80000010b943:	40                   	rex
ffff80000010b944:	40                   	rex
ffff80000010b945:	40                   	rex
ffff80000010b946:	40                   	rex
ffff80000010b947:	40                   	rex
ffff80000010b948:	40                   	rex
ffff80000010b949:	40                   	rex
ffff80000010b94a:	40                   	rex
ffff80000010b94b:	42                   	rex.X
ffff80000010b94c:	42 fe 00             	rex.X incb (%rax)
ffff80000010b94f:	00 00                	add    %al,(%rax)
ffff80000010b951:	c3                   	ret    
ffff80000010b952:	42                   	rex.X
ffff80000010b953:	66 66 66 5a          	data16 data16 pop %dx
ffff80000010b957:	5a                   	pop    %rdx
ffff80000010b958:	5a                   	pop    %rdx
ffff80000010b959:	42                   	rex.X
ffff80000010b95a:	42                   	rex.X
ffff80000010b95b:	42                   	rex.X
ffff80000010b95c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010b95f:	00 00                	add    %al,(%rax)
ffff80000010b961:	c7 42 62 62 52 52 52 	movl   $0x52525262,0x62(%rdx)
ffff80000010b968:	4a                   	rex.WX
ffff80000010b969:	4a                   	rex.WX
ffff80000010b96a:	4a                   	rex.WX
ffff80000010b96b:	46                   	rex.RX
ffff80000010b96c:	46 e2 00             	rex.RX loop ffff80000010b96f <tss+0xb6f>
ffff80000010b96f:	00 00                	add    %al,(%rax)
ffff80000010b971:	38 44 82 82          	cmp    %al,-0x7e(%rdx,%rax,4)
ffff80000010b975:	82                   	(bad)  
ffff80000010b976:	82                   	(bad)  
ffff80000010b977:	82                   	(bad)  
ffff80000010b978:	82                   	(bad)  
ffff80000010b979:	82                   	(bad)  
ffff80000010b97a:	82                   	(bad)  
ffff80000010b97b:	82                   	(bad)  
ffff80000010b97c:	44 38 00             	cmp    %r8b,(%rax)
ffff80000010b97f:	00 00                	add    %al,(%rax)
ffff80000010b981:	f8                   	clc    
ffff80000010b982:	44                   	rex.R
ffff80000010b983:	42                   	rex.X
ffff80000010b984:	42                   	rex.X
ffff80000010b985:	42                   	rex.X
ffff80000010b986:	44 78 40             	rex.R js ffff80000010b9c9 <tss+0xbc9>
ffff80000010b989:	40                   	rex
ffff80000010b98a:	40                   	rex
ffff80000010b98b:	40                   	rex
ffff80000010b98c:	40                   	rex
ffff80000010b98d:	f0 00 00             	lock add %al,(%rax)
ffff80000010b990:	00 38                	add    %bh,(%rax)
ffff80000010b992:	44 82                	rex.R (bad) 
ffff80000010b994:	82                   	(bad)  
ffff80000010b995:	82                   	(bad)  
ffff80000010b996:	82                   	(bad)  
ffff80000010b997:	82                   	(bad)  
ffff80000010b998:	82                   	(bad)  
ffff80000010b999:	82                   	(bad)  
ffff80000010b99a:	92                   	xchg   %eax,%edx
ffff80000010b99b:	8a 44 3a 00          	mov    0x0(%rdx,%rdi,1),%al
ffff80000010b99f:	00 00                	add    %al,(%rax)
ffff80000010b9a1:	fc                   	cld    
ffff80000010b9a2:	42                   	rex.X
ffff80000010b9a3:	42                   	rex.X
ffff80000010b9a4:	42                   	rex.X
ffff80000010b9a5:	42 7c 44             	rex.X jl ffff80000010b9ec <tss+0xbec>
ffff80000010b9a8:	42                   	rex.X
ffff80000010b9a9:	42                   	rex.X
ffff80000010b9aa:	42                   	rex.X
ffff80000010b9ab:	42                   	rex.X
ffff80000010b9ac:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010b9af:	00 00                	add    %al,(%rax)
ffff80000010b9b1:	3a 46 82             	cmp    -0x7e(%rsi),%al
ffff80000010b9b4:	82                   	(bad)  
ffff80000010b9b5:	80 40 38 04          	addb   $0x4,0x38(%rax)
ffff80000010b9b9:	02 82 82 c4 b8 00    	add    0xb8c482(%rdx),%al
ffff80000010b9bf:	00 00                	add    %al,(%rax)
ffff80000010b9c1:	fe                   	(bad)  
ffff80000010b9c2:	92                   	xchg   %eax,%edx
ffff80000010b9c3:	92                   	xchg   %eax,%edx
ffff80000010b9c4:	10 10                	adc    %dl,(%rax)
ffff80000010b9c6:	10 10                	adc    %dl,(%rax)
ffff80000010b9c8:	10 10                	adc    %dl,(%rax)
ffff80000010b9ca:	10 10                	adc    %dl,(%rax)
ffff80000010b9cc:	10 7c 00 00          	adc    %bh,0x0(%rax,%rax,1)
ffff80000010b9d0:	00 e7                	add    %ah,%bh
ffff80000010b9d2:	42                   	rex.X
ffff80000010b9d3:	42                   	rex.X
ffff80000010b9d4:	42                   	rex.X
ffff80000010b9d5:	42                   	rex.X
ffff80000010b9d6:	42                   	rex.X
ffff80000010b9d7:	42                   	rex.X
ffff80000010b9d8:	42                   	rex.X
ffff80000010b9d9:	42                   	rex.X
ffff80000010b9da:	42                   	rex.X
ffff80000010b9db:	42 24 3c             	rex.X and $0x3c,%al
ffff80000010b9de:	00 00                	add    %al,(%rax)
ffff80000010b9e0:	00 e7                	add    %ah,%bh
ffff80000010b9e2:	42                   	rex.X
ffff80000010b9e3:	42                   	rex.X
ffff80000010b9e4:	42                   	rex.X
ffff80000010b9e5:	42 24 24             	rex.X and $0x24,%al
ffff80000010b9e8:	24 24                	and    $0x24,%al
ffff80000010b9ea:	18 18                	sbb    %bl,(%rax)
ffff80000010b9ec:	18 18                	sbb    %bl,(%rax)
ffff80000010b9ee:	00 00                	add    %al,(%rax)
ffff80000010b9f0:	00 e7                	add    %ah,%bh
ffff80000010b9f2:	42                   	rex.X
ffff80000010b9f3:	42                   	rex.X
ffff80000010b9f4:	42 5a                	rex.X pop %rdx
ffff80000010b9f6:	5a                   	pop    %rdx
ffff80000010b9f7:	5a                   	pop    %rdx
ffff80000010b9f8:	5a                   	pop    %rdx
ffff80000010b9f9:	24 24                	and    $0x24,%al
ffff80000010b9fb:	24 24                	and    $0x24,%al
ffff80000010b9fd:	24 00                	and    $0x0,%al
ffff80000010b9ff:	00 00                	add    %al,(%rax)
ffff80000010ba01:	e7 42                	out    %eax,$0x42
ffff80000010ba03:	42 24 24             	rex.X and $0x24,%al
ffff80000010ba06:	24 18                	and    $0x18,%al
ffff80000010ba08:	24 24                	and    $0x24,%al
ffff80000010ba0a:	24 42                	and    $0x42,%al
ffff80000010ba0c:	42 e7 00             	rex.X out %eax,$0x0
ffff80000010ba0f:	00 00                	add    %al,(%rax)
ffff80000010ba11:	ee                   	out    %al,(%dx)
ffff80000010ba12:	44                   	rex.R
ffff80000010ba13:	44                   	rex.R
ffff80000010ba14:	44 28 28             	sub    %r13b,(%rax)
ffff80000010ba17:	28 10                	sub    %dl,(%rax)
ffff80000010ba19:	10 10                	adc    %dl,(%rax)
ffff80000010ba1b:	10 10                	adc    %dl,(%rax)
ffff80000010ba1d:	7c 00                	jl     ffff80000010ba1f <tss+0xc1f>
ffff80000010ba1f:	00 00                	add    %al,(%rax)
ffff80000010ba21:	fe 84 84 08 08 10 10 	incb   0x10100808(%rsp,%rax,4)
ffff80000010ba28:	20 20                	and    %ah,(%rax)
ffff80000010ba2a:	40                   	rex
ffff80000010ba2b:	42 82                	rex.X (bad) 
ffff80000010ba2d:	fe 00                	incb   (%rax)
ffff80000010ba2f:	00 00                	add    %al,(%rax)
ffff80000010ba31:	3e 20 20             	ds and %ah,(%rax)
ffff80000010ba34:	20 20                	and    %ah,(%rax)
ffff80000010ba36:	20 20                	and    %ah,(%rax)
ffff80000010ba38:	20 20                	and    %ah,(%rax)
ffff80000010ba3a:	20 20                	and    %ah,(%rax)
ffff80000010ba3c:	20 20                	and    %ah,(%rax)
ffff80000010ba3e:	3e 00 80 80 40 40 20 	ds add %al,0x20404080(%rax)
ffff80000010ba45:	20 20                	and    %ah,(%rax)
ffff80000010ba47:	10 10                	adc    %dl,(%rax)
ffff80000010ba49:	08 08                	or     %cl,(%rax)
ffff80000010ba4b:	04 04                	add    $0x4,%al
ffff80000010ba4d:	04 02                	add    $0x2,%al
ffff80000010ba4f:	02 00                	add    (%rax),%al
ffff80000010ba51:	7c 04                	jl     ffff80000010ba57 <tss+0xc57>
ffff80000010ba53:	04 04                	add    $0x4,%al
ffff80000010ba55:	04 04                	add    $0x4,%al
ffff80000010ba57:	04 04                	add    $0x4,%al
ffff80000010ba59:	04 04                	add    $0x4,%al
ffff80000010ba5b:	04 04                	add    $0x4,%al
ffff80000010ba5d:	04 7c                	add    $0x7c,%al
ffff80000010ba5f:	00 00                	add    %al,(%rax)
ffff80000010ba61:	10 28                	adc    %ch,(%rax)
ffff80000010ba63:	44 82                	rex.R (bad) 
	...
ffff80000010ba7d:	00 fe                	add    %bh,%dh
ffff80000010ba7f:	00 10                	add    %dl,(%rax)
ffff80000010ba81:	08 04 00             	or     %al,(%rax,%rax,1)
	...
ffff80000010ba94:	00 70 08             	add    %dh,0x8(%rax)
ffff80000010ba97:	04 3c                	add    $0x3c,%al
ffff80000010ba99:	44 84 84 8c 76 00 00 	test   %r8b,-0x3fffff8a(%rsp,%rcx,4)
ffff80000010baa0:	c0 
ffff80000010baa1:	40                   	rex
ffff80000010baa2:	40                   	rex
ffff80000010baa3:	40                   	rex
ffff80000010baa4:	40 58                	rex pop %rax
ffff80000010baa6:	64 42                	fs rex.X
ffff80000010baa8:	42                   	rex.X
ffff80000010baa9:	42                   	rex.X
ffff80000010baaa:	42                   	rex.X
ffff80000010baab:	42                   	rex.X
ffff80000010baac:	64 58                	fs pop %rax
ffff80000010baae:	00 00                	add    %al,(%rax)
ffff80000010bab0:	00 00                	add    %al,(%rax)
ffff80000010bab2:	00 00                	add    %al,(%rax)
ffff80000010bab4:	00 30                	add    %dh,(%rax)
ffff80000010bab6:	4c 84 84 80 80 82 44 	rex.WR test %r8b,0x38448280(%rax,%rax,4)
ffff80000010babd:	38 
ffff80000010babe:	00 00                	add    %al,(%rax)
ffff80000010bac0:	0c 04                	or     $0x4,%al
ffff80000010bac2:	04 04                	add    $0x4,%al
ffff80000010bac4:	04 34                	add    $0x34,%al
ffff80000010bac6:	4c 84 84 84 84 84 4c 	rex.WR test %r8b,0x364c8484(%rsp,%rax,4)
ffff80000010bacd:	36 
ffff80000010bace:	00 00                	add    %al,(%rax)
ffff80000010bad0:	00 00                	add    %al,(%rax)
ffff80000010bad2:	00 00                	add    %al,(%rax)
ffff80000010bad4:	00 38                	add    %bh,(%rax)
ffff80000010bad6:	44 82                	rex.R (bad) 
ffff80000010bad8:	82                   	(bad)  
ffff80000010bad9:	fc                   	cld    
ffff80000010bada:	80 82 42 3c 00 00 0e 	addb   $0xe,0x3c42(%rdx)
ffff80000010bae1:	10 10                	adc    %dl,(%rax)
ffff80000010bae3:	10 10                	adc    %dl,(%rax)
ffff80000010bae5:	7c 10                	jl     ffff80000010baf7 <tss+0xcf7>
ffff80000010bae7:	10 10                	adc    %dl,(%rax)
ffff80000010bae9:	10 10                	adc    %dl,(%rax)
ffff80000010baeb:	10 10                	adc    %dl,(%rax)
ffff80000010baed:	7c 00                	jl     ffff80000010baef <tss+0xcef>
ffff80000010baef:	00 00                	add    %al,(%rax)
ffff80000010baf1:	00 00                	add    %al,(%rax)
ffff80000010baf3:	00 00                	add    %al,(%rax)
ffff80000010baf5:	36 4c 84 84 84 84 4c 	ss rex.WR test %r8b,0x4344c84(%rsp,%rax,4)
ffff80000010bafc:	34 04 
ffff80000010bafe:	04 38                	add    $0x38,%al
ffff80000010bb00:	c0 40 40 40          	rolb   $0x40,0x40(%rax)
ffff80000010bb04:	40 58                	rex pop %rax
ffff80000010bb06:	64 42                	fs rex.X
ffff80000010bb08:	42                   	rex.X
ffff80000010bb09:	42                   	rex.X
ffff80000010bb0a:	42                   	rex.X
ffff80000010bb0b:	42                   	rex.X
ffff80000010bb0c:	42 e3 00             	rex.X jrcxz ffff80000010bb0f <tss+0xd0f>
ffff80000010bb0f:	00 00                	add    %al,(%rax)
ffff80000010bb11:	10 10                	adc    %dl,(%rax)
ffff80000010bb13:	00 00                	add    %al,(%rax)
ffff80000010bb15:	30 10                	xor    %dl,(%rax)
ffff80000010bb17:	10 10                	adc    %dl,(%rax)
ffff80000010bb19:	10 10                	adc    %dl,(%rax)
ffff80000010bb1b:	10 10                	adc    %dl,(%rax)
ffff80000010bb1d:	38 00                	cmp    %al,(%rax)
ffff80000010bb1f:	00 00                	add    %al,(%rax)
ffff80000010bb21:	04 04                	add    $0x4,%al
ffff80000010bb23:	00 00                	add    %al,(%rax)
ffff80000010bb25:	0c 04                	or     $0x4,%al
ffff80000010bb27:	04 04                	add    $0x4,%al
ffff80000010bb29:	04 04                	add    $0x4,%al
ffff80000010bb2b:	04 04                	add    $0x4,%al
ffff80000010bb2d:	08 08                	or     %cl,(%rax)
ffff80000010bb2f:	30 c0                	xor    %al,%al
ffff80000010bb31:	40                   	rex
ffff80000010bb32:	40                   	rex
ffff80000010bb33:	40                   	rex
ffff80000010bb34:	40                   	rex
ffff80000010bb35:	4e                   	rex.WRX
ffff80000010bb36:	44                   	rex.R
ffff80000010bb37:	48 50                	rex.W push %rax
ffff80000010bb39:	60                   	(bad)  
ffff80000010bb3a:	50                   	push   %rax
ffff80000010bb3b:	48                   	rex.W
ffff80000010bb3c:	44 e6 00             	rex.R out %al,$0x0
ffff80000010bb3f:	00 30                	add    %dh,(%rax)
ffff80000010bb41:	10 10                	adc    %dl,(%rax)
ffff80000010bb43:	10 10                	adc    %dl,(%rax)
ffff80000010bb45:	10 10                	adc    %dl,(%rax)
ffff80000010bb47:	10 10                	adc    %dl,(%rax)
ffff80000010bb49:	10 10                	adc    %dl,(%rax)
ffff80000010bb4b:	10 10                	adc    %dl,(%rax)
ffff80000010bb4d:	38 00                	cmp    %al,(%rax)
ffff80000010bb4f:	00 00                	add    %al,(%rax)
ffff80000010bb51:	00 00                	add    %al,(%rax)
ffff80000010bb53:	00 00                	add    %al,(%rax)
ffff80000010bb55:	f6 49 49 49          	testb  $0x49,0x49(%rcx)
ffff80000010bb59:	49                   	rex.WB
ffff80000010bb5a:	49                   	rex.WB
ffff80000010bb5b:	49                   	rex.WB
ffff80000010bb5c:	49 db 00             	rex.WB fildl (%r8)
ffff80000010bb5f:	00 00                	add    %al,(%rax)
ffff80000010bb61:	00 00                	add    %al,(%rax)
ffff80000010bb63:	00 00                	add    %al,(%rax)
ffff80000010bb65:	d8 64 42 42          	fsubs  0x42(%rdx,%rax,2)
ffff80000010bb69:	42                   	rex.X
ffff80000010bb6a:	42                   	rex.X
ffff80000010bb6b:	42                   	rex.X
ffff80000010bb6c:	42 e3 00             	rex.X jrcxz ffff80000010bb6f <tss+0xd6f>
ffff80000010bb6f:	00 00                	add    %al,(%rax)
ffff80000010bb71:	00 00                	add    %al,(%rax)
ffff80000010bb73:	00 00                	add    %al,(%rax)
ffff80000010bb75:	38 44 82 82          	cmp    %al,-0x7e(%rdx,%rax,4)
ffff80000010bb79:	82                   	(bad)  
ffff80000010bb7a:	82                   	(bad)  
ffff80000010bb7b:	82                   	(bad)  
ffff80000010bb7c:	44 38 00             	cmp    %r8b,(%rax)
ffff80000010bb7f:	00 00                	add    %al,(%rax)
ffff80000010bb81:	00 00                	add    %al,(%rax)
ffff80000010bb83:	00 d8                	add    %bl,%al
ffff80000010bb85:	64 42                	fs rex.X
ffff80000010bb87:	42                   	rex.X
ffff80000010bb88:	42                   	rex.X
ffff80000010bb89:	42                   	rex.X
ffff80000010bb8a:	42                   	rex.X
ffff80000010bb8b:	64 58                	fs pop %rax
ffff80000010bb8d:	40                   	rex
ffff80000010bb8e:	40 e0 00             	rex loopne ffff80000010bb91 <tss+0xd91>
ffff80000010bb91:	00 00                	add    %al,(%rax)
ffff80000010bb93:	00 34 4c             	add    %dh,(%rsp,%rcx,2)
ffff80000010bb96:	84 84 84 84 84 4c 34 	test   %al,0x344c8484(%rsp,%rax,4)
ffff80000010bb9d:	04 04                	add    $0x4,%al
ffff80000010bb9f:	0e                   	(bad)  
ffff80000010bba0:	00 00                	add    %al,(%rax)
ffff80000010bba2:	00 00                	add    %al,(%rax)
ffff80000010bba4:	00 dc                	add    %bl,%ah
ffff80000010bba6:	62 42                	(bad)  
ffff80000010bba8:	40                   	rex
ffff80000010bba9:	40                   	rex
ffff80000010bbaa:	40                   	rex
ffff80000010bbab:	40                   	rex
ffff80000010bbac:	40 e0 00             	rex loopne ffff80000010bbaf <tss+0xdaf>
ffff80000010bbaf:	00 00                	add    %al,(%rax)
ffff80000010bbb1:	00 00                	add    %al,(%rax)
ffff80000010bbb3:	00 00                	add    %al,(%rax)
ffff80000010bbb5:	7a 86                	jp     ffff80000010bb3d <tss+0xd3d>
ffff80000010bbb7:	82                   	(bad)  
ffff80000010bbb8:	c0 38 06             	sarb   $0x6,(%rax)
ffff80000010bbbb:	82                   	(bad)  
ffff80000010bbbc:	c2 bc 00             	ret    $0xbc
ffff80000010bbbf:	00 00                	add    %al,(%rax)
ffff80000010bbc1:	00 10                	add    %dl,(%rax)
ffff80000010bbc3:	10 10                	adc    %dl,(%rax)
ffff80000010bbc5:	7c 10                	jl     ffff80000010bbd7 <tss+0xdd7>
ffff80000010bbc7:	10 10                	adc    %dl,(%rax)
ffff80000010bbc9:	10 10                	adc    %dl,(%rax)
ffff80000010bbcb:	10 10                	adc    %dl,(%rax)
ffff80000010bbcd:	0e                   	(bad)  
ffff80000010bbce:	00 00                	add    %al,(%rax)
ffff80000010bbd0:	00 00                	add    %al,(%rax)
ffff80000010bbd2:	00 00                	add    %al,(%rax)
ffff80000010bbd4:	00 c6                	add    %al,%dh
ffff80000010bbd6:	42                   	rex.X
ffff80000010bbd7:	42                   	rex.X
ffff80000010bbd8:	42                   	rex.X
ffff80000010bbd9:	42                   	rex.X
ffff80000010bbda:	42                   	rex.X
ffff80000010bbdb:	42                   	rex.X
ffff80000010bbdc:	46 3b 00             	rex.RX cmp (%rax),%r8d
ffff80000010bbdf:	00 00                	add    %al,(%rax)
ffff80000010bbe1:	00 00                	add    %al,(%rax)
ffff80000010bbe3:	00 00                	add    %al,(%rax)
ffff80000010bbe5:	e7 42                	out    %eax,$0x42
ffff80000010bbe7:	42                   	rex.X
ffff80000010bbe8:	42 24 24             	rex.X and $0x24,%al
ffff80000010bbeb:	24 18                	and    $0x18,%al
ffff80000010bbed:	18 00                	sbb    %al,(%rax)
ffff80000010bbef:	00 00                	add    %al,(%rax)
ffff80000010bbf1:	00 00                	add    %al,(%rax)
ffff80000010bbf3:	00 00                	add    %al,(%rax)
ffff80000010bbf5:	e7 42                	out    %eax,$0x42
ffff80000010bbf7:	42 5a                	rex.X pop %rdx
ffff80000010bbf9:	5a                   	pop    %rdx
ffff80000010bbfa:	5a                   	pop    %rdx
ffff80000010bbfb:	24 24                	and    $0x24,%al
ffff80000010bbfd:	24 00                	and    $0x0,%al
ffff80000010bbff:	00 00                	add    %al,(%rax)
ffff80000010bc01:	00 00                	add    %al,(%rax)
ffff80000010bc03:	00 00                	add    %al,(%rax)
ffff80000010bc05:	c6 44 28 28 10       	movb   $0x10,0x28(%rax,%rbp,1)
ffff80000010bc0a:	28 28                	sub    %ch,(%rax)
ffff80000010bc0c:	44 c6 00 00          	rex.R movb $0x0,(%rax)
ffff80000010bc10:	00 00                	add    %al,(%rax)
ffff80000010bc12:	00 00                	add    %al,(%rax)
ffff80000010bc14:	00 e7                	add    %ah,%bh
ffff80000010bc16:	42                   	rex.X
ffff80000010bc17:	42 24 24             	rex.X and $0x24,%al
ffff80000010bc1a:	24 18                	and    $0x18,%al
ffff80000010bc1c:	18 10                	sbb    %dl,(%rax)
ffff80000010bc1e:	10 60 00             	adc    %ah,0x0(%rax)
ffff80000010bc21:	00 00                	add    %al,(%rax)
ffff80000010bc23:	00 00                	add    %al,(%rax)
ffff80000010bc25:	fe 82 84 08 10 20    	incb   0x20100884(%rdx)
ffff80000010bc2b:	42 82                	rex.X (bad) 
ffff80000010bc2d:	fe 00                	incb   (%rax)
ffff80000010bc2f:	00 00                	add    %al,(%rax)
ffff80000010bc31:	06                   	(bad)  
ffff80000010bc32:	08 10                	or     %dl,(%rax)
ffff80000010bc34:	10 10                	adc    %dl,(%rax)
ffff80000010bc36:	10 60 10             	adc    %ah,0x10(%rax)
ffff80000010bc39:	10 10                	adc    %dl,(%rax)
ffff80000010bc3b:	10 08                	adc    %cl,(%rax)
ffff80000010bc3d:	06                   	(bad)  
ffff80000010bc3e:	00 00                	add    %al,(%rax)
ffff80000010bc40:	10 10                	adc    %dl,(%rax)
ffff80000010bc42:	10 10                	adc    %dl,(%rax)
ffff80000010bc44:	10 10                	adc    %dl,(%rax)
ffff80000010bc46:	10 10                	adc    %dl,(%rax)
ffff80000010bc48:	10 10                	adc    %dl,(%rax)
ffff80000010bc4a:	10 10                	adc    %dl,(%rax)
ffff80000010bc4c:	10 10                	adc    %dl,(%rax)
ffff80000010bc4e:	10 10                	adc    %dl,(%rax)
ffff80000010bc50:	00 60 10             	add    %ah,0x10(%rax)
ffff80000010bc53:	08 08                	or     %cl,(%rax)
ffff80000010bc55:	08 08                	or     %cl,(%rax)
ffff80000010bc57:	06                   	(bad)  
ffff80000010bc58:	08 08                	or     %cl,(%rax)
ffff80000010bc5a:	08 08                	or     %cl,(%rax)
ffff80000010bc5c:	10 60 00             	adc    %ah,0x0(%rax)
ffff80000010bc5f:	00 00                	add    %al,(%rax)
ffff80000010bc61:	72 8c                	jb     ffff80000010bbef <tss+0xdef>
	...

Disassembly of section .rodata:

ffff80000010c480 <_rodata>:
ffff80000010c480:	30 31                	xor    %dh,(%rcx)
ffff80000010c482:	32 33                	xor    (%rbx),%dh
ffff80000010c484:	34 35                	xor    $0x35,%al
ffff80000010c486:	36 37                	ss (bad) 
ffff80000010c488:	38 39                	cmp    %bh,(%rcx)
ffff80000010c48a:	41                   	rex.B
ffff80000010c48b:	42                   	rex.X
ffff80000010c48c:	43                   	rex.XB
ffff80000010c48d:	44                   	rex.R
ffff80000010c48e:	45                   	rex.RB
ffff80000010c48f:	46                   	rex.RX
ffff80000010c490:	47                   	rex.RXB
ffff80000010c491:	48                   	rex.W
ffff80000010c492:	49                   	rex.WB
ffff80000010c493:	4a                   	rex.WX
ffff80000010c494:	4b                   	rex.WXB
ffff80000010c495:	4c                   	rex.WR
ffff80000010c496:	4d                   	rex.WRB
ffff80000010c497:	4e                   	rex.WRX
ffff80000010c498:	4f 50                	rex.WRXB push %r8
ffff80000010c49a:	51                   	push   %rcx
ffff80000010c49b:	52                   	push   %rdx
ffff80000010c49c:	53                   	push   %rbx
ffff80000010c49d:	54                   	push   %rsp
ffff80000010c49e:	55                   	push   %rbp
ffff80000010c49f:	56                   	push   %rsi
ffff80000010c4a0:	57                   	push   %rdi
ffff80000010c4a1:	58                   	pop    %rax
ffff80000010c4a2:	59                   	pop    %rcx
ffff80000010c4a3:	5a                   	pop    %rdx
ffff80000010c4a4:	00 00                	add    %al,(%rax)
ffff80000010c4a6:	00 00                	add    %al,(%rax)
ffff80000010c4a8:	30 31                	xor    %dh,(%rcx)
ffff80000010c4aa:	32 33                	xor    (%rbx),%dh
ffff80000010c4ac:	34 35                	xor    $0x35,%al
ffff80000010c4ae:	36 37                	ss (bad) 
ffff80000010c4b0:	38 39                	cmp    %bh,(%rcx)
ffff80000010c4b2:	61                   	(bad)  
ffff80000010c4b3:	62 63 64 65 66       	(bad)
ffff80000010c4b8:	67 68 69 6a 6b 6c    	addr32 push $0x6c6b6a69
ffff80000010c4be:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010c4bf:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010c4c0:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010c4c1:	70 71                	jo     ffff80000010c534 <_rodata+0xb4>
ffff80000010c4c3:	72 73                	jb     ffff80000010c538 <_rodata+0xb8>
ffff80000010c4c5:	74 75                	je     ffff80000010c53c <_rodata+0xbc>
ffff80000010c4c7:	76 77                	jbe    ffff80000010c540 <_rodata+0xc0>
ffff80000010c4c9:	78 79                	js     ffff80000010c544 <_rodata+0xc4>
ffff80000010c4cb:	7a 00                	jp     ffff80000010c4cd <_rodata+0x4d>
ffff80000010c4cd:	00 00                	add    %al,(%rax)
ffff80000010c4cf:	00 97 48 10 00 00    	add    %dl,0x1048(%rdi)
ffff80000010c4d5:	80 ff ff             	cmp    $0xff,%bh
ffff80000010c4d8:	a9 48 10 00 00       	test   $0x1048,%eax
ffff80000010c4dd:	80 ff ff             	cmp    $0xff,%bh
ffff80000010c4e0:	a9 48 10 00 00       	test   $0x1048,%eax
ffff80000010c4e5:	80 ff ff             	cmp    $0xff,%bh
ffff80000010c4e8:	9d                   	popf   
ffff80000010c4e9:	48 10 00             	rex.W adc %al,(%rax)
ffff80000010c4ec:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c4f2:	10 00                	adc    %al,(%rax)
ffff80000010c4f4:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c4fa:	10 00                	adc    %al,(%rax)
ffff80000010c4fc:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c502:	10 00                	adc    %al,(%rax)
ffff80000010c504:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c50a:	10 00                	adc    %al,(%rax)
ffff80000010c50c:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c512:	10 00                	adc    %al,(%rax)
ffff80000010c514:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c51a:	10 00                	adc    %al,(%rax)
ffff80000010c51c:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c522:	10 00                	adc    %al,(%rax)
ffff80000010c524:	00 80 ff ff 91 48    	add    %al,0x4891ffff(%rax)
ffff80000010c52a:	10 00                	adc    %al,(%rax)
ffff80000010c52c:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c532:	10 00                	adc    %al,(%rax)
ffff80000010c534:	00 80 ff ff 8b 48    	add    %al,0x488bffff(%rax)
ffff80000010c53a:	10 00                	adc    %al,(%rax)
ffff80000010c53c:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c542:	10 00                	adc    %al,(%rax)
ffff80000010c544:	00 80 ff ff a9 48    	add    %al,0x48a9ffff(%rax)
ffff80000010c54a:	10 00                	adc    %al,(%rax)
ffff80000010c54c:	00 80 ff ff a3 48    	add    %al,0x48a3ffff(%rax)
ffff80000010c552:	10 00                	adc    %al,(%rax)
ffff80000010c554:	00 80 ff ff 76 52    	add    %al,0x5276ffff(%rax)
ffff80000010c55a:	10 00                	adc    %al,(%rax)
ffff80000010c55c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c562:	10 00                	adc    %al,(%rax)
ffff80000010c564:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c56a:	10 00                	adc    %al,(%rax)
ffff80000010c56c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c572:	10 00                	adc    %al,(%rax)
ffff80000010c574:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c57a:	10 00                	adc    %al,(%rax)
ffff80000010c57c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c582:	10 00                	adc    %al,(%rax)
ffff80000010c584:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c58a:	10 00                	adc    %al,(%rax)
ffff80000010c58c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c592:	10 00                	adc    %al,(%rax)
ffff80000010c594:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c59a:	10 00                	adc    %al,(%rax)
ffff80000010c59c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5a2:	10 00                	adc    %al,(%rax)
ffff80000010c5a4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5aa:	10 00                	adc    %al,(%rax)
ffff80000010c5ac:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5b2:	10 00                	adc    %al,(%rax)
ffff80000010c5b4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5ba:	10 00                	adc    %al,(%rax)
ffff80000010c5bc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5c2:	10 00                	adc    %al,(%rax)
ffff80000010c5c4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5ca:	10 00                	adc    %al,(%rax)
ffff80000010c5cc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5d2:	10 00                	adc    %al,(%rax)
ffff80000010c5d4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5da:	10 00                	adc    %al,(%rax)
ffff80000010c5dc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5e2:	10 00                	adc    %al,(%rax)
ffff80000010c5e4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5ea:	10 00                	adc    %al,(%rax)
ffff80000010c5ec:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5f2:	10 00                	adc    %al,(%rax)
ffff80000010c5f4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c5fa:	10 00                	adc    %al,(%rax)
ffff80000010c5fc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c602:	10 00                	adc    %al,(%rax)
ffff80000010c604:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c60a:	10 00                	adc    %al,(%rax)
ffff80000010c60c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c612:	10 00                	adc    %al,(%rax)
ffff80000010c614:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c61a:	10 00                	adc    %al,(%rax)
ffff80000010c61c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c622:	10 00                	adc    %al,(%rax)
ffff80000010c624:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c62a:	10 00                	adc    %al,(%rax)
ffff80000010c62c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c632:	10 00                	adc    %al,(%rax)
ffff80000010c634:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c63a:	10 00                	adc    %al,(%rax)
ffff80000010c63c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c642:	10 00                	adc    %al,(%rax)
ffff80000010c644:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c64a:	10 00                	adc    %al,(%rax)
ffff80000010c64c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c652:	10 00                	adc    %al,(%rax)
ffff80000010c654:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c65a:	10 00                	adc    %al,(%rax)
ffff80000010c65c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c662:	10 00                	adc    %al,(%rax)
ffff80000010c664:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c66a:	10 00                	adc    %al,(%rax)
ffff80000010c66c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c672:	10 00                	adc    %al,(%rax)
ffff80000010c674:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c67a:	10 00                	adc    %al,(%rax)
ffff80000010c67c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c682:	10 00                	adc    %al,(%rax)
ffff80000010c684:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c68a:	10 00                	adc    %al,(%rax)
ffff80000010c68c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c692:	10 00                	adc    %al,(%rax)
ffff80000010c694:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c69a:	10 00                	adc    %al,(%rax)
ffff80000010c69c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6a2:	10 00                	adc    %al,(%rax)
ffff80000010c6a4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6aa:	10 00                	adc    %al,(%rax)
ffff80000010c6ac:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6b2:	10 00                	adc    %al,(%rax)
ffff80000010c6b4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6ba:	10 00                	adc    %al,(%rax)
ffff80000010c6bc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6c2:	10 00                	adc    %al,(%rax)
ffff80000010c6c4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6ca:	10 00                	adc    %al,(%rax)
ffff80000010c6cc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6d2:	10 00                	adc    %al,(%rax)
ffff80000010c6d4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6da:	10 00                	adc    %al,(%rax)
ffff80000010c6dc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6e2:	10 00                	adc    %al,(%rax)
ffff80000010c6e4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6ea:	10 00                	adc    %al,(%rax)
ffff80000010c6ec:	00 80 ff ff bc 4d    	add    %al,0x4dbcffff(%rax)
ffff80000010c6f2:	10 00                	adc    %al,(%rax)
ffff80000010c6f4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c6fa:	10 00                	adc    %al,(%rax)
ffff80000010c6fc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c702:	10 00                	adc    %al,(%rax)
ffff80000010c704:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c70a:	10 00                	adc    %al,(%rax)
ffff80000010c70c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c712:	10 00                	adc    %al,(%rax)
ffff80000010c714:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c71a:	10 00                	adc    %al,(%rax)
ffff80000010c71c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c722:	10 00                	adc    %al,(%rax)
ffff80000010c724:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c72a:	10 00                	adc    %al,(%rax)
ffff80000010c72c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c732:	10 00                	adc    %al,(%rax)
ffff80000010c734:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c73a:	10 00                	adc    %al,(%rax)
ffff80000010c73c:	00 80 ff ff 86 50    	add    %al,0x5086ffff(%rax)
ffff80000010c742:	10 00                	adc    %al,(%rax)
ffff80000010c744:	00 80 ff ff 85 4a    	add    %al,0x4a85ffff(%rax)
ffff80000010c74a:	10 00                	adc    %al,(%rax)
ffff80000010c74c:	00 80 ff ff bc 4e    	add    %al,0x4ebcffff(%rax)
ffff80000010c752:	10 00                	adc    %al,(%rax)
ffff80000010c754:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c75a:	10 00                	adc    %al,(%rax)
ffff80000010c75c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c762:	10 00                	adc    %al,(%rax)
ffff80000010c764:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c76a:	10 00                	adc    %al,(%rax)
ffff80000010c76c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c772:	10 00                	adc    %al,(%rax)
ffff80000010c774:	00 80 ff ff bc 4e    	add    %al,0x4ebcffff(%rax)
ffff80000010c77a:	10 00                	adc    %al,(%rax)
ffff80000010c77c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c782:	10 00                	adc    %al,(%rax)
ffff80000010c784:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c78a:	10 00                	adc    %al,(%rax)
ffff80000010c78c:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c792:	10 00                	adc    %al,(%rax)
ffff80000010c794:	00 80 ff ff 04 51    	add    %al,0x5104ffff(%rax)
ffff80000010c79a:	10 00                	adc    %al,(%rax)
ffff80000010c79c:	00 80 ff ff c0 4f    	add    %al,0x4fc0ffff(%rax)
ffff80000010c7a2:	10 00                	adc    %al,(%rax)
ffff80000010c7a4:	00 80 ff ff 29 4c    	add    %al,0x4c29ffff(%rax)
ffff80000010c7aa:	10 00                	adc    %al,(%rax)
ffff80000010c7ac:	00 80 ff ff 29 4d    	add    %al,0x4d29ffff(%rax)
ffff80000010c7b2:	10 00                	adc    %al,(%rax)
ffff80000010c7b4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c7ba:	10 00                	adc    %al,(%rax)
ffff80000010c7bc:	00 80 ff ff c0 51    	add    %al,0x51c0ffff(%rax)
ffff80000010c7c2:	10 00                	adc    %al,(%rax)
ffff80000010c7c4:	00 80 ff ff 1f 4b    	add    %al,0x4b1fffff(%rax)
ffff80000010c7ca:	10 00                	adc    %al,(%rax)
ffff80000010c7cc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c7d2:	10 00                	adc    %al,(%rax)
ffff80000010c7d4:	00 80 ff ff c0 4e    	add    %al,0x4ec0ffff(%rax)
ffff80000010c7da:	10 00                	adc    %al,(%rax)
ffff80000010c7dc:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c7e2:	10 00                	adc    %al,(%rax)
ffff80000010c7e4:	00 80 ff ff 87 52    	add    %al,0x5287ffff(%rax)
ffff80000010c7ea:	10 00                	adc    %al,(%rax)
ffff80000010c7ec:	00 80 ff ff b8 4d    	add    %al,0x4db8ffff(%rax)
ffff80000010c7f2:	10 00                	adc    %al,(%rax)
ffff80000010c7f4:	00 80 ff ff 61 73    	add    %al,0x7361ffff(%rax)
ffff80000010c7fa:	73 65                	jae    ffff80000010c861 <_rodata+0x3e1>
ffff80000010c7fc:	72 74                	jb     ffff80000010c872 <_rodata+0x3f2>
ffff80000010c7fe:	20 3a                	and    %bh,(%rdx)
ffff80000010c800:	20 00                	and    %al,(%rax)
ffff80000010c802:	1b 5b 34             	sbb    0x34(%rbx),%ebx
ffff80000010c805:	30 6d 00             	xor    %ch,0x0(%rbp)
ffff80000010c808:	1b 5b 33             	sbb    0x33(%rbx),%ebx
ffff80000010c80b:	31 6d 00             	xor    %ebp,0x0(%rbp)
ffff80000010c80e:	00 00                	add    %al,(%rax)
ffff80000010c810:	25 73 2d 2d 2d       	and    $0x2d2d2d73,%eax
ffff80000010c815:	2d 2d 3e 66 69       	sub    $0x69663e2d,%eax
ffff80000010c81a:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c81b:	65 3a 25 73 09 62 61 	cmp    %gs:0x61620973(%rip),%ah        # ffff80006172d195 <_ebss+0x6161e2ad>
ffff80000010c822:	73 65                	jae    ffff80000010c889 <_rodata+0x409>
ffff80000010c824:	5f                   	pop    %rdi
ffff80000010c825:	66 69 6c 65 3a 25 73 	imul   $0x7325,0x3a(%rbp,%riz,2),%bp
ffff80000010c82c:	09 66 75             	or     %esp,0x75(%rsi)
ffff80000010c82f:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010c830:	63 3a                	movsxd (%rdx),%edi
ffff80000010c832:	25 73 09 6c 69       	and    $0x696c0973,%eax
ffff80000010c837:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010c838:	65 3a 25 64 0a 00 1b 	cmp    %gs:0x1b000a64(%rip),%ah        # ffff80001b10d2a3 <_ebss+0x1affe3bb>
ffff80000010c83f:	5b                   	pop    %rbx
ffff80000010c840:	30 6d 00             	xor    %ch,0x0(%rbp)
ffff80000010c843:	00 00                	add    %al,(%rax)
ffff80000010c845:	00 00                	add    %al,(%rax)
ffff80000010c847:	00 25 73 0a 00 1b    	add    %ah,0x1b000a73(%rip)        # ffff80001b10d2c0 <_ebss+0x1affe3d8>
ffff80000010c84d:	5b                   	pop    %rbx
ffff80000010c84e:	34 30                	xor    $0x30,%al
ffff80000010c850:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010c851:	00 1b                	add    %bl,(%rbx)
ffff80000010c853:	5b                   	pop    %rbx
ffff80000010c854:	33 32                	xor    (%rdx),%esi
ffff80000010c856:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010c857:	00 25 73 00 0a 00    	add    %ah,0xa0073(%rip)        # ffff8000001ac8d0 <_ebss+0x9d9e8>
ffff80000010c85d:	00 00                	add    %al,(%rax)
ffff80000010c85f:	00 46 61             	add    %al,0x61(%rsi)
ffff80000010c862:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010c863:	69 6c 79 3a 25 78 20 	imul   $0x45207825,0x3a(%rcx,%rdi,2),%ebp
ffff80000010c86a:	45 
ffff80000010c86b:	78 74                	js     ffff80000010c8e1 <_rodata+0x461>
ffff80000010c86d:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010c86f:	64 65 64 20 46 61    	fs gs and %al,%fs:0x61(%rsi)
ffff80000010c875:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010c876:	69 6c 79 3a 25 78 20 	imul   $0x4d207825,0x3a(%rcx,%rdi,2),%ebp
ffff80000010c87d:	4d 
ffff80000010c87e:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010c87f:	64 65 3a 25 78 20 45 	fs cmp %gs:0x78452078(%rip),%ah        # ffff80007855e8ff <_ebss+0x7844fa17>
ffff80000010c886:	78 
ffff80000010c887:	74 65                	je     ffff80000010c8ee <_rodata+0x46e>
ffff80000010c889:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010c88a:	64 65 64 20 4d 6f    	fs gs and %cl,%fs:0x6f(%rbp)
ffff80000010c890:	64 65 3a 25 78 20 43 	fs cmp %gs:0x50432078(%rip),%ah        # ffff80005053e910 <_ebss+0x5042fa28>
ffff80000010c897:	50 
ffff80000010c898:	55                   	push   %rbp
ffff80000010c899:	74 79                	je     ffff80000010c914 <_rodata+0x494>
ffff80000010c89b:	70 65                	jo     ffff80000010c902 <_rodata+0x482>
ffff80000010c89d:	3a 25 78 20 53 74    	cmp    0x74532078(%rip),%ah        # ffff80007463e91b <_ebss+0x7452fa33>
ffff80000010c8a3:	65 70 49             	gs jo  ffff80000010c8ef <_rodata+0x46f>
ffff80000010c8a6:	44 3a 25 78 0a 00 00 	cmp    0xa78(%rip),%r12b        # ffff80000010d325 <_erodata+0x5a>
ffff80000010c8ad:	00 00                	add    %al,(%rax)
ffff80000010c8af:	00 63 70             	add    %ah,0x70(%rbx)
ffff80000010c8b2:	75 20                	jne    ffff80000010c8d4 <_rodata+0x454>
ffff80000010c8b4:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010c8b5:	75 6d                	jne    ffff80000010c924 <_rodata+0x4a4>
ffff80000010c8b7:	20 3a                	and    %bh,(%rdx)
ffff80000010c8b9:	20 25 6c 78 20 69    	and    %ah,0x6920786c(%rip)        # ffff80006931412b <_ebss+0x69205243>
ffff80000010c8bf:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010c8c0:	69 74 20 61 70 69 63 	imul   $0x20636970,0x61(%rax,%riz,1),%esi
ffff80000010c8c7:	20 
ffff80000010c8c8:	69 64 20 3a 20 25 6c 	imul   $0x786c2520,0x3a(%rax,%riz,1),%esp
ffff80000010c8cf:	78 
ffff80000010c8d0:	0a 00                	or     (%rax),%al
ffff80000010c8d2:	00 00                	add    %al,(%rax)
ffff80000010c8d4:	00 00                	add    %al,(%rax)
ffff80000010c8d6:	00 00                	add    %al,(%rax)
ffff80000010c8d8:	50                   	push   %rax
ffff80000010c8d9:	68 79 73 69 63       	push   $0x63697379
ffff80000010c8de:	61                   	(bad)  
ffff80000010c8df:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c8e0:	20 41 64             	and    %al,0x64(%rcx)
ffff80000010c8e3:	64 72 65             	fs jb  ffff80000010c94b <_rodata+0x4cb>
ffff80000010c8e6:	73 73                	jae    ffff80000010c95b <_rodata+0x4db>
ffff80000010c8e8:	20 57 69             	and    %dl,0x69(%rdi)
ffff80000010c8eb:	64 74 68             	fs je  ffff80000010c956 <_rodata+0x4d6>
ffff80000010c8ee:	3a 25 64 20 4c 69    	cmp    0x694c2064(%rip),%ah        # ffff8000695ce958 <_ebss+0x694bfa70>
ffff80000010c8f4:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010c8f5:	65 61                	gs (bad) 
ffff80000010c8f7:	72 20                	jb     ffff80000010c919 <_rodata+0x499>
ffff80000010c8f9:	41                   	rex.B
ffff80000010c8fa:	64 64 72 65          	fs fs jb ffff80000010c963 <_rodata+0x4e3>
ffff80000010c8fe:	73 73                	jae    ffff80000010c973 <_rodata+0x4f3>
ffff80000010c900:	20 57 69             	and    %dl,0x69(%rdi)
ffff80000010c903:	64 74 68             	fs je  ffff80000010c96e <_rodata+0x4ee>
ffff80000010c906:	3a 25 64 0a 00 4d    	cmp    0x4d000a64(%rip),%ah        # ffff80004d10d370 <_ebss+0x4cffe488>
ffff80000010c90c:	41 58                	pop    %r8
ffff80000010c90e:	20 4f 70             	and    %cl,0x70(%rdi)
ffff80000010c911:	65 72 61             	gs jb  ffff80000010c975 <_rodata+0x4f5>
ffff80000010c914:	74 6f                	je     ffff80000010c985 <_rodata+0x505>
ffff80000010c916:	72 20                	jb     ffff80000010c938 <_rodata+0x4b8>
ffff80000010c918:	43 6f                	rex.XB outsl %ds:(%rsi),(%dx)
ffff80000010c91a:	64 65 3a 25 78 09 00 	fs cmp %gs:0x4d000978(%rip),%ah        # ffff80004d10d29a <_ebss+0x4cffe3b2>
ffff80000010c921:	4d 
ffff80000010c922:	41 58                	pop    %r8
ffff80000010c924:	20 45 58             	and    %al,0x58(%rbp)
ffff80000010c927:	54                   	push   %rsp
ffff80000010c928:	20 4f 70             	and    %cl,0x70(%rdi)
ffff80000010c92b:	65 72 61             	gs jb  ffff80000010c98f <_rodata+0x50f>
ffff80000010c92e:	74 6f                	je     ffff80000010c99f <_rodata+0x51f>
ffff80000010c930:	72 20                	jb     ffff80000010c952 <_rodata+0x4d2>
ffff80000010c932:	43 6f                	rex.XB outsl %ds:(%rsi),(%dx)
ffff80000010c934:	64 65 3a 25 78 0a 00 	fs cmp %gs:0xa78(%rip),%ah        # ffff80000010d3b4 <_erodata+0xe9>
ffff80000010c93b:	00 
ffff80000010c93c:	00 00                	add    %al,(%rax)
ffff80000010c93e:	00 00                	add    %al,(%rax)
ffff80000010c940:	43 53                	rex.XB push %r11
ffff80000010c942:	3a 25 23 30 31 30    	cmp    0x30313023(%rip),%ah        # ffff80003041f96b <_ebss+0x30310a83>
ffff80000010c948:	78 2c                	js     ffff80000010c976 <_rodata+0x4f6>
ffff80000010c94a:	53                   	push   %rbx
ffff80000010c94b:	53                   	push   %rbx
ffff80000010c94c:	3a 25 23 30 31 30    	cmp    0x30313023(%rip),%ah        # ffff80003041f975 <_ebss+0x30310a8d>
ffff80000010c952:	78 0a                	js     ffff80000010c95e <_rodata+0x4de>
ffff80000010c954:	44 53                	rex.R push %rbx
ffff80000010c956:	3a 25 23 30 31 30    	cmp    0x30313023(%rip),%ah        # ffff80003041f97f <_ebss+0x30310a97>
ffff80000010c95c:	78 2c                	js     ffff80000010c98a <_rodata+0x50a>
ffff80000010c95e:	45 53                	rex.RB push %r11
ffff80000010c960:	3a 25 23 30 31 30    	cmp    0x30313023(%rip),%ah        # ffff80003041f989 <_ebss+0x30310aa1>
ffff80000010c966:	78 0a                	js     ffff80000010c972 <_rodata+0x4f2>
ffff80000010c968:	52                   	push   %rdx
ffff80000010c969:	46                   	rex.RX
ffff80000010c96a:	4c                   	rex.WR
ffff80000010c96b:	41                   	rex.B
ffff80000010c96c:	47 53                	rex.RXB push %r11
ffff80000010c96e:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f997 <_ebss+0x38310aaf>
ffff80000010c974:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c975:	78 0a                	js     ffff80000010c981 <_rodata+0x501>
ffff80000010c977:	00 1b                	add    %bl,(%rbx)
ffff80000010c979:	5b                   	pop    %rbx
ffff80000010c97a:	34 30                	xor    $0x30,%al
ffff80000010c97c:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010c97d:	00 1b                	add    %bl,(%rbx)
ffff80000010c97f:	5b                   	pop    %rbx
ffff80000010c980:	33 33                	xor    (%rbx),%esi
ffff80000010c982:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010c983:	00 00                	add    %al,(%rax)
ffff80000010c985:	00 00                	add    %al,(%rax)
ffff80000010c987:	00 52 41             	add    %dl,0x41(%rdx)
ffff80000010c98a:	58                   	pop    %rax
ffff80000010c98b:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f9b4 <_ebss+0x38310acc>
ffff80000010c991:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c992:	78 2c                	js     ffff80000010c9c0 <_rodata+0x540>
ffff80000010c994:	52                   	push   %rdx
ffff80000010c995:	42 58                	rex.X pop %rax
ffff80000010c997:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f9c0 <_ebss+0x38310ad8>
ffff80000010c99d:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c99e:	78 2c                	js     ffff80000010c9cc <_rodata+0x54c>
ffff80000010c9a0:	52                   	push   %rdx
ffff80000010c9a1:	43 58                	rex.XB pop %r8
ffff80000010c9a3:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f9cc <_ebss+0x38310ae4>
ffff80000010c9a9:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c9aa:	78 2c                	js     ffff80000010c9d8 <_rodata+0x558>
ffff80000010c9ac:	52                   	push   %rdx
ffff80000010c9ad:	44 58                	rex.R pop %rax
ffff80000010c9af:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f9d8 <_ebss+0x38310af0>
ffff80000010c9b5:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c9b6:	78 0a                	js     ffff80000010c9c2 <_rodata+0x542>
ffff80000010c9b8:	52                   	push   %rdx
ffff80000010c9b9:	53                   	push   %rbx
ffff80000010c9ba:	50                   	push   %rax
ffff80000010c9bb:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f9e4 <_ebss+0x38310afc>
ffff80000010c9c1:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c9c2:	78 2c                	js     ffff80000010c9f0 <_rodata+0x570>
ffff80000010c9c4:	52                   	push   %rdx
ffff80000010c9c5:	42 50                	rex.X push %rax
ffff80000010c9c7:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f9f0 <_ebss+0x38310b08>
ffff80000010c9cd:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c9ce:	78 2c                	js     ffff80000010c9fc <_rodata+0x57c>
ffff80000010c9d0:	52                   	push   %rdx
ffff80000010c9d1:	49 50                	rex.WB push %r8
ffff80000010c9d3:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841f9fc <_ebss+0x38310b14>
ffff80000010c9d9:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c9da:	78 0a                	js     ffff80000010c9e6 <_rodata+0x566>
ffff80000010c9dc:	52                   	push   %rdx
ffff80000010c9dd:	53                   	push   %rbx
ffff80000010c9de:	49 3a 25 23 30 31 38 	rex.WB cmp 0x38313023(%rip),%spl        # ffff80003841fa08 <_ebss+0x38310b20>
ffff80000010c9e5:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c9e6:	78 2c                	js     ffff80000010ca14 <_rodata+0x594>
ffff80000010c9e8:	52                   	push   %rdx
ffff80000010c9e9:	44                   	rex.R
ffff80000010c9ea:	49 3a 25 23 30 31 38 	rex.WB cmp 0x38313023(%rip),%spl        # ffff80003841fa14 <_ebss+0x38310b2c>
ffff80000010c9f1:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010c9f2:	78 0a                	js     ffff80000010c9fe <_rodata+0x57e>
ffff80000010c9f4:	00 00                	add    %al,(%rax)
ffff80000010c9f6:	00 00                	add    %al,(%rax)
ffff80000010c9f8:	52                   	push   %rdx
ffff80000010c9f9:	38 20                	cmp    %ah,(%rax)
ffff80000010c9fb:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fa24 <_ebss+0x38310b3c>
ffff80000010ca01:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca02:	78 2c                	js     ffff80000010ca30 <_rodata+0x5b0>
ffff80000010ca04:	52                   	push   %rdx
ffff80000010ca05:	39 20                	cmp    %esp,(%rax)
ffff80000010ca07:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fa30 <_ebss+0x38310b48>
ffff80000010ca0d:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca0e:	78 0a                	js     ffff80000010ca1a <_rodata+0x59a>
ffff80000010ca10:	52                   	push   %rdx
ffff80000010ca11:	31 30                	xor    %esi,(%rax)
ffff80000010ca13:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fa3c <_ebss+0x38310b54>
ffff80000010ca19:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca1a:	78 2c                	js     ffff80000010ca48 <_rodata+0x5c8>
ffff80000010ca1c:	52                   	push   %rdx
ffff80000010ca1d:	31 31                	xor    %esi,(%rcx)
ffff80000010ca1f:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fa48 <_ebss+0x38310b60>
ffff80000010ca25:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca26:	78 0a                	js     ffff80000010ca32 <_rodata+0x5b2>
ffff80000010ca28:	52                   	push   %rdx
ffff80000010ca29:	31 32                	xor    %esi,(%rdx)
ffff80000010ca2b:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fa54 <_ebss+0x38310b6c>
ffff80000010ca31:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca32:	78 2c                	js     ffff80000010ca60 <_rodata+0x5e0>
ffff80000010ca34:	52                   	push   %rdx
ffff80000010ca35:	31 33                	xor    %esi,(%rbx)
ffff80000010ca37:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fa60 <_ebss+0x38310b78>
ffff80000010ca3d:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca3e:	78 0a                	js     ffff80000010ca4a <_rodata+0x5ca>
ffff80000010ca40:	52                   	push   %rdx
ffff80000010ca41:	31 34 3a             	xor    %esi,(%rdx,%rdi,1)
ffff80000010ca44:	25 23 30 31 38       	and    $0x38313023,%eax
ffff80000010ca49:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca4a:	78 2c                	js     ffff80000010ca78 <_rodata+0x5f8>
ffff80000010ca4c:	52                   	push   %rdx
ffff80000010ca4d:	31 35 3a 25 23 30    	xor    %esi,0x3023253a(%rip)        # ffff80003033ef8d <_ebss+0x302300a5>
ffff80000010ca53:	31 38                	xor    %edi,(%rax)
ffff80000010ca55:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca56:	78 0a                	js     ffff80000010ca62 <_rodata+0x5e2>
	...
ffff80000010ca60:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010ca62:	5f                   	pop    %rdi
ffff80000010ca63:	64 69 76 69 64 65 5f 	imul   $0x655f6564,%fs:0x69(%rsi),%esi
ffff80000010ca6a:	65 
ffff80000010ca6b:	72 72                	jb     ffff80000010cadf <_rodata+0x65f>
ffff80000010ca6d:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010ca6e:	72 28                	jb     ffff80000010ca98 <_rodata+0x618>
ffff80000010ca70:	30 29                	xor    %ch,(%rcx)
ffff80000010ca72:	2c 20                	sub    $0x20,%al
ffff80000010ca74:	45 52                	rex.RB push %r10
ffff80000010ca76:	52                   	push   %rdx
ffff80000010ca77:	4f 52                	rex.WRXB push %r10
ffff80000010ca79:	5f                   	pop    %rdi
ffff80000010ca7a:	43                   	rex.XB
ffff80000010ca7b:	4f                   	rex.WRXB
ffff80000010ca7c:	44                   	rex.R
ffff80000010ca7d:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841faa7 <_ebss+0x38310bbf>
ffff80000010ca84:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca85:	78 2c                	js     ffff80000010cab3 <_rodata+0x633>
ffff80000010ca87:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010ca8a:	50                   	push   %rax
ffff80000010ca8b:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fab4 <_ebss+0x38310bcc>
ffff80000010ca91:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca92:	78 2c                	js     ffff80000010cac0 <_rodata+0x640>
ffff80000010ca94:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010ca97:	50                   	push   %rax
ffff80000010ca98:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fac1 <_ebss+0x38310bd9>
ffff80000010ca9e:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ca9f:	78 0a                	js     ffff80000010caab <_rodata+0x62b>
ffff80000010caa1:	00 1b                	add    %bl,(%rbx)
ffff80000010caa3:	5b                   	pop    %rbx
ffff80000010caa4:	33 31                	xor    (%rcx),%esi
ffff80000010caa6:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010caa7:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010caab:	64 65 62 75 67 28 31 	(bad)
ffff80000010cab2:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010cab5:	45 52                	rex.RB push %r10
ffff80000010cab7:	52                   	push   %rdx
ffff80000010cab8:	4f 52                	rex.WRXB push %r10
ffff80000010caba:	5f                   	pop    %rdi
ffff80000010cabb:	43                   	rex.XB
ffff80000010cabc:	4f                   	rex.WRXB
ffff80000010cabd:	44                   	rex.R
ffff80000010cabe:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fae8 <_ebss+0x38310c00>
ffff80000010cac5:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cac6:	78 2c                	js     ffff80000010caf4 <_rodata+0x674>
ffff80000010cac8:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cacb:	50                   	push   %rax
ffff80000010cacc:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841faf5 <_ebss+0x38310c0d>
ffff80000010cad2:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cad3:	78 2c                	js     ffff80000010cb01 <_rodata+0x681>
ffff80000010cad5:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cad8:	50                   	push   %rax
ffff80000010cad9:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fb02 <_ebss+0x38310c1a>
ffff80000010cadf:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cae0:	78 0a                	js     ffff80000010caec <_rodata+0x66c>
ffff80000010cae2:	00 00                	add    %al,(%rax)
ffff80000010cae4:	00 00                	add    %al,(%rax)
ffff80000010cae6:	00 00                	add    %al,(%rax)
ffff80000010cae8:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010caea:	5f                   	pop    %rdi
ffff80000010caeb:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010caec:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010caed:	69 28 32 29 2c 20    	imul   $0x202c2932,(%rax),%ebp
ffff80000010caf3:	45 52                	rex.RB push %r10
ffff80000010caf5:	52                   	push   %rdx
ffff80000010caf6:	4f 52                	rex.WRXB push %r10
ffff80000010caf8:	5f                   	pop    %rdi
ffff80000010caf9:	43                   	rex.XB
ffff80000010cafa:	4f                   	rex.WRXB
ffff80000010cafb:	44                   	rex.R
ffff80000010cafc:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fb26 <_ebss+0x38310c3e>
ffff80000010cb03:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb04:	78 2c                	js     ffff80000010cb32 <_rodata+0x6b2>
ffff80000010cb06:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cb09:	50                   	push   %rax
ffff80000010cb0a:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fb33 <_ebss+0x38310c4b>
ffff80000010cb10:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb11:	78 2c                	js     ffff80000010cb3f <_rodata+0x6bf>
ffff80000010cb13:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cb16:	50                   	push   %rax
ffff80000010cb17:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fb40 <_ebss+0x38310c58>
ffff80000010cb1d:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb1e:	78 0a                	js     ffff80000010cb2a <_rodata+0x6aa>
	...
ffff80000010cb28:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010cb2a:	5f                   	pop    %rdi
ffff80000010cb2b:	69 6e 74 33 28 33 29 	imul   $0x29332833,0x74(%rsi),%ebp
ffff80000010cb32:	2c 20                	sub    $0x20,%al
ffff80000010cb34:	45 52                	rex.RB push %r10
ffff80000010cb36:	52                   	push   %rdx
ffff80000010cb37:	4f 52                	rex.WRXB push %r10
ffff80000010cb39:	5f                   	pop    %rdi
ffff80000010cb3a:	43                   	rex.XB
ffff80000010cb3b:	4f                   	rex.WRXB
ffff80000010cb3c:	44                   	rex.R
ffff80000010cb3d:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fb67 <_ebss+0x38310c7f>
ffff80000010cb44:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb45:	78 2c                	js     ffff80000010cb73 <_rodata+0x6f3>
ffff80000010cb47:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cb4a:	50                   	push   %rax
ffff80000010cb4b:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fb74 <_ebss+0x38310c8c>
ffff80000010cb51:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb52:	78 2c                	js     ffff80000010cb80 <_rodata+0x700>
ffff80000010cb54:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cb57:	50                   	push   %rax
ffff80000010cb58:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fb81 <_ebss+0x38310c99>
ffff80000010cb5e:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb5f:	78 0a                	js     ffff80000010cb6b <_rodata+0x6eb>
ffff80000010cb61:	00 00                	add    %al,(%rax)
ffff80000010cb63:	00 00                	add    %al,(%rax)
ffff80000010cb65:	00 00                	add    %al,(%rax)
ffff80000010cb67:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010cb6b:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cb6c:	76 65                	jbe    ffff80000010cbd3 <_rodata+0x753>
ffff80000010cb6e:	72 66                	jb     ffff80000010cbd6 <_rodata+0x756>
ffff80000010cb70:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb71:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cb72:	77 28                	ja     ffff80000010cb9c <_rodata+0x71c>
ffff80000010cb74:	34 29                	xor    $0x29,%al
ffff80000010cb76:	2c 20                	sub    $0x20,%al
ffff80000010cb78:	45 52                	rex.RB push %r10
ffff80000010cb7a:	52                   	push   %rdx
ffff80000010cb7b:	4f 52                	rex.WRXB push %r10
ffff80000010cb7d:	5f                   	pop    %rdi
ffff80000010cb7e:	43                   	rex.XB
ffff80000010cb7f:	4f                   	rex.WRXB
ffff80000010cb80:	44                   	rex.R
ffff80000010cb81:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fbab <_ebss+0x38310cc3>
ffff80000010cb88:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb89:	78 2c                	js     ffff80000010cbb7 <_rodata+0x737>
ffff80000010cb8b:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cb8e:	50                   	push   %rax
ffff80000010cb8f:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fbb8 <_ebss+0x38310cd0>
ffff80000010cb95:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cb96:	78 2c                	js     ffff80000010cbc4 <_rodata+0x744>
ffff80000010cb98:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cb9b:	50                   	push   %rax
ffff80000010cb9c:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fbc5 <_ebss+0x38310cdd>
ffff80000010cba2:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cba3:	78 0a                	js     ffff80000010cbaf <_rodata+0x72f>
ffff80000010cba5:	00 00                	add    %al,(%rax)
ffff80000010cba7:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010cbab:	62                   	(bad)  
ffff80000010cbac:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cbad:	75 6e                	jne    ffff80000010cc1d <_rodata+0x79d>
ffff80000010cbaf:	64 73 28             	fs jae ffff80000010cbda <_rodata+0x75a>
ffff80000010cbb2:	35 29 2c 20 45       	xor    $0x45202c29,%eax
ffff80000010cbb7:	52                   	push   %rdx
ffff80000010cbb8:	52                   	push   %rdx
ffff80000010cbb9:	4f 52                	rex.WRXB push %r10
ffff80000010cbbb:	5f                   	pop    %rdi
ffff80000010cbbc:	43                   	rex.XB
ffff80000010cbbd:	4f                   	rex.WRXB
ffff80000010cbbe:	44                   	rex.R
ffff80000010cbbf:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fbe9 <_ebss+0x38310d01>
ffff80000010cbc6:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cbc7:	78 2c                	js     ffff80000010cbf5 <_rodata+0x775>
ffff80000010cbc9:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cbcc:	50                   	push   %rax
ffff80000010cbcd:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fbf6 <_ebss+0x38310d0e>
ffff80000010cbd3:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cbd4:	78 2c                	js     ffff80000010cc02 <_rodata+0x782>
ffff80000010cbd6:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cbd9:	50                   	push   %rax
ffff80000010cbda:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fc03 <_ebss+0x38310d1b>
ffff80000010cbe0:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cbe1:	78 0a                	js     ffff80000010cbed <_rodata+0x76d>
ffff80000010cbe3:	00 00                	add    %al,(%rax)
ffff80000010cbe5:	00 00                	add    %al,(%rax)
ffff80000010cbe7:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010cbeb:	75 6e                	jne    ffff80000010cc5b <_rodata+0x7db>
ffff80000010cbed:	64 65 66 69 6e 65 64 	fs imul $0x5f64,%gs:0x65(%rsi),%bp
ffff80000010cbf4:	5f 
ffff80000010cbf5:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cbf6:	70 63                	jo     ffff80000010cc5b <_rodata+0x7db>
ffff80000010cbf8:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cbf9:	64 65 28 36          	fs sub %dh,%gs:(%rsi)
ffff80000010cbfd:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010cc00:	45 52                	rex.RB push %r10
ffff80000010cc02:	52                   	push   %rdx
ffff80000010cc03:	4f 52                	rex.WRXB push %r10
ffff80000010cc05:	5f                   	pop    %rdi
ffff80000010cc06:	43                   	rex.XB
ffff80000010cc07:	4f                   	rex.WRXB
ffff80000010cc08:	44                   	rex.R
ffff80000010cc09:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fc33 <_ebss+0x38310d4b>
ffff80000010cc10:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc11:	78 2c                	js     ffff80000010cc3f <_rodata+0x7bf>
ffff80000010cc13:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cc16:	50                   	push   %rax
ffff80000010cc17:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fc40 <_ebss+0x38310d58>
ffff80000010cc1d:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc1e:	78 2c                	js     ffff80000010cc4c <_rodata+0x7cc>
ffff80000010cc20:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cc23:	50                   	push   %rax
ffff80000010cc24:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fc4d <_ebss+0x38310d65>
ffff80000010cc2a:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc2b:	78 0a                	js     ffff80000010cc37 <_rodata+0x7b7>
ffff80000010cc2d:	00 00                	add    %al,(%rax)
ffff80000010cc2f:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010cc33:	64 65 76 5f          	fs gs jbe ffff80000010cc96 <_rodata+0x816>
ffff80000010cc37:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010cc38:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cc39:	74 5f                	je     ffff80000010cc9a <_rodata+0x81a>
ffff80000010cc3b:	61                   	(bad)  
ffff80000010cc3c:	76 61                	jbe    ffff80000010cc9f <_rodata+0x81f>
ffff80000010cc3e:	69 6c 61 62 6c 65 28 	imul   $0x3728656c,0x62(%rcx,%riz,2),%ebp
ffff80000010cc45:	37 
ffff80000010cc46:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010cc49:	45 52                	rex.RB push %r10
ffff80000010cc4b:	52                   	push   %rdx
ffff80000010cc4c:	4f 52                	rex.WRXB push %r10
ffff80000010cc4e:	5f                   	pop    %rdi
ffff80000010cc4f:	43                   	rex.XB
ffff80000010cc50:	4f                   	rex.WRXB
ffff80000010cc51:	44                   	rex.R
ffff80000010cc52:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fc7c <_ebss+0x38310d94>
ffff80000010cc59:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc5a:	78 2c                	js     ffff80000010cc88 <_rodata+0x808>
ffff80000010cc5c:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cc5f:	50                   	push   %rax
ffff80000010cc60:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fc89 <_ebss+0x38310da1>
ffff80000010cc66:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc67:	78 2c                	js     ffff80000010cc95 <_rodata+0x815>
ffff80000010cc69:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cc6c:	50                   	push   %rax
ffff80000010cc6d:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fc96 <_ebss+0x38310dae>
ffff80000010cc73:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc74:	78 0a                	js     ffff80000010cc80 <_rodata+0x800>
ffff80000010cc76:	00 00                	add    %al,(%rax)
ffff80000010cc78:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010cc7a:	5f                   	pop    %rdi
ffff80000010cc7b:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010cc7d:	75 62                	jne    ffff80000010cce1 <_rodata+0x861>
ffff80000010cc7f:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc80:	65 5f                	gs pop %rdi
ffff80000010cc82:	66 61                	data16 (bad) 
ffff80000010cc84:	75 6c                	jne    ffff80000010ccf2 <_rodata+0x872>
ffff80000010cc86:	74 28                	je     ffff80000010ccb0 <_rodata+0x830>
ffff80000010cc88:	38 29                	cmp    %ch,(%rcx)
ffff80000010cc8a:	2c 20                	sub    $0x20,%al
ffff80000010cc8c:	45 52                	rex.RB push %r10
ffff80000010cc8e:	52                   	push   %rdx
ffff80000010cc8f:	4f 52                	rex.WRXB push %r10
ffff80000010cc91:	5f                   	pop    %rdi
ffff80000010cc92:	43                   	rex.XB
ffff80000010cc93:	4f                   	rex.WRXB
ffff80000010cc94:	44                   	rex.R
ffff80000010cc95:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fcbf <_ebss+0x38310dd7>
ffff80000010cc9c:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cc9d:	78 2c                	js     ffff80000010cccb <_rodata+0x84b>
ffff80000010cc9f:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cca2:	50                   	push   %rax
ffff80000010cca3:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fccc <_ebss+0x38310de4>
ffff80000010cca9:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ccaa:	78 2c                	js     ffff80000010ccd8 <_rodata+0x858>
ffff80000010ccac:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010ccaf:	50                   	push   %rax
ffff80000010ccb0:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fcd9 <_ebss+0x38310df1>
ffff80000010ccb6:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ccb7:	78 0a                	js     ffff80000010ccc3 <_rodata+0x843>
ffff80000010ccb9:	00 00                	add    %al,(%rax)
ffff80000010ccbb:	00 00                	add    %al,(%rax)
ffff80000010ccbd:	00 00                	add    %al,(%rax)
ffff80000010ccbf:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010ccc3:	63 6f 70             	movsxd 0x70(%rdi),%ebp
ffff80000010ccc6:	72 6f                	jb     ffff80000010cd37 <_rodata+0x8b7>
ffff80000010ccc8:	63 65 73             	movsxd 0x73(%rbp),%esp
ffff80000010cccb:	73 6f                	jae    ffff80000010cd3c <_rodata+0x8bc>
ffff80000010cccd:	72 5f                	jb     ffff80000010cd2e <_rodata+0x8ae>
ffff80000010cccf:	73 65                	jae    ffff80000010cd36 <_rodata+0x8b6>
ffff80000010ccd1:	67 6d                	insl   (%dx),%es:(%edi)
ffff80000010ccd3:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010ccd5:	74 5f                	je     ffff80000010cd36 <_rodata+0x8b6>
ffff80000010ccd7:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010ccd8:	76 65                	jbe    ffff80000010cd3f <_rodata+0x8bf>
ffff80000010ccda:	72 72                	jb     ffff80000010cd4e <_rodata+0x8ce>
ffff80000010ccdc:	75 6e                	jne    ffff80000010cd4c <_rodata+0x8cc>
ffff80000010ccde:	28 39                	sub    %bh,(%rcx)
ffff80000010cce0:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010cce3:	45 52                	rex.RB push %r10
ffff80000010cce5:	52                   	push   %rdx
ffff80000010cce6:	4f 52                	rex.WRXB push %r10
ffff80000010cce8:	5f                   	pop    %rdi
ffff80000010cce9:	43                   	rex.XB
ffff80000010ccea:	4f                   	rex.WRXB
ffff80000010cceb:	44                   	rex.R
ffff80000010ccec:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fd16 <_ebss+0x38310e2e>
ffff80000010ccf3:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010ccf4:	78 2c                	js     ffff80000010cd22 <_rodata+0x8a2>
ffff80000010ccf6:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010ccf9:	50                   	push   %rax
ffff80000010ccfa:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fd23 <_ebss+0x38310e3b>
ffff80000010cd00:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cd01:	78 2c                	js     ffff80000010cd2f <_rodata+0x8af>
ffff80000010cd03:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cd06:	50                   	push   %rax
ffff80000010cd07:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fd30 <_ebss+0x38310e48>
ffff80000010cd0d:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cd0e:	78 0a                	js     ffff80000010cd1a <_rodata+0x89a>
	...
ffff80000010cd18:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010cd1a:	5f                   	pop    %rdi
ffff80000010cd1b:	69 6e 76 61 6c 69 64 	imul   $0x64696c61,0x76(%rsi),%ebp
ffff80000010cd22:	28 31                	sub    %dh,(%rcx)
ffff80000010cd24:	30 29                	xor    %ch,(%rcx)
ffff80000010cd26:	2c 20                	sub    $0x20,%al
ffff80000010cd28:	45 52                	rex.RB push %r10
ffff80000010cd2a:	52                   	push   %rdx
ffff80000010cd2b:	4f 52                	rex.WRXB push %r10
ffff80000010cd2d:	5f                   	pop    %rdi
ffff80000010cd2e:	43                   	rex.XB
ffff80000010cd2f:	4f                   	rex.WRXB
ffff80000010cd30:	44                   	rex.R
ffff80000010cd31:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841fd5b <_ebss+0x38310e73>
ffff80000010cd38:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cd39:	78 2c                	js     ffff80000010cd67 <_rodata+0x8e7>
ffff80000010cd3b:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cd3e:	50                   	push   %rax
ffff80000010cd3f:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fd68 <_ebss+0x38310e80>
ffff80000010cd45:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cd46:	78 2c                	js     ffff80000010cd74 <_rodata+0x8f4>
ffff80000010cd48:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cd4b:	50                   	push   %rax
ffff80000010cd4c:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841fd75 <_ebss+0x38310e8d>
ffff80000010cd52:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cd53:	78 0a                	js     ffff80000010cd5f <_rodata+0x8df>
ffff80000010cd55:	00 00                	add    %al,(%rax)
ffff80000010cd57:	00 54 68 65          	add    %dl,0x65(%rax,%rbp,2)
ffff80000010cd5b:	20 65 78             	and    %ah,0x78(%rbp)
ffff80000010cd5e:	63 65 70             	movsxd 0x70(%rbp),%esp
ffff80000010cd61:	74 69                	je     ffff80000010cdcc <_rodata+0x94c>
ffff80000010cd63:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cd64:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010cd65:	20 6f 63             	and    %ch,0x63(%rdi)
ffff80000010cd68:	63 75 72             	movsxd 0x72(%rbp),%esi
ffff80000010cd6b:	72 65                	jb     ffff80000010cdd2 <_rodata+0x952>
ffff80000010cd6d:	64 20 64 75 72       	and    %ah,%fs:0x72(%rbp,%rsi,2)
ffff80000010cd72:	69 6e 67 20 64 65 6c 	imul   $0x6c656420,0x67(%rsi),%ebp
ffff80000010cd79:	69 76 65 72 79 20 6f 	imul   $0x6f207972,0x65(%rsi),%esi
ffff80000010cd80:	66 20 61 6e          	data16 and %ah,0x6e(%rcx)
ffff80000010cd84:	20 65 76             	and    %ah,0x76(%rbp)
ffff80000010cd87:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010cd89:	74 20                	je     ffff80000010cdab <_rodata+0x92b>
ffff80000010cd8b:	65 78 74             	gs js  ffff80000010ce02 <_rodata+0x982>
ffff80000010cd8e:	65 72 6e             	gs jb  ffff80000010cdff <_rodata+0x97f>
ffff80000010cd91:	61                   	(bad)  
ffff80000010cd92:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cd93:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
ffff80000010cd97:	74 68                	je     ffff80000010ce01 <_rodata+0x981>
ffff80000010cd99:	65 20 70 72          	and    %dh,%gs:0x72(%rax)
ffff80000010cd9d:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cd9e:	67 72 61             	addr32 jb ffff80000010ce02 <_rodata+0x982>
ffff80000010cda1:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010cda2:	2c 20                	sub    $0x20,%al
ffff80000010cda4:	73 75                	jae    ffff80000010ce1b <_rodata+0x99b>
ffff80000010cda6:	63 68 20             	movsxd 0x20(%rax),%ebp
ffff80000010cda9:	61                   	(bad)  
ffff80000010cdaa:	73 20                	jae    ffff80000010cdcc <_rodata+0x94c>
ffff80000010cdac:	61                   	(bad)  
ffff80000010cdad:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010cdae:	20 69 6e             	and    %ch,0x6e(%rcx)
ffff80000010cdb1:	74 65                	je     ffff80000010ce18 <_rodata+0x998>
ffff80000010cdb3:	72 72                	jb     ffff80000010ce27 <_rodata+0x9a7>
ffff80000010cdb5:	75 70                	jne    ffff80000010ce27 <_rodata+0x9a7>
ffff80000010cdb7:	74 20                	je     ffff80000010cdd9 <_rodata+0x959>
ffff80000010cdb9:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cdba:	72 20                	jb     ffff80000010cddc <_rodata+0x95c>
ffff80000010cdbc:	61                   	(bad)  
ffff80000010cdbd:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010cdbe:	20 65 61             	and    %ah,0x61(%rbp)
ffff80000010cdc1:	72 6c                	jb     ffff80000010ce2f <_rodata+0x9af>
ffff80000010cdc3:	69 65 72 20 65 78 63 	imul   $0x63786520,0x72(%rbp),%esp
ffff80000010cdca:	65 70 74             	gs jo  ffff80000010ce41 <_rodata+0x9c1>
ffff80000010cdcd:	69 6f 6e 0a 00 00 00 	imul   $0xa,0x6e(%rdi),%ebp
ffff80000010cdd4:	00 00                	add    %al,(%rax)
ffff80000010cdd6:	00 00                	add    %al,(%rax)
ffff80000010cdd8:	52                   	push   %rdx
ffff80000010cdd9:	65 66 65 72 73       	gs data16 gs jb ffff80000010ce51 <_rodata+0x9d1>
ffff80000010cdde:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
ffff80000010cde2:	61                   	(bad)  
ffff80000010cde3:	20 67 61             	and    %ah,0x61(%rdi)
ffff80000010cde6:	74 65                	je     ffff80000010ce4d <_rodata+0x9cd>
ffff80000010cde8:	20 64 65 73          	and    %ah,0x73(%rbp,%riz,2)
ffff80000010cdec:	63 72 69             	movsxd 0x69(%rdx),%esi
ffff80000010cdef:	70 74                	jo     ffff80000010ce65 <_rodata+0x9e5>
ffff80000010cdf1:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cdf2:	72 20                	jb     ffff80000010ce14 <_rodata+0x994>
ffff80000010cdf4:	69 6e 20 74 68 65 20 	imul   $0x20656874,0x20(%rsi),%ebp
ffff80000010cdfb:	49                   	rex.WB
ffff80000010cdfc:	44 54                	rex.R push %rsp
ffff80000010cdfe:	0a 00                	or     (%rax),%al
ffff80000010ce00:	52                   	push   %rdx
ffff80000010ce01:	65 66 65 72 73       	gs data16 gs jb ffff80000010ce79 <_rodata+0x9f9>
ffff80000010ce06:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
ffff80000010ce0a:	61                   	(bad)  
ffff80000010ce0b:	20 67 61             	and    %ah,0x61(%rdi)
ffff80000010ce0e:	74 65                	je     ffff80000010ce75 <_rodata+0x9f5>
ffff80000010ce10:	20 64 65 73          	and    %ah,0x73(%rbp,%riz,2)
ffff80000010ce14:	63 72 69             	movsxd 0x69(%rdx),%esi
ffff80000010ce17:	70 74                	jo     ffff80000010ce8d <_rodata+0xa0d>
ffff80000010ce19:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010ce1a:	72 20                	jb     ffff80000010ce3c <_rodata+0x9bc>
ffff80000010ce1c:	69 6e 20 74 68 65 20 	imul   $0x20656874,0x20(%rsi),%ebp
ffff80000010ce23:	47                   	rex.RXB
ffff80000010ce24:	44 54                	rex.R push %rsp
ffff80000010ce26:	20 6f 72             	and    %ch,0x72(%rdi)
ffff80000010ce29:	20 74 68 65          	and    %dh,0x65(%rax,%rbp,2)
ffff80000010ce2d:	20 63 75             	and    %ah,0x75(%rbx)
ffff80000010ce30:	72 72                	jb     ffff80000010cea4 <_rodata+0xa24>
ffff80000010ce32:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010ce34:	74 20                	je     ffff80000010ce56 <_rodata+0x9d6>
ffff80000010ce36:	4c                   	rex.WR
ffff80000010ce37:	44 54                	rex.R push %rsp
ffff80000010ce39:	0a 00                	or     (%rax),%al
ffff80000010ce3b:	00 00                	add    %al,(%rax)
ffff80000010ce3d:	00 00                	add    %al,(%rax)
ffff80000010ce3f:	00 52 65             	add    %dl,0x65(%rdx)
ffff80000010ce42:	66 65 72 73          	data16 gs jb ffff80000010ceb9 <_rodata+0xa39>
ffff80000010ce46:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
ffff80000010ce4a:	61                   	(bad)  
ffff80000010ce4b:	20 73 65             	and    %dh,0x65(%rbx)
ffff80000010ce4e:	67 6d                	insl   (%dx),%es:(%edi)
ffff80000010ce50:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010ce52:	74 20                	je     ffff80000010ce74 <_rodata+0x9f4>
ffff80000010ce54:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010ce55:	72 20                	jb     ffff80000010ce77 <_rodata+0x9f7>
ffff80000010ce57:	67 61                	addr32 (bad) 
ffff80000010ce59:	74 65                	je     ffff80000010cec0 <_rodata+0xa40>
ffff80000010ce5b:	20 64 65 73          	and    %ah,0x73(%rbp,%riz,2)
ffff80000010ce5f:	63 72 69             	movsxd 0x69(%rdx),%esi
ffff80000010ce62:	70 74                	jo     ffff80000010ced8 <_rodata+0xa58>
ffff80000010ce64:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010ce65:	72 20                	jb     ffff80000010ce87 <_rodata+0xa07>
ffff80000010ce67:	69 6e 20 74 68 65 20 	imul   $0x20656874,0x20(%rsi),%ebp
ffff80000010ce6e:	4c                   	rex.WR
ffff80000010ce6f:	44 54                	rex.R push %rsp
ffff80000010ce71:	0a 00                	or     (%rax),%al
ffff80000010ce73:	00 00                	add    %al,(%rax)
ffff80000010ce75:	00 00                	add    %al,(%rax)
ffff80000010ce77:	00 52 65             	add    %dl,0x65(%rdx)
ffff80000010ce7a:	66 65 72 73          	data16 gs jb ffff80000010cef1 <_rodata+0xa71>
ffff80000010ce7e:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
ffff80000010ce82:	61                   	(bad)  
ffff80000010ce83:	20 64 65 73          	and    %ah,0x73(%rbp,%riz,2)
ffff80000010ce87:	63 72 69             	movsxd 0x69(%rdx),%esi
ffff80000010ce8a:	70 74                	jo     ffff80000010cf00 <_rodata+0xa80>
ffff80000010ce8c:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010ce8d:	72 20                	jb     ffff80000010ceaf <_rodata+0xa2f>
ffff80000010ce8f:	69 6e 20 74 68 65 20 	imul   $0x20656874,0x20(%rsi),%ebp
ffff80000010ce96:	63 75 72             	movsxd 0x72(%rbp),%esi
ffff80000010ce99:	72 65                	jb     ffff80000010cf00 <_rodata+0xa80>
ffff80000010ce9b:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010ce9c:	74 20                	je     ffff80000010cebe <_rodata+0xa3e>
ffff80000010ce9e:	47                   	rex.RXB
ffff80000010ce9f:	44 54                	rex.R push %rsp
ffff80000010cea1:	0a 00                	or     (%rax),%al
ffff80000010cea3:	00 00                	add    %al,(%rax)
ffff80000010cea5:	00 00                	add    %al,(%rax)
ffff80000010cea7:	00 53 65             	add    %dl,0x65(%rbx)
ffff80000010ceaa:	67 6d                	insl   (%dx),%es:(%edi)
ffff80000010ceac:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010ceae:	74 20                	je     ffff80000010ced0 <_rodata+0xa50>
ffff80000010ceb0:	53                   	push   %rbx
ffff80000010ceb1:	65 6c                	gs insb (%dx),%es:(%rdi)
ffff80000010ceb3:	65 63 74 6f 72       	movsxd %gs:0x72(%rdi,%rbp,2),%esi
ffff80000010ceb8:	20 49 6e             	and    %cl,0x6e(%rcx)
ffff80000010cebb:	64 65 78 3a          	fs gs js ffff80000010cef9 <_rodata+0xa79>
ffff80000010cebf:	25 23 30 31 30       	and    $0x30313023,%eax
ffff80000010cec4:	78 0a                	js     ffff80000010ced0 <_rodata+0xa50>
ffff80000010cec6:	00 00                	add    %al,(%rax)
ffff80000010cec8:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010ceca:	5f                   	pop    %rdi
ffff80000010cecb:	73 65                	jae    ffff80000010cf32 <_rodata+0xab2>
ffff80000010cecd:	67 6d                	insl   (%dx),%es:(%edi)
ffff80000010cecf:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010ced1:	74 5f                	je     ffff80000010cf32 <_rodata+0xab2>
ffff80000010ced3:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010ced4:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010ced5:	74 5f                	je     ffff80000010cf36 <_rodata+0xab6>
ffff80000010ced7:	70 72                	jo     ffff80000010cf4b <_rodata+0xacb>
ffff80000010ced9:	65 73 65             	gs jae ffff80000010cf41 <_rodata+0xac1>
ffff80000010cedc:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010cedd:	74 28                	je     ffff80000010cf07 <_rodata+0xa87>
ffff80000010cedf:	31 31                	xor    %esi,(%rcx)
ffff80000010cee1:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010cee4:	45 52                	rex.RB push %r10
ffff80000010cee6:	52                   	push   %rdx
ffff80000010cee7:	4f 52                	rex.WRXB push %r10
ffff80000010cee9:	5f                   	pop    %rdi
ffff80000010ceea:	43                   	rex.XB
ffff80000010ceeb:	4f                   	rex.WRXB
ffff80000010ceec:	44                   	rex.R
ffff80000010ceed:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841ff17 <_ebss+0x3831102f>
ffff80000010cef4:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cef5:	78 2c                	js     ffff80000010cf23 <_rodata+0xaa3>
ffff80000010cef7:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cefa:	50                   	push   %rax
ffff80000010cefb:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841ff24 <_ebss+0x3831103c>
ffff80000010cf01:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf02:	78 2c                	js     ffff80000010cf30 <_rodata+0xab0>
ffff80000010cf04:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cf07:	50                   	push   %rax
ffff80000010cf08:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841ff31 <_ebss+0x38311049>
ffff80000010cf0e:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf0f:	78 0a                	js     ffff80000010cf1b <_rodata+0xa9b>
ffff80000010cf11:	00 00                	add    %al,(%rax)
ffff80000010cf13:	00 00                	add    %al,(%rax)
ffff80000010cf15:	00 00                	add    %al,(%rax)
ffff80000010cf17:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010cf1b:	73 74                	jae    ffff80000010cf91 <_rodata+0xb11>
ffff80000010cf1d:	61                   	(bad)  
ffff80000010cf1e:	63 6b 5f             	movsxd 0x5f(%rbx),%ebp
ffff80000010cf21:	73 65                	jae    ffff80000010cf88 <_rodata+0xb08>
ffff80000010cf23:	67 6d                	insl   (%dx),%es:(%edi)
ffff80000010cf25:	65 6e                	outsb  %gs:(%rsi),(%dx)
ffff80000010cf27:	74 5f                	je     ffff80000010cf88 <_rodata+0xb08>
ffff80000010cf29:	66 61                	data16 (bad) 
ffff80000010cf2b:	75 6c                	jne    ffff80000010cf99 <_rodata+0xb19>
ffff80000010cf2d:	74 28                	je     ffff80000010cf57 <_rodata+0xad7>
ffff80000010cf2f:	31 32                	xor    %esi,(%rdx)
ffff80000010cf31:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010cf34:	45 52                	rex.RB push %r10
ffff80000010cf36:	52                   	push   %rdx
ffff80000010cf37:	4f 52                	rex.WRXB push %r10
ffff80000010cf39:	5f                   	pop    %rdi
ffff80000010cf3a:	43                   	rex.XB
ffff80000010cf3b:	4f                   	rex.WRXB
ffff80000010cf3c:	44                   	rex.R
ffff80000010cf3d:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841ff67 <_ebss+0x3831107f>
ffff80000010cf44:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf45:	78 2c                	js     ffff80000010cf73 <_rodata+0xaf3>
ffff80000010cf47:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cf4a:	50                   	push   %rax
ffff80000010cf4b:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841ff74 <_ebss+0x3831108c>
ffff80000010cf51:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf52:	78 2c                	js     ffff80000010cf80 <_rodata+0xb00>
ffff80000010cf54:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cf57:	50                   	push   %rax
ffff80000010cf58:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841ff81 <_ebss+0x38311099>
ffff80000010cf5e:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf5f:	78 0a                	js     ffff80000010cf6b <_rodata+0xaeb>
ffff80000010cf61:	00 00                	add    %al,(%rax)
ffff80000010cf63:	00 00                	add    %al,(%rax)
ffff80000010cf65:	00 00                	add    %al,(%rax)
ffff80000010cf67:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010cf6b:	67 65 6e             	outsb  %gs:(%esi),(%dx)
ffff80000010cf6e:	65 72 61             	gs jb  ffff80000010cfd2 <_rodata+0xb52>
ffff80000010cf71:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf72:	5f                   	pop    %rdi
ffff80000010cf73:	70 72                	jo     ffff80000010cfe7 <_rodata+0xb67>
ffff80000010cf75:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010cf76:	74 65                	je     ffff80000010cfdd <_rodata+0xb5d>
ffff80000010cf78:	63 74 69 6f          	movsxd 0x6f(%rcx,%rbp,2),%esi
ffff80000010cf7c:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010cf7d:	28 31                	sub    %dh,(%rcx)
ffff80000010cf7f:	33 29                	xor    (%rcx),%ebp
ffff80000010cf81:	2c 20                	sub    $0x20,%al
ffff80000010cf83:	45 52                	rex.RB push %r10
ffff80000010cf85:	52                   	push   %rdx
ffff80000010cf86:	5f                   	pop    %rdi
ffff80000010cf87:	43                   	rex.XB
ffff80000010cf88:	4f                   	rex.WRXB
ffff80000010cf89:	44                   	rex.R
ffff80000010cf8a:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003841ffb4 <_ebss+0x383110cc>
ffff80000010cf91:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf92:	78 2c                	js     ffff80000010cfc0 <_rodata+0xb40>
ffff80000010cf94:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cf97:	50                   	push   %rax
ffff80000010cf98:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841ffc1 <_ebss+0x383110d9>
ffff80000010cf9e:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cf9f:	78 2c                	js     ffff80000010cfcd <_rodata+0xb4d>
ffff80000010cfa1:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cfa4:	50                   	push   %rax
ffff80000010cfa5:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841ffce <_ebss+0x383110e6>
ffff80000010cfab:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cfac:	78 2c                	js     ffff80000010cfda <_rodata+0xb5a>
ffff80000010cfae:	20 52 44             	and    %dl,0x44(%rdx)
ffff80000010cfb1:	58                   	pop    %rax
ffff80000010cfb2:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003841ffdb <_ebss+0x383110f3>
ffff80000010cfb8:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cfb9:	78 0a                	js     ffff80000010cfc5 <_rodata+0xb45>
ffff80000010cfbb:	00 00                	add    %al,(%rax)
ffff80000010cfbd:	00 00                	add    %al,(%rax)
ffff80000010cfbf:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010cfc3:	70 61                	jo     ffff80000010d026 <_rodata+0xba6>
ffff80000010cfc5:	67 65 5f             	addr32 gs pop %rdi
ffff80000010cfc8:	66 61                	data16 (bad) 
ffff80000010cfca:	75 6c                	jne    ffff80000010d038 <_rodata+0xbb8>
ffff80000010cfcc:	74 28                	je     ffff80000010cff6 <_rodata+0xb76>
ffff80000010cfce:	31 34 29             	xor    %esi,(%rcx,%rbp,1)
ffff80000010cfd1:	2c 20                	sub    $0x20,%al
ffff80000010cfd3:	45 52                	rex.RB push %r10
ffff80000010cfd5:	52                   	push   %rdx
ffff80000010cfd6:	4f 52                	rex.WRXB push %r10
ffff80000010cfd8:	5f                   	pop    %rdi
ffff80000010cfd9:	43                   	rex.XB
ffff80000010cfda:	4f                   	rex.WRXB
ffff80000010cfdb:	44                   	rex.R
ffff80000010cfdc:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff800038420006 <_ebss+0x3831111e>
ffff80000010cfe3:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cfe4:	78 2c                	js     ffff80000010d012 <_rodata+0xb92>
ffff80000010cfe6:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010cfe9:	50                   	push   %rax
ffff80000010cfea:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420013 <_ebss+0x3831112b>
ffff80000010cff0:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cff1:	78 2c                	js     ffff80000010d01f <_rodata+0xb9f>
ffff80000010cff3:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010cff6:	50                   	push   %rax
ffff80000010cff7:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420020 <_ebss+0x38311138>
ffff80000010cffd:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010cffe:	78 0a                	js     ffff80000010d00a <_rodata+0xb8a>
ffff80000010d000:	00 50 61             	add    %dl,0x61(%rax)
ffff80000010d003:	67 65 20 4e 6f       	and    %cl,%gs:0x6f(%esi)
ffff80000010d008:	74 2d                	je     ffff80000010d037 <_rodata+0xbb7>
ffff80000010d00a:	50                   	push   %rax
ffff80000010d00b:	72 65                	jb     ffff80000010d072 <_rodata+0xbf2>
ffff80000010d00d:	73 65                	jae    ffff80000010d074 <_rodata+0xbf4>
ffff80000010d00f:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d010:	74 2c                	je     ffff80000010d03e <_rodata+0xbbe>
ffff80000010d012:	09 00                	or     %eax,(%rax)
ffff80000010d014:	00 00                	add    %al,(%rax)
ffff80000010d016:	00 00                	add    %al,(%rax)
ffff80000010d018:	50                   	push   %rax
ffff80000010d019:	61                   	(bad)  
ffff80000010d01a:	67 65 2d 6c 65 76 65 	addr32 gs sub $0x6576656c,%eax
ffff80000010d021:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d022:	20 70 72             	and    %dh,0x72(%rax)
ffff80000010d025:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d026:	74 65                	je     ffff80000010d08d <_rodata+0xc0d>
ffff80000010d028:	63 74 69 6f          	movsxd 0x6f(%rcx,%rbp,2),%esi
ffff80000010d02c:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d02d:	20 74 68 72          	and    %dh,0x72(%rax,%rbp,2)
ffff80000010d031:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d032:	77 73                	ja     ffff80000010d0a7 <_rodata+0xc27>
ffff80000010d034:	20 61 6e             	and    %ah,0x6e(%rcx)
ffff80000010d037:	20 65 78             	and    %ah,0x78(%rbp)
ffff80000010d03a:	63 65 70             	movsxd 0x70(%rbp),%esp
ffff80000010d03d:	74 69                	je     ffff80000010d0a8 <_rodata+0xc28>
ffff80000010d03f:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d040:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d041:	2c 09                	sub    $0x9,%al
ffff80000010d043:	00 57 72             	add    %dl,0x72(%rdi)
ffff80000010d046:	69 74 65 20 43 61 75 	imul   $0x73756143,0x20(%rbp,%riz,2),%esi
ffff80000010d04d:	73 
ffff80000010d04e:	65 20 46 61          	and    %al,%gs:0x61(%rsi)
ffff80000010d052:	75 6c                	jne    ffff80000010d0c0 <_rodata+0xc40>
ffff80000010d054:	74 2c                	je     ffff80000010d082 <_rodata+0xc02>
ffff80000010d056:	09 00                	or     %eax,(%rax)
ffff80000010d058:	52                   	push   %rdx
ffff80000010d059:	65 61                	gs (bad) 
ffff80000010d05b:	64 20 43 61          	and    %al,%fs:0x61(%rbx)
ffff80000010d05f:	75 73                	jne    ffff80000010d0d4 <_rodata+0xc54>
ffff80000010d061:	65 20 46 61          	and    %al,%gs:0x61(%rsi)
ffff80000010d065:	75 6c                	jne    ffff80000010d0d3 <_rodata+0xc53>
ffff80000010d067:	74 2c                	je     ffff80000010d095 <_rodata+0xc15>
ffff80000010d069:	09 00                	or     %eax,(%rax)
ffff80000010d06b:	46 61                	rex.RX (bad) 
ffff80000010d06d:	75 6c                	jne    ffff80000010d0db <_rodata+0xc5b>
ffff80000010d06f:	74 20                	je     ffff80000010d091 <_rodata+0xc11>
ffff80000010d071:	69 6e 20 75 73 65 72 	imul   $0x72657375,0x20(%rsi),%ebp
ffff80000010d078:	28 33                	sub    %dh,(%rbx)
ffff80000010d07a:	29 09                	sub    %ecx,(%rcx)
ffff80000010d07c:	00 46 61             	add    %al,0x61(%rsi)
ffff80000010d07f:	75 6c                	jne    ffff80000010d0ed <_rodata+0xc6d>
ffff80000010d081:	74 20                	je     ffff80000010d0a3 <_rodata+0xc23>
ffff80000010d083:	69 6e 20 73 75 70 65 	imul   $0x65707573,0x20(%rsi),%ebp
ffff80000010d08a:	72 76                	jb     ffff80000010d102 <_rodata+0xc82>
ffff80000010d08c:	69 73 6f 72 28 30 2c 	imul   $0x2c302872,0x6f(%rbx),%esi
ffff80000010d093:	31 2c 32             	xor    %ebp,(%rdx,%rsi,1)
ffff80000010d096:	29 09                	sub    %ecx,(%rcx)
ffff80000010d098:	00 52 65             	add    %dl,0x65(%rdx)
ffff80000010d09b:	73 65                	jae    ffff80000010d102 <_rodata+0xc82>
ffff80000010d09d:	72 76                	jb     ffff80000010d115 <_rodata+0xc95>
ffff80000010d09f:	65 64 20 42 69       	gs and %al,%fs:0x69(%rdx)
ffff80000010d0a4:	74 20                	je     ffff80000010d0c6 <_rodata+0xc46>
ffff80000010d0a6:	43 61                	rex.XB (bad) 
ffff80000010d0a8:	75 73                	jne    ffff80000010d11d <_rodata+0xc9d>
ffff80000010d0aa:	65 20 46 61          	and    %al,%gs:0x61(%rsi)
ffff80000010d0ae:	75 6c                	jne    ffff80000010d11c <_rodata+0xc9c>
ffff80000010d0b0:	74 09                	je     ffff80000010d0bb <_rodata+0xc3b>
ffff80000010d0b2:	00 49 6e             	add    %cl,0x6e(%rcx)
ffff80000010d0b5:	73 74                	jae    ffff80000010d12b <_rodata+0xcab>
ffff80000010d0b7:	72 75                	jb     ffff80000010d12e <_rodata+0xcae>
ffff80000010d0b9:	63 74 69 6f          	movsxd 0x6f(%rcx,%rbp,2),%esi
ffff80000010d0bd:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d0be:	20 66 65             	and    %ah,0x65(%rsi)
ffff80000010d0c1:	74 63                	je     ffff80000010d126 <_rodata+0xca6>
ffff80000010d0c3:	68 20 43 61 75       	push   $0x75614320
ffff80000010d0c8:	73 65                	jae    ffff80000010d12f <_rodata+0xcaf>
ffff80000010d0ca:	20 46 61             	and    %al,0x61(%rsi)
ffff80000010d0cd:	75 6c                	jne    ffff80000010d13b <_rodata+0xcbb>
ffff80000010d0cf:	74 00                	je     ffff80000010d0d1 <_rodata+0xc51>
ffff80000010d0d1:	0a 00                	or     (%rax),%al
ffff80000010d0d3:	00 00                	add    %al,(%rax)
ffff80000010d0d5:	00 00                	add    %al,(%rax)
ffff80000010d0d7:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010d0db:	78 38                	js     ffff80000010d115 <_rodata+0xc95>
ffff80000010d0dd:	37                   	(bad)  
ffff80000010d0de:	5f                   	pop    %rdi
ffff80000010d0df:	46 50                	rex.RX push %rax
ffff80000010d0e1:	55                   	push   %rbp
ffff80000010d0e2:	5f                   	pop    %rdi
ffff80000010d0e3:	65 72 72             	gs jb  ffff80000010d158 <_rodata+0xcd8>
ffff80000010d0e6:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d0e7:	72 28                	jb     ffff80000010d111 <_rodata+0xc91>
ffff80000010d0e9:	31 36                	xor    %esi,(%rsi)
ffff80000010d0eb:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010d0ee:	45 52                	rex.RB push %r10
ffff80000010d0f0:	52                   	push   %rdx
ffff80000010d0f1:	4f 52                	rex.WRXB push %r10
ffff80000010d0f3:	5f                   	pop    %rdi
ffff80000010d0f4:	43                   	rex.XB
ffff80000010d0f5:	4f                   	rex.WRXB
ffff80000010d0f6:	44                   	rex.R
ffff80000010d0f7:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff800038420121 <_ebss+0x38311239>
ffff80000010d0fe:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d0ff:	78 2c                	js     ffff80000010d12d <_rodata+0xcad>
ffff80000010d101:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010d104:	50                   	push   %rax
ffff80000010d105:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003842012e <_ebss+0x38311246>
ffff80000010d10b:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d10c:	78 2c                	js     ffff80000010d13a <_rodata+0xcba>
ffff80000010d10e:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010d111:	50                   	push   %rax
ffff80000010d112:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff80003842013b <_ebss+0x38311253>
ffff80000010d118:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d119:	78 0a                	js     ffff80000010d125 <_rodata+0xca5>
ffff80000010d11b:	00 00                	add    %al,(%rax)
ffff80000010d11d:	00 00                	add    %al,(%rax)
ffff80000010d11f:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010d123:	61                   	(bad)  
ffff80000010d124:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d125:	69 67 6e 6d 65 6e 74 	imul   $0x746e656d,0x6e(%rdi),%esp
ffff80000010d12c:	5f                   	pop    %rdi
ffff80000010d12d:	63 68 65             	movsxd 0x65(%rax),%ebp
ffff80000010d130:	63 6b 28             	movsxd 0x28(%rbx),%ebp
ffff80000010d133:	31 37                	xor    %esi,(%rdi)
ffff80000010d135:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010d138:	45 52                	rex.RB push %r10
ffff80000010d13a:	52                   	push   %rdx
ffff80000010d13b:	4f 52                	rex.WRXB push %r10
ffff80000010d13d:	5f                   	pop    %rdi
ffff80000010d13e:	43                   	rex.XB
ffff80000010d13f:	4f                   	rex.WRXB
ffff80000010d140:	44                   	rex.R
ffff80000010d141:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003842016b <_ebss+0x38311283>
ffff80000010d148:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d149:	78 2c                	js     ffff80000010d177 <_rodata+0xcf7>
ffff80000010d14b:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010d14e:	50                   	push   %rax
ffff80000010d14f:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420178 <_ebss+0x38311290>
ffff80000010d155:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d156:	78 2c                	js     ffff80000010d184 <_rodata+0xd04>
ffff80000010d158:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010d15b:	50                   	push   %rax
ffff80000010d15c:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420185 <_ebss+0x3831129d>
ffff80000010d162:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d163:	78 0a                	js     ffff80000010d16f <_rodata+0xcef>
ffff80000010d165:	00 00                	add    %al,(%rax)
ffff80000010d167:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010d16b:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010d16c:	61                   	(bad)  
ffff80000010d16d:	63 68 69             	movsxd 0x69(%rax),%ebp
ffff80000010d170:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d171:	65 5f                	gs pop %rdi
ffff80000010d173:	63 68 65             	movsxd 0x65(%rax),%ebp
ffff80000010d176:	63 6b 28             	movsxd 0x28(%rbx),%ebp
ffff80000010d179:	31 38                	xor    %edi,(%rax)
ffff80000010d17b:	29 2c 20             	sub    %ebp,(%rax,%riz,1)
ffff80000010d17e:	45 52                	rex.RB push %r10
ffff80000010d180:	52                   	push   %rdx
ffff80000010d181:	4f 52                	rex.WRXB push %r10
ffff80000010d183:	5f                   	pop    %rdi
ffff80000010d184:	43                   	rex.XB
ffff80000010d185:	4f                   	rex.WRXB
ffff80000010d186:	44                   	rex.R
ffff80000010d187:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff8000384201b1 <_ebss+0x383112c9>
ffff80000010d18e:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d18f:	78 2c                	js     ffff80000010d1bd <_rodata+0xd3d>
ffff80000010d191:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010d194:	50                   	push   %rax
ffff80000010d195:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff8000384201be <_ebss+0x383112d6>
ffff80000010d19b:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d19c:	78 2c                	js     ffff80000010d1ca <_rodata+0xd4a>
ffff80000010d19e:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010d1a1:	50                   	push   %rax
ffff80000010d1a2:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff8000384201cb <_ebss+0x383112e3>
ffff80000010d1a8:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d1a9:	78 0a                	js     ffff80000010d1b5 <_rodata+0xd35>
ffff80000010d1ab:	00 00                	add    %al,(%rax)
ffff80000010d1ad:	00 00                	add    %al,(%rax)
ffff80000010d1af:	00 64 6f 5f          	add    %ah,0x5f(%rdi,%rbp,2)
ffff80000010d1b3:	53                   	push   %rbx
ffff80000010d1b4:	49                   	rex.WB
ffff80000010d1b5:	4d                   	rex.WRB
ffff80000010d1b6:	44 5f                	rex.R pop %rdi
ffff80000010d1b8:	65 78 63             	gs js  ffff80000010d21e <_rodata+0xd9e>
ffff80000010d1bb:	65 70 74             	gs jo  ffff80000010d232 <_rodata+0xdb2>
ffff80000010d1be:	69 6f 6e 28 31 39 29 	imul   $0x29393128,0x6e(%rdi),%ebp
ffff80000010d1c5:	2c 20                	sub    $0x20,%al
ffff80000010d1c7:	45 52                	rex.RB push %r10
ffff80000010d1c9:	52                   	push   %rdx
ffff80000010d1ca:	4f 52                	rex.WRXB push %r10
ffff80000010d1cc:	5f                   	pop    %rdi
ffff80000010d1cd:	43                   	rex.XB
ffff80000010d1ce:	4f                   	rex.WRXB
ffff80000010d1cf:	44                   	rex.R
ffff80000010d1d0:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff8000384201fa <_ebss+0x38311312>
ffff80000010d1d7:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d1d8:	78 2c                	js     ffff80000010d206 <_rodata+0xd86>
ffff80000010d1da:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010d1dd:	50                   	push   %rax
ffff80000010d1de:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420207 <_ebss+0x3831131f>
ffff80000010d1e4:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d1e5:	78 2c                	js     ffff80000010d213 <_rodata+0xd93>
ffff80000010d1e7:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010d1ea:	50                   	push   %rax
ffff80000010d1eb:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420214 <_ebss+0x3831132c>
ffff80000010d1f1:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d1f2:	78 0a                	js     ffff80000010d1fe <_rodata+0xd7e>
ffff80000010d1f4:	00 00                	add    %al,(%rax)
ffff80000010d1f6:	00 00                	add    %al,(%rax)
ffff80000010d1f8:	64 6f                	outsl  %fs:(%rsi),(%dx)
ffff80000010d1fa:	5f                   	pop    %rdi
ffff80000010d1fb:	76 69                	jbe    ffff80000010d266 <_rodata+0xde6>
ffff80000010d1fd:	72 74                	jb     ffff80000010d273 <_rodata+0xdf3>
ffff80000010d1ff:	75 61                	jne    ffff80000010d262 <_rodata+0xde2>
ffff80000010d201:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d202:	69 7a 61 74 69 6f 6e 	imul   $0x6e6f6974,0x61(%rdx),%edi
ffff80000010d209:	5f                   	pop    %rdi
ffff80000010d20a:	65 78 63             	gs js  ffff80000010d270 <_rodata+0xdf0>
ffff80000010d20d:	65 70 74             	gs jo  ffff80000010d284 <_rodata+0xe04>
ffff80000010d210:	69 6f 6e 28 32 30 29 	imul   $0x29303228,0x6e(%rdi),%ebp
ffff80000010d217:	2c 20                	sub    $0x20,%al
ffff80000010d219:	45 52                	rex.RB push %r10
ffff80000010d21b:	52                   	push   %rdx
ffff80000010d21c:	4f 52                	rex.WRXB push %r10
ffff80000010d21e:	5f                   	pop    %rdi
ffff80000010d21f:	43                   	rex.XB
ffff80000010d220:	4f                   	rex.WRXB
ffff80000010d221:	44                   	rex.R
ffff80000010d222:	45 3a 25 23 30 31 38 	cmp    0x38313023(%rip),%r12b        # ffff80003842024c <_ebss+0x38311364>
ffff80000010d229:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d22a:	78 2c                	js     ffff80000010d258 <_rodata+0xdd8>
ffff80000010d22c:	20 52 53             	and    %dl,0x53(%rdx)
ffff80000010d22f:	50                   	push   %rax
ffff80000010d230:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420259 <_ebss+0x38311371>
ffff80000010d236:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d237:	78 2c                	js     ffff80000010d265 <_rodata+0xde5>
ffff80000010d239:	20 52 49             	and    %dl,0x49(%rdx)
ffff80000010d23c:	50                   	push   %rax
ffff80000010d23d:	3a 25 23 30 31 38    	cmp    0x38313023(%rip),%ah        # ffff800038420266 <_ebss+0x3831137e>
ffff80000010d243:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d244:	78 0a                	js     ffff80000010d250 <_rodata+0xdd0>
ffff80000010d246:	00 00                	add    %al,(%rax)
ffff80000010d248:	4f 53                	rex.WRXB push %r11
ffff80000010d24a:	20 43 61             	and    %al,0x61(%rbx)
ffff80000010d24d:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d24e:	20 55 73             	and    %dl,0x73(%rbp)
ffff80000010d251:	65 64 20 54 6f 74    	gs and %dl,%fs:0x74(%rdi,%rbp,2)
ffff80000010d257:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d258:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d259:	20 52 41             	and    %dl,0x41(%rdx)
ffff80000010d25c:	4d 20 3d 20 25 23 30 	rex.WRB and %r15b,0x30232520(%rip)        # ffff80003033f783 <_ebss+0x3023089b>
ffff80000010d263:	31 38                	xor    %edi,(%rax)
ffff80000010d265:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d266:	78 20                	js     ffff80000010d288 <_rodata+0xe08>
ffff80000010d268:	42 79 74             	rex.X jns ffff80000010d2df <_erodata+0x14>
ffff80000010d26b:	65 0a 00             	or     %gs:(%rax),%al
ffff80000010d26e:	1b 5b 34             	sbb    0x34(%rbx),%ebx
ffff80000010d271:	30 6d 00             	xor    %ch,0x0(%rbp)
ffff80000010d274:	1b 5b 33             	sbb    0x33(%rbx),%ebx
ffff80000010d277:	31 6d 00             	xor    %ebp,0x0(%rbp)
ffff80000010d27a:	00 00                	add    %al,(%rax)
ffff80000010d27c:	00 00                	add    %al,(%rax)
ffff80000010d27e:	00 00                	add    %al,(%rax)
ffff80000010d280:	74 6f                	je     ffff80000010d2f1 <_erodata+0x26>
ffff80000010d282:	74 61                	je     ffff80000010d2e5 <_erodata+0x1a>
ffff80000010d284:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d285:	20 65 66             	and    %ah,0x66(%rbp)
ffff80000010d288:	66 65 63 74 69 76    	movsxd %gs:0x76(%rcx,%rbp,2),%si
ffff80000010d28e:	65 20 32             	and    %dh,%gs:(%rdx)
ffff80000010d291:	4d                   	rex.WRB
ffff80000010d292:	42 20 70 61          	rex.X and %sil,0x61(%rax)
ffff80000010d296:	67 65 73 3a          	addr32 gs jae ffff80000010d2d4 <_erodata+0x9>
ffff80000010d29a:	25 23 30 31 30       	and    $0x30313023,%eax
ffff80000010d29f:	78 20                	js     ffff80000010d2c1 <_rodata+0xe41>
ffff80000010d2a1:	3d 20 25 23 30       	cmp    $0x30232520,%eax
ffff80000010d2a6:	31 30                	xor    %esi,(%rax)
ffff80000010d2a8:	64 0a 00             	or     %fs:(%rax),%al
ffff80000010d2ab:	1b 5b 33             	sbb    0x33(%rbx),%ebx
ffff80000010d2ae:	32 6d 00             	xor    0x0(%rbp),%ch
ffff80000010d2b1:	48                   	rex.W
ffff80000010d2b2:	65 6c                	gs insb (%dx),%es:(%rdi)
ffff80000010d2b4:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d2b5:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d2b6:	0a 00                	or     (%rax),%al
ffff80000010d2b8:	25 73 00 1b 5b       	and    $0x5b1b0073,%eax
ffff80000010d2bd:	34 30                	xor    $0x30,%al
ffff80000010d2bf:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010d2c0:	00 1b                	add    %bl,(%rbx)
ffff80000010d2c2:	5b                   	pop    %rbx
ffff80000010d2c3:	33 32                	xor    (%rdx),%esi
ffff80000010d2c5:	6d                   	insl   (%dx),%es:(%rdi)
ffff80000010d2c6:	00                   	.byte 0x0
ffff80000010d2c7:	25                   	.byte 0x25
ffff80000010d2c8:	73 0a                	jae    ffff80000010d2d4 <_erodata+0x9>
	...

Disassembly of section .eh_frame:

ffff80000010d2d0 <.eh_frame>:
ffff80000010d2d0:	14 00                	adc    $0x0,%al
ffff80000010d2d2:	00 00                	add    %al,(%rax)
ffff80000010d2d4:	00 00                	add    %al,(%rax)
ffff80000010d2d6:	00 00                	add    %al,(%rax)
ffff80000010d2d8:	01 7a 52             	add    %edi,0x52(%rdx)
ffff80000010d2db:	00 01                	add    %al,(%rcx)
ffff80000010d2dd:	78 10                	js     ffff80000010d2ef <_erodata+0x24>
ffff80000010d2df:	01 1b                	add    %ebx,(%rbx)
ffff80000010d2e1:	0c 07                	or     $0x7,%al
ffff80000010d2e3:	08 90 01 00 00 1c    	or     %dl,0x1c000001(%rax)
ffff80000010d2e9:	00 00                	add    %al,(%rax)
ffff80000010d2eb:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d2ee:	00 00                	add    %al,(%rax)
ffff80000010d2f0:	19 6f ff             	sbb    %ebp,-0x1(%rdi)
ffff80000010d2f3:	ff 15 00 00 00 00    	call   *0x0(%rip)        # ffff80000010d2f9 <_erodata+0x2e>
ffff80000010d2f9:	45 0e                	rex.RB (bad) 
ffff80000010d2fb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d301:	4c 0c 07             	rex.WR or $0x7,%al
ffff80000010d304:	08 00                	or     %al,(%rax)
ffff80000010d306:	00 00                	add    %al,(%rax)
ffff80000010d308:	1c 00                	sbb    $0x0,%al
ffff80000010d30a:	00 00                	add    %al,(%rax)
ffff80000010d30c:	3c 00                	cmp    $0x0,%al
ffff80000010d30e:	00 00                	add    %al,(%rax)
ffff80000010d310:	0e                   	(bad)  
ffff80000010d311:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d312:	ff                   	(bad)  
ffff80000010d313:	ff 15 00 00 00 00    	call   *0x0(%rip)        # ffff80000010d319 <_erodata+0x4e>
ffff80000010d319:	45 0e                	rex.RB (bad) 
ffff80000010d31b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d321:	4c 0c 07             	rex.WR or $0x7,%al
ffff80000010d324:	08 00                	or     %al,(%rax)
ffff80000010d326:	00 00                	add    %al,(%rax)
ffff80000010d328:	1c 00                	sbb    $0x0,%al
ffff80000010d32a:	00 00                	add    %al,(%rax)
ffff80000010d32c:	5c                   	pop    %rsp
ffff80000010d32d:	00 00                	add    %al,(%rax)
ffff80000010d32f:	00 03                	add    %al,(%rbx)
ffff80000010d331:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d332:	ff                   	(bad)  
ffff80000010d333:	ff 14 00             	call   *(%rax,%rax,1)
ffff80000010d336:	00 00                	add    %al,(%rax)
ffff80000010d338:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d33b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d341:	4b 0c 07             	rex.WXB or $0x7,%al
ffff80000010d344:	08 00                	or     %al,(%rax)
ffff80000010d346:	00 00                	add    %al,(%rax)
ffff80000010d348:	1c 00                	sbb    $0x0,%al
ffff80000010d34a:	00 00                	add    %al,(%rax)
ffff80000010d34c:	7c 00                	jl     ffff80000010d34e <_erodata+0x83>
ffff80000010d34e:	00 00                	add    %al,(%rax)
ffff80000010d350:	f7 6e ff             	imull  -0x1(%rsi)
ffff80000010d353:	ff 15 00 00 00 00    	call   *0x0(%rip)        # ffff80000010d359 <_erodata+0x8e>
ffff80000010d359:	45 0e                	rex.RB (bad) 
ffff80000010d35b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d361:	4c 0c 07             	rex.WR or $0x7,%al
ffff80000010d364:	08 00                	or     %al,(%rax)
ffff80000010d366:	00 00                	add    %al,(%rax)
ffff80000010d368:	1c 00                	sbb    $0x0,%al
ffff80000010d36a:	00 00                	add    %al,(%rax)
ffff80000010d36c:	9c                   	pushf  
ffff80000010d36d:	00 00                	add    %al,(%rax)
ffff80000010d36f:	00 ec                	add    %ch,%ah
ffff80000010d371:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d372:	ff                   	(bad)  
ffff80000010d373:	ff 1e                	lcall  *(%rsi)
ffff80000010d375:	00 00                	add    %al,(%rax)
ffff80000010d377:	00 00                	add    %al,(%rax)
ffff80000010d379:	45 0e                	rex.RB (bad) 
ffff80000010d37b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d381:	55                   	push   %rbp
ffff80000010d382:	0c 07                	or     $0x7,%al
ffff80000010d384:	08 00                	or     %al,(%rax)
ffff80000010d386:	00 00                	add    %al,(%rax)
ffff80000010d388:	1c 00                	sbb    $0x0,%al
ffff80000010d38a:	00 00                	add    %al,(%rax)
ffff80000010d38c:	bc 00 00 00 ea       	mov    $0xea000000,%esp
ffff80000010d391:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d392:	ff                   	(bad)  
ffff80000010d393:	ff 20                	jmp    *(%rax)
ffff80000010d395:	00 00                	add    %al,(%rax)
ffff80000010d397:	00 00                	add    %al,(%rax)
ffff80000010d399:	45 0e                	rex.RB (bad) 
ffff80000010d39b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d3a1:	57                   	push   %rdi
ffff80000010d3a2:	0c 07                	or     $0x7,%al
ffff80000010d3a4:	08 00                	or     %al,(%rax)
ffff80000010d3a6:	00 00                	add    %al,(%rax)
ffff80000010d3a8:	1c 00                	sbb    $0x0,%al
ffff80000010d3aa:	00 00                	add    %al,(%rax)
ffff80000010d3ac:	dc 00                	faddl  (%rax)
ffff80000010d3ae:	00 00                	add    %al,(%rax)
ffff80000010d3b0:	ea                   	(bad)  
ffff80000010d3b1:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d3b2:	ff                   	(bad)  
ffff80000010d3b3:	ff 1b                	lcall  *(%rbx)
ffff80000010d3b5:	00 00                	add    %al,(%rax)
ffff80000010d3b7:	00 00                	add    %al,(%rax)
ffff80000010d3b9:	45 0e                	rex.RB (bad) 
ffff80000010d3bb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d3c1:	52                   	push   %rdx
ffff80000010d3c2:	0c 07                	or     $0x7,%al
ffff80000010d3c4:	08 00                	or     %al,(%rax)
ffff80000010d3c6:	00 00                	add    %al,(%rax)
ffff80000010d3c8:	1c 00                	sbb    $0x0,%al
ffff80000010d3ca:	00 00                	add    %al,(%rax)
ffff80000010d3cc:	fc                   	cld    
ffff80000010d3cd:	00 00                	add    %al,(%rax)
ffff80000010d3cf:	00 e5                	add    %ah,%ch
ffff80000010d3d1:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d3d2:	ff                   	(bad)  
ffff80000010d3d3:	ff 1e                	lcall  *(%rsi)
ffff80000010d3d5:	00 00                	add    %al,(%rax)
ffff80000010d3d7:	00 00                	add    %al,(%rax)
ffff80000010d3d9:	45 0e                	rex.RB (bad) 
ffff80000010d3db:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d3e1:	55                   	push   %rbp
ffff80000010d3e2:	0c 07                	or     $0x7,%al
ffff80000010d3e4:	08 00                	or     %al,(%rax)
ffff80000010d3e6:	00 00                	add    %al,(%rax)
ffff80000010d3e8:	1c 00                	sbb    $0x0,%al
ffff80000010d3ea:	00 00                	add    %al,(%rax)
ffff80000010d3ec:	1c 01                	sbb    $0x1,%al
ffff80000010d3ee:	00 00                	add    %al,(%rax)
ffff80000010d3f0:	e3 6e                	jrcxz  ffff80000010d460 <_erodata+0x195>
ffff80000010d3f2:	ff                   	(bad)  
ffff80000010d3f3:	ff 25 00 00 00 00    	jmp    *0x0(%rip)        # ffff80000010d3f9 <_erodata+0x12e>
ffff80000010d3f9:	45 0e                	rex.RB (bad) 
ffff80000010d3fb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d401:	5c                   	pop    %rsp
ffff80000010d402:	0c 07                	or     $0x7,%al
ffff80000010d404:	08 00                	or     %al,(%rax)
ffff80000010d406:	00 00                	add    %al,(%rax)
ffff80000010d408:	1c 00                	sbb    $0x0,%al
ffff80000010d40a:	00 00                	add    %al,(%rax)
ffff80000010d40c:	3c 01                	cmp    $0x1,%al
ffff80000010d40e:	00 00                	add    %al,(%rax)
ffff80000010d410:	e8 6e ff ff 27       	call   ffff80002810d383 <_ebss+0x27ffe49b>
ffff80000010d415:	00 00                	add    %al,(%rax)
ffff80000010d417:	00 00                	add    %al,(%rax)
ffff80000010d419:	45 0e                	rex.RB (bad) 
ffff80000010d41b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d421:	5e                   	pop    %rsi
ffff80000010d422:	0c 07                	or     $0x7,%al
ffff80000010d424:	08 00                	or     %al,(%rax)
ffff80000010d426:	00 00                	add    %al,(%rax)
ffff80000010d428:	1c 00                	sbb    $0x0,%al
ffff80000010d42a:	00 00                	add    %al,(%rax)
ffff80000010d42c:	5c                   	pop    %rsp
ffff80000010d42d:	01 00                	add    %eax,(%rax)
ffff80000010d42f:	00 ef                	add    %ch,%bh
ffff80000010d431:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d432:	ff                   	(bad)  
ffff80000010d433:	ff 24 00             	jmp    *(%rax,%rax,1)
ffff80000010d436:	00 00                	add    %al,(%rax)
ffff80000010d438:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d43b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d441:	5b                   	pop    %rbx
ffff80000010d442:	0c 07                	or     $0x7,%al
ffff80000010d444:	08 00                	or     %al,(%rax)
ffff80000010d446:	00 00                	add    %al,(%rax)
ffff80000010d448:	1c 00                	sbb    $0x0,%al
ffff80000010d44a:	00 00                	add    %al,(%rax)
ffff80000010d44c:	7c 01                	jl     ffff80000010d44f <_erodata+0x184>
ffff80000010d44e:	00 00                	add    %al,(%rax)
ffff80000010d450:	f3 6e                	rep outsb %ds:(%rsi),(%dx)
ffff80000010d452:	ff                   	(bad)  
ffff80000010d453:	ff 1f                	lcall  *(%rdi)
ffff80000010d455:	00 00                	add    %al,(%rax)
ffff80000010d457:	00 00                	add    %al,(%rax)
ffff80000010d459:	45 0e                	rex.RB (bad) 
ffff80000010d45b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d461:	56                   	push   %rsi
ffff80000010d462:	0c 07                	or     $0x7,%al
ffff80000010d464:	08 00                	or     %al,(%rax)
ffff80000010d466:	00 00                	add    %al,(%rax)
ffff80000010d468:	1c 00                	sbb    $0x0,%al
ffff80000010d46a:	00 00                	add    %al,(%rax)
ffff80000010d46c:	9c                   	pushf  
ffff80000010d46d:	01 00                	add    %eax,(%rax)
ffff80000010d46f:	00 f2                	add    %dh,%dl
ffff80000010d471:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d472:	ff                   	(bad)  
ffff80000010d473:	ff 26                	jmp    *(%rsi)
ffff80000010d475:	00 00                	add    %al,(%rax)
ffff80000010d477:	00 00                	add    %al,(%rax)
ffff80000010d479:	45 0e                	rex.RB (bad) 
ffff80000010d47b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d481:	5d                   	pop    %rbp
ffff80000010d482:	0c 07                	or     $0x7,%al
ffff80000010d484:	08 00                	or     %al,(%rax)
ffff80000010d486:	00 00                	add    %al,(%rax)
ffff80000010d488:	1c 00                	sbb    $0x0,%al
ffff80000010d48a:	00 00                	add    %al,(%rax)
ffff80000010d48c:	bc 01 00 00 f8       	mov    $0xf8000001,%esp
ffff80000010d491:	6e                   	outsb  %ds:(%rsi),(%dx)
ffff80000010d492:	ff                   	(bad)  
ffff80000010d493:	ff 49 00             	decl   0x0(%rcx)
ffff80000010d496:	00 00                	add    %al,(%rax)
ffff80000010d498:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d49b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d4a1:	02 40 0c             	add    0xc(%rax),%al
ffff80000010d4a4:	07                   	(bad)  
ffff80000010d4a5:	08 00                	or     %al,(%rax)
ffff80000010d4a7:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d4aa:	00 00                	add    %al,(%rax)
ffff80000010d4ac:	dc 01                	faddl  (%rcx)
ffff80000010d4ae:	00 00                	add    %al,(%rax)
ffff80000010d4b0:	21 6f ff             	and    %ebp,-0x1(%rdi)
ffff80000010d4b3:	ff 47 00             	incl   0x0(%rdi)
ffff80000010d4b6:	00 00                	add    %al,(%rax)
ffff80000010d4b8:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d4bb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d4c1:	7e 0c                	jle    ffff80000010d4cf <_erodata+0x204>
ffff80000010d4c3:	07                   	(bad)  
ffff80000010d4c4:	08 00                	or     %al,(%rax)
ffff80000010d4c6:	00 00                	add    %al,(%rax)
ffff80000010d4c8:	1c 00                	sbb    $0x0,%al
ffff80000010d4ca:	00 00                	add    %al,(%rax)
ffff80000010d4cc:	fc                   	cld    
ffff80000010d4cd:	01 00                	add    %eax,(%rax)
ffff80000010d4cf:	00 48 6f             	add    %cl,0x6f(%rax)
ffff80000010d4d2:	ff                   	(bad)  
ffff80000010d4d3:	ff 34 00             	push   (%rax,%rax,1)
ffff80000010d4d6:	00 00                	add    %al,(%rax)
ffff80000010d4d8:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d4db:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d4e1:	6b 0c 07 08          	imul   $0x8,(%rdi,%rax,1),%ecx
ffff80000010d4e5:	00 00                	add    %al,(%rax)
ffff80000010d4e7:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d4ea:	00 00                	add    %al,(%rax)
ffff80000010d4ec:	1c 02                	sbb    $0x2,%al
ffff80000010d4ee:	00 00                	add    %al,(%rax)
ffff80000010d4f0:	5c                   	pop    %rsp
ffff80000010d4f1:	6f                   	outsl  %ds:(%rsi),(%dx)
ffff80000010d4f2:	ff                   	(bad)  
ffff80000010d4f3:	ff 35 00 00 00 00    	push   0x0(%rip)        # ffff80000010d4f9 <_erodata+0x22e>
ffff80000010d4f9:	45 0e                	rex.RB (bad) 
ffff80000010d4fb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d501:	6c                   	insb   (%dx),%es:(%rdi)
ffff80000010d502:	0c 07                	or     $0x7,%al
ffff80000010d504:	08 00                	or     %al,(%rax)
ffff80000010d506:	00 00                	add    %al,(%rax)
ffff80000010d508:	1c 00                	sbb    $0x0,%al
ffff80000010d50a:	00 00                	add    %al,(%rax)
ffff80000010d50c:	3c 02                	cmp    $0x2,%al
ffff80000010d50e:	00 00                	add    %al,(%rax)
ffff80000010d510:	71 6f                	jno    ffff80000010d581 <_erodata+0x2b6>
ffff80000010d512:	ff                   	(bad)  
ffff80000010d513:	ff 28                	ljmp   *(%rax)
ffff80000010d515:	00 00                	add    %al,(%rax)
ffff80000010d517:	00 00                	add    %al,(%rax)
ffff80000010d519:	45 0e                	rex.RB (bad) 
ffff80000010d51b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d521:	5f                   	pop    %rdi
ffff80000010d522:	0c 07                	or     $0x7,%al
ffff80000010d524:	08 00                	or     %al,(%rax)
ffff80000010d526:	00 00                	add    %al,(%rax)
ffff80000010d528:	1c 00                	sbb    $0x0,%al
ffff80000010d52a:	00 00                	add    %al,(%rax)
ffff80000010d52c:	5c                   	pop    %rsp
ffff80000010d52d:	02 00                	add    (%rax),%al
ffff80000010d52f:	00 79 6f             	add    %bh,0x6f(%rcx)
ffff80000010d532:	ff                   	(bad)  
ffff80000010d533:	ff 2a                	ljmp   *(%rdx)
ffff80000010d535:	00 00                	add    %al,(%rax)
ffff80000010d537:	00 00                	add    %al,(%rax)
ffff80000010d539:	45 0e                	rex.RB (bad) 
ffff80000010d53b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d541:	61                   	(bad)  
ffff80000010d542:	0c 07                	or     $0x7,%al
ffff80000010d544:	08 00                	or     %al,(%rax)
ffff80000010d546:	00 00                	add    %al,(%rax)
ffff80000010d548:	1c 00                	sbb    $0x0,%al
ffff80000010d54a:	00 00                	add    %al,(%rax)
ffff80000010d54c:	7c 02                	jl     ffff80000010d550 <_erodata+0x285>
ffff80000010d54e:	00 00                	add    %al,(%rax)
ffff80000010d550:	83 6f ff ff          	subl   $0xffffffff,-0x1(%rdi)
ffff80000010d554:	4b 00 00             	rex.WXB add %al,(%r8)
ffff80000010d557:	00 00                	add    %al,(%rax)
ffff80000010d559:	45 0e                	rex.RB (bad) 
ffff80000010d55b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d561:	02 42 0c             	add    0xc(%rdx),%al
ffff80000010d564:	07                   	(bad)  
ffff80000010d565:	08 00                	or     %al,(%rax)
ffff80000010d567:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d56a:	00 00                	add    %al,(%rax)
ffff80000010d56c:	9c                   	pushf  
ffff80000010d56d:	02 00                	add    (%rax),%al
ffff80000010d56f:	00 ae 6f ff ff 7d    	add    %ch,0x7dffff6f(%rsi)
ffff80000010d575:	02 00                	add    (%rax),%al
ffff80000010d577:	00 00                	add    %al,(%rax)
ffff80000010d579:	45 0e                	rex.RB (bad) 
ffff80000010d57b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d581:	03 74 02 0c          	add    0xc(%rdx,%rax,1),%esi
ffff80000010d585:	07                   	(bad)  
ffff80000010d586:	08 00                	or     %al,(%rax)
ffff80000010d588:	1c 00                	sbb    $0x0,%al
ffff80000010d58a:	00 00                	add    %al,(%rax)
ffff80000010d58c:	bc 02 00 00 0b       	mov    $0xb000002,%esp
ffff80000010d591:	72 ff                	jb     ffff80000010d592 <_erodata+0x2c7>
ffff80000010d593:	ff 64 00 00          	jmp    *0x0(%rax,%rax,1)
ffff80000010d597:	00 00                	add    %al,(%rax)
ffff80000010d599:	45 0e                	rex.RB (bad) 
ffff80000010d59b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d5a1:	02 5b 0c             	add    0xc(%rbx),%bl
ffff80000010d5a4:	07                   	(bad)  
ffff80000010d5a5:	08 00                	or     %al,(%rax)
ffff80000010d5a7:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d5aa:	00 00                	add    %al,(%rax)
ffff80000010d5ac:	dc 02                	faddl  (%rdx)
ffff80000010d5ae:	00 00                	add    %al,(%rax)
ffff80000010d5b0:	4f 72 ff             	rex.WRXB jb ffff80000010d5b2 <_erodata+0x2e7>
ffff80000010d5b3:	ff f2                	push   %rdx
ffff80000010d5b5:	0a 00                	or     (%rax),%al
ffff80000010d5b7:	00 00                	add    %al,(%rax)
ffff80000010d5b9:	45 0e                	rex.RB (bad) 
ffff80000010d5bb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d5c1:	03 e9                	add    %ecx,%ebp
ffff80000010d5c3:	0a 0c 07             	or     (%rdi,%rax,1),%cl
ffff80000010d5c6:	08 00                	or     %al,(%rax)
ffff80000010d5c8:	1c 00                	sbb    $0x0,%al
ffff80000010d5ca:	00 00                	add    %al,(%rax)
ffff80000010d5cc:	fc                   	cld    
ffff80000010d5cd:	02 00                	add    (%rax),%al
ffff80000010d5cf:	00 21                	add    %ah,(%rcx)
ffff80000010d5d1:	7d ff                	jge    ffff80000010d5d2 <_erodata+0x307>
ffff80000010d5d3:	ff c9                	dec    %ecx
ffff80000010d5d5:	00 00                	add    %al,(%rax)
ffff80000010d5d7:	00 00                	add    %al,(%rax)
ffff80000010d5d9:	45 0e                	rex.RB (bad) 
ffff80000010d5db:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d5e1:	02 c0                	add    %al,%al
ffff80000010d5e3:	0c 07                	or     $0x7,%al
ffff80000010d5e5:	08 00                	or     %al,(%rax)
ffff80000010d5e7:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d5ea:	00 00                	add    %al,(%rax)
ffff80000010d5ec:	1c 03                	sbb    $0x3,%al
ffff80000010d5ee:	00 00                	add    %al,(%rax)
ffff80000010d5f0:	ca 7d ff             	lret   $0xff7d
ffff80000010d5f3:	ff                   	(bad)  
ffff80000010d5f4:	39 00                	cmp    %eax,(%rax)
ffff80000010d5f6:	00 00                	add    %al,(%rax)
ffff80000010d5f8:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d5fb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d601:	70 0c                	jo     ffff80000010d60f <_erodata+0x344>
ffff80000010d603:	07                   	(bad)  
ffff80000010d604:	08 00                	or     %al,(%rax)
ffff80000010d606:	00 00                	add    %al,(%rax)
ffff80000010d608:	1c 00                	sbb    $0x0,%al
ffff80000010d60a:	00 00                	add    %al,(%rax)
ffff80000010d60c:	3c 03                	cmp    $0x3,%al
ffff80000010d60e:	00 00                	add    %al,(%rax)
ffff80000010d610:	e3 7d                	jrcxz  ffff80000010d68f <_erodata+0x3c4>
ffff80000010d612:	ff                   	(bad)  
ffff80000010d613:	ff 53 00             	call   *0x0(%rbx)
ffff80000010d616:	00 00                	add    %al,(%rax)
ffff80000010d618:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d61b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d621:	02 4a 0c             	add    0xc(%rdx),%cl
ffff80000010d624:	07                   	(bad)  
ffff80000010d625:	08 00                	or     %al,(%rax)
ffff80000010d627:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d62a:	00 00                	add    %al,(%rax)
ffff80000010d62c:	5c                   	pop    %rsp
ffff80000010d62d:	03 00                	add    (%rax),%eax
ffff80000010d62f:	00 16                	add    %dl,(%rsi)
ffff80000010d631:	7e ff                	jle    ffff80000010d632 <_erodata+0x367>
ffff80000010d633:	ff 48 00             	decl   0x0(%rax)
ffff80000010d636:	00 00                	add    %al,(%rax)
ffff80000010d638:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d63b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d641:	7f 0c                	jg     ffff80000010d64f <_erodata+0x384>
ffff80000010d643:	07                   	(bad)  
ffff80000010d644:	08 00                	or     %al,(%rax)
ffff80000010d646:	00 00                	add    %al,(%rax)
ffff80000010d648:	1c 00                	sbb    $0x0,%al
ffff80000010d64a:	00 00                	add    %al,(%rax)
ffff80000010d64c:	7c 03                	jl     ffff80000010d651 <_erodata+0x386>
ffff80000010d64e:	00 00                	add    %al,(%rax)
ffff80000010d650:	3e 7e ff             	jle,pt ffff80000010d652 <_erodata+0x387>
ffff80000010d653:	ff b4 00 00 00 00 45 	push   0x45000000(%rax,%rax,1)
ffff80000010d65a:	0e                   	(bad)  
ffff80000010d65b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d661:	02 ab 0c 07 08 00    	add    0x8070c(%rbx),%ch
ffff80000010d667:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d66a:	00 00                	add    %al,(%rax)
ffff80000010d66c:	9c                   	pushf  
ffff80000010d66d:	03 00                	add    (%rax),%eax
ffff80000010d66f:	00 d2                	add    %dl,%dl
ffff80000010d671:	7e ff                	jle    ffff80000010d672 <_erodata+0x3a7>
ffff80000010d673:	ff 48 00             	decl   0x0(%rax)
ffff80000010d676:	00 00                	add    %al,(%rax)
ffff80000010d678:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d67b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d681:	7f 0c                	jg     ffff80000010d68f <_erodata+0x3c4>
ffff80000010d683:	07                   	(bad)  
ffff80000010d684:	08 00                	or     %al,(%rax)
ffff80000010d686:	00 00                	add    %al,(%rax)
ffff80000010d688:	1c 00                	sbb    $0x0,%al
ffff80000010d68a:	00 00                	add    %al,(%rax)
ffff80000010d68c:	bc 03 00 00 fa       	mov    $0xfa000003,%esp
ffff80000010d691:	7e ff                	jle    ffff80000010d692 <_erodata+0x3c7>
ffff80000010d693:	ff 4b 00             	decl   0x0(%rbx)
ffff80000010d696:	00 00                	add    %al,(%rax)
ffff80000010d698:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d69b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d6a1:	02 42 0c             	add    0xc(%rdx),%al
ffff80000010d6a4:	07                   	(bad)  
ffff80000010d6a5:	08 00                	or     %al,(%rax)
ffff80000010d6a7:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d6aa:	00 00                	add    %al,(%rax)
ffff80000010d6ac:	dc 03                	faddl  (%rbx)
ffff80000010d6ae:	00 00                	add    %al,(%rax)
ffff80000010d6b0:	25 7f ff ff 3d       	and    $0x3dffff7f,%eax
ffff80000010d6b5:	00 00                	add    %al,(%rax)
ffff80000010d6b7:	00 00                	add    %al,(%rax)
ffff80000010d6b9:	45 0e                	rex.RB (bad) 
ffff80000010d6bb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d6c1:	74 0c                	je     ffff80000010d6cf <_erodata+0x404>
ffff80000010d6c3:	07                   	(bad)  
ffff80000010d6c4:	08 00                	or     %al,(%rax)
ffff80000010d6c6:	00 00                	add    %al,(%rax)
ffff80000010d6c8:	1c 00                	sbb    $0x0,%al
ffff80000010d6ca:	00 00                	add    %al,(%rax)
ffff80000010d6cc:	fc                   	cld    
ffff80000010d6cd:	03 00                	add    (%rax),%eax
ffff80000010d6cf:	00 42 7f             	add    %al,0x7f(%rdx)
ffff80000010d6d2:	ff                   	(bad)  
ffff80000010d6d3:	ff 5d 00             	lcall  *0x0(%rbp)
ffff80000010d6d6:	00 00                	add    %al,(%rax)
ffff80000010d6d8:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d6db:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d6e1:	02 54 0c 07          	add    0x7(%rsp,%rcx,1),%dl
ffff80000010d6e5:	08 00                	or     %al,(%rax)
ffff80000010d6e7:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d6ea:	00 00                	add    %al,(%rax)
ffff80000010d6ec:	1c 04                	sbb    $0x4,%al
ffff80000010d6ee:	00 00                	add    %al,(%rax)
ffff80000010d6f0:	7f 7f                	jg     ffff80000010d771 <_erodata+0x4a6>
ffff80000010d6f2:	ff                   	(bad)  
ffff80000010d6f3:	ff 5c 01 00          	lcall  *0x0(%rcx,%rax,1)
ffff80000010d6f7:	00 00                	add    %al,(%rax)
ffff80000010d6f9:	45 0e                	rex.RB (bad) 
ffff80000010d6fb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d701:	03 53 01             	add    0x1(%rbx),%edx
ffff80000010d704:	0c 07                	or     $0x7,%al
ffff80000010d706:	08 00                	or     %al,(%rax)
ffff80000010d708:	1c 00                	sbb    $0x0,%al
ffff80000010d70a:	00 00                	add    %al,(%rax)
ffff80000010d70c:	3c 04                	cmp    $0x4,%al
ffff80000010d70e:	00 00                	add    %al,(%rax)
ffff80000010d710:	bb 80 ff ff bb       	mov    $0xbbffff80,%ebx
ffff80000010d715:	00 00                	add    %al,(%rax)
ffff80000010d717:	00 00                	add    %al,(%rax)
ffff80000010d719:	45 0e                	rex.RB (bad) 
ffff80000010d71b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d721:	02 b2 0c 07 08 00    	add    0x8070c(%rdx),%dh
ffff80000010d727:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d72a:	00 00                	add    %al,(%rax)
ffff80000010d72c:	5c                   	pop    %rsp
ffff80000010d72d:	04 00                	add    $0x0,%al
ffff80000010d72f:	00 56 81             	add    %dl,-0x7f(%rsi)
ffff80000010d732:	ff                   	(bad)  
ffff80000010d733:	ff 01                	incl   (%rcx)
ffff80000010d735:	01 00                	add    %eax,(%rax)
ffff80000010d737:	00 00                	add    %al,(%rax)
ffff80000010d739:	45 0e                	rex.RB (bad) 
ffff80000010d73b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d741:	02 f8                	add    %al,%bh
ffff80000010d743:	0c 07                	or     $0x7,%al
ffff80000010d745:	08 00                	or     %al,(%rax)
ffff80000010d747:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d74a:	00 00                	add    %al,(%rax)
ffff80000010d74c:	7c 04                	jl     ffff80000010d752 <_erodata+0x487>
ffff80000010d74e:	00 00                	add    %al,(%rax)
ffff80000010d750:	37                   	(bad)  
ffff80000010d751:	82                   	(bad)  
ffff80000010d752:	ff                   	(bad)  
ffff80000010d753:	ff f2                	push   %rdx
ffff80000010d755:	00 00                	add    %al,(%rax)
ffff80000010d757:	00 00                	add    %al,(%rax)
ffff80000010d759:	45 0e                	rex.RB (bad) 
ffff80000010d75b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d761:	02 e9                	add    %cl,%ch
ffff80000010d763:	0c 07                	or     $0x7,%al
ffff80000010d765:	08 00                	or     %al,(%rax)
ffff80000010d767:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d76a:	00 00                	add    %al,(%rax)
ffff80000010d76c:	9c                   	pushf  
ffff80000010d76d:	04 00                	add    $0x0,%al
ffff80000010d76f:	00 09                	add    %cl,(%rcx)
ffff80000010d771:	83 ff ff             	cmp    $0xffffffff,%edi
ffff80000010d774:	1f                   	(bad)  
ffff80000010d775:	01 00                	add    %eax,(%rax)
ffff80000010d777:	00 00                	add    %al,(%rax)
ffff80000010d779:	45 0e                	rex.RB (bad) 
ffff80000010d77b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d781:	03 16                	add    (%rsi),%edx
ffff80000010d783:	01 0c 07             	add    %ecx,(%rdi,%rax,1)
ffff80000010d786:	08 00                	or     %al,(%rax)
ffff80000010d788:	1c 00                	sbb    $0x0,%al
ffff80000010d78a:	00 00                	add    %al,(%rax)
ffff80000010d78c:	bc 04 00 00 08       	mov    $0x8000004,%esp
ffff80000010d791:	84 ff                	test   %bh,%bh
ffff80000010d793:	ff 69 05             	ljmp   *0x5(%rcx)
ffff80000010d796:	00 00                	add    %al,(%rax)
ffff80000010d798:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d79b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d7a1:	03 60 05             	add    0x5(%rax),%esp
ffff80000010d7a4:	0c 07                	or     $0x7,%al
ffff80000010d7a6:	08 00                	or     %al,(%rax)
ffff80000010d7a8:	20 00                	and    %al,(%rax)
ffff80000010d7aa:	00 00                	add    %al,(%rax)
ffff80000010d7ac:	dc 04 00             	faddl  (%rax,%rax,1)
ffff80000010d7af:	00 51 89             	add    %dl,-0x77(%rcx)
ffff80000010d7b2:	ff                   	(bad)  
ffff80000010d7b3:	ff 4a 00             	decl   0x0(%rdx)
ffff80000010d7b6:	00 00                	add    %al,(%rax)
ffff80000010d7b8:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d7bb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d7c1:	41 83 03 02          	addl   $0x2,(%r11)
ffff80000010d7c5:	40 0c 07             	rex or $0x7,%al
ffff80000010d7c8:	08 00                	or     %al,(%rax)
ffff80000010d7ca:	00 00                	add    %al,(%rax)
ffff80000010d7cc:	20 00                	and    %al,(%rax)
ffff80000010d7ce:	00 00                	add    %al,(%rax)
ffff80000010d7d0:	00 05 00 00 77 89    	add    %al,-0x76890000(%rip)        # ffff7fff8987d7d6 <OLD_SS+0xffff7fff8987d71e>
ffff80000010d7d6:	ff                   	(bad)  
ffff80000010d7d7:	ff a8 04 00 00 00    	ljmp   *0x4(%rax)
ffff80000010d7dd:	45 0e                	rex.RB (bad) 
ffff80000010d7df:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d7e5:	03 9f 04 0c 07 08    	add    0x8070c04(%rdi),%ebx
ffff80000010d7eb:	00 00                	add    %al,(%rax)
ffff80000010d7ed:	00 00                	add    %al,(%rax)
ffff80000010d7ef:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d7f2:	00 00                	add    %al,(%rax)
ffff80000010d7f4:	24 05                	and    $0x5,%al
ffff80000010d7f6:	00 00                	add    %al,(%rax)
ffff80000010d7f8:	fb                   	sti    
ffff80000010d7f9:	8d                   	(bad)  
ffff80000010d7fa:	ff                   	(bad)  
ffff80000010d7fb:	ff 9d 00 00 00 00    	lcall  *0x0(%rbp)
ffff80000010d801:	45 0e                	rex.RB (bad) 
ffff80000010d803:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d809:	02 94 0c 07 08 00 00 	add    0x807(%rsp,%rcx,1),%dl
ffff80000010d810:	1c 00                	sbb    $0x0,%al
ffff80000010d812:	00 00                	add    %al,(%rax)
ffff80000010d814:	44 05 00 00 78 8e    	rex.R add $0x8e780000,%eax
ffff80000010d81a:	ff                   	(bad)  
ffff80000010d81b:	ff 51 00             	call   *0x0(%rcx)
ffff80000010d81e:	00 00                	add    %al,(%rax)
ffff80000010d820:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d823:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d829:	02 48 0c             	add    0xc(%rax),%cl
ffff80000010d82c:	07                   	(bad)  
ffff80000010d82d:	08 00                	or     %al,(%rax)
ffff80000010d82f:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d832:	00 00                	add    %al,(%rax)
ffff80000010d834:	64 05 00 00 a9 8e    	fs add $0x8ea90000,%eax
ffff80000010d83a:	ff                   	(bad)  
ffff80000010d83b:	ff 51 00             	call   *0x0(%rcx)
ffff80000010d83e:	00 00                	add    %al,(%rax)
ffff80000010d840:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d843:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d849:	02 48 0c             	add    0xc(%rax),%cl
ffff80000010d84c:	07                   	(bad)  
ffff80000010d84d:	08 00                	or     %al,(%rax)
ffff80000010d84f:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d852:	00 00                	add    %al,(%rax)
ffff80000010d854:	84 05 00 00 da 8e    	test   %al,-0x71260000(%rip)        # ffff7fff8eead85a <OLD_SS+0xffff7fff8eead7a2>
ffff80000010d85a:	ff                   	(bad)  
ffff80000010d85b:	ff 51 00             	call   *0x0(%rcx)
ffff80000010d85e:	00 00                	add    %al,(%rax)
ffff80000010d860:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d863:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d869:	02 48 0c             	add    0xc(%rax),%cl
ffff80000010d86c:	07                   	(bad)  
ffff80000010d86d:	08 00                	or     %al,(%rax)
ffff80000010d86f:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d872:	00 00                	add    %al,(%rax)
ffff80000010d874:	a4                   	movsb  %ds:(%rsi),%es:(%rdi)
ffff80000010d875:	05 00 00 0b 8f       	add    $0x8f0b0000,%eax
ffff80000010d87a:	ff                   	(bad)  
ffff80000010d87b:	ff 51 00             	call   *0x0(%rcx)
ffff80000010d87e:	00 00                	add    %al,(%rax)
ffff80000010d880:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d883:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d889:	02 48 0c             	add    0xc(%rax),%cl
ffff80000010d88c:	07                   	(bad)  
ffff80000010d88d:	08 00                	or     %al,(%rax)
ffff80000010d88f:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d892:	00 00                	add    %al,(%rax)
ffff80000010d894:	c4                   	(bad)  
ffff80000010d895:	05 00 00 3c 8f       	add    $0x8f3c0000,%eax
ffff80000010d89a:	ff                   	(bad)  
ffff80000010d89b:	ff                   	(bad)  
ffff80000010d89c:	b9 00 00 00 00       	mov    $0x0,%ecx
ffff80000010d8a1:	45 0e                	rex.RB (bad) 
ffff80000010d8a3:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d8a9:	02 b0 0c 07 08 00    	add    0x8070c(%rax),%dh
ffff80000010d8af:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d8b2:	00 00                	add    %al,(%rax)
ffff80000010d8b4:	e4 05                	in     $0x5,%al
ffff80000010d8b6:	00 00                	add    %al,(%rax)
ffff80000010d8b8:	d5                   	(bad)  
ffff80000010d8b9:	8f                   	(bad)  
ffff80000010d8ba:	ff                   	(bad)  
ffff80000010d8bb:	ff cd                	dec    %ebp
ffff80000010d8bd:	00 00                	add    %al,(%rax)
ffff80000010d8bf:	00 00                	add    %al,(%rax)
ffff80000010d8c1:	45 0e                	rex.RB (bad) 
ffff80000010d8c3:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d8c9:	02 c4                	add    %ah,%al
ffff80000010d8cb:	0c 07                	or     $0x7,%al
ffff80000010d8cd:	08 00                	or     %al,(%rax)
ffff80000010d8cf:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010d8d2:	00 00                	add    %al,(%rax)
ffff80000010d8d4:	04 06                	add    $0x6,%al
ffff80000010d8d6:	00 00                	add    %al,(%rax)
ffff80000010d8d8:	82                   	(bad)  
ffff80000010d8d9:	90                   	nop
ffff80000010d8da:	ff                   	(bad)  
ffff80000010d8db:	ff b7 01 00 00 00    	push   0x1(%rdi)
ffff80000010d8e1:	45 0e                	rex.RB (bad) 
ffff80000010d8e3:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d8e9:	03 ae 01 0c 07 08    	add    0x8070c01(%rsi),%ebp
ffff80000010d8ef:	00 18                	add    %bl,(%rax)
ffff80000010d8f1:	00 00                	add    %al,(%rax)
ffff80000010d8f3:	00 24 06             	add    %ah,(%rsi,%rax,1)
ffff80000010d8f6:	00 00                	add    %al,(%rax)
ffff80000010d8f8:	19 92 ff ff 86 00    	sbb    %edx,0x86ffff(%rdx)
ffff80000010d8fe:	00 00                	add    %al,(%rax)
ffff80000010d900:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d903:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d909:	00 00                	add    %al,(%rax)
ffff80000010d90b:	00 18                	add    %bl,(%rax)
ffff80000010d90d:	00 00                	add    %al,(%rax)
ffff80000010d90f:	00 40 06             	add    %al,0x6(%rax)
ffff80000010d912:	00 00                	add    %al,(%rax)
ffff80000010d914:	83 92 ff ff 86 00 00 	adcl   $0x0,0x86ffff(%rdx)
ffff80000010d91b:	00 00                	add    %al,(%rax)
ffff80000010d91d:	45 0e                	rex.RB (bad) 
ffff80000010d91f:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d925:	00 00                	add    %al,(%rax)
ffff80000010d927:	00 18                	add    %bl,(%rax)
ffff80000010d929:	00 00                	add    %al,(%rax)
ffff80000010d92b:	00 5c 06 00          	add    %bl,0x0(%rsi,%rax,1)
ffff80000010d92f:	00 ed                	add    %ch,%ch
ffff80000010d931:	92                   	xchg   %eax,%edx
ffff80000010d932:	ff                   	(bad)  
ffff80000010d933:	ff 86 00 00 00 00    	incl   0x0(%rsi)
ffff80000010d939:	45 0e                	rex.RB (bad) 
ffff80000010d93b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d941:	00 00                	add    %al,(%rax)
ffff80000010d943:	00 18                	add    %bl,(%rax)
ffff80000010d945:	00 00                	add    %al,(%rax)
ffff80000010d947:	00 78 06             	add    %bh,0x6(%rax)
ffff80000010d94a:	00 00                	add    %al,(%rax)
ffff80000010d94c:	57                   	push   %rdi
ffff80000010d94d:	93                   	xchg   %eax,%ebx
ffff80000010d94e:	ff                   	(bad)  
ffff80000010d94f:	ff 86 00 00 00 00    	incl   0x0(%rsi)
ffff80000010d955:	45 0e                	rex.RB (bad) 
ffff80000010d957:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d95d:	00 00                	add    %al,(%rax)
ffff80000010d95f:	00 18                	add    %bl,(%rax)
ffff80000010d961:	00 00                	add    %al,(%rax)
ffff80000010d963:	00 94 06 00 00 c1 93 	add    %dl,-0x6c3f0000(%rsi,%rax,1)
ffff80000010d96a:	ff                   	(bad)  
ffff80000010d96b:	ff 86 00 00 00 00    	incl   0x0(%rsi)
ffff80000010d971:	45 0e                	rex.RB (bad) 
ffff80000010d973:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d979:	00 00                	add    %al,(%rax)
ffff80000010d97b:	00 18                	add    %bl,(%rax)
ffff80000010d97d:	00 00                	add    %al,(%rax)
ffff80000010d97f:	00 b0 06 00 00 2b    	add    %dh,0x2b000006(%rax)
ffff80000010d985:	94                   	xchg   %eax,%esp
ffff80000010d986:	ff                   	(bad)  
ffff80000010d987:	ff 86 00 00 00 00    	incl   0x0(%rsi)
ffff80000010d98d:	45 0e                	rex.RB (bad) 
ffff80000010d98f:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d995:	00 00                	add    %al,(%rax)
ffff80000010d997:	00 18                	add    %bl,(%rax)
ffff80000010d999:	00 00                	add    %al,(%rax)
ffff80000010d99b:	00 cc                	add    %cl,%ah
ffff80000010d99d:	06                   	(bad)  
ffff80000010d99e:	00 00                	add    %al,(%rax)
ffff80000010d9a0:	95                   	xchg   %eax,%ebp
ffff80000010d9a1:	94                   	xchg   %eax,%esp
ffff80000010d9a2:	ff                   	(bad)  
ffff80000010d9a3:	ff 86 00 00 00 00    	incl   0x0(%rsi)
ffff80000010d9a9:	45 0e                	rex.RB (bad) 
ffff80000010d9ab:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d9b1:	00 00                	add    %al,(%rax)
ffff80000010d9b3:	00 18                	add    %bl,(%rax)
ffff80000010d9b5:	00 00                	add    %al,(%rax)
ffff80000010d9b7:	00 e8                	add    %ch,%al
ffff80000010d9b9:	06                   	(bad)  
ffff80000010d9ba:	00 00                	add    %al,(%rax)
ffff80000010d9bc:	ff 94 ff ff 86 00 00 	call   *0x86ff(%rdi,%rdi,8)
ffff80000010d9c3:	00 00                	add    %al,(%rax)
ffff80000010d9c5:	45 0e                	rex.RB (bad) 
ffff80000010d9c7:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d9cd:	00 00                	add    %al,(%rax)
ffff80000010d9cf:	00 18                	add    %bl,(%rax)
ffff80000010d9d1:	00 00                	add    %al,(%rax)
ffff80000010d9d3:	00 04 07             	add    %al,(%rdi,%rax,1)
ffff80000010d9d6:	00 00                	add    %al,(%rax)
ffff80000010d9d8:	69 95 ff ff 86 00 00 	imul   $0x45000000,0x86ffff(%rbp),%edx
ffff80000010d9df:	00 00 45 
ffff80000010d9e2:	0e                   	(bad)  
ffff80000010d9e3:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010d9e9:	00 00                	add    %al,(%rax)
ffff80000010d9eb:	00 18                	add    %bl,(%rax)
ffff80000010d9ed:	00 00                	add    %al,(%rax)
ffff80000010d9ef:	00 20                	add    %ah,(%rax)
ffff80000010d9f1:	07                   	(bad)  
ffff80000010d9f2:	00 00                	add    %al,(%rax)
ffff80000010d9f4:	d3 95 ff ff 86 00    	rcll   %cl,0x86ffff(%rbp)
ffff80000010d9fa:	00 00                	add    %al,(%rax)
ffff80000010d9fc:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010d9ff:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010da05:	00 00                	add    %al,(%rax)
ffff80000010da07:	00 18                	add    %bl,(%rax)
ffff80000010da09:	00 00                	add    %al,(%rax)
ffff80000010da0b:	00 3c 07             	add    %bh,(%rdi,%rax,1)
ffff80000010da0e:	00 00                	add    %al,(%rax)
ffff80000010da10:	3d 96 ff ff 17       	cmp    $0x17ffff96,%eax
ffff80000010da15:	02 00                	add    (%rax),%al
ffff80000010da17:	00 00                	add    %al,(%rax)
ffff80000010da19:	45 0e                	rex.RB (bad) 
ffff80000010da1b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010da21:	00 00                	add    %al,(%rax)
ffff80000010da23:	00 18                	add    %bl,(%rax)
ffff80000010da25:	00 00                	add    %al,(%rax)
ffff80000010da27:	00 58 07             	add    %bl,0x7(%rax)
ffff80000010da2a:	00 00                	add    %al,(%rax)
ffff80000010da2c:	38 98 ff ff 17 02    	cmp    %bl,0x217ffff(%rax)
ffff80000010da32:	00 00                	add    %al,(%rax)
ffff80000010da34:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010da37:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010da3d:	00 00                	add    %al,(%rax)
ffff80000010da3f:	00 18                	add    %bl,(%rax)
ffff80000010da41:	00 00                	add    %al,(%rax)
ffff80000010da43:	00 74 07 00          	add    %dh,0x0(%rdi,%rax,1)
ffff80000010da47:	00 33                	add    %dh,(%rbx)
ffff80000010da49:	9a                   	(bad)  
ffff80000010da4a:	ff                   	(bad)  
ffff80000010da4b:	ff 17                	call   *(%rdi)
ffff80000010da4d:	02 00                	add    (%rax),%al
ffff80000010da4f:	00 00                	add    %al,(%rax)
ffff80000010da51:	45 0e                	rex.RB (bad) 
ffff80000010da53:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010da59:	00 00                	add    %al,(%rax)
ffff80000010da5b:	00 18                	add    %bl,(%rax)
ffff80000010da5d:	00 00                	add    %al,(%rax)
ffff80000010da5f:	00 90 07 00 00 2e    	add    %dl,0x2e000007(%rax)
ffff80000010da65:	9c                   	pushf  
ffff80000010da66:	ff                   	(bad)  
ffff80000010da67:	ff 28                	ljmp   *(%rax)
ffff80000010da69:	02 00                	add    (%rax),%al
ffff80000010da6b:	00 00                	add    %al,(%rax)
ffff80000010da6d:	45 0e                	rex.RB (bad) 
ffff80000010da6f:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010da75:	00 00                	add    %al,(%rax)
ffff80000010da77:	00 18                	add    %bl,(%rax)
ffff80000010da79:	00 00                	add    %al,(%rax)
ffff80000010da7b:	00 ac 07 00 00 3a 9e 	add    %ch,-0x61c60000(%rdi,%rax,1)
ffff80000010da82:	ff                   	(bad)  
ffff80000010da83:	ff cf                	dec    %edi
ffff80000010da85:	02 00                	add    (%rax),%al
ffff80000010da87:	00 00                	add    %al,(%rax)
ffff80000010da89:	45 0e                	rex.RB (bad) 
ffff80000010da8b:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010da91:	00 00                	add    %al,(%rax)
ffff80000010da93:	00 18                	add    %bl,(%rax)
ffff80000010da95:	00 00                	add    %al,(%rax)
ffff80000010da97:	00 c8                	add    %cl,%al
ffff80000010da99:	07                   	(bad)  
ffff80000010da9a:	00 00                	add    %al,(%rax)
ffff80000010da9c:	ed                   	in     (%dx),%eax
ffff80000010da9d:	a0 ff ff 86 00 00 00 	movabs 0x450000000086ffff,%al
ffff80000010daa4:	00 45 
ffff80000010daa6:	0e                   	(bad)  
ffff80000010daa7:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010daad:	00 00                	add    %al,(%rax)
ffff80000010daaf:	00 18                	add    %bl,(%rax)
ffff80000010dab1:	00 00                	add    %al,(%rax)
ffff80000010dab3:	00 e4                	add    %ah,%ah
ffff80000010dab5:	07                   	(bad)  
ffff80000010dab6:	00 00                	add    %al,(%rax)
ffff80000010dab8:	57                   	push   %rdi
ffff80000010dab9:	a1 ff ff 86 00 00 00 	movabs 0x450000000086ffff,%eax
ffff80000010dac0:	00 45 
ffff80000010dac2:	0e                   	(bad)  
ffff80000010dac3:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010dac9:	00 00                	add    %al,(%rax)
ffff80000010dacb:	00 18                	add    %bl,(%rax)
ffff80000010dacd:	00 00                	add    %al,(%rax)
ffff80000010dacf:	00 00                	add    %al,(%rax)
ffff80000010dad1:	08 00                	or     %al,(%rax)
ffff80000010dad3:	00 c1                	add    %al,%cl
ffff80000010dad5:	a1 ff ff 86 00 00 00 	movabs 0x450000000086ffff,%eax
ffff80000010dadc:	00 45 
ffff80000010dade:	0e                   	(bad)  
ffff80000010dadf:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010dae5:	00 00                	add    %al,(%rax)
ffff80000010dae7:	00 18                	add    %bl,(%rax)
ffff80000010dae9:	00 00                	add    %al,(%rax)
ffff80000010daeb:	00 1c 08             	add    %bl,(%rax,%rcx,1)
ffff80000010daee:	00 00                	add    %al,(%rax)
ffff80000010daf0:	2b a2 ff ff 86 00    	sub    0x86ffff(%rdx),%esp
ffff80000010daf6:	00 00                	add    %al,(%rax)
ffff80000010daf8:	00 45 0e             	add    %al,0xe(%rbp)
ffff80000010dafb:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010db01:	00 00                	add    %al,(%rax)
ffff80000010db03:	00 18                	add    %bl,(%rax)
ffff80000010db05:	00 00                	add    %al,(%rax)
ffff80000010db07:	00 38                	add    %bh,(%rax)
ffff80000010db09:	08 00                	or     %al,(%rax)
ffff80000010db0b:	00 95 a2 ff ff 86    	add    %dl,-0x7900005e(%rbp)
ffff80000010db11:	00 00                	add    %al,(%rax)
ffff80000010db13:	00 00                	add    %al,(%rax)
ffff80000010db15:	45 0e                	rex.RB (bad) 
ffff80000010db17:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010db1d:	00 00                	add    %al,(%rax)
ffff80000010db1f:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010db22:	00 00                	add    %al,(%rax)
ffff80000010db24:	54                   	push   %rsp
ffff80000010db25:	08 00                	or     %al,(%rax)
ffff80000010db27:	00 ff                	add    %bh,%bh
ffff80000010db29:	a2 ff ff c7 02 00 00 	movabs %al,0x4500000002c7ffff
ffff80000010db30:	00 45 
ffff80000010db32:	0e                   	(bad)  
ffff80000010db33:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010db39:	03 be 02 0c 07 08    	add    0x8070c02(%rsi),%edi
ffff80000010db3f:	00 1c 00             	add    %bl,(%rax,%rax,1)
ffff80000010db42:	00 00                	add    %al,(%rax)
ffff80000010db44:	74 08                	je     ffff80000010db4e <_erodata+0x883>
ffff80000010db46:	00 00                	add    %al,(%rax)
ffff80000010db48:	a6                   	cmpsb  %es:(%rdi),%ds:(%rsi)
ffff80000010db49:	a5                   	movsl  %ds:(%rsi),%es:(%rdi)
ffff80000010db4a:	ff                   	(bad)  
ffff80000010db4b:	ff 0a                	decl   (%rdx)
ffff80000010db4d:	08 00                	or     %al,(%rax)
ffff80000010db4f:	00 00                	add    %al,(%rax)
ffff80000010db51:	45 0e                	rex.RB (bad) 
ffff80000010db53:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010db59:	03 01                	add    (%rcx),%eax
ffff80000010db5b:	08 0c 07             	or     %cl,(%rdi,%rax,1)
ffff80000010db5e:	08 00                	or     %al,(%rax)
ffff80000010db60:	18 00                	sbb    %al,(%rax)
ffff80000010db62:	00 00                	add    %al,(%rax)
ffff80000010db64:	94                   	xchg   %eax,%esp
ffff80000010db65:	08 00                	or     %al,(%rax)
ffff80000010db67:	00 90 ad ff ff 43    	add    %dl,0x43ffffad(%rax)
ffff80000010db6d:	01 00                	add    %eax,(%rax)
ffff80000010db6f:	00 00                	add    %al,(%rax)
ffff80000010db71:	45 0e                	rex.RB (bad) 
ffff80000010db73:	10 86 02 43 0d 06    	adc    %al,0x60d4302(%rsi)
ffff80000010db79:	00 00                	add    %al,(%rax)
	...

Disassembly of section .bss:

ffff80000010db80 <pos>:
	...

ffff80000010dbc0 <buf>:
	...

ffff80000010ebc0 <cpunum>:
ffff80000010ebc0:	00 00                	add    %al,(%rax)
	...

ffff80000010ebc4 <initial_apicid>:
	...

ffff80000010ebe0 <mem_structure>:
	...

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	47                   	rex.RXB
   1:	43                   	rex.XB
   2:	43 3a 20             	rex.XB cmp (%r8),%spl
   5:	28 55 62             	sub    %dl,0x62(%rbp)
   8:	75 6e                	jne    78 <ES>
   a:	74 75                	je     81 <RAX+0x1>
   c:	20 31                	and    %dh,(%rcx)
   e:	31 2e                	xor    %ebp,(%rsi)
  10:	34 2e                	xor    $0x2e,%al
  12:	30 2d 31 75 62 75    	xor    %ch,0x75627531(%rip)        # 75627549 <OLD_SS+0x75627491>
  18:	6e                   	outsb  %ds:(%rsi),(%dx)
  19:	74 75                	je     90 <ERRCODE>
  1b:	31 7e 32             	xor    %edi,0x32(%rsi)
  1e:	32 2e                	xor    (%rsi),%ch
  20:	30 34 29             	xor    %dh,(%rcx,%rbp,1)
  23:	20 31                	and    %dh,(%rcx)
  25:	31 2e                	xor    %ebp,(%rsi)
  27:	34 2e                	xor    $0x2e,%al
  29:	30 00                	xor    %al,(%rax)
