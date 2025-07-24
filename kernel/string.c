#include <string.h>

s32 strlen(u8 *str)
{
    u32 res = 0;
    for(res = 0; str[res] != '\0'; res++);
    return res;
}
