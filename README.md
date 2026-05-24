# owOS

What happens when you lock me in a room with a computer, buildroot, and vim? This, apparently.

Ok, it's not really an operating system... but who cares? Screw you and your POSIX standards.

## Building the OS

Note that precompiled binaries should be available on the website (<https://owos.bkd.lol/>), so just use those if you are not willing to go through all of the steps below. For now, these only work in virtual machines. See the "Running the OS (on real hardware)" section.

To build the OS, clone buildroot in the root of the repo with `git clone https://github.com/buildroot/buildroot.git`, move into the directory with `cd buildroot`, then run `make menuconfig`. You will then need to select all of the following settings:

---

### Target options

Target Architecture: x86_64

### Toolchain

C library: musl

### Build options

ENABLE: compiler cache (makes compiling significantly faster after the first run-through)

### System configuration

System hostname: "owOS"

System banner: "Welcome to owOS"

Init system: BusyBox

DISABLE: Run a getty (login prompt) after boot

Root filesystem overlay directories: "../src"

Custom scripts to run after creating filesystem images: "$(TOPDIR)/../bundle_img.sh"

### Kernel

ENABLE: Linux Kernel

Defconfig name: "x86_64"

### Filesystem images

ENABLE: ext2/3/4 root filesystem

### Bootloaders

ENABLE: syslinux

> ENABLE: install mbr

### Host utiltites

ENABLE: host genimage

---

 This will take upwards of 10 minutes depending on your hardware (much longer on anything from before 5 or so years ago), so be prepared to wait a while the first time you compile the system. Depending on what you change (mostly enabling cache), these times will decrease dramatically after the first time you compile.

## Running the OS (in a VM)

Once everything is compiled (assuming there were no errors that stopped the build process), you can run `qemu-system-x86_64 -kernel output/images/bzImage -initrd output/images/rootfs.cpio -append "init=/init console=ttyS0" -nographic` to start the compiled OS in QEMU (assuming you have it installed). I like using `sudo qemu-system-x86_64 -m 1G -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,format=raw,if=virtio -append "root=/dev/vda rw console=tty1"`, as it opens up in its own window instead of using the terminal. It also stops a few weird visual bugs from happening (but those were mostly from when I was writing everything in Python instead of C).

## Running the OS (on real hardware)

I have spent like an hour trying to get this to work on real hardware, to no avail. Feel free to try yourself :3
