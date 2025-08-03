#include "gdt.h"


struct gdt_entry_struct gdt_entries[5];
struct gdt_ptr_struct gdt_ptr;

void initGDT() {
    gdt_ptr.limit = (sizeof(struct gdt_entry_struct) * 5) - 1;
    gdt_ptr.base = (uintptr_t)&gdt_entries;

    setGdtGate(0,0,0,0,0); //null seg
    setGdtGate(1,0,0xFFFFFFFF,0x9A,0xCF); //kernel code segment
    //9A = 1001 1010 -> permission bits
    setGdtGate(2, 0, 0xFFFFFFFF, 0x92, 0xCF); //kernel data segment
    setGdtGate(3,0,0xFFFFFFFF,0xFA,0xCF); //user code segment
    setGdtGate(4, 0, 0xFFFFFFFF, 0xF2, 0xCF); //user data segment

    gdt_flush((uintptr_t)&gdt_ptr);
}

void setGdtGate(uint32_t num, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran) {
    gdt_entries[num].lower_base = (base & 0xFFFF);
    gdt_entries[num].middle_base = (base >> 16) & 0xFF;
    gdt_entries[num].higher_base = (base >> 24) & 0xFF;

    gdt_entries[num].limit = (limit & 0xFFFF);
    gdt_entries[num].flags = (limit >> 16) & 0x0F;
    gdt_entries[num].flags |= gran & 0xF0;

    gdt_entries[num].access = access;
}