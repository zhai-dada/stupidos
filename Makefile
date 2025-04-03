current_dir := $(shell pwd)
emulator_dir := $(shell pwd)/emulator
build_dir := $(shell pwd)/build
DISK=$(shell sudo losetup -fP --show $(shell pwd)/emulator/disk.img)

disk:
	make -C ./emulator disk

net:
	make -C ./emulator net

qemu:
	make clean

	make -C kernel all

	mkdir -p $(current_dir)/tmp
	sudo mount $(DISK)p1 $(current_dir)/tmp
	sudo mkdir -p $(current_dir)/tmp/EFI/BOOT
	sudo cp $(emulator_dir)/BOOTX64.efi ./tmp/EFI/BOOT/BOOTX64.efi

	sudo cp $(build_dir)/kernel/osImage ./tmp/osImage

	sudo umount $(current_dir)/tmp
	sudo losetup -D
	sudo sync

	rm -r $(current_dir)/tmp

	sudo qemu-system-x86_64 -bios emulator/OVMF.fd -hda $(emulator_dir)/disk.img \
	-cpu host -enable-kvm -m 4096 -smp 4 \
	-net none -netdev tap,id=my-tap,ifname=stupidos-tap,script=no,downscript=no -device e1000e,netdev=my-tap \
	-serial stdio

clean:
	rm -rf ./build

.PHONY:clean qemu disk net
