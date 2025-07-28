#include <printk.h>

#define PRINTK_BUFFER_LEN 4096

// 格式化显示FLAG   补0，符号，加号，空格，左对其，#，小写
#define ZEROPAD 0b0000001   /*0*/
#define SIGN    0b0000010
#define PLUS    0b0000100   /*+*/
#define SPACE   0b0001000   /* */
#define LEFT    0b0010000   /*-*/
#define SPECIAL 0b0100000   /*0x*/
#define SMALL   0b1000000

#define is_digit(c) ((c) >= '0' && (c) <= '9')

#define do_div(n, base) ({			\
	u64 __base = (base);			\
	u64 __rem;						\
	__rem = ((u64)(n)) % __base;	\
	(n) = ((u64)(n)) / __base;		\
	__rem;							\
})

s8 printk_buffer[PRINTK_BUFFER_LEN];

static s8 *number(s8 *str, s64 num, s32 base, s32 size, s32 precision, s32 type)
{
	s8 c, sign, tmp[50];
	const s8 *digits = (s8*)"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	s32 i;

	if (type & SMALL)
	{
        digits = (s8*)"0123456789abcdefghijklmnopqrstuvwxyz";
    }
	if (type & LEFT)
	{
        type &= ~ZEROPAD;
    }
	if (base < 2 || base > 36)
	{
        return 0;
    }
	c = (type & ZEROPAD) ? '0' : ' ';
	sign = 0;
	if (type & SIGN && num < 0)
	{
		sign = '-';
		num = -num;
	}
	else
	{
        sign = (type & PLUS) ? '+' : ((type & SPACE) ? ' ' : 0);
    }
	if (sign)
	{
        size--;
    }
	if (type & SPECIAL)
	{
        if (base == 16)
		{
            size -= 2;
        }
		else if (base == 8)
		{
            size--;
        }
    }
	i = 0;
	if (num == 0)
	{
        tmp[i++] = '0';
    }
	else
	{
        while (num != 0)
		{
            tmp[i++] = digits[do_div(num, base)];
        }
    }
	if (i > precision)
	{
        precision = i;
    }
	size -= precision;
	if (!(type & (ZEROPAD + LEFT)))
	{
        while (size-- > 0)
		{
            *str++ = ' ';
        }
    }
	if (sign)
	{
        *str++ = sign;
    }
	if (type & SPECIAL)
	{
        if (base == 8)
		{
            *str++ = '0';
        }
		else if (base == 16)
		{
			*str++ = '0';
			*str++ = digits[33];
		}
    }
	if (!(type & LEFT))
	{
        while (size-- > 0)
		{
            *str++ = c;
        }
    }
	while (i < precision--)
	{
        *str++ = '0';
    }
	while (i-- > 0)
	{
        *str++ = tmp[i];
    }
	while (size-- > 0)
	{
        *str++ = ' ';
    }
	return str;
}

static s32 skip_atoi(const s8 **s)
{
	s32 i = 0;

	while (is_digit(**s))
	{
		i = i * 10 + *((*s)++) - '0';
	}
	return i;
}

static s32 vsprintf(s8 *buf, const s8 *fmt, va_list args)
{
	s8 *str, *s;
	s32 flags;
	s32 field_width;
	s32 precision;
	s32 len, i;

	s32 qualifier; /* 'h', 'l', 'L' or 'Z' for integer fields */

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
		{
            field_width = skip_atoi(&fmt);
        }
		else if (*fmt == '*')
		{
			fmt++;
			field_width = va_arg(args, s32);
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
			{
                precision = skip_atoi(&fmt);
            }
			else if (*fmt == '*')
			{
				fmt++;
				precision = va_arg(args, s32);
			}
			if (precision < 0)
			{
                precision = 0;
            }
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
			{
                while (--field_width > 0)
				{
                    *str++ = ' ';
                }
            }
			*str++ = (u8)va_arg(args, s32);
			while (--field_width > 0)
			{
                *str++ = ' ';
            }
			break;

		case 's':

			s = va_arg(args, s8 *);
			if (!s)
			{
				s = '\0';
			}
			len = strlen(s);
			if (precision < 0)
			{
				precision = len;
			}
			else if (len > precision)
			{
				len = precision;
			}
			if (!(flags & LEFT))
			{
				while (len < field_width--)
				{
					*str++ = ' ';
				}
			}
			for (i = 0; i < len; i++)
			{
				*str++ = *s++;
			}
			while (len < field_width--)
			{
				*str++ = ' ';
			}
			break;

		case 'o':
			if (qualifier == 'l')
			{
				str = number(str, va_arg(args, u64), 8, field_width, precision, flags);
			}
			else
			{
				str = number(str, va_arg(args, u32), 8, field_width, precision, flags);
			}
			break;

		case 'p':
			if (field_width == -1)
			{
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}

			str = number(str, (u64)va_arg(args, void *), 16, field_width, precision, flags);
			break;

		case 'x':
			flags |= SMALL;

		case 'X':
			if (qualifier == 'l')
			{
				str = number(str, va_arg(args, u64), 16, field_width, precision, flags);
			}
			else
			{
				str = number(str, va_arg(args, u32), 16, field_width, precision, flags);
			}
			break;

		case 'd':
		case 'i':
			flags |= SIGN;
		case 'u':
			if (qualifier == 'l')
			{
				str = number(str, va_arg(args, u64), 10, field_width, precision, flags);
			}
			else
			{
				str = number(str, va_arg(args, u32), 10, field_width, precision, flags);
			}
			break;

		case 'n':
			if (qualifier == 'l')
			{
				s64 *ip = va_arg(args, s64 *);
				*ip = (str - buf);
			}
			else
			{
				s32 *ip = va_arg(args, s32 *);
				*ip = (str - buf);
			}
			break;

        case 'b': // binary
            u32 num = va_arg(args, u64);
            str = number(str, num, 2, field_width, precision, flags);
            break;

        case 'm': // mac address
            flags |= SMALL | ZEROPAD;
            u8* ptr = va_arg(args, u8 *);
            for (u32 t = 0; t < 6; t++, ptr++)
            {
                s32 num = *ptr;
                str = number(str, num, 16, 2, precision, flags);
                *str = ':';
                str++;
            }
            str--;
            break;

        case 'r': // ip address
            flags |= SMALL;
            ptr = va_arg(args, u8 *);
            for (u32 t = 0; t < 4; t++, ptr++)
            {
                u32 num = *ptr;
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
			{
				*str++ = *fmt;
			}
			else
			{
				fmt--;
			}
			break;
		}
	}
	*str = '\0';
	return (str - buf);
}


s32 sprintf(s8* buffer, const s8* fmt, ...)
{
	s32 i = 0;

	va_list args;
	va_start(args, fmt);
	i = vsprintf(buffer, fmt, args);
	va_end(args);

    return i;
}

s32 printk(const s8* fmt, ...)
{
	s32 i = 0;

	va_list args;
	va_start(args, fmt);
	i = vsprintf(printk_buffer, fmt, args);
	va_end(args);

	uart_send_string(printk_buffer);

    return i;
}