#include <backtrace.h>
#include <printk.h>
#include <debug.h>

extern u64 kallsyms_addresses[] __attribute__((weak));
extern s64 kallsyms_syms_num __attribute__((weak));
extern s64 kallsyms_index[] __attribute__((weak));
extern s8 *kallsyms_names __attribute__((weak));

s32 lookup_kallsyms(u64 address)
{
    s32 index = 0;
    s8 *string = (s8 *)&kallsyms_names;
    for (index = 0; index < kallsyms_syms_num; index++)
    {
        if (address > kallsyms_addresses[index] && address <= kallsyms_addresses[index + 1])
        {
            break;
        }
    }
    if (index < kallsyms_syms_num)
    {
        DBG_SERIAL(SERIAL_ATTR_FRONT_RED, SERIAL_ATTR_BACK_BLACK, "backtrace address:%#018lx (+) %04d\tbacktrace function:%s(%#018lx)\n", address, address - kallsyms_addresses[index], &string[kallsyms_index[index]], kallsyms_addresses[index]);
        return 0;
    }
    return 1;
}

void backtrace(struct stackregs *regs)
{
    u64 *rbp = (u64 *)regs->rbp;
    u64 ret_address = *(rbp + 1);
    s32 i = 0;

    lookup_kallsyms(regs->rip);
    for (i = 0; i < 10; i++)
    {
        if (lookup_kallsyms(ret_address))
        {
            break;
        }
        rbp = (u64 *)*rbp;
        ret_address = *(rbp + 1);
    }
}
