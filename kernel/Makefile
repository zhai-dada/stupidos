CFLAGS 			:=	-mcmodel=large -fno-builtin -fno-stack-protector -m64 -fno-PIC -I./include/ -c
OBJFLAGS 		:=	-I elf64-x86-64 -S -R ".eh_frame" -R ".comment" -O binary
LDFLAGS 		:=	-b elf64-x86-64 -z muldefs -z noexecstack

CC 				:= 	gcc
OUTPUTKERNELDIR := 	../build/kernel
KERNELOBJS 		:=	$(patsubst ./src/%.c,$(OUTPUTKERNELDIR)/%.o,$(wildcard ./src/*.c))
MKDIR 			:=	mkdir -p


$(OUTPUTKERNELDIR)/%.o: ./src/%.c
	@$(MKDIR) $(OUTPUTKERNELDIR)
	$(CC) $(CFLAGS) $< -o $@

head.o:./src/head.S
	gcc -E -I./include/ $< -o $(OUTPUTKERNELDIR)/head.s
	as --64 $(OUTPUTKERNELDIR)/head.s -o $(OUTPUTKERNELDIR)/head.o
entry.o:./src/entry.S
	gcc -E -I./include/ $< -o $(OUTPUTKERNELDIR)/entry.s
	as --64 $(OUTPUTKERNELDIR)/entry.s -o $(OUTPUTKERNELDIR)/entry.o
apu_boot.o:./src/apu_boot.S
	gcc -E -I./include/ $< -o $(OUTPUTKERNELDIR)/apu_boot.s
	as --64 $(OUTPUTKERNELDIR)/apu_boot.s -o $(OUTPUTKERNELDIR)/apu_boot.o

system: $(KERNELOBJS) head.o entry.o apu_boot.o
	ld $(LDFLAGS) $(OUTPUTKERNELDIR)/head.o $(OUTPUTKERNELDIR)/entry.o $(OUTPUTKERNELDIR)/apu_boot.o $(KERNELOBJS) -o $(OUTPUTKERNELDIR)/$@ -T ./kernel.lds

all: system
	objcopy $(OBJFLAGS) $(OUTPUTKERNELDIR)/system $(OUTPUTKERNELDIR)/kernel.bin 
	objdump -D $(OUTPUTKERNELDIR)/system > test

.PHONY: all
