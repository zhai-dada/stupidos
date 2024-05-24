#ifndef __UEFI_BOOT_PARAM_INFO_H__
#define __UEFI_BOOT_PARAM_INFO_H__

#include <stdint.h>

struct EFI_GRAPHICSOUTPUT_INFORMATION
{
    uint32_t hr;   // 水平分辨率
    uint32_t vr;   // 垂直分辨率
    uint32_t ppsl; // 像素每扫描线
    uint64_t bufferbase;
    uint64_t buffersize;
};
struct EFI_E820_MEMORY_DESCRIPTOR
{
    uint64_t address;
    uint64_t length;
    uint32_t type;
} __attribute__((packed));

struct EFI_E820_MEMORY_DESCRIPTOR_INFORMATION
{
    uint32_t entrycount;
    struct EFI_E820_MEMORY_DESCRIPTOR e820_entry[];
};
struct KERNEL_BOOT_INFORMATION
{
    struct EFI_GRAPHICSOUTPUT_INFORMATION graphicsinf;
    struct EFI_E820_MEMORY_DESCRIPTOR_INFORMATION e820inf;
};


extern struct KERNEL_BOOT_INFORMATION *boot_info;

#endif