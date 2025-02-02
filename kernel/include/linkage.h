#ifndef __LINKAGE_H__
#define __LINKAGE_H__

/* 将参数 X 替换为字符串 并且链接其他字符*/
#define SYMBOL_NAME(X) X
#define SYMBOL_NAME_STR(X) #X
#define SYMBOL_NAME_LABEL(X) X##:

#define ENTRY(name)            \
    .global SYMBOL_NAME(name); \
    SYMBOL_NAME_LABEL(name)

#endif