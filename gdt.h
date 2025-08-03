#ifndef _KERNEL_GDT_H
#define _KERNEL_GDT_H

#include <stdint.h>

struct gdt_entry_struct {
    uint16_t limit;
    uint16_t lower_base;
    uint8_t middle_base;
    uint8_t access;
    uint8_t flags;
    uint8_t higher_base; 
}__attribute__((packed));

struct gdt_ptr_struct {
    uint16_t limit;
    unsigned int base;
}__attribute__((packed));

void initGDT();
void setGdtGate(uint32_t num, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran);
extern void gdt_flush(uintptr_t addr);

#endif