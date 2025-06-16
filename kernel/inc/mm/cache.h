#ifndef __CACHE_H__
#define __CACHE_H__

#include <stdint.h>

#ifdef ALDER_LAKE
#define CACHE_LINE_SIZE 64
#else
#define CACHE_LINE_SIZE 64
#endif

#define __align_to_cache __attribute__((aligned(CACHE_LINE_SIZE)))

struct zone_padding
{
    u8 xxx[0];
} __align_to_cache;

#define ZONE_PADDING(name) struct zone_padding name;

#endif
