CFLAGS 			:=	-mcmodel=large -fno-builtin -fno-stack-protector -fno-pie -fno-pic -fno-common -nostartfiles -Wno-address-of-packed-member -m64 -I./include/ -c -O0
LDFLAGS 		:=	-b elf64-x86-64 -z muldefs -z noexecstack

CC 				:= 	gcc
BUILD_KERNEL := 	../build/kernel
KERNELOBJS 		:=	$(patsubst ./src/%.c,$(BUILD_KERNEL)/%.o,$(wildcard ./src/*.c)) \
					$(patsubst ./src/net/%.c,$(BUILD_KERNEL)/%.o,$(wildcard ./src/net/*.c))
MKDIR 			:=	mkdir -p

$(BUILD_KERNEL)/%.o: ./src/%.c
	@$(MKDIR) $(BUILD_KERNEL)
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_KERNEL)/%.o: ./src/net/%.c
	@$(MKDIR) $(BUILD_KERNEL)
	$(CC) $(CFLAGS) $< -o $@

head.o:./src/head.S
	gcc -E -I./include/ $< -o $(BUILD_KERNEL)/head.s
	as --64 $(BUILD_KERNEL)/head.s -o $(BUILD_KERNEL)/head.o
entry.o:./src/entry.S
	gcc -E -I./include/ $< -o $(BUILD_KERNEL)/entry.s
	as --64 $(BUILD_KERNEL)/entry.s -o $(BUILD_KERNEL)/entry.o
apu_boot.o:./src/apu_boot.S
	gcc -E -I./include/ $< -o $(BUILD_KERNEL)/apu_boot.s
	as --64 $(BUILD_KERNEL)/apu_boot.s -o $(BUILD_KERNEL)/apu_boot.o

system: $(KERNELOBJS) head.o entry.o apu_boot.o
	ld $(LDFLAGS) $(BUILD_KERNEL)/head.o $(BUILD_KERNEL)/entry.o $(BUILD_KERNEL)/apu_boot.o $(KERNELOBJS) -o $(BUILD_KERNEL)/$@ -T ./kernel.lds

osImage:system
	gcc kallsyms.c -o kallsyms
	nm -n $(BUILD_KERNEL)/system | ./kallsyms > kallsyms.S
	gcc -c kallsyms.S -o $(BUILD_KERNEL)/kallsyms.o
	rm kallsyms.S
	ld $(LDFLAGS) $(BUILD_KERNEL)/head.o $(BUILD_KERNEL)/entry.o $(BUILD_KERNEL)/kallsyms.o $(BUILD_KERNEL)/apu_boot.o $(KERNELOBJS) -o $(BUILD_KERNEL)/$@ -T ./kernel.lds

all: osImage