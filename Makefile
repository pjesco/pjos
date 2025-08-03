CROSS-COMPILE = $(HOME)/opt/cross/bin/i686-elf
AS = $(CROSS-COMPILE)-as
CC = $(CROSS-COMPILE)-gcc
LD = $(CROSS-COMPILE)-ld

SYSROOT=$(pwd)/sysroot
CC:= $(CC) --sysroot=$(SYSROOT)

.PHONY: clean kernel boot image
all: clean kernel boot image

clean:
	rm -rf *.o

kernel:
	$(CC) -c kernel.c -o kernel.o -g -std=gnu99 -ffreestanding -O2 -Wall -Wextra -nostdlib
	$(CC) -c gdt.c -o gdt.o -g -std=gnu99 -ffreestanding -O2 -Wall -Wextra -nostdlib

boot:
	$(AS) boot.s -o boot.o
	nasm -f elf32 gdt.s -o gdts.o

image:
	$(CC) -T linker.ld -o pjos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o gdt.o gdts.o -lgcc
	mkdir -p isodir/boot/grub
	cp pjos.bin isodir/boot/grub
	cp grub.cfg isodir/boot/grub/grub.cfg
	cp pjos.bin isodir/boot
	cp grub.cfg isodir/boot/grub.cfg
	grub-mkrescue -o pjos.iso isodir