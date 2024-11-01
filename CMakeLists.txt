cmake_minimum_required(VERSION 3.10)
project(KernelBuild)
set(CMAKE_DEBUG_POSTFIX=ON)

# 输出目录
set(OUTPUT_KERNEL_DIR ${CMAKE_BINARY_DIR}/kernel)
set(OUTPUT_USER_DIR ${CMAKE_BINARY_DIR}/user)

# 创建输出目录
file(MAKE_DIRECTORY ${OUTPUT_KERNEL_DIR})
file(MAKE_DIRECTORY ${OUTPUT_USER_DIR})

# 收集源文件
file(GLOB KERNEL_SOURCES ${PROJECT_SOURCE_DIR}/kernel/src/*.c)
file(GLOB KERNEL_ASSEMBLY_SOURCES ${PROJECT_SOURCE_DIR}/kernel/src/*.S)

# 编译器标志
set(C_FLAGS -mcmodel=large -fno-builtin -fno-stack-protector -fno-pie -fno-pic -fno-common -std=gnu99 -nostartfiles -Wno-address-of-packed-member -m64 -O0 -I${PROJECT_SOURCE_DIR}/kernel/include/)
set(LD_FLAGS -b elf64-x86-64 -z muldefs -z noexecstack)

# 用于存储所有对象文件的列表
set(OBJECT_FILES_S "")
set(OBJECT_FILES_C "")

# 处理 S 文件
foreach(S_FILE ${KERNEL_ASSEMBLY_SOURCES})
    get_filename_component(BASE_NAME ${S_FILE} NAME_WE)
    set(OBJECT_FILE ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.o)
    add_custom_command(
        OUTPUT ${OBJECT_FILE}
        COMMAND gcc -E -I ${PROJECT_SOURCE_DIR}/kernel/include/ ${S_FILE} -o ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.s
        COMMAND as --64 ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.s -o ${OBJECT_FILE}
        DEPENDS ${source_file}
        DEPENDS ${S_FILE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    list(APPEND OBJECT_FILES_S ${OBJECT_FILE})
endforeach()

# 处理 C 文件
foreach(KERNEL_C_FILE ${KERNEL_SOURCES})
    get_filename_component(BASE_NAME ${KERNEL_C_FILE} NAME_WE)
    set(OBJECT_FILE ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.o)
    add_custom_command(
        OUTPUT ${OBJECT_FILE}
        COMMAND ${CMAKE_C_COMPILER} ${C_FLAGS} -c ${KERNEL_C_FILE} -o ${OBJECT_FILE}
        DEPENDS ${KERNEL_C_FILE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    list(APPEND OBJECT_FILES_C ${OBJECT_FILE})
endforeach()

add_custom_target(
    kernel
    ALL 
    COMMAND ld ${LD_FLAGS} -o osImage ${OUTPUT_KERNEL_DIR}/head.o ${OUTPUT_KERNEL_DIR}/entry.o ${OUTPUT_KERNEL_DIR}/apu_boot.o ${OBJECT_FILES_C} -T${PROJECT_SOURCE_DIR}/kernel/kernel.lds
    DEPENDS ${OBJECT_FILES_C}
    DEPENDS ${OBJECT_FILES_S}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)


