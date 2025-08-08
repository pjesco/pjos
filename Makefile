CROSS-COMPILE = $(HOME)/opt/cross/bin/i686-elf
AS = $(CROSS-COMPILE)-as
CC = $(CROSS-COMPILE)-gcc
LD = $(CROSS-COMPILE)-ld

SYSROOT=$(pwd)/sysroot
CC:= $(CC) --sysroot=$(SYSROOT)

CFLAGS = -g -std=gnu99 -ffreestanding -Wall -Wextra -nostdlib

.PHONY: clean kernel boot image
all: clean kernel boot image

clean:
	rm -rf *.o

kernel:
	$(CC) -c src/kernel.c -o kernel.o $(CFLAGS)
	$(CC) -c src/util.c -o util.o $(CFLAGS)
	$(CC) -c src/gdt.c -o gdt.o $(CFLAGS)
	$(CC) -c src/vga.c -o vga.o $(CFLAGS)
	$(CC) -c src/interrupts/idt.c -o idt.o $(CFLAGS)
	$(CC) -c src/timer.c -o timer.o $(CFLAGS)
	$(CC) -c src/keyboard.c -o keyboard.o $(CFLAGS)
	$(CC) -c src/stdlib/stdio.c -o stdio.o $(CFLAGS)
	$(CC) -c src/memory.c -o memory.o $(CFLAGS)

boot:
	nasm -f elf32 src/boot.s -o boot.o
	nasm -f elf32 src/gdt.s -o gdts.o
	nasm -f elf32 src/interrupts/idt.s -o idts.o

image:
	$(CC) -T linker.ld -o pjos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o vga.o gdt.o gdts.o util.o idt.o idts.o timer.o keyboard.o memory.o stdio.o -lgcc
	mkdir -p isodir/boot/grub
	cp pjos.bin isodir/boot/grub
	cp grub.cfg isodir/boot/grub/grub.cfg
	cp pjos.bin isodir/boot
	cp grub.cfg isodir/boot/grub.cfg
	grub-mkrescue -o pjos.iso isodir