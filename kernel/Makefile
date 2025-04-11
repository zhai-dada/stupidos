BUILD_KERNEL := ../build/kernel

CFLAGS 	:=	-mcmodel=large -fno-builtin -fno-stack-protector -fno-pie -fno-pic -fno-common -nostartfiles -Wno-address-of-packed-member -m64 -I./inc/ -c -O0 -DASSERT -DQEMU
LDFLAGS :=	-b elf64-x86-64 -z muldefs -z noexecstack

obj = 	$(BUILD_KERNEL)/head.o		\
		$(BUILD_KERNEL)/entry.o		\
		$(BUILD_KERNEL)/uefi.o		\
		$(BUILD_KERNEL)/interrupt.o \
		$(BUILD_KERNEL)/apic.o		\
		$(BUILD_KERNEL)/kernel.o	\
		$(BUILD_KERNEL)/memory.o	\
		$(BUILD_KERNEL)/kmem.o		\
		$(BUILD_KERNEL)/asm.o		\
		$(BUILD_KERNEL)/libio.o		\
		$(BUILD_KERNEL)/list.o		\
		$(BUILD_KERNEL)/vsprintf.o	\
		$(BUILD_KERNEL)/string.o	\
		$(BUILD_KERNEL)/assert.o	\
		$(BUILD_KERNEL)/serial.o	\
		$(BUILD_KERNEL)/vbe.o		\
		$(BUILD_KERNEL)/cpu.o		\
		$(BUILD_KERNEL)/gate.o		\
		$(BUILD_KERNEL)/task.o		\
		$(BUILD_KERNEL)/trap.o		

$(BUILD_KERNEL)/head.o:./src/head.S
	gcc -E -I./inc/ $< -o $(BUILD_KERNEL)/head.s
	as --64 $(BUILD_KERNEL)/head.s -o $@

$(BUILD_KERNEL)/entry.o:./src/entry.S
	gcc -E -I./inc/ $< -o $(BUILD_KERNEL)/entry.s
	as --64 $(BUILD_KERNEL)/entry.s -o $@

$(BUILD_KERNEL)/asm.o:./src/lib/asm.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/string.o:./src/lib/string.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/assert.o:./src/assert.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/libio.o:./src/lib/libio.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/list.o:./src/lib/list.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/vsprintf.o:./src/lib/vsprintf.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/serial.o:./src/driver/serial.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/vbe.o:./src/driver/vbe.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/uefi.o:./src/uefi.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/cpu.o:./src/cpu.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/interrupt.o:./src/interrupt.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/apic.o:./src/apic.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/trap.o:./src/trap.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/gate.o:./src/gate.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/memory.o:./src/mm/memory.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/kmem.o:./src/mm/kmem.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/task.o:./src/task.c
	gcc $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/kernel.o:./src/kernel.c
	gcc $(CFLAGS) $< -o $@


$(BUILD_KERNEL)/osImage:$(obj)
	ld $(LDFLAGS) $(obj) -o $@ -T ./kernel.lds

builddir:
	mkdir -p $(BUILD_KERNEL)

all: builddir $(BUILD_KERNEL)/osImage

.PHONY:builddir all

