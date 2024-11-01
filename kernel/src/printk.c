#include <printk.h>
#include <lib.h>
#include <memory.h>
#include <uefi.h>
#include <font.h>

struct position pos;
int8_t buf[4096] = {0};

void init_printk(void)
{
	spinlock_init(&pos.printk_lock);
	int32_t *addr = (int32_t *)0xffff800003000000;

	pos.x_resolution = boot_info->graphicsinf.hr;
	pos.y_resolution = boot_info->graphicsinf.vr;
	pos.x_position = 0;
	pos.y_position = 0;

	pos.x_charsize = 8;
	pos.y_charsize = 16;

	pos.FB_addr = addr;
	pos.FB_length = boot_info->graphicsinf.buffersize;
	memset(pos.FB_addr, 0, pos.FB_length);
}
void vbe_buffer_init()
{
	uint64_t i = 0;
	uint64_t *tmp = NULL;
	uint64_t *tmp1 = NULL;
	uint64_t *virtual = NULL;
	uint64_t phy = 0;
	uint32_t *FB_addr = (uint32_t *)P_TO_V(boot_info->graphicsinf.bufferbase);
	
	cr3 = get_gdt();
	tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)cr3 & (~0xfffUL))) + (((uint64_t)FB_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
	if (*tmp == 0)
	{
		virtual = (uint64_t *)kmalloc(PAGE_4K_SIZE, 0);
		memset(virtual, 0, PAGE_4K_SIZE);
		set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_KERNEL_GDT | PAGE_USER_GDT));
	}
	tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((uint64_t)FB_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
	if (*tmp == 0)
	{
		virtual = (uint64_t *)kmalloc(PAGE_4K_SIZE, 0);
		memset(virtual, 0, PAGE_4K_SIZE);
		set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_KERNEL_DIR | PAGE_USER_DIR));
	}
	for (i = 0; i < pos.FB_length; i = i + PAGE_2M_SIZE)
	{
		tmp1 = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp & (~0xfffUL)) & (~0xfffUL))) + ((((uint64_t)FB_addr + i) >> PAGE_2M_SHIFT) & 0x1ff) * 8);
		phy = boot_info->graphicsinf.bufferbase + i;
		set_pdt(tmp1, make_pdt(phy, PAGE_KERNEL_PAGE | PAGE_PWT | PAGE_PCD | PAGE_USER_PAGE));
	}
	pos.FB_addr = (uint32_t *)P_TO_V(boot_info->graphicsinf.bufferbase);
	flush_tlb();
	return;
}

int32_t skip_atoi(const int8_t **s)
{
	int32_t i = 0;

	while (is_digit(**s))
	{
		i = i * 10 + *((*s)++) - '0';
	}
	return i;
}

