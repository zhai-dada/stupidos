#include <driver/vbe.h>
#include <debug.h>
#include <lib/string.h>
#include <lib/asm.h>
#include <uefi.h>
#include <mm/memory.h>

struct vbe_info pos;
s8 buf[4096] = {0};

void vbe_init(void)
{
	s32 *addr = (s32 *)0xffff800003000000;

	pos.x_resolution = boot_info->graphicsinf.hr;
	pos.y_resolution = boot_info->graphicsinf.vr;
	pos.x_position = 0;
	pos.y_position = 0;

	pos.x_charsize = 8;
	pos.y_charsize = 16;

	pos.vbe_base_addr = addr;
	pos.vbe_buffer_length = boot_info->graphicsinf.buffersize;
	memset(pos.vbe_base_addr, 0, pos.vbe_buffer_length);

	spinlock_init(&pos.vbelock);
}

static void vbe_putchar(u32 *fb, s32 x_size, s32 x, s32 y, u32 FRcolor, u32 BKcolor, u8 font)
{
	u32 *addr = NULL;
	s32 i = 0, j = 0;
	u8 *fontp = NULL;
	fontp = ascii_font[font];

	for (i = 0; i < 16; i++)
	{
		addr = fb + x_size * (y + i) + x;
		for (j = 0; j < 8; j++)
		{
			*fontp & (0x80 >> j) ? (*addr = FRcolor) : (*addr = BKcolor);
			addr++;
		}
		fontp++;
	}
	return;
}

/**
 * 很早之前用汇编写的一个，很乱
 */
static void roll_screen(void)
{
	s8 *i = (s8 *)pos.vbe_base_addr;
	s8 *j = (s8 *)i + pos.x_resolution * pos.y_charsize * 4;
	s8 *res = (s8 *)pos.vbe_base_addr + pos.x_resolution * (pos.y_resolution / pos.y_charsize - 1) * pos.y_charsize * 4;
	s32 count = (s32)(res - i);
	s8 *all = (s8 *)pos.vbe_base_addr + pos.vbe_buffer_length;
	s8 black = 0x00;
	asm volatile
	(
		"cld 		\n"
		"rep movsq 	\n"
		:
		: "D"(i), "S"(j), "c"(count / 8)
		: "memory"
	);
	io_mfence();
	for (j = res; j < all; j++)
	{
		*j = 0;
	}
	io_mfence();
	return;
}

s32 color_printk(u32 FRcolor, u32 BKcolor, const s8 *fmt, ...)
{
	s32 i = 0;
	s32 count = 0;
	s32 line = 0;
	u64 flags = 0;

	spinlock_lock(&pos.vbelock);

	va_list args;
	va_start(args, fmt);
	i = vsprintf(buf, fmt, args);
	va_end(args);
	
	for (count = 0; count < i || line; count++)
	{
		if (line > 0)
		{
			count--;
			goto tab;
		}
		if ((u8) * (buf + count) == '\n')
		{
			pos.y_position++;
			pos.x_position = 0;
		}
		else if ((u8) * (buf + count) == '\b')
		{
			pos.x_position--;
			if (pos.x_position < 0)
			{
				pos.x_position = (pos.x_resolution / pos.x_charsize - 1) * pos.x_charsize;
				pos.y_position--;
				if (pos.y_position < 0)
					pos.y_position = (pos.y_resolution / pos.y_charsize - 1) * pos.y_charsize;
			}
			vbe_putchar(pos.vbe_base_addr, pos.x_resolution, pos.x_position * pos.x_charsize, pos.y_position * pos.y_charsize, FRcolor, BKcolor, ' ');
		}
		else if ((u8) * (buf + count) == '\t')
		{
			line = ((pos.x_position + 8) & ~(8 - 1)) - pos.x_position;

		tab:
			line--;
			vbe_putchar(pos.vbe_base_addr, pos.x_resolution, pos.x_position * pos.x_charsize, pos.y_position * pos.y_charsize, FRcolor, BKcolor, ' ');
			pos.x_position++;
		}
		else
		{
			u8 font = (u8)*(buf + count);
			vbe_putchar(pos.vbe_base_addr, pos.x_resolution, pos.x_position * pos.x_charsize, pos.y_position * pos.y_charsize, FRcolor, BKcolor, font);
			pos.x_position++;
		}

		if (pos.x_position >= (pos.x_resolution / pos.x_charsize))
		{
			pos.y_position++;
			pos.x_position = 0;
		}
		if (pos.y_position >= (pos.y_resolution / pos.y_charsize))
		{
			roll_screen();
			pos.y_position--;
		}
	}
	spinlock_unlock(&pos.vbelock);
	return i;
}

void vbe_buffer_init(void)
{
	buffer_remap(boot_info->graphicsinf.bufferbase, boot_info->graphicsinf.buffersize);
	pos.vbe_base_addr = (u32 *)P_TO_V(boot_info->graphicsinf.bufferbase);
	return;
}
