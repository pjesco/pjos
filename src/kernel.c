#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "gdt.h"
#include "vga.h"
#include "interrupts/idt.h"
#include "timer.h"
#include "keyboard.h"
#include "stdlib/stdio.h"
#include "multiboot.h"
#include "memory.h"

#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

void kernel_main(uint32_t magic, struct multiboot_info* bootInfo) 
{
    initGDT();
    print("GDT is done!\r\n");
    initIdt();
    print("IDT is done!\r\n");
    //print((char*)(1/0));
    initTimer();
    print("Timer is done!\r\n");

    initKeyboard();
    print("Keyboard is done!\r\n");

    //initMemory(bootInfo);

    printf("Hello, Kernel World!\n");

    for (;;) {}
}