#ifndef __UEFI_BOOT_PARAM_INFO_H__
#define __UEFI_BOOT_PARAM_INFO_H__

#include <stdint.h>

struct EFI_GRAPHICSOUTPUT_INFORMATION
{
    u32 hr;   // 水平分辨率
    u32 vr;   // 垂直分辨率
    u32 ppsl; // 像素每扫描线
    u64 bufferbase;
    u64 buffersize;
};
struct EFI_E820_MEMORY_DESCRIPTOR
{
    u64 address;
    u64 length;
    u32 type;
} __attribute__((packed));

struct EFI_E820_MEMORY_DESCRIPTOR_INFORMATION
{
    u32 entrycount;
    struct EFI_E820_MEMORY_DESCRIPTOR e820_entry[];
};
struct KERNEL_BOOT_INFORMATION
{
    struct EFI_GRAPHICSOUTPUT_INFORMATION graphicsinf;
    struct EFI_E820_MEMORY_DESCRIPTOR_INFORMATION e820inf;
};

extern struct KERNEL_BOOT_INFORMATION *boot_info;

#endif