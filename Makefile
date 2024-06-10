MAKE		:= make
current_dir := $(shell pwd)
A=$(shell sudo losetup -fP --show disk.img)

qemu:
	make clean
	$(MAKE) -C ./user all
	$(MAKE) -C ./kernel all
	$(MAKE) -C ./test all
	sudo mount $(A)p1 ./tmp
	sudo mkdir -p $(current_dir)/tmp
	sudo mkdir -p $(current_dir)/tmp/EFI/BOOT
	sudo cp $(current_dir)/BOOTX64.efi ./tmp/EFI/BOOT/BOOTX64.efi
	sudo cp $(current_dir)/build/kernel/kernel.bin $(current_dir)/tmp
	sudo cp $(current_dir)/build/user/init.bin $(current_dir)/tmp
	sudo cp $(current_dir)/build/test/test.bin $(current_dir)/tmp
	sudo umount ./tmp
	sudo losetup -D
	sudo sync
	sudo qemu-system-x86_64 -bios OVMF.fd -hda disk.img -cpu host -enable-kvm -m 4096 -smp 4 -netdev tap,id=mytap,ifname=tap0,script=no,downscript=no -device e1000,netdev=mytap,mac=12:34:56:78:55:aa -display vnc=:0 -vga virtio -monitor stdio
clean:
	rm -rf ./build

.PHONY:kernel user clean
