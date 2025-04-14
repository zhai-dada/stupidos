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
    u64 tmp_address = mem_des.end_of_struct;
    for(i = 0; i < 16; ++i)
    {
        kmalloc_cache_size[i].cache_pool = (kmem_t*)mem_des.end_of_struct;
        mem_des.end_of_struct = mem_des.end_of_struct + sizeof(kmem_t) + sizeof(s64) * 10;
        list_init(&kmalloc_cache_size[i].cache_pool->list);
        kmalloc_cache_size[i].cache_pool->using_count = 0;
        kmalloc_cache_size[i].cache_pool->free_count = PAGE_2M_SIZE / kmalloc_cache_size[i].size;
        kmalloc_cache_size[i].cache_pool->color_length = ((PAGE_2M_SIZE / kmalloc_cache_size[i].size + sizeof(u64) * 8 - 1) >> 6) << 3;
        kmalloc_cache_size[i].cache_pool->color_count = kmalloc_cache_size[i].cache_pool->free_count;
        kmalloc_cache_size[i].cache_pool->color_map = (u64*)mem_des.end_of_struct;
        mem_des.end_of_struct = (u64)(mem_des.end_of_struct + kmalloc_cache_size[i].cache_pool->color_length + sizeof(u64) * 10) & (~(sizeof(u64) - 1));
        memset(kmalloc_cache_size[i].cache_pool->color_map, 0xff, kmalloc_cache_size[i].cache_pool->color_length);
        for(j = 0; j < kmalloc_cache_size[i].cache_pool->color_count; ++j)
        {
            *(kmalloc_cache_size[i].cache_pool->color_map + (j >> 6)) ^= 1UL << (j % 64);
        }
        kmalloc_cache_size[i].total_free = kmalloc_cache_size[i].cache_pool->color_count;
        kmalloc_cache_size[i].total_using = 0;
    }
    i = V_TO_P(mem_des.end_of_struct) >> PAGE_2M_SHIFT;
    for(j = PAGE_2M_ALIGN(V_TO_P(tmp_address)) >> PAGE_2M_SHIFT; j <= i; ++j)
    {
        page = mem_des.pages_struct + j;
        *(mem_des.bits_map + ((page->p_address >> PAGE_2M_SHIFT) >> 6)) |= 1UL << (page->p_address >> PAGE_2M_SHIFT) % 64;
        page->zone_struct->page_using_count++;
        page->zone_struct->page_free_count--;
        serial_printf(SFGREEN, SBBLACK, "free count %018ld\n", page->zone_struct->page_free_count);
        page_init(page, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
    }
    serial_printf(SFYELLOW, SBBLACK, "2.bits_map:%#018lx\tzone_struct->page_using:%d\tzone_struct->page_free:%d\n", *mem_des.bits_map, mem_des.zones_struct->page_using_count, mem_des.zones_struct->page_free_count);
    serial_printf(SFGREEN, SBBLACK, "%018lx\n", mem_des.end_of_struct);

    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[0].page_using_count, mem_des.zones_struct[0].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[1].page_using_count, mem_des.zones_struct[1].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[2].page_using_count, mem_des.zones_struct[2].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[3].page_using_count, mem_des.zones_struct[3].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "start_code:%#018lx end_code:%#018lx start_data:%#018lx end_data:%#018lx start_brk:%#018lx end_of_struct:%#018lx\n", mem_des.start_code, mem_des.end_code, mem_des.start_data, mem_des.end_data, mem_des.start_brk, mem_des.end_of_struct);

    for(i = 0; i < 16; ++i)
    {
        page = alloc_pages(1, 1, PAGE_PT_MAPED | PAGE_KERNEL_INIT | PAGE_KERNEL);
        kmalloc_cache_size[i].cache_pool->page = page;
        kmalloc_cache_size[i].cache_pool->vaddress = (void *)P_TO_V(page->p_address);
    }
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[0].page_using_count, mem_des.zones_struct[0].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[1].page_using_count, mem_des.zones_struct[1].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[2].page_using_count, mem_des.zones_struct[2].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "3.bits_map:%#018lx\tzone_struct->page_using:%ld\tzone_struct->page_free:%ld\n", *mem_des.bits_map, mem_des.zones_struct[3].page_using_count, mem_des.zones_struct[3].page_free_count);
    serial_printf(SFYELLOW, SBBLACK, "start_code:%#018lx end_code:%#018lx start_data:%#018lx end_data:%#018lx start_brk:%#018lx end_of_struct:%#018lx\n", mem_des.start_code, mem_des.end_code, mem_des.start_data, mem_des.end_data, mem_des.start_brk, mem_des.end_of_struct);
    pagetable_init();
    return SOK;
}

