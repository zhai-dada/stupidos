#include <uefi.h>
#include <memory.h>
#include <printk.h>
#include <errno.h>
#include <task.h>

struct kmem_cache kmalloc_cache_size[16] = 
{
    {32, 0, 0, NULL, NULL, NULL},
    {64, 0, 0, NULL, NULL, NULL},
    {128, 0, 0, NULL, NULL, NULL},
    {256, 0, 0, NULL, NULL, NULL},
    {512, 0, 0, NULL, NULL, NULL},
    {1024, 0, 0, NULL, NULL, NULL},
    {2048, 0, 0, NULL, NULL, NULL},
    {4096, 0, 0, NULL, NULL, NULL},
    {8192, 0, 0, NULL, NULL, NULL},
    {16384, 0, 0, NULL, NULL, NULL},
    {32768, 0, 0, NULL, NULL, NULL},
    {65536, 0, 0, NULL, NULL, NULL},
    {131072, 0, 0, NULL, NULL, NULL},
    {262144, 0, 0, NULL, NULL, NULL},
    {524288, 0, 0, NULL, NULL, NULL},
    {1048576, 0, 0, NULL, NULL, NULL}
};
int32_t ZONE_DMA_INDEX = 0;
int32_t ZONE_NORMAL_INDEX = 0;
int32_t ZONE_UNMAPED_INDEX = 0;
uint64_t* cr3 = NULL;


uint64_t page_init(struct page *page, uint64_t flags)
{
    page->attribute |= flags;
    if(!page->reference_count || (page->attribute & PAGE_SHARED))
    {
        page->reference_count++;
        page->zone_struct->total_pages_link++;
    }
    return 1;
}
void init_memory(void)
{
    int32_t i, j;
    uint64_t total_mem = 0;
    struct EFI_E820_MEMORY_DESCRIPTOR *p = NULL;
    p = (struct EFI_E820_MEMORY_DESCRIPTOR *)boot_info->e820inf.e820_entry;
    for (i = 0; i < boot_info->e820inf.entrycount; ++i)
    {
        if (p->type == 1)
        {
            total_mem += p->length;
        }
        else if (p->type > 4 || p->length == 0 || p->type < 1)
        {
            break;
        }
        mem_structure.e820[i].address = p->address;
        mem_structure.e820[i].length = p->length;
        mem_structure.e820[i].type = p->type;
        mem_structure.e820_length = i;
        p++;
    }
    color_printk(ORANGE, BLACK, "OS Can Used Totol RAM = %#018x\n", total_mem);
    total_mem = 0;
	for(i = 0;i <= mem_structure.e820_length;i++)
	{
		uint64_t start,end;
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
    color_printk(ORANGE, BLACK, "Total effective 2MB Pages:%#010x = %#010d\n", total_mem, total_mem);
    total_mem = mem_structure.e820[mem_structure.e820_length].address + mem_structure.e820[mem_structure.e820_length].length;
    mem_structure.bits_map = (uint64_t *)PAGE_4K_ALIGN(mem_structure.start_brk);
    mem_structure.bits_size = total_mem >> PAGE_2M_SHIFT;
    mem_structure.bits_length = ((mem_structure.bits_size + sizeof(uint64_t) - 1) / 8) & (~(sizeof(uint64_t) - 1));
    memset(mem_structure.bits_map, 0xff, mem_structure.bits_length);
    mem_structure.pages_struct = (struct page *)PAGE_4K_ALIGN((uint64_t)mem_structure.bits_map + mem_structure.bits_length);
    mem_structure.pages_size = mem_structure.bits_size;
    mem_structure.pages_length = (mem_structure.pages_size * sizeof(struct page) + sizeof(int64_t) - 1) & (~(sizeof(int64_t) - 1));
    memset(mem_structure.pages_struct, 0x00, mem_structure.pages_length);
    mem_structure.zones_struct = (struct zone *)PAGE_4K_ALIGN((uint64_t)mem_structure.pages_struct + mem_structure.pages_length);
    mem_structure.zones_size = 0;
    mem_structure.zones_length = (5 * sizeof(struct zone) + sizeof(int64_t) - 1) & (~(sizeof(int64_t) - 1));
    memset(mem_structure.zones_struct, 0x00, mem_structure.zones_length);
    for (i = 0; i <= mem_structure.e820_length; ++i)
    {
        uint64_t start, end;
        struct page *p;
        struct zone *z;
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
        z->pages_group = (struct page *)(mem_structure.pages_struct + (start >> PAGE_2M_SHIFT));
        p = z->pages_group;
        for (j = 0; j < z->pages_length; ++j, p++)
        {
            p->zone_struct = z;
            p->p_address = start + PAGE_2M_SIZE * j;
            p->attribute = 0;
            p->age = 0;
            p->reference_count = 0;
            *(mem_structure.bits_map + ((p->p_address >> PAGE_2M_SHIFT) >> 6)) ^= 1UL << (p->p_address >> PAGE_2M_SHIFT) % 64;
        }
    }
    mem_structure.pages_struct->zone_struct = mem_structure.zones_struct;
    mem_structure.pages_struct->p_address = 0;
    set_page_attribute(mem_structure.pages_struct, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
    mem_structure.pages_struct->reference_count = 1;
    mem_structure.pages_struct->age = 0;

    mem_structure.zones_length = (mem_structure.zones_size * sizeof(struct zone) + sizeof(int64_t) - 1) & (~(sizeof(int64_t) - 1));
    color_printk(ORANGE, BLACK, "bits_map:%#018lx bits_size:%#018lx bits_length:%#018lx\n", *mem_structure.bits_map, mem_structure.bits_size, mem_structure.bits_length);
    color_printk(ORANGE, BLACK, "pages_struct:%#018lx pages_size:%#018lx pages_length:%#018lx\n", mem_structure.pages_struct, mem_structure.pages_size, mem_structure.pages_length);
    color_printk(ORANGE, BLACK, "zones_struct:%#018lx zones_size:%#018lx zones_length:%#018lx\n", mem_structure.zones_struct, mem_structure.zones_size, mem_structure.zones_length);
    ZONE_DMA_INDEX = 0;
    ZONE_NORMAL_INDEX = 1;
    ZONE_UNMAPED_INDEX = 0;
    // int32_t tmpc = 0, tmpd = 0;
    for (i = 0; i < mem_structure.zones_size; ++i)
    {
        struct zone *z = mem_structure.zones_struct + i;
        // tmpc = z->page_free_count;
        // if(tmpc > tmpd)
        // {
        //     tmpd = tmpc;
        //     ZONE_NORMAL_INDEX = i;
        // }
        color_printk(ORANGE, BLACK, "zone_start_address:%#018lx zone_end_address:%#018lx zone_length:%#018lx pages_group:%#018lx pages_length:%#018lx pages_freecount:%#018lx\n", z->zone_start_address, z->zone_end_address, z->zone_length, z->pages_group, z->pages_length, z->page_free_count);
        if (z->zone_start_address >= 0x100000000 && !ZONE_UNMAPED_INDEX)
        {
            ZONE_UNMAPED_INDEX = i;
        }
    }
	color_printk(ORANGE, BLACK, "ZONE_DMA_INDEX:%d\tZONE_NORMAL_INDEX:%d\tZONE_UNMAPED_INDEX:%d\n", ZONE_DMA_INDEX, ZONE_NORMAL_INDEX, ZONE_UNMAPED_INDEX);
    mem_structure.end_of_struct = (uint64_t)((uint64_t)mem_structure.zones_struct + mem_structure.zones_length + sizeof(int64_t) * 32) & (~(sizeof(int64_t) - 1));
    color_printk(ORANGE, BLACK, "start_code:%#018lx end_code:%#018lx start_data:%#018lx end_data:%#018lx start_brk:%#018lx end_of_struct:%#018lx\n", mem_structure.start_code, mem_structure.end_code, mem_structure.start_data, mem_structure.end_data, mem_structure.start_brk, mem_structure.end_of_struct);
    i = V_TO_P(mem_structure.end_of_struct) >> PAGE_2M_SHIFT;
    for (j = 1; j <= i; ++j)
    {
        struct page* tmp_page = mem_structure.pages_struct + j;
        page_init(tmp_page, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
        *(mem_structure.bits_map + ((tmp_page->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (tmp_page->p_address >> PAGE_2M_SHIFT) % 64;
        tmp_page->zone_struct->page_using_count++;
        tmp_page->zone_struct->page_free_count--;

    }
    cr3 = get_gdt();
    color_printk(INDIGO, BLACK, "cr3:%#018lx\n", cr3);
    color_printk(INDIGO, BLACK, "*cr3:%#018lx\n", *(uint64_t *)P_TO_V(cr3) & (~0xff));
    color_printk(INDIGO, BLACK, "**cr3:%#018lx\n", *(uint64_t *)P_TO_V(*(uint64_t *)P_TO_V(cr3) & (~0xff)) & (~0xff));
    color_printk(ORANGE, BLACK, "1.bits_map:%#018lx\tzone_struct->page_using:%d\tzone_struct->page_free:%d\n", *mem_structure.bits_map, mem_structure.zones_struct->page_using_count, mem_structure.zones_struct->page_free_count);
    flush_tlb();
    return;
}
uint64_t *get_gdt(void)
{
    uint64_t *tmp;
    asm volatile
    (
        "movq %%cr3, %0     \n"
        : "=r"(tmp)
        :
        : "memory"
    );
    return tmp;
}
struct page * alloc_pages(int32_t zone_select,int32_t number,uint64_t page_flags)
{
	int32_t i;
	uint64_t page = 0;
	uint64_t attribute = 0;

	int32_t zone_start = 0;
	int32_t zone_end = 0;
	
	if(number >= 64 || number <= 0)
	{
		color_printk(RED,BLACK,"alloc_pages() ERROR: number is invalid\n");
		return NULL;		
	}

	switch(zone_select)
	{
		case ZONE_DMA:
				zone_start = 0;
				zone_end = ZONE_DMA_INDEX;
				attribute = PAGE_PT_MAPED;
			break;

		case ZONE_NORMAL:
				zone_start = ZONE_DMA_INDEX;
				zone_end = ZONE_NORMAL_INDEX;
				attribute = PAGE_PT_MAPED;
			break;

		case ZONE_UNMAPED:
				zone_start = ZONE_UNMAPED_INDEX;
				zone_end = mem_structure.zones_size - 1;
				attribute = 0;
			break;

		default:
			color_printk(RED,BLACK,"alloc_pages() ERROR: zone_select index is invalid\n");
			return NULL;
			break;
	}

	for(i = zone_start; i <= zone_end; ++i)
	{
		struct zone * z;
		uint64_t j;
		uint64_t start,end;
		uint64_t tmp;

		if((mem_structure.zones_struct + i)->page_free_count < number)
		{
            continue;
        }
		z = mem_structure.zones_struct + i;
		start = z->zone_start_address >> PAGE_2M_SHIFT;
		end = z->zone_end_address >> PAGE_2M_SHIFT;

		tmp = 64 - start % 64;

		for(j = start;j < end;j += j % 64 ? tmp : 64)
		{
			uint64_t * p = mem_structure.bits_map + (j >> 6);
			uint64_t k = 0;
			uint64_t shift = j % 64;
			
			uint64_t num = (1UL << number) - 1;
			
			for(k = shift;k < 64;++k)
			{
				if( !( (k ? ((*p >> k) | (*(p + 1) << (64 - k))) : *p) & (num) ) )
				{
					uint64_t	l;
					page = j + k - shift;
					for(l = 0;l < number;l++)
					{
						struct page * pageptr = mem_structure.pages_struct + page + l;

						*(mem_structure.bits_map + ((pageptr->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (pageptr->p_address >> PAGE_2M_SHIFT) % 64;
						z->page_using_count++;
						z->page_free_count--;
						pageptr->attribute = attribute;
					}
					goto find_free_pages;
				}
			}
		}
	}

	color_printk(RED,BLACK,"alloc_pages() ERROR: no page can alloc\n");
	return NULL;

find_free_pages:

	return (struct page *)(mem_structure.pages_struct + page);
}

struct kmem* kmalloc_create(uint64_t size)
{
    int32_t i = 0;
    struct kmem* kmem = NULL;
    struct page* page = NULL;
    uint64_t* vaddress = NULL;
    int64_t structsize = 0;
    page = alloc_pages(ZONE_NORMAL, 1, 0);
    if(page == NULL)
    {
        color_printk(RED, BLACK, "kmalloc_create()->page_alloc() ERROR page = NULL\n");
        return NULL;
    }
    page_init(page, PAGE_KERNEL);
    switch(size)
    {
        case 32:
        case 64:
        case 128:
        case 256:
        case 512:
            vaddress = (uint64_t*)P_TO_V(page->p_address);
            structsize = sizeof(struct kmem) + PAGE_2M_SIZE / size / 8;
            kmem = (struct kmem*)((uint8_t*)vaddress + PAGE_2M_SIZE - structsize);
            kmem->color_map = (uint64_t*)((uint8_t*)kmem + sizeof(struct kmem));
            kmem->free_count = (PAGE_2M_SIZE - (PAGE_2M_SIZE / size / 8) - sizeof(struct kmem)) / size;
            kmem->using_count = 0;
            kmem->color_count = kmem->free_count;
            kmem->vaddress = vaddress;
            kmem->page = page;
            list_init(&kmem->list);
            kmem->color_length = ((kmem->color_count + sizeof(uint64_t) * 8 - 1) >> 6) << 3;
            memset(kmem->color_map, 0xff, kmem->color_length);
            for(i = 0; i < kmem->color_count; ++i)
            {
                *(kmem->color_map + (i >> 6)) ^= 1UL << i % 64;
            }
            break;
        case 1024: //1KB
        case 2048:
        case 4096: //4KB
        case 8192:
        case 16384:
        case 32768:
        case 65536:
        case 131072:
        case 262144:
        case 524288:
        case 1048576:
            kmem = (struct kmem*)kmalloc(sizeof(struct kmem), 0);
            kmem->free_count = PAGE_2M_SIZE / size;
            kmem->using_count = 0;
            kmem->color_count = kmem->free_count;
            kmem->color_length = ((kmem->color_count + sizeof(uint64_t) * 8 - 1) >> 6) << 3;
            kmem->color_map = (uint64_t*)kmalloc(kmem->color_length, 0);
            memset(kmem->color_map, 0xff, kmem->color_length);
            kmem->vaddress = (uint64_t*)P_TO_V(page->p_address);
            kmem->page = page;
            list_init(&kmem->list);
            for(i = 0; i < kmem->color_count; ++i)
            {
                *(kmem->color_map + (i >> 6)) ^= 1UL << i % 64;
            }
            break;
        default:
            color_printk(RED, BLACK, "kmalloc_create() ERROR:wrong size%08d\n", size);
            free_pages(page, 1);
            return NULL;
    }
    return kmem;
}
void* kmalloc(uint64_t size, uint64_t flags)
{
    int32_t i = 0;
    int32_t j = 0;
    struct kmem* kmem = NULL;
    //1048576 = 1MB
    if(size > 1048576)
    {
        color_printk(RED, BLACK, "kmalloc() ERROR:kmalloc size too int64_t:%08d\n", size);
        return NULL;
    }
    for(i = 0; i < 16; i++)
    {
        if(kmalloc_cache_size[i].size >= size)
        {
            break;
        }
    }
    kmem = kmalloc_cache_size[i].cache_pool;
    if(kmalloc_cache_size[i].total_free != 0)
    {
        do
        {
            if(kmem->free_count == 0)
            {
                kmem = container_of(list_next(&kmem->list), struct kmem, list);
            }
            else
            {
                break;
            }
        }while(kmem != kmalloc_cache_size[i].cache_pool);
    }
    else
    {
        kmem = kmalloc_create(kmalloc_cache_size[i].size);
        if(kmem == NULL)
        {
            color_printk(RED, BLACK, "kmalloc()->kmalloc_create()->kmem == NULL\n");
            return NULL;
        }
        kmalloc_cache_size[i].total_free += kmem->color_count;
        color_printk(BLUE, BLACK, "kmalloc()->kmalloc_create() <= size:%#010x\n", kmalloc_cache_size[i].size);
        list_add_before(&kmalloc_cache_size[i].cache_pool->list, &kmem->list);
    }
    for(j = 0; j < kmem->color_count; ++j)
    {
        if(*(kmem->color_map + (j >> 6)) == 0xffffffffffffffffUL)
        {
            j += 63;
            continue;
        }
        if((*(kmem->color_map + (j >> 6)) & (1UL << (j % 64))) == 0)
        {
            *(kmem->color_map + (j >> 6)) |= 1UL << (j % 64);
            kmem->using_count++;
            kmem->free_count--;
            kmalloc_cache_size[i].total_using++;
            kmalloc_cache_size[i].total_free--;
            return (void *)((char*)kmem->vaddress + kmalloc_cache_size[i].size * j);
        }
    }
    color_printk(RED, BLACK, "kmalloc() ERROR: no memory call alloc\n");
    return NULL;
}
struct kmem_cache* kmem_create(uint64_t size, void* (*construct)(void* vaddress, uint64_t arg), void* (*destruct)(void* vaddress, uint64_t arg), uint64_t arg)
{
    struct kmem_cache* kmem_cache = NULL;
    kmem_cache = (struct kmem_cache*)kmalloc(sizeof(struct kmem_cache), 0);
    if(kmem_cache == NULL)
    {
        color_printk(RED, BLACK, "kmem_create()->kmem_cache = NULL\n");
        return NULL;
    }
    memset(kmem_cache, 0, sizeof(struct kmem_cache));
    kmem_cache->size = SIZEOF_LONG_ALIGN(size);
    kmem_cache->total_using = 0;
    kmem_cache->total_free = 0;
    kmem_cache->cache_pool = (struct kmem*)kmalloc(sizeof(struct kmem), 0);
    if(kmem_cache->cache_pool == NULL)
    {
        color_printk(RED, BLACK, "kmem_cache()->kmalloc(kmem_cache->cache_pool) ERROR == NULL\n");
        kfree(kmem_cache);
        return NULL;
    }
    memset(kmem_cache->cache_pool, 0, sizeof(struct kmem));
    kmem_cache->construct = construct;
    kmem_cache->destruct = destruct;
    list_init(&kmem_cache->cache_pool->list);
    kmem_cache->cache_pool->page = alloc_pages(ZONE_NORMAL, 1, 0);
    if(kmem_cache->cache_pool->page == NULL)
    {
        color_printk(RED, BLACK, "kmem_cache()->alloc_pages() page == NULL\n");
        kfree(kmem_cache->cache_pool);
        kfree(kmem_cache);
        return NULL;
    }
    page_init(kmem_cache->cache_pool->page, PAGE_KERNEL);
    kmem_cache->cache_pool->using_count = 0;
    kmem_cache->cache_pool->free_count = PAGE_2M_SIZE / kmem_cache->size;
    kmem_cache->total_free = kmem_cache->cache_pool->free_count;
    kmem_cache->cache_pool->vaddress = (uint64_t*)P_TO_V(kmem_cache->cache_pool->page->p_address);
    kmem_cache->cache_pool->color_count = kmem_cache->cache_pool->free_count;
    kmem_cache->cache_pool->color_length = ((kmem_cache->cache_pool->color_count + sizeof(uint64_t) * 8 - 1) >> 6) << 3;
    kmem_cache->cache_pool->color_map = (uint64_t*)kmalloc(kmem_cache->cache_pool->color_length, 0);
    if(kmem_cache->cache_pool->color_map == NULL)
    {
        color_printk(RED, BLACK, "kmem_create()->color_map == NULL\n");
        free_pages(kmem_cache->cache_pool->page, 1);
        kfree(kmem_cache->cache_pool);
        kfree(kmem_cache);
        return NULL;
    }
    memset(kmem_cache->cache_pool->color_map, 0, kmem_cache->cache_pool->color_length);
    return kmem_cache;
}
uint64_t kmem_destroy(struct kmem_cache* kmem_cache)
{
    struct kmem* kmem_pool = kmem_cache->cache_pool;
    struct kmem* kmem_tmp = NULL;
    if(kmem_cache->total_using != 0)
    {
        color_printk(RED, BLACK, "kmem_cache->total_using != 0\n");
        return 0;
    }
    while(!list_is_empty(&kmem_pool->list))
    {
        kmem_tmp = kmem_pool;
        kmem_pool = (struct kmem*)container_of(list_next(&kmem_pool->list), struct kmem, list);
        list_delete(&kmem_tmp->list);
        kfree(kmem_tmp->color_map);
        page_clean(kmem_tmp->page);
        free_pages(kmem_tmp->page, 1);
        kfree(kmem_tmp);
    }
    kfree(kmem_pool->color_map);
    page_clean(kmem_pool->page);
    free_pages(kmem_pool->page, 1);
    kfree(kmem_pool);
    return 1;
}
void* kmem_malloc(struct kmem_cache* kmem_cache, uint64_t arg)
{
    struct kmem* kmem_pool = kmem_cache->cache_pool;
    struct kmem* kmem_tmp = NULL;
    int32_t j = 0;
    if(kmem_cache->total_free == 0)
    {
        kmem_tmp = (struct kmem*)kmalloc(sizeof(struct kmem), 0);
        if(kmem_tmp == NULL)
        {
            color_printk(RED, BLACK, "kmem_malloc()->kmalloc kmem_tmp == NULL\n");
            return NULL;
        }
        memset(kmem_tmp, 0, sizeof(struct kmem));
        list_init(&kmem_tmp->list);
        kmem_tmp->page = alloc_pages(ZONE_NORMAL, 1, 0);
        if(kmem_tmp->page == NULL)
        {
            color_printk(RED, BLACK, "kmem_malloc()->alloc_page == NULL\n");
            kfree(kmem_tmp);
            return NULL;
        }
        page_init(kmem_tmp->page, PAGE_KERNEL);
        kmem_tmp->using_count = 0;
        kmem_tmp->free_count = PAGE_2M_SIZE / kmem_cache->size;
        kmem_tmp->vaddress = (uint64_t*)P_TO_V(kmem_tmp->page->p_address);
        kmem_tmp->color_count = kmem_tmp->free_count;
        kmem_tmp->color_length = ((kmem_tmp->color_count + sizeof(uint64_t) * 8 - 1) >> 6) << 3;
        kmem_tmp->color_map = (uint64_t*)kmalloc(kmem_tmp->color_length, 0);
        if(kmem_tmp->color_map == NULL)
        {
            color_printk(RED, BLACK, "kmem_malloc()->kmalloc(colormap) == NULL\n");
            free_pages(kmem_tmp->page, 1);
            kfree(kmem_tmp);
            return NULL;
        }
        memset(kmem_tmp->color_map, 0, kmem_tmp->color_length);
        list_add_behind(&kmem_cache->cache_pool->list, &kmem_tmp->list);
        kmem_cache->total_free += kmem_tmp->color_count;
        for(j = 0; j < kmem_tmp->color_count; ++j)
        {
            if((*(kmem_tmp->color_map + (j >> 6)) & 1UL << (j % 64)) == 0)
            {
                *(kmem_tmp->color_map + (j >> 6)) |= 1UL << (j % 64);
                kmem_tmp->using_count++;
                kmem_tmp->free_count--;
                kmem_cache->total_free--;
                kmem_cache->total_using++;
                if(kmem_cache->construct != NULL)
                {
                    return kmem_cache->construct((char*)kmem_tmp->vaddress + kmem_cache->size * j, arg);
                }
                else
                {
                    return (void*)((char*)kmem_tmp->vaddress + kmem_cache->size * j);
                }
            }
        }
    }
    else
    {
        do
        {
            if(kmem_pool->free_count == 0)
            {
                kmem_pool = (struct kmem*)container_of(list_next(&kmem_pool->list), struct kmem, list);
                continue;
            }
            for(j = 0; j < kmem_pool->color_count; ++j)
            {
                if(*(kmem_pool->color_map + (j >> 6)) == 0xffffffffffffffffUL)
                {
                    j += 63;
                    continue;
                }
            }
            if((*(kmem_pool->color_map + (j >> 6)) & (1UL << (j % 64))) == 0)
            {
                *(kmem_pool->color_map + (j >> 6)) |= 1UL << (j % 64);
                kmem_pool->using_count++;
                kmem_pool->free_count--;
                if(kmem_cache->construct != NULL)
                {
                    return kmem_cache->construct((char*)kmem_tmp->vaddress + kmem_cache->size * j, arg);
                }
                else
                {
                    return (void*)((char*)kmem_tmp->vaddress + kmem_cache->size * j);
                }
            }
        }while(kmem_pool != kmem_cache->cache_pool);
    }
    color_printk(RED, BLACK, "kmem_malloc()ERROR: can't alloc\n");
    if(kmem_tmp != NULL)
    {
        list_delete(&kmem_tmp->list);
        kfree(kmem_tmp->color_map);
        page_clean(kmem_tmp->page);
        free_pages(kmem_tmp->page, 1);
        kfree(kmem_tmp);
    }
    return NULL;
}
uint64_t kmem_free(struct kmem_cache* kmem_cache, void* address, uint64_t arg)
{
    struct kmem* kmem_pool = kmem_cache->cache_pool;
    int32_t index = 0;
    do
    {
        if(kmem_pool->vaddress <= address && address < kmem_pool->vaddress + PAGE_2M_SIZE)
        {
            index = (address - kmem_pool->vaddress) / kmem_cache->size;
            *(kmem_pool->color_map + (index >> 6)) ^= 1UL << (index % 64);
            kmem_pool->using_count--;
            kmem_pool->free_count++;
            kmem_cache->total_free++;
            kmem_cache->total_using--;
            if(kmem_cache->destruct != NULL)
            {
                kmem_cache->destruct((char*)kmem_pool->vaddress + kmem_cache->size * index, arg);
            }
            if((kmem_pool->using_count == 0) && (kmem_cache->total_free >= kmem_pool->color_count * 3 / 2))
            {
                list_delete(&kmem_pool->list);
                kmem_cache->total_free -= kmem_pool->color_count;
                kfree(kmem_pool->color_map);
                page_clean(kmem_pool->page);
                free_pages(kmem_pool->page, 1);
                kfree(kmem_pool);
            }
            return 1;
        }
        else
        {
            kmem_pool = (struct kmem*)container_of(list_next(&kmem_pool->list), struct kmem, list);
            continue;
        }
    }while(kmem_pool != kmem_cache->cache_pool);
    color_printk(RED, BLACK, "kmem_free() ERROR address is not in kmem\n");
    return 0;
}
uint64_t page_clean(struct page * page)
{
    page->reference_count--;
    page->zone_struct->total_pages_link--;
    if(!page->reference_count)
    {
        page->attribute &= PAGE_PT_MAPED;
    }
    return 1;
}
void free_pages(struct page* page, int32_t number)
{
    int32_t i = 0;
    if(page == NULL)
    {
        color_printk(RED, BLACK, "free_pages()ERROR:page is invalid\n");
        return;
    }
    if(number >= 64 || number <= 0)
    {
        color_printk(RED, BLACK, "free_pages()ERROR:number is invalid\n");
        return;
    }
    for(i = 0; i < number; ++i, page++)
    {
        *(mem_structure.bits_map +((page->p_address >> PAGE_2M_SHIFT) >> 6)) &= ~(1UL << (page->p_address >> PAGE_2M_SHIFT) % 64);
        page->zone_struct->page_using_count--;
        page->zone_struct->page_free_count++;
        page->attribute = 0;
    }
    return;
}
uint64_t kfree(void* address)
{
    int32_t i = 0;
    int32_t index = 0;
    struct kmem* kmem = NULL;
    void* page_bass_address = (void*)((uint64_t)address & PAGE_2M_MASK);
    for(i = 0; i < 16; ++i)
    {
        kmem = kmalloc_cache_size[i].cache_pool;
        do
        {
            if(kmem->vaddress == page_bass_address)
            {
                index = (address - kmem->vaddress) / kmalloc_cache_size[i].size;
                *(kmem->color_map + (index >> 6)) ^= 1UL << index % 64;
                kmem->free_count++;
                kmem->using_count--;
                kmalloc_cache_size[i].total_free++;
                kmalloc_cache_size[i].total_using--;
                if((kmem->using_count == 0) && (kmalloc_cache_size[i].total_free >= kmem->color_count * 3 / 2) && kmalloc_cache_size[i].cache_pool != kmem)
                {
                    switch(kmalloc_cache_size[i].size)
                    {
                        case 32:
                        case 64:
                        case 128:
                        case 256:
                        case 512:
                            list_delete(&kmem->list);
                            kmalloc_cache_size[i].total_free -= kmem->color_count;
                            page_clean(kmem->page);
                            free_pages(kmem->page, 1);
                            break;
                        default:
                            list_delete(&kmem->list);
                            kmalloc_cache_size[i].total_free -= kmem->color_count;
                            kfree(kmem->color_map);
                            page_clean(kmem->page);
                            free_pages(kmem->page, 1);
                            kfree(kmem);
                            break;
                    }
                }
                return 1;
            }
            else
            {
                kmem = (struct kmem*)container_of(list_next(&kmem->list), struct kmem, list);
            }
        }while(kmem != kmalloc_cache_size[i].cache_pool);
    }
    color_printk(RED, BLACK, "kfree() ERROR:can't free memory\n");
    return 0;
}
uint64_t kmem_init(void)
{
    struct page* page = NULL;
    uint64_t* virtual = NULL;
    uint64_t i;
    uint64_t j;
    uint64_t tmp_address = mem_structure.end_of_struct;
    for(i = 0; i < 16; ++i)
    {
        kmalloc_cache_size[i].cache_pool = (struct kmem*)mem_structure.end_of_struct;
        mem_structure.end_of_struct = mem_structure.end_of_struct + sizeof(struct kmem) + sizeof(int64_t) * 10;
        list_init(&kmalloc_cache_size[i].cache_pool->list);
        kmalloc_cache_size[i].cache_pool->using_count = 0;
        kmalloc_cache_size[i].cache_pool->free_count = PAGE_2M_SIZE / kmalloc_cache_size[i].size;
        kmalloc_cache_size[i].cache_pool->color_length = ((PAGE_2M_SIZE / kmalloc_cache_size[i].size + sizeof(uint64_t) * 8 - 1) >> 6) <<3;
        kmalloc_cache_size[i].cache_pool->color_count = kmalloc_cache_size[i].cache_pool->free_count;
        kmalloc_cache_size[i].cache_pool->color_map = (uint64_t*)mem_structure.end_of_struct;
        mem_structure.end_of_struct = (uint64_t)(mem_structure.end_of_struct + kmalloc_cache_size[i].cache_pool->color_length + sizeof(uint64_t) * 10) & (~(sizeof(uint64_t) - 1));
        memset(kmalloc_cache_size[i].cache_pool->color_map, 0xff, kmalloc_cache_size[i].cache_pool->color_length);
        for(j = 0; j < kmalloc_cache_size[i].cache_pool->color_count; ++j)
        {
            *(kmalloc_cache_size[i].cache_pool->color_map + (j >> 6)) ^= 1UL << (j % 64);
        }
        kmalloc_cache_size[i].total_free = kmalloc_cache_size[i].cache_pool->color_count;
        kmalloc_cache_size[i].total_using = 0;
    }
    i = V_TO_P(mem_structure.end_of_struct) >> PAGE_2M_SHIFT;
    for(j = PAGE_2M_ALIGN(V_TO_P(tmp_address)) >> PAGE_2M_SHIFT; j <= i; ++j)
    {
        page = mem_structure.pages_struct + j;
        *(mem_structure.bits_map + ((page->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (page->p_address >> PAGE_2M_SHIFT) % 64;
        page->zone_struct->page_using_count++;
        page->zone_struct->page_free_count--;
        color_printk(GREEN, BLACK, "%018ld\n",page->zone_struct->page_free_count);
        page_init(page, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
    }
    color_printk(ORANGE, BLACK, "2.bits_map:%#018lx\tzone_struct->page_using:%d\tzone_struct->page_free:%d\n", *mem_structure.bits_map, mem_structure.zones_struct->page_using_count, mem_structure.zones_struct->page_free_count);
    color_printk(GREEN, BLACK, "%018lx\n", mem_structure.end_of_struct);
    for(i = 0; i < 16; ++i)
    {
        page = alloc_pages(ZONE_NORMAL, 1, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
        kmalloc_cache_size[i].cache_pool->page = page;
        kmalloc_cache_size[i].cache_pool->vaddress = (void *)P_TO_V(page->p_address);
    }
    color_printk(ORANGE, BLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[0].page_using_count, mem_structure.zones_struct[0].page_free_count);
    color_printk(ORANGE, BLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[1].page_using_count, mem_structure.zones_struct[1].page_free_count);
    color_printk(ORANGE, BLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[2].page_using_count, mem_structure.zones_struct[2].page_free_count);
    color_printk(ORANGE, BLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[3].page_using_count, mem_structure.zones_struct[3].page_free_count);
    color_printk(ORANGE, BLACK, "start_code:%#018lx end_code:%#018lx start_data:%#018lx end_data:%#018lx start_brk:%#018lx end_of_struct:%#018lx\n", mem_structure.start_code, mem_structure.end_code, mem_structure.start_data, mem_structure.end_data, mem_structure.start_brk, mem_structure.end_of_struct);
    return 1;
}
uint64_t get_page_attribute(struct page* page)
{
    if(page == NULL)
    {
        color_printk(RED, BLACK, "get_page_attribute() ERROR:page == NULL\n");
        return 0;
    }
    return (page->attribute);
}
uint64_t set_page_attribute(struct page* page, uint64_t flags)
{
    if(page == NULL)
    {
        color_printk(RED, BLACK, "set_page_attribute() ERROR:page == NULL\n");
        return 0;
    }
    page->attribute = flags;
    return 1;
}
void pagetable_init()
{
    uint64_t i = 0;
    uint64_t j = 0;
    uint64_t* tmp = NULL;
    uint64_t* virtual;
    cr3 = get_gdt();
    tmp = (uint64_t*)(((uint64_t)P_TO_V((uint64_t)cr3 & (~0xfffUL))) + 8 * 256);
    color_printk(YELLOW, BLACK, "1:%#018lx\t%#018lx\n", (uint64_t)tmp, *tmp);
    tmp = (uint64_t*)P_TO_V(*tmp & (~0xfffUL));
    color_printk(YELLOW, BLACK, "2:%#018lx\t%#018lx\n", (uint64_t)tmp, *tmp);
    tmp = (uint64_t*)P_TO_V(*tmp & (~0xfffUL));
    color_printk(YELLOW, BLACK, "3:%#018lx\t%#018lx\n", (uint64_t)tmp, *tmp);
    for(i = 0; i < mem_structure.zones_size; ++i)
    {
        struct zone* z = mem_structure.zones_struct + i;
        struct page* page = z->pages_group;
        for(j = 0; j < z->pages_length; ++j, ++page)
        {
            tmp = (uint64_t*)(((uint64_t)P_TO_V((uint64_t)cr3 & (~0xfffUL))) + (((uint64_t)P_TO_V(page->p_address) >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
            if(*tmp == 0)
            {
                virtual = (uint64_t*)kmalloc(PAGE_4K_SIZE, 0);
                memset(virtual, 0, PAGE_4K_SIZE);
                set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_KERNEL_GDT));
            }
            tmp = (uint64_t*)(((uint64_t)P_TO_V((uint64_t)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((uint64_t)P_TO_V(page->p_address) >> PAGE_1G_SHIFT) & 0x1ff) * 8);
            if(*tmp == 0)
            {
                virtual = (uint64_t*)kmalloc(PAGE_4K_SIZE, 0);
                memset(virtual, 0, PAGE_4K_SIZE);
                set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_KERNEL_DIR));
            }
            tmp = (uint64_t*)(((uint64_t)P_TO_V((uint64_t)(*tmp & (~0xfffUL)) & (~0xfffUL))) + (((uint64_t)P_TO_V(page->p_address) >> PAGE_2M_SHIFT) & 0x1ff) * 8);
            set_pdt(tmp, make_pdt(page->p_address, PAGE_KERNEL_PAGE));
            // if(j % 50 == 0)
            // {
            //     color_printk(GREEN, BLACK, "%018lx\t%018lx\n", tmp, *tmp);
            // }
        }
    }
    flush_tlb();
    return;
}

uint64_t do_brk(uint64_t addr, uint64_t len)
{
    uint64_t* tmp = NULL;
    uint64_t* virtual = NULL;
    struct page* p = NULL;
    uint64_t i = 0;
    for(i = addr; i < addr + len; i += PAGE_2M_SIZE)
    {
        tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)current->mm->pgd & (~0xfffUL))) + ((i >> PAGE_GDT_SHIFT) & 0x1ff) * 8);
        if(*tmp == 0)
        {
            virtual = (uint64_t*)kmalloc(PAGE_4K_SIZE, 0);
            memset(virtual, 0, PAGE_4K_SIZE);
            set_pml4t(tmp, make_pml4t(V_TO_P(virtual), PAGE_USER_GDT));
        }
        tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp) & (~0xfffUL))) + ((i >> PAGE_1G_SHIFT) & 0x1ff) * 8);
        if(*tmp == 0)
        {
            virtual = (uint64_t*)kmalloc(PAGE_4K_SIZE, 0);
            memset(virtual, 0, PAGE_4K_SIZE);
            set_pdpt(tmp, make_pdpt(V_TO_P(virtual), PAGE_USER_DIR));
        }
        tmp = (uint64_t *)(((uint64_t)P_TO_V((uint64_t)(*tmp) & (~0xfffUL))) + ((i >> PAGE_2M_SHIFT) & 0x1ff) * 8);
        if(*tmp == 0)
        {
            p = alloc_pages(ZONE_NORMAL, 1, PAGE_PT_MAPED);
            if(p == NULL)
            {
                return -ENOMEM;
            }
            set_pdt(tmp, make_pdt(p->p_address, PAGE_USER_PAGE));
        }
    }
    current->mm->end_brk = i;
    flush_tlb();
    return i;
}
