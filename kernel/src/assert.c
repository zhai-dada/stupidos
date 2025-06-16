#include <assert.h>
#include <debug.h>

void assert_failure(s8* exp, s8* file, s8* base, const s8* func, s32 line)
{
    printk("assert : ");
    printk("%s----->file:%s\tbase_file:%s\tfunc:%s\tline:%d\n", exp, file, base, func, line);
    return;
}
