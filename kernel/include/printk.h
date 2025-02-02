#ifndef __PRINTK_H__
#define __PRINTK_H__

#include <stdarg.h>
#include <linkage.h>
#include <lib.h>
#include <spinlock.h>

/**
 * 格式化显示，格式符
 * 补0，符号，加号，空格，左对其，#，小写
*/
#define ZEROPAD 0b0000001   /*0*/
#define SIGN    0b0000010
#define PLUS    0b0000100   /*+*/
#define SPACE   0b0001000   /* */
#define LEFT    0b0010000   /*-*/
#define SPECIAL 0b0100000   /*0x*/
#define SMALL   0b1000000

/**
 * 颜色----->32位色深
*/
#define WHITE   0x00ffffff
#define BLACK   0x00000000
#define RED     0x00ff0000
#define ORANGE  0x00ff8000
#define YELLOW  0x00ffff00
#define GREEN   0x0000ff00
#define BLUE    0x000000ff
#define INDIGO  0x0000ffff
#define PURPLE  0x008000ff

#define is_digit(c) ((c) >= '0' && (c) <= '9')

/**
 * 显示信息结构体
 * 包含显示的分辨率，当前光标的位置，字符的大小以及缓冲区地址以及缓冲区的长度
*/
struct position
{
    s32 x_resolution;
    s32 y_resolution;

    s32 x_position;
    s32 y_position;

    s32 x_charsize;
    s32 y_charsize;

    u32 *FB_addr;
    u64 FB_length;
    spinlock_t printk_lock;
};

void init_printk(void);
void vbe_buffer_init(void);

s32 color_printk(u32 FRcolor, u32 BKcolor, const s8 *fmt, ...);

#endif
