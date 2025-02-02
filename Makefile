current_dir := $(shell pwd)
emulator_dir := $(shell pwd)/emulator
build_dir := $(shell pwd)/build
A=$(shell sudo losetup -fP --show $(shell pwd)/emulator/disk.img)

disk:
	make -C ./emulator disk

qemu:
	make clean
	make -C ./user user_bin
	make -C ./kernel all
	make -C ./app app_bin
	mkdir -p ./tmp
	sudo mount $(A)p1 ./tmp
	sudo mkdir -p $(current_dir)/tmp
	sudo mkdir -p $(current_dir)/tmp/EFI/BOOT
	sudo cp $(emulator_dir)/BOOTX64.efi ./tmp/EFI/BOOT/BOOTX64.efi
	sudo cp $(build_dir)/kernel/osImage $(current_dir)/tmp/osImage
	sudo cp $(build_dir)/user/init.bin $(current_dir)/tmp
	sudo cp $(build_dir)/app/app.bin $(current_dir)/tmp
	sudo touch $(current_dir)/tmp/keyboard.dev
	sudo umount ./tmp
	sudo losetup -D
	sudo sync
	rm -r ./tmp
	sudo qemu-system-x86_64 -bios OVMF.fd -hda $(emulator_dir)/disk.img \
	-cpu host -enable-kvm -m 4096 -smp 4 \
	-net none -netdev tap,id=mytap,ifname=stupidos-tap,script=no,downscript=no -device e1000e,netdev=mytap \
	-serial stdio
clean:
	rm -rf ./build

.PHONY:kernel user clean
