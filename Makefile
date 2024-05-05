MAKE		:= make
current_dir := $(shell pwd)



qemu:
	make clean
	$(MAKE) -C ./user all
	$(MAKE) -C ./kernel all
	sudo mkdir -p $(current_dir)/tmp
	sudo mkdir -p $(current_dir)/tmp/EFI/BOOT
	sudo cp $(current_dir)/BOOTX64.efi ./tmp/EFI/BOOT/BOOTX64.efi
	sudo cp $(current_dir)/build/kernel/kernel.bin $(current_dir)/tmp
	sudo cp $(current_dir)/build/user/init.bin $(current_dir)/tmp
	sudo sync
	sudo qemu-system-x86_64 -bios OVMF.fd -hda disk.img -cpu host -enable-kvm -m 4096 -smp 4 -display vnc=:0 -monitor stdio
clean:
	rm -rf ./build

.PHONY:kernel user clean