void putchar(uint32_t *fb, int32_t x_size, int32_t x, int32_t y, uint32_t FRcolor, uint32_t BKcolor, uint8_t font)
{
	uint32_t *addr = NULL;
	int32_t i = 0, j = 0;
	uint8_t *fontp = NULL;
	fontp = font_ascii[font];

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

static int8_t *number(int8_t *str, int64_t num, int32_t base, int32_t size, int32_t precision, int32_t type)
{
	int8_t c, sign, tmp[50];
	const int8_t *digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	int32_t i;

	if (type & SMALL)
		digits = "0123456789abcdefghijklmnopqrstuvwxyz";
	if (type & LEFT)
		type &= ~ZEROPAD;
	if (base < 2 || base > 36)
		return 0;
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
	if (type & SIGN && num < 0)
	{
		sign = '-';
		num = -num;
	}
	else
		sign = (type & PLUS) ? '+' : ((type & SPACE) ? ' ' : 0);
	if (sign)
		size--;
	if (type & SPECIAL)
		if (base == 16)
			size -= 2;
		else if (base == 8)
			size--;
	i = 0;
	if (num == 0)
		tmp[i++] = '0';
	else
		while (num != 0)
			tmp[i++] = digits[do_div(num, base)];
	if (i > precision)
		precision = i;
	size -= precision;
	if (!(type & (ZEROPAD + LEFT)))
		while (size-- > 0)
			*str++ = ' ';
	if (sign)
		*str++ = sign;
	if (type & SPECIAL)
		if (base == 8)
			*str++ = '0';
		else if (base == 16)
		{
			*str++ = '0';
			*str++ = digits[33];
		}
	if (!(type & LEFT))
		while (size-- > 0)
			*str++ = c;

	while (i < precision--)
		*str++ = '0';
	while (i-- > 0)
		*str++ = tmp[i];
	while (size-- > 0)
		*str++ = ' ';
	return str;
}

int32_t vsprintf(int8_t *buf, const int8_t *fmt, va_list args)
{
	int8_t *str, *s;
	int32_t flags;
	int32_t field_width;
	int32_t precision;
	int32_t len, i;

	int32_t qualifier; /* 'h', 'l', 'L' or 'Z' for integer fields */

	for (str = buf; *fmt; fmt++)
	{

		if (*fmt != '%')
		{
			*str++ = *fmt;
			continue;
		}
		flags = 0;
	repeat:
		fmt++;
		switch (*fmt)
		{
		case '-':
			flags |= LEFT;
			goto repeat;
		case '+':
			flags |= PLUS;
			goto repeat;
		case ' ':
			flags |= SPACE;
			goto repeat;
		case '#':
			flags |= SPECIAL;
			goto repeat;
		case '0':
			flags |= ZEROPAD;
			goto repeat;
		}

		field_width = -1;
		if (is_digit(*fmt))
			field_width = skip_atoi(&fmt);
		else if (*fmt == '*')
		{
			fmt++;
			field_width = va_arg(args, int32_t);
			if (field_width < 0)
			{
				field_width = -field_width;
				flags |= LEFT;
			}
		}

		precision = -1;
		if (*fmt == '.')
		{
			fmt++;
			if (is_digit(*fmt))
				precision = skip_atoi(&fmt);
			else if (*fmt == '*')
			{
				fmt++;
				precision = va_arg(args, int32_t);
			}
			if (precision < 0)
				precision = 0;
		}

		qualifier = -1;
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' || *fmt == 'Z')
		{
			qualifier = *fmt;
			fmt++;
		}

		switch (*fmt)
		{
		case 'c':

			if (!(flags & LEFT))
				while (--field_width > 0)
					*str++ = ' ';
			*str++ = (uint8_t)va_arg(args, int32_t);
			while (--field_width > 0)
				*str++ = ' ';
			break;

		case 's':

			s = va_arg(args, int8_t *);
			if (!s)
				s = '\0';
			len = strlen(s);
			if (precision < 0)
				precision = len;
			else if (len > precision)
				len = precision;

			if (!(flags & LEFT))
				while (len < field_width--)
					*str++ = ' ';
			for (i = 0; i < len; i++)
				*str++ = *s++;
			while (len < field_width--)
				*str++ = ' ';
			break;

		case 'o':
			if (qualifier == 'l')
				str = number(str, va_arg(args, uint64_t), 8, field_width, precision, flags);
			else
				str = number(str, va_arg(args, uint32_t), 8, field_width, precision, flags);
			break;

		case 'p':

			if (field_width == -1)
			{
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}

			str = number(str, (uint64_t)va_arg(args, void *), 16, field_width, precision, flags);
			break;

		case 'x':

			flags |= SMALL;

		case 'X':

			if (qualifier == 'l')
				str = number(str, va_arg(args, uint64_t), 16, field_width, precision, flags);
			else
				str = number(str, va_arg(args, uint32_t), 16, field_width, precision, flags);
			break;

		case 'd':
		case 'i':
			flags |= SIGN;
		case 'u':

			if (qualifier == 'l')
				str = number(str, va_arg(args, uint64_t), 10, field_width, precision, flags);
			else
				str = number(str, va_arg(args, uint32_t), 10, field_width, precision, flags);
			break;

		case 'n':

			if (qualifier == 'l')
			{
				int64_t *ip = va_arg(args, int64_t *);
				*ip = (str - buf);
			}
			else
			{
				int32_t *ip = va_arg(args, int32_t *);
				*ip = (str - buf);
			}
			break;
        case 'b': // binary
            uint32_t num = va_arg(args, unsigned long);
            str = number(str, num, 2, field_width, precision, flags);
            break;
        case 'm': // mac address
            flags |= SMALL | ZEROPAD;
            uint8_t* ptr = va_arg(args, uint8_t *);
            for (uint32_t t = 0; t < 6; t++, ptr++)
            {
                int num = *ptr;
                str = number(str, num, 16, 2, precision, flags);
                *str = ':';
                str++;
            }
            str--;
            break;
        case 'r': // ip address
            flags |= SMALL;
            ptr = va_arg(args, uint8_t *);
            for (uint32_t t = 0; t < 4; t++, ptr++)
            {
                uint32_t num = *ptr;
                str = number(str, num, 10, field_width, precision, flags);
                *str = '.';
                str++;
            }
            str--;
            break;
		case '%':

			*str++ = '%';
			break;

		default:

			*str++ = '%';
			if (*fmt)
				*str++ = *fmt;
			else
				fmt--;
			break;
		}
	}
	*str = '\0';
	return (str - buf);
}

int32_t color_printk(uint32_t FRcolor, uint32_t BKcolor, const int8_t *fmt, ...)
{
	int32_t i = 0;
	int32_t count = 0;
	int32_t line = 0;
	uint64_t flags = 0;
	local_irq_save(flags);
	spinlock_lock(&pos.printk_lock);
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
		if ((uint8_t) * (buf + count) == '\n')
		{
			pos.y_position++;
			pos.x_position = 0;
		}
		else if ((uint8_t) * (buf + count) == '\b')
		{
			pos.x_position--;
			if (pos.x_position < 0)
			{
				pos.x_position = (pos.x_resolution / pos.x_charsize - 1) * pos.x_charsize;
				pos.y_position--;
				if (pos.y_position < 0)
					pos.y_position = (pos.y_resolution / pos.y_charsize - 1) * pos.y_charsize;
			}
			putchar(pos.FB_addr, pos.x_resolution, pos.x_position * pos.x_charsize, pos.y_position * pos.y_charsize, FRcolor, BKcolor, ' ');
		}
		else if ((uint8_t) * (buf + count) == '\t')
		{
			line = ((pos.x_position + 8) & ~(8 - 1)) - pos.x_position;

		tab:
			line--;
			putchar(pos.FB_addr, pos.x_resolution, pos.x_position * pos.x_charsize, pos.y_position * pos.y_charsize, FRcolor, BKcolor, ' ');
			pos.x_position++;
		}
		else
		{
			uint8_t font = (uint8_t)*(buf + count);
			putchar(pos.FB_addr, pos.x_resolution, pos.x_position * pos.x_charsize, pos.y_position * pos.y_charsize, FRcolor, BKcolor, font);
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
	spinlock_unlock(&pos.printk_lock);
	local_irq_restore(flags);
	return i;
}
void roll_screen(void)
{
	int8_t *i = (int8_t *)pos.FB_addr;
	int8_t *j = (int8_t *)i + pos.x_resolution * pos.y_charsize * 4;
	int8_t *res = (int8_t *)pos.FB_addr + pos.x_resolution * (pos.y_resolution / pos.y_charsize - 1) * pos.y_charsize * 4;
	int32_t count = (int32_t)(res - i);
	int8_t *all = (int8_t *)pos.FB_addr + pos.FB_length;
	int8_t black = 0x00;
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
// void roll_screen(void)
// {
// 	memcpy(pos.FB_addr, pos.FB_addr + pos.x_resolution * pos.y_charsize * 4, pos.x_resolution * (pos.y_resolution - 1));
// 	io_mfence();
// 	memset(pos.x_resolution * (pos.y_resolution - 1) * 4 + pos.FB_addr, 0, pos.x_resolution * 1);
// 	io_mfence();
// 	return;
// }
