#include <mm/memory.h>
#include <uefi.h>
#include <lib/asm.h>
#include <driver/serial.h>

mm_des_t mem_structure = {{0}, 0};

extern s8 _text, _etext;
extern s8 _data, _edata;
extern s8 _rodata, _erodata;
extern s8 _bss, _ebss;
extern s8 _end;

u64* cr3;

u64 set_page_attribute(page_t* page, u64 flags)
{
    if(page == NULL)
    {
        serial_printf(SFGREEN, SBBLACK, "set_page_attribute() ERROR:page == NULL\n");
        return SFAIL;
    }
    page->attribute = flags;
    return SOK;
}

u64 page_init(page_t *page, u64 flags)
{
    page->attribute |= flags;
    if(!page->reference_count || (page->attribute & PAGE_SHARED))
    {
        page->reference_count++;
        page->zone_struct->total_pages_link++;
    }
    return SOK;
}

page_t * alloc_pages(s32 zone_select, s32 number, u64 page_flags)
{
	s32 i;
	u64 page = 0;

	if(number >= 64 || number <= 0)
	{
		serial_printf(SFYELLOW, SBBLACK, "alloc_pages() ERROR: number is invalid\n");
		return NULL;		
	}
    if(zone_select > mem_structure.zones_length)
    {
        serial_printf(SFYELLOW, SBBLACK, "alloc_pages() ERROR: zone_select index is invalid\n");
        return NULL;
    }

	for(i = zone_select; i <= zone_select; ++i)
	{
		struct zone * z;
		u64 j;
		u64 start,end;
		u64 tmp;

		if((mem_structure.zones_struct + i)->page_free_count < number)
		{
            continue;
        }
		z = mem_structure.zones_struct + i;
		start = z->zone_start_address >> PAGE_2M_SHIFT;
		end = z->zone_end_address >> PAGE_2M_SHIFT;

		tmp = 64 - start % 64;

		for(j = start; j < end; j += j % 64 ? tmp : 64)
		{
			u64 * p = mem_structure.bits_map + (j >> 6);
			u64 k = 0;
			u64 shift = j % 64;
			
			u64 num = (1UL << number) - 1;
			
			for(k = shift;k < 64;++k)
			{
				if( !( (k ? ((*p >> k) | (*(p + 1) << (64 - k))) : *p) & (num) ) )
				{
					u64	l;
					page = j + k - shift;
					for(l = 0;l < number;l++)
					{
						page_t * pageptr = mem_structure.pages_struct + page + l;

						*(mem_structure.bits_map + ((pageptr->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (pageptr->p_address >> PAGE_2M_SHIFT) % 64;
						z->page_using_count++;
						z->page_free_count--;
						pageptr->attribute = PAGE_PT_MAPED;
					}
					goto find_free_pages;
				}
			}
		}
	}

	serial_printf(SFYELLOW, SBBLACK, "alloc_pages() ERROR: no page can alloc\n");
	return NULL;

find_free_pages:

	return (page_t *)(mem_structure.pages_struct + page);
}


void mm_init(void)
{
    // clear
    memset((void *)&_bss, 0, (u64)&_end - (u64)&_bss);

    mem_structure.start_code = (u64)&_text;
    mem_structure.end_code = (u64)&_etext;
    mem_structure.start_data = (u64)&_data;
    mem_structure.end_data = (u64)&_edata;
    mem_structure.start_brk = (u64)&_end;
    mem_structure.end_rodata = (u64)&_erodata;

    s32 i, j;
    u64 total_mem = 0;
    efi_e820_t *p = NULL;
    p = (efi_e820_t *)boot_info->e820inf.e820_entry;

    // 解析从UEFI获取的内存数据，统计可用内存
    for (i = 0; i < boot_info->e820inf.count; ++i)
    {
        // 1 是可用的RAM
        if (p->type == 1)
        {
            total_mem += p->length;
        }
        // 大于5 Unusable
        else if (p->type > 4 || p->type < 1 || p->length == 0)
        {
            break;
        }
        mem_structure.e820[i].address = p->address;
        mem_structure.e820[i].length = p->length;
        mem_structure.e820[i].type = p->type;
        mem_structure.e820_length = i;
        p++;
    }

    // 不是2M对齐的内存部分全部舍弃掉 start 和 end 部分都有舍弃
    total_mem = 0;
	for(i = 0; i <= mem_structure.e820_length; i++)
	{
		u64 start,end;
		if(mem_structure.e820[i].type != 1)
		{
            continue;
        }
		start = PAGE_2M_ALIGN(mem_structure.e820[i].address);
		end   = ((mem_structure.e820[i].address + mem_structure.e820[i].length) >> PAGE_2M_SHIFT) << PAGE_2M_SHIFT;
        if(end <= start)
		{
            continue;
        }
		total_mem += (end - start) >> PAGE_2M_SHIFT;
	}
    serial_printf(SFGREEN, SBBLACK, "total effective 2MB pages:%#010x = %#010d\n", total_mem, total_mem);
    total_mem = mem_structure.e820[mem_structure.e820_length].address + mem_structure.e820[mem_structure.e820_length].length;
    // brk之后Bitsmap
    mem_structure.bits_map = (u64 *)PAGE_4K_ALIGN(mem_structure.start_brk);
    mem_structure.bits_size = total_mem >> PAGE_2M_SHIFT;
    mem_structure.bits_length = ((mem_structure.bits_size + sizeof(u64) - 1) / 8) & (~(sizeof(u64) - 1));
    memset(mem_structure.bits_map, 0xff, mem_structure.bits_length);
    mem_structure.pages_struct = (page_t*)PAGE_4K_ALIGN((u64)mem_structure.bits_map + mem_structure.bits_length);
    mem_structure.pages_size = mem_structure.bits_size;
    mem_structure.pages_length = (mem_structure.pages_size * sizeof(page_t) + sizeof(u64) - 1) & (~(sizeof(u64) - 1));
    memset(mem_structure.pages_struct, 0x00, mem_structure.pages_length);
    // 预留5个
    mem_structure.zones_struct = (zone_t *)PAGE_4K_ALIGN((u64)mem_structure.pages_struct + mem_structure.pages_length);
    mem_structure.zones_size = 0;
    mem_structure.zones_length = (5 * sizeof(zone_t) + sizeof(u64) - 1) & (~(sizeof(u64) - 1));
    memset(mem_structure.zones_struct, 0x00, mem_structure.zones_length);
    for (i = 0; i <= mem_structure.e820_length; ++i)
    {
        u64 start, end;
        page_t *page;
        zone_t *z;
        if (mem_structure.e820[i].type != 1)
        {
            continue;
        }
        start = PAGE_2M_ALIGN(mem_structure.e820[i].address);
        end = ((mem_structure.e820[i].address + mem_structure.e820[i].length) >> PAGE_2M_SHIFT) << PAGE_2M_SHIFT;
        if (end <= start)
        {
            continue;
        }
        z = mem_structure.zones_struct + mem_structure.zones_size;
        mem_structure.zones_size++;
        z->zone_start_address = start;
        z->zone_end_address = end;
        z->zone_length = end - start;
        z->page_using_count = 0;
        z->page_free_count = (end - start) >> PAGE_2M_SHIFT;
        z->total_pages_link = 0;
        z->attritube = 0;
        z->gmd_struct = &mem_structure;
        z->pages_length = (end - start) >> PAGE_2M_SHIFT;
        z->pages_group = (page_t *)(mem_structure.pages_struct + (start >> PAGE_2M_SHIFT));

        page = z->pages_group;
        for (j = 0; j < z->pages_length; ++j, page++)
        {
            page->zone_struct = z;
            page->p_address = start + PAGE_2M_SIZE * j;
            page->attribute = 0;
            page->age = 0;
            page->reference_count = 0;
            *(mem_structure.bits_map + ((page->p_address >> PAGE_2M_SHIFT) >> 6)) ^= 1UL << (page->p_address >> PAGE_2M_SHIFT) % 64;
        }
    }
    mem_structure.pages_struct->zone_struct = mem_structure.zones_struct;

    mem_structure.pages_struct->p_address = 0;
    set_page_attribute(mem_structure.pages_struct, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
    mem_structure.pages_struct->reference_count = 1;
    mem_structure.pages_struct->age = 0;
    mem_structure.zones_length = (mem_structure.zones_size * sizeof(zone_t) + sizeof(s64) - 1) & (~(sizeof(s64) - 1));
    serial_printf(SFCYAN, SBBLACK, "bits_map:%#018lx bits_size:%#018lx bits_length:%#018lx\n", *mem_structure.bits_map, mem_structure.bits_size, mem_structure.bits_length);
    serial_printf(SFCYAN, SBBLACK, "pages_struct:%#018lx pages_size:%#018lx pages_length:%#018lx\n", mem_structure.pages_struct, mem_structure.pages_size, mem_structure.pages_length);
    serial_printf(SFCYAN, SBBLACK, "zones_struct:%#018lx zones_size:%#018lx zones_length:%#018lx\n", mem_structure.zones_struct, mem_structure.zones_size, mem_structure.zones_length);

    s32 tmpc = 0, tmpd = 0;
    for (i = 0; i < mem_structure.zones_size; ++i)
    {
        zone_t *z = mem_structure.zones_struct + i;
        serial_printf(SFYELLOW, SBBLACK, \
            "zone_start_address:%#018lx zone_end_address:%#018lx \
            zone_length:%#018lx pages_group:%#018lx \
            pages_length:%#018lx pages_freecount:%#018lx\n", \
            z->zone_start_address, z->zone_end_address, \
            z->zone_length, z->pages_group, \
            z->pages_length, z->page_free_count);
    }
    mem_structure.end_of_struct = (u64)((u64)mem_structure.zones_struct + mem_structure.zones_length + sizeof(s64) * 32) & (~(sizeof(s64) - 1));
    serial_printf(SFCYAN, SBBLACK, \
        "start_code:%#018lx end_code:%#018lx \
        start_data:%#018lx end_data:%#018lx \
        start_brk:%#018lx end_of_struct:%#018lx\n", \
        mem_structure.start_code, mem_structure.end_code, \
        mem_structure.start_data, mem_structure.end_data, \
        mem_structure.start_brk, mem_structure.end_of_struct);
    i = V_TO_P(mem_structure.end_of_struct) >> PAGE_2M_SHIFT;
    for (j = 0; j <= i; ++j)
    {
        page_t* tmp_page = mem_structure.pages_struct + j;
        page_init(tmp_page, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
        *(mem_structure.bits_map + ((tmp_page->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (tmp_page->p_address >> PAGE_2M_SHIFT) % 64;
        tmp_page->zone_struct->page_using_count++;
        tmp_page->zone_struct->page_free_count--;

    }
    cr3 = get_gdt();
    serial_printf(SFCYAN, SBBLACK, "cr3:%#018lx\n", cr3);
    serial_printf(SFCYAN, SBBLACK, "*cr3:%#018lx\n", *(u64 *)P_TO_V(cr3) & (~0xff));
    serial_printf(SFCYAN, SBBLACK, "**cr3:%#018lx\n", *(u64 *)P_TO_V(*(u64 *)P_TO_V(cr3) & (~0xff)) & (~0xff));
    serial_printf(SFCYAN, SBBLACK, "1.bits_map:%#018lx\tzone_struct->page_using:%d\tzone_struct->page_free:%d\n", *mem_structure.bits_map, mem_structure.zones_struct->page_using_count, mem_structure.zones_struct->page_free_count);
    flush_cr3();
    return;
}