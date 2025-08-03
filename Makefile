ARCH := arm64
CROSS_COMPILE ?= aarch64-linux-gnu-

QEMU ?= qemu-system-aarch64

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld
STRIP := $(CROSS_COMPILE)strip
OBJCOPY := $(CROSS_COMPILE)objcopy
GDB := gdb-multiarch
GDBSCRIPT := debug/debug.gdb
GDBOPENOCD := debug/openocd.gdb


CFLAGS += -g -nostdlib -fno-builtin -Iinclude -MMD -mgeneral-regs-only
ASMFLAGS += -g -Iinclude -MMD
GDB_QEMU_FLAGS += --tui stupidos.elf -x $(GDBSCRIPT)
GDB_OPENOCD_FLAGS += --tui stupidos.elf -x $(GDBOPENOCD)

QEMUFLAGS += -nographic -machine raspi4b
QEMUFLAGS += -m 2048

LINKER ?= $(shell pwd)/boot/raspi4b.lds
BUILD_DIR := $(shell pwd)/build
PRJ_DIR := $(shell pwd)

ENTRY := _start

OBJ += 	$(BUILD_DIR)/boot.o 		\
		$(BUILD_DIR)/entry.o 		\
		$(BUILD_DIR)/early_uart.o 	\
		$(BUILD_DIR)/trap.o			\
		$(BUILD_DIR)/mm.o			\
		$(BUILD_DIR)/uart.o			\
		$(BUILD_DIR)/printk.o		\
		$(BUILD_DIR)/string.o		\
		$(BUILD_DIR)/kernel.o

DEP_FILES = $(OBJ:%.o=%.d)
-include $(DEP_FILES)

builddir:
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/boot.o:$(PRJ_DIR)/boot/boot.S
	$(CC) $(ASMFLAGS) -c $< -o $@

$(BUILD_DIR)/entry.o:$(PRJ_DIR)/boot/entry.S
	$(CC) $(ASMFLAGS) -c $< -o $@

$(BUILD_DIR)/mm.o:$(PRJ_DIR)/mm/mm.S
	$(CC) $(ASMFLAGS) -c $< -o $@

$(BUILD_DIR)/early_uart.o:$(PRJ_DIR)/boot/early_uart.S
	$(CC) $(ASMFLAGS) -c $< -o $@

$(BUILD_DIR)/trap.o:$(PRJ_DIR)/kernel/trap.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/uart.o:$(PRJ_DIR)/drivers/uart.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/printk.o:$(PRJ_DIR)/kernel/printk.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/string.o:$(PRJ_DIR)/kernel/string.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/kernel.o:$(PRJ_DIR)/kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

all:stupidos.bin

stupidos.elf:builddir $(OBJ) $(LINKER)
	$(LD) -o $@ $(OBJ) -T $(LINKER) -e $(ENTRY) -Map stupidos.map

stupidos.bin:stupidos.elf
	$(OBJCOPY) stupidos.elf -O binary $@

run_qemu:stupidos.bin
	$(QEMU) $(QEMUFLAGS) -kernel $<

debug_qemu:stupidos.bin
	$(QEMU) $(QEMUFLAGS) -kernel $< -S -s &
	$(GDB) $(GDB_QEMU_FLAGS)
	killall $(QEMU)

debug_openocd:stupidos.bin
	$(GDB) $(GDB_OPENOCD_FLAGS)

clean:
	rm -rf $(BUILD_DIR) *.bin *.elf *.map

.PHONY:clean builddir
