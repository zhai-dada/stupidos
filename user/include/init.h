#ifndef __TEST_H__
#define __TEST_H__

struct	buildincmd
{
	char *name;
	int (*function)(int,char**);
};
extern struct buildincmd shell_internal_cmd[];

extern char *current_dir;

#endif