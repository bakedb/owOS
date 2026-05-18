# owOS

What happens when you take what is probably the worst language for systems programming and attempt to make an operating system with it? This, apparently.

Ok, it's not really an operating system... but who cares? Screw you and your POSIX standards.

## Building the OS

To build the OS, clone buildroot in the root of the repo with `git clone https://github.com/buildroot/buildroot.git`, move into the directory with `cd buildroot`, then run `make defconfig BR2_DEFCONFIG=../defconfig && make`. This will take upwards of 10 minutes, so be prepared to wait a while the first time you compile the system. Depending on what you change, these times will decrease dramatically after the first time.

Once everything is compiled (assuming there were no errors that stopped the build process), you can run `qemu-system-x86_64 -kernel output/images/bzImage -initrd output/images/rootfs.cpio -append "init=/init console=ttyS0" -nographic` to start the compiled OS in QEMU (assuming you have it installed).
