.PHONY: boot
boot:
	i586-elf-as boot.s -o boot.o

.PHONY: kernel
kernel:
	i586-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

.PHONY: link
link:
	i586-elf-gcc -T linker.ld -o kernel.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

.PHONY: iso
iso:
	mkdir -p iso/boot/grub
	cp kernel.bin iso/boot/kernel.bin
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o kernel.iso iso/

.PHONY: clean
clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.iso
	rm -rf iso/

.PHONY: all
all:
	make boot
	make kernel
	make link

.PHONY: qemu
qemu:
	make all iso
	qemu-system-i386 -cdrom kernel.iso
	
.PHONY: qemu-kernel
qemu-kernel:
	make all
	qemu-system-i386 -kernel kernel.bin
