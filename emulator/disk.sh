dd if=/dev/zero of=disk.img bs=512M count=6
cat fdisk.args | fdisk disk.img
DISK=$(sudo losetup -fP --show disk.img)
sudo mkfs.fat -F 32 $DISK\p1
sudo mkfs.fat -F 32 $DISK\p2
sudo losetup -d $DISK
