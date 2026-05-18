#!/bin/bash
sudo qemu-system-x86_64     -m 1G     -kernel ./manual_image_workspace/vmlinuz     -drive file=./output_img/sdcard.img,format=raw,if=virtio     -append "root=/dev/vda2 rw console=ttyS0"     -nographic
