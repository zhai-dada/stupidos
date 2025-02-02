#include <assert.h>
#include <printk.h>

void assert_failure(s8* exp, s8* file, s8* base, const s8* func, s32 line)
{
    color_printk(RED, BLACK, "ASSERT");
    color_printk(RED, BLACK, "%s----->file:%s\tbase_file:%s\tfunc:%s\tline:%d\n", exp, file, base, func, line);
    return;
}