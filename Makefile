ARCH := arm64
CROSS_COMPILE ?= aarch64-linux-gnu-

QEMU ?= qemu-system-aarch64

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld
STRIP := $(CROSS_COMPILE)strip
OBJCOPY := $(CROSS_COMPILE)objcopy

CFLAGS += -g -Wall -nostdlib -nostdinc -Iinclude -MMD
ASMFLAGS += -g -Iinclude -MMD

QEMUFLAGS += -nographic -machine raspi4b
QEMUFLAGS += -m 2048

LINKER ?= $(shell pwd)/boot/raspi4b.lds
BUILD_DIR := $(shell pwd)/build
PRJ_DIR := $(shell pwd)

OBJ += 	$(BUILD_DIR)/boot.o \
		$(BUILD_DIR)/mm.o	\
		$(BUILD_DIR)/kernel.o

DEP_FILES = $(OBJ:%.o=%.d)
-include $(DEP_FILES)

$(BUILD_DIR)/boot.o:$(PRJ_DIR)/boot/boot.S
	@mkdir -p $(BUILD_DIR)
	$(CC) $(ASMFLAGS) -c $< -o $@

$(BUILD_DIR)/mm.o:$(PRJ_DIR)/mm/mm.S
	$(CC) $(ASMFLAGS) -c $< -o $@

$(BUILD_DIR)/kernel.o:$(PRJ_DIR)/kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

all:stupidos.bin

stupidos.elf:$(OBJ) $(LINKER)
	$(LD) -T $(LINKER) -o $@ $(OBJ)
# 	$(STRIP) $@

stupidos.bin:stupidos.elf
	$(OBJCOPY) stupidos.elf -O binary $@

run:stupidos.bin
	$(QEMU) $(QEMUFLAGS) -kernel $<

debug:stupidos.bin
	$(QEMU) $(QEMUFLAGS) -kernel $< -S -s

clean:
	rm -rf $(BUILD_DIR)/* *.bin *.elf

.PHONY:clean
	