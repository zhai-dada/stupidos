#ifndef __ASSERT_H__
#define __ASSERT_H__
#include <stdint.h>


#define DEBUG


void assert_failure(s8* exp, s8* file, s8* base, const s8* func, s32 line);

#ifndef DEBUG
#define assert(exp) void(0)
#else
#define assert(exp)                                                             \
    if(exp)                                                                     \
    {                                                                           \
        ;                                                                       \
    }                                                                           \
    else                                                                        \
    {                                                                           \
        assert_failure(#exp, __FILE__, __BASE_FILE__, __func__, __LINE__);      \
    }                       


#endif

#endif