#include "unistd.h"
#include "stdio.h"
#include "stdlib.h"
#include "fcntl.h"
#include "string.h"
#include "keyboard.h"
#include "init.h"

int main(int argc, char* argv[])
{
	int i = 0;
	printf("Hello\n");
	if(fork() == 0)
	{
		// exit(0);
		if(fork() == 0)
		{
			while(1)
				printf("test00000000\n");
		}
		else
		{
				while(1)
					printf("test11111111\n");
		}
	}
	else
	{
		if(fork() == 0)
		{
			while(1)
				printf("test22222222\n");
		}
		else
		{
			if(fork() == 0)
			{
				while(1)
					printf("test33333333\n");
			}
			else
			{
				while(1)
					printf("test44444444\n");			
			}
		}
	}
	while(1){;}
	exit(0);
	return 0;
}
