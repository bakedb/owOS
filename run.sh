#!/bin/bash
echo "Make sure that you have QEMU installed!"
sudo qemu-system-x86_64 -m 1G -kernel bzImage -drive file=rootfs.ext2,format=raw,if=virtio -append "root=/dev/vda rw console=tty1"