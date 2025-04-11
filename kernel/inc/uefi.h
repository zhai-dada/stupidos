#ifndef __UEFI_BOOT_PARAM_INFO_H__
#define __UEFI_BOOT_PARAM_INFO_H__
/**
 * 这些信息是由UEFI程序获取的，结构体的定义参见该项目的UEFI Loader
 */
#include <stdint.h>

typedef struct
{
    u32 hr;   // 水平分辨率
    u32 vr;   // 垂直分辨率
    u32 ppsl; // 像素每扫描线
    u64 bufferbase;
    u64 buffersize;
} efi_graphic_info_t;

typedef struct
{
    u64 address;
    u64 length;
    u32 type;
} __attribute__((packed)) efi_e820_t;

typedef struct
{
    u32 count;
    efi_e820_t e820_entry[];
} efi_e820_info_t;

typedef struct
{
    efi_graphic_info_t graphicsinf;
    efi_e820_info_t e820inf;
} boot_para_t;

extern boot_para_t *boot_info;

#endif