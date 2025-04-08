#include <mm/memory.h>
#include <uefi.h>
#include <lib/asm.h>
#include <driver/serial.h>
#include <mm/kmem.h>
#include <driver/vbe.h>

mm_des_t mem_des = {{0}, 0};

u64* cr3;

extern u64 _text, _etext;
extern u64 _data, _edata;
extern u64 _rodata, _erodata;
extern u64 _bss, _ebss;
extern u64 _end;

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

u64 get_page_attribute(page_t* page)
{
    if(page == NULL)
    {
        serial_printf(SFGREEN, SBBLACK, "get_page_attribute() ERROR:page == NULL\n");
        return SFAIL;
    }
    return (page->attribute);
}

u64 page_clean(page_t * page)
{
    page->reference_count--;
    page->zone_struct->total_pages_link--;
    if(!page->reference_count)
    {
        page->attribute &= PAGE_PT_MAPED;
    }
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
    if(zone_select > mem_des.zones_length)
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

		if((mem_des.zones_struct + i)->page_free_count < number)
		{
            continue;
        }
		z = mem_des.zones_struct + i;
		start = z->zone_start_address >> PAGE_2M_SHIFT;
		end = z->zone_end_address >> PAGE_2M_SHIFT;

		tmp = 64 - start % 64;

		for(j = start; j < end; j += j % 64 ? tmp : 64)
		{
			u64 * p = mem_des.bits_map + (j >> 6);
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
						page_t * pageptr = mem_des.pages_struct + page + l;

						*(mem_des.bits_map + ((pageptr->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (pageptr->p_address >> PAGE_2M_SHIFT) % 64;
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

	return (page_t *)(mem_des.pages_struct + page);
}

void free_pages(page_t* page, s32 number)
{
    s32 i = 0;
    if(page == NULL)
    {
        serial_printf(SFRED, SBBLACK, "free_pages()ERROR:page is invalid\n");
        return;
    }
    if(number >= 64 || number <= 0)
    {
        serial_printf(SFRED, SBBLACK, "free_pages()ERROR:number is invalid\n");
        return;
    }
    for(i = 0; i < number; ++i, page++)
    {
        *(mem_des.bits_map +((page->p_address >> PAGE_2M_SHIFT) >> 6)) &= ~(1UL << (page->p_address >> PAGE_2M_SHIFT) % 64);
        page->zone_struct->page_using_count--;
        page->zone_struct->page_free_count++;
        page->attribute = 0;
    }
    return;
}

void mm_init(void)
{
    mem_des.start_code = (u64)&_text;
    mem_des.end_code = (u64)&_etext;
    mem_des.start_data = (u64)&_data;
    mem_des.end_data = (u64)&_edata;
    mem_des.start_brk = (u64)&_end;
    mem_des.end_rodata = (u64)&_erodata;

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
        mem_des.e820[i].address = p->address;
        mem_des.e820[i].length = p->length;
        mem_des.e820[i].type = p->type;
        mem_des.e820_length = i;
        p++;
    }
    // 不是2M对齐的内存部分全部舍弃掉 start 和 end 部分都有舍弃
    total_mem = 0;
	for(i = 0; i <= mem_des.e820_length; i++)
	{
		u64 start,end;
		if(mem_des.e820[i].type != 1)
		{
            continue;
        }
		start = PAGE_2M_ALIGN(mem_des.e820[i].address);
		end   = ((mem_des.e820[i].address + mem_des.e820[i].length) >> PAGE_2M_SHIFT) << PAGE_2M_SHIFT;
        if(end <= start)
		{
            continue;
        }
		total_mem += (end - start) >> PAGE_2M_SHIFT;
	}
    serial_printf(SFGREEN, SBBLACK, "total effective 2MB pages:%#010x = %#010d\n", total_mem, total_mem);
    total_mem = mem_des.e820[mem_des.e820_length].address + mem_des.e820[mem_des.e820_length].length;
    // brk之后Bitsmap
    mem_des.bits_map = (u64 *)PAGE_4K_ALIGN(mem_des.start_brk);
    mem_des.bits_size = total_mem >> PAGE_2M_SHIFT;
    mem_des.bits_length = ((mem_des.bits_size + sizeof(u64) - 1) / 8) & (~(sizeof(u64) - 1));
    memset(mem_des.bits_map, 0xff, mem_des.bits_length);
    mem_des.pages_struct = (page_t*)PAGE_4K_ALIGN((u64)mem_des.bits_map + mem_des.bits_length);
    mem_des.pages_size = mem_des.bits_size;
    mem_des.pages_length = (mem_des.pages_size * sizeof(page_t) + sizeof(u64) - 1) & (~(sizeof(u64) - 1));
    memset(mem_des.pages_struct, 0x00, mem_des.pages_length);
    // 预留5个
    mem_des.zones_struct = (zone_t *)PAGE_4K_ALIGN((u64)mem_des.pages_struct + mem_des.pages_length);
    mem_des.zones_size = 0;
    mem_des.zones_length = (5 * sizeof(zone_t) + sizeof(u64) - 1) & (~(sizeof(u64) - 1));
    memset(mem_des.zones_struct, 0x00, mem_des.zones_length);
    for (i = 0; i <= mem_des.e820_length; ++i)
    {
        u64 start, end;
        page_t *page;
        zone_t *z;
        if (mem_des.e820[i].type != 1)
        {
            continue;
        }
        start = PAGE_2M_ALIGN(mem_des.e820[i].address);
        end = ((mem_des.e820[i].address + mem_des.e820[i].length) >> PAGE_2M_SHIFT) << PAGE_2M_SHIFT;
        if (end <= start)
        {
            continue;
        }
        z = mem_des.zones_struct + mem_des.zones_size;
        mem_des.zones_size++;
        z->zone_start_address = start;
        z->zone_end_address = end;
        z->zone_length = end - start;
        z->page_using_count = 0;
        z->page_free_count = (end - start) >> PAGE_2M_SHIFT;
        z->total_pages_link = 0;
        z->attritube = 0;
        z->gmd_struct = &mem_des;
        z->pages_length = (end - start) >> PAGE_2M_SHIFT;
        z->pages_group = (page_t *)(mem_des.pages_struct + (start >> PAGE_2M_SHIFT));

        page = z->pages_group;
        for (j = 0; j < z->pages_length; ++j, page++)
        {
            page->zone_struct = z;
            page->p_address = start + PAGE_2M_SIZE * j;
            page->attribute = 0;
            page->age = 0;
            page->reference_count = 0;
            *(mem_des.bits_map + ((page->p_address >> PAGE_2M_SHIFT) >> 6)) ^= 1UL << (page->p_address >> PAGE_2M_SHIFT) % 64;
        }
    }
    // 第一个 2M 页面
    mem_des.pages_struct->zone_struct = mem_des.zones_struct;
    mem_des.pages_struct->p_address = 0;
    set_page_attribute(mem_des.pages_struct, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
    mem_des.pages_struct->reference_count = 1;
    mem_des.pages_struct->age = 0;
    mem_des.zones_length = (mem_des.zones_size * sizeof(zone_t) + sizeof(s64) - 1) & (~(sizeof(s64) - 1));
    serial_printf(SFCYAN, SBBLACK, "bits_map:%#018lx bits_size:%#018lx bits_length:%#018lx\n", *mem_des.bits_map, mem_des.bits_size, mem_des.bits_length);
    serial_printf(SFCYAN, SBBLACK, "pages_struct:%#018lx pages_size:%#018lx pages_length:%#018lx\n", mem_des.pages_struct, mem_des.pages_size, mem_des.pages_length);
    serial_printf(SFCYAN, SBBLACK, "zones_struct:%#018lx zones_size:%#018lx zones_length:%#018lx\n", mem_des.zones_struct, mem_des.zones_size, mem_des.zones_length);

    s32 tmpc = 0, tmpd = 0;
    for (i = 0; i < mem_des.zones_size; ++i)
    {
        zone_t *z = mem_des.zones_struct + i;
        serial_printf(SFYELLOW, SBBLACK, \
            "zone_start_address:%#018lx zone_end_address:%#018lx \
            zone_length:%#018lx pages_group:%#018lx \
            pages_length:%#018lx pages_freecount:%#018lx\n", \
            z->zone_start_address, z->zone_end_address, \
            z->zone_length, z->pages_group, \
            z->pages_length, z->page_free_count);
    }
    mem_des.end_of_struct = (u64)((u64)mem_des.zones_struct + mem_des.zones_length + sizeof(s64) * 32) & (~(sizeof(s64) - 1));
    serial_printf(SFCYAN, SBBLACK, \
        "start_code:%#018lx end_code:%#018lx \
        start_data:%#018lx end_data:%#018lx \
        start_brk:%#018lx end_of_struct:%#018lx\n", \
        mem_des.start_code, mem_des.end_code, \
        mem_des.start_data, mem_des.end_data, \
        mem_des.start_brk, mem_des.end_of_struct);
    i = V_TO_P(mem_des.end_of_struct) >> PAGE_2M_SHIFT;
    for (j = 0; j <= i; ++j)
    {
        page_t* tmp_page = mem_des.pages_struct + j;
        page_init(tmp_page, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
        *(mem_des.bits_map + ((tmp_page->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (tmp_page->p_address >> PAGE_2M_SHIFT) % 64;
        tmp_page->zone_struct->page_using_count++;
        tmp_page->zone_struct->page_free_count--;

    }
    cr3 = get_gdt();
    serial_printf(SFCYAN, SBBLACK, "cr3:%#018lx\n", cr3);
    serial_printf(SFCYAN, SBBLACK, "*cr3:%#018lx\n", *(u64 *)P_TO_V(cr3) & (~0xff));
    serial_printf(SFCYAN, SBBLACK, "**cr3:%#018lx\n", *(u64 *)P_TO_V(*(u64 *)P_TO_V(cr3) & (~0xff)) & (~0xff));
    serial_printf(SFCYAN, SBBLACK, "1.bits_map:%#018lx\tzone_struct->page_using:%d\tzone_struct->page_free:%d\n", *mem_des.bits_map, mem_des.zones_struct->page_using_count, mem_des.zones_struct->page_free_count);
    flush_cr3();
    return;
}

void pagetable_init()
{
    u64 i = 0;
    u64 j = 0;
    u64* tmp = NULL;
    u64* virtual;
    cr3 = get_gdt();
    tmp = (u64*)(((u64)P_TO_V((u64)cr3 & (~0xfffUL))) + 8 * 256);
    serial_printf(SFYELLOW, SBBLACK, "1:%#018lx\t%#018lx\n", (u64)tmp, *tmp);
    tmp = (u64*)P_TO_V(*tmp & (~0xfffUL));
    serial_printf(SFYELLOW, SBBLACK, "2:%#018lx\t%#018lx\n", (u64)tmp, *tmp);
    tmp = (u64*)P_TO_V(*tmp & (~0xfffUL));
    serial_printf(SFYELLOW, SBBLACK, "3:%#018lx\t%#018lx\n", (u64)tmp, *tmp);
    for(i = 0; i < mem_des.zones_size; ++i)
    {
        zone_t* z = mem_des.zones_struct + i;
        page_t* page = z->pages_group;
        for(j = 0; j < z->pages_length; ++j, ++page)
        {
            tmp = (u64*)(((u64)P_TO_V((u64)cr3 & (~0xfffUL))) + (((u64)P_TO_V(page->p_address) >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
            if(*tmp == 0)
            {
                virtual = (u64*)kmalloc(PAGE_4K_SIZE, 0);
                memset(virtual, 0, PAGE_4K_SIZE);
                set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_ATTR_KERNEL_GDT));
            }
            tmp = (u64*)(((u64)P_TO_V((u64)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((u64)P_TO_V(page->p_address) >> PAGE_1G_SHIFT) & 0x1ff) * 8);
            if(*tmp == 0)
            {
                virtual = (u64*)kmalloc(PAGE_4K_SIZE, 0);
                memset(virtual, 0, PAGE_4K_SIZE);
                set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_ATTR_KERNEL_DIR));
            }
            tmp = (u64*)(((u64)P_TO_V((u64)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((u64)P_TO_V(page->p_address) >> PAGE_2M_SHIFT) & 0x1ff) * 8);
            set_pdt(tmp, make_pdt(page->p_address, PAGE_ATTR_KERNEL_PAGE));
        }
    }
    flush_cr3();
    return;
}

u64 buffer_remap(u64 phaddr, u64 length)
{
	u64 i = 0;
	u64 *tmp = NULL;
	u64 *tmp1 = NULL;
	u64 *virtual = NULL;
	u64 phy = 0;
	u32 *tmp_addr = (u32 *)P_TO_V(phaddr & PAGE_2M_MASK);

	cr3 = get_gdt();
	tmp = (u64 *)(((u64)P_TO_V((u64)cr3 & (~0xfffUL))) + (((u64)tmp_addr >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
	if (*tmp == 0)
	{
		virtual = (u64 *)kmalloc(PAGE_4K_SIZE, 0);
		memset(virtual, 0, PAGE_4K_SIZE);
		set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_ATTR_KERNEL_GDT | PAGE_ATTR_USER_GDT));
	}
	tmp = (u64 *)(((u64)P_TO_V((u64)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((u64)tmp_addr >> PAGE_1G_SHIFT) & 0x1ff) * 8);
	if (*tmp == 0)
	{
		virtual = (u64 *)kmalloc(PAGE_4K_SIZE, 0);
		memset(virtual, 0, PAGE_4K_SIZE);
		set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_ATTR_KERNEL_DIR | PAGE_ATTR_USER_DIR));
	}
	for (i = 0; i < length; i = i + PAGE_2M_SIZE)
	{
		tmp1 = (u64 *)(((u64)P_TO_V((u64)(*tmp & (~0xfffUL)) & (~0xfffUL))) + ((((u64)tmp_addr + i) >> PAGE_2M_SHIFT) & 0x1ff) * 8);
		phy = phaddr + i;
		set_pdt(tmp1, make_pdt(phy & PAGE_2M_MASK, PAGE_ATTR_KERNEL_PAGE | PAGE_ATTR_PWT | PAGE_ATTR_PCD | PAGE_ATTR_USER_PAGE));
	}
	flush_cr3();
	return (u64)P_TO_V(phaddr);
}