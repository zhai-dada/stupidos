CFLAGS 			:=	-mcmodel=large -fno-builtin -fno-stack-protector -m64 -fno-PIC -I./include/ -c
OBJFLAGS 		:=	-I elf64-x86-64 -S -R ".eh_frame" -R ".comment" -O binary
LDFLAGS 		:=	-b elf64-x86-64 -z muldefs

CC 				:= 	gcc
OUTPUTUSERDIR 	:= 	../build/user
USEROBJS 		:=	$(patsubst ./src/%.c,$(OUTPUTUSERDIR)/%.o,$(wildcard ./src/*.c))
MKDIR 			:=	mkdir -p

$(OUTPUTUSERDIR)/%.o: ./src/%.c
	@$(MKDIR) $(OUTPUTUSERDIR)
	$(CC) $(CFLAGS) $< -o $@

user: $(USEROBJS)
	ld $(LDFLAGS) $(USEROBJS) -o $(OUTPUTUSERDIR)/user -T user.lds

user_bin: user
	objcopy $(OBJFLAGS) $(OUTPUTUSERDIR)/user $(OUTPUTUSERDIR)/init.bin
	# objdump -D $(OUTPUTUSERDIR)/user > test