static kmem_t* kmalloc_create(u64 size)
{
    s32 i = 0;
    kmem_t* kmem = NULL;
    page_t* page = NULL;
    u64* vaddress = NULL;
    s64 structsize = 0;
    page = alloc_pages(1, 1, 0);
    if(page == NULL)
    {
        serial_printf(SFRED, SBBLACK, "kmalloc_create()->page_alloc() ERROR page = NULL\n");
        return NULL;
    }
    page_init(page, PAGE_KERNEL | PAGE_PT_MAPED);
    switch(size)
    {
        case 32:
        case 64:
        case 128:
        case 256:
        case 512:
            vaddress = (u64*)P_TO_V(page->p_address);
            structsize = sizeof(kmem_t) + PAGE_2M_SIZE / size / 8;
            kmem = (kmem_t*)((u64)vaddress + PAGE_2M_SIZE - structsize);
            kmem->color_map = (u64*)((u8*)kmem + sizeof(kmem_t));
            kmem->free_count = (PAGE_2M_SIZE - (PAGE_2M_SIZE / size / 8) - sizeof(kmem_t)) / size;
            kmem->using_count = 0;
            kmem->color_count = kmem->free_count;
            kmem->vaddress = vaddress;
            kmem->page = page;
            list_init(&kmem->list);
            kmem->color_length = ((kmem->color_count + sizeof(u64) * 8 - 1) >> 6) << 3;
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
            kmem = (kmem_t*)kmalloc(sizeof(kmem_t), 0);
            kmem->free_count = PAGE_2M_SIZE / size;
            kmem->using_count = 0;
            kmem->color_count = kmem->free_count;
            kmem->color_length = ((kmem->color_count + sizeof(u64) * 8 - 1) >> 6) << 3;
            kmem->color_map = (u64*)kmalloc(kmem->color_length, 0);
            memset(kmem->color_map, 0xff, kmem->color_length);
            kmem->vaddress = (u64*)P_TO_V(page->p_address);
            kmem->page = page;
            list_init(&kmem->list);
            for(i = 0; i < kmem->color_count; ++i)
            {
                *(kmem->color_map + (i >> 6)) ^= 1UL << i % 64;
            }
            break;
        default:
            serial_printf(SFYELLOW, SBBLACK, "kmalloc_create() ERROR:wrong size%08d\n", size);
            free_pages(page, 1);
            return NULL;
    }
    return kmem;
}

void* kmalloc(u64 size, u64 flags)
{
    s32 i = 0;
    s32 j = 0;
    kmem_t* kmem = NULL;
    //1048576 = 1MB
    if(size > 1048576)
    {
        serial_printf(SFYELLOW, SBBLACK, "kmalloc() ERROR:kmalloc size too s64:%08d\n", size);
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
                kmem = container_of(list_next(&kmem->list), list, kmem_t);
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
            serial_printf(SFYELLOW, SBBLACK, "kmalloc()->kmalloc_create()->kmem == NULL\n");
            return NULL;
        }
        kmalloc_cache_size[i].total_free += kmem->color_count;
        serial_printf(SFRED, SBBLACK, "kmalloc()->kmalloc_create() <= size:%#010x\n", kmalloc_cache_size[i].size);
        list_add_before(&kmalloc_cache_size[i].cache_pool->list, &kmem->list);
    }
    for(j = 0; j < kmem->color_count; ++j)
    {
        if(*(kmem->color_map + (j >> 6)) == 0xffffffffffffffffUL)
        {
            j += 63;
            continue;
        }
        else if((*(kmem->color_map + (j >> 6)) & (1UL << (j % 64))) == 0)
        {
            *(kmem->color_map + (j >> 6)) |= 1UL << (j % 64);
            kmem->using_count++;
            kmem->free_count--;
            kmalloc_cache_size[i].total_using++;
            kmalloc_cache_size[i].total_free--;
            return (void *)((u64)kmem->vaddress + kmalloc_cache_size[i].size * j);
        }
    }
    serial_printf(SFYELLOW, SBBLACK, "kmalloc() ERROR: no memory call alloc\n");
    return NULL;
}

u64 kfree(void* address)
{
    s32 i = 0;
    s32 index = 0;
    kmem_t* kmem = NULL;
    void* page_bass_address = (void*)((u64)address & PAGE_2M_MASK);
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
                return SOK;
            }
            else
            {
                kmem = (kmem_t*)container_of(list_next(&kmem->list), list, kmem_t);
            }
        }while(kmem != kmalloc_cache_size[i].cache_pool);
    }
    serial_printf(SFYELLOW, SBBLACK, "kfree() ERROR:can't free memory\n");
    return SFAIL;
}