#ifndef __ASSERT_H__
#define __ASSERT_H__
#include <stdint.h>


#define DEBUG


void assert_failure(int8_t* exp, int8_t* file, int8_t* base, const int8_t* func, int32_t line);

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