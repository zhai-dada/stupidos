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
/**
 * 判断是否是数字或者gb2312汉字
*/
#define is_digit(c) ((c) >= '0' && (c) <= '9')
#define is_gb2312(ch) (ch >= 0xA1 && ch <= 0xFE)

/**
 * 显示信息结构体
 * 包含显示的分辨率，当前光标的位置，字符的大小以及缓冲区地址以及缓冲区的长度
*/
struct position
{
    int32_t x_resolution;
    int32_t y_resolution;

    int32_t x_position;
    int32_t y_position;

    int32_t x_charsize;
    int32_t y_charsize;

    uint32_t *FB_addr;
    uint64_t FB_length;
    spinlock_t printk_lock;
};
extern struct position pos;

void init_printk(void);
void vbe_buffer_init();
void putchar(uint32_t *fb, int32_t x_size, int32_t x, int32_t y, uint32_t FRcolor, uint32_t BKcolor, uint8_t font);

int32_t skip_atoi(const int8_t **s);

static int8_t *number(int8_t *str, long num, int32_t base, int32_t size, int32_t precision, int32_t type);

int32_t color_printk(uint32_t FRcolor, uint32_t BKcolor, const int8_t *fmt, ...);
int32_t vsprintf(int8_t *buf, const int8_t *fmt, va_list args);
void roll_screen(void);

#endif
