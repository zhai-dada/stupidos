#include <assert.h>
#include <printk.h>

void assert_failure(int8_t* exp, int8_t* file, int8_t* base, const int8_t* func, int32_t line)
{
    color_printk(RED, BLACK, "ASSERT");
    color_printk(RED, BLACK, "%s----->file:%s\tbase_file:%s\tfunc:%s\tline:%d\n", exp, file, base, func, line);
    return;
}