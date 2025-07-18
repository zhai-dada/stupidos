#include <mm/mm.h>

s32 kernel_main(void)
{
    u64 a = 0xffffffffffffffff;
    memzero(&a, sizeof(s32));
    while(1)
    {
        a++;
        a++;
    }
    return 0;
}