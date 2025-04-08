#ifndef __VBE_H__
#define __VBE_H__

#include <stdint.h>
#include <lib/libfont.h>

// UEFI设置的分辨率为 1024 * 768

#define WHITE   0x00ffffff
#define BLACK   0x00000000
#define RED     0x00ff0000
#define ORANGE  0x00ff8000
#define YELLOW  0x00ffff00
#define GREEN   0x0000ff00
#define BLUE    0x000000ff
#define INDIGO  0x0000ffff
#define PURPLE  0x008000ff

typedef struct vbe_info
{
    s32 x_resolution;
    s32 y_resolution;

    s32 x_position;
    s32 y_position;

    s32 x_charsize;
    s32 y_charsize;

    u32 *vbe_base_addr;
    u64 vbe_buffer_length;
} vbe_info_t;

void vbe_init(void);
s32 color_printk(u32 FRcolor, u32 BKcolor, const s8 *fmt, ...);

void vbe_buffer_init(void);

#endif