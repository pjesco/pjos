#ifndef _TIMER_H
#define _TIMER_H

void initTimer();
void onIrq0(struct InterruptRegisters* regs);

#endif