#include <mm/memory.h>
#include <mm/kmem.h>
#include <lib/list.h>
#include <driver/serial.h>

kmem_cache_t kmalloc_cache_size[16] = 
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

u64 kmem_init(void)
{
    page_t* page = NULL;
    u64 i;
    u64 j;
    u64 tmp_address = mem_structure.end_of_struct;
    for(i = 0; i < 16; ++i)
    {
        kmalloc_cache_size[i].cache_pool = (kmem_t*)mem_structure.end_of_struct;
        mem_structure.end_of_struct = mem_structure.end_of_struct + sizeof(kmem_t) + sizeof(s64) * 10;
        list_init(&kmalloc_cache_size[i].cache_pool->list);
        kmalloc_cache_size[i].cache_pool->using_count = 0;
        kmalloc_cache_size[i].cache_pool->free_count = PAGE_2M_SIZE / kmalloc_cache_size[i].size;
        kmalloc_cache_size[i].cache_pool->color_length = ((PAGE_2M_SIZE / kmalloc_cache_size[i].size + sizeof(u64) * 8 - 1) >> 6) << 3;
        kmalloc_cache_size[i].cache_pool->color_count = kmalloc_cache_size[i].cache_pool->free_count;
        kmalloc_cache_size[i].cache_pool->color_map = (u64*)mem_structure.end_of_struct;
        mem_structure.end_of_struct = (u64)(mem_structure.end_of_struct + kmalloc_cache_size[i].cache_pool->color_length + sizeof(u64) * 10) & (~(sizeof(u64) - 1));
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
        serial_printf(SFGREEN, SBBLACK, "free count %018ld\n", page->zone_struct->page_free_count);
        page_init(page, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
    }
    serial_printf(SFYELLOW, SBBLACK, "2.bits_map:%#018lx\tzone_struct->page_using:%d\tzone_struct->page_free:%d\n", *mem_structure.bits_map, mem_structure.zones_struct->page_using_count, mem_structure.zones_struct->page_free_count);
    serial_printf(SFGREEN, SBBLACK, "%018lx\n", mem_structure.end_of_struct);

    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[0].page_using_count, mem_structure.zones_struct[0].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[1].page_using_count, mem_structure.zones_struct[1].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[2].page_using_count, mem_structure.zones_struct[2].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[3].page_using_count, mem_structure.zones_struct[3].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "start_code:%#018lx end_code:%#018lx start_data:%#018lx end_data:%#018lx start_brk:%#018lx end_of_struct:%#018lx\n", mem_structure.start_code, mem_structure.end_code, mem_structure.start_data, mem_structure.end_data, mem_structure.start_brk, mem_structure.end_of_struct);

    for(i = 0; i < 16; ++i)
    {
        page = alloc_pages(1, 1, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
        kmalloc_cache_size[i].cache_pool->page = page;
        kmalloc_cache_size[i].cache_pool->vaddress = (void *)P_TO_V(page->p_address);
    }
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[0].page_using_count, mem_structure.zones_struct[0].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[1].page_using_count, mem_structure.zones_struct[1].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[2].page_using_count, mem_structure.zones_struct[2].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_structure.bits_map, mem_structure.zones_struct[3].page_using_count, mem_structure.zones_struct[3].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "start_code:%#018lx end_code:%#018lx start_data:%#018lx end_data:%#018lx start_brk:%#018lx end_of_struct:%#018lx\n", mem_structure.start_code, mem_structure.end_code, mem_structure.start_data, mem_structure.end_data, mem_structure.start_brk, mem_structure.end_of_struct);
    return 1;
}