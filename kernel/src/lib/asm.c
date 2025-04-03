#include <lib/asm.h>

u64 *get_gdt(void)
{
    u64 *tmp;
    asm volatile
    (
        "movq %%cr3, %0 \n"
        : "=r"(tmp)
        :
        : "memory"
    );
    return tmp;
}