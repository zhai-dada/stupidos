#include <trap.h>
#include <printk.h>
#include <asm.h>

static const s8* const bad_mode_handler[] = 
{
    "Sync Abort",
    "IRQ",
    "FIQ",
    "SError"
};

void bad_mode(pt_regs_t* regs, u32 reason, u32 esr)
{
    printk("[bad mode\t] : %s , far : %#010x, esr: %#010x\n", bad_mode_handler[reason], read_sysreg(far_el1), esr);
    return;
}
