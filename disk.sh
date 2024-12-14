dd if=/dev/zero of=disk.img bs=512M count=2
cat fdisk.args | fdisk disk.img
