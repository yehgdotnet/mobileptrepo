CC = gcc

GCC_DEBUG = -ggdb
GCC_OPT = -O3 -Wall -static
GCC_CFLAGS = $(GCC_OPT) 

SUN_OPT = -Bstatic
SUN_CFLAGS = $(SUN_OPT) 

all: mac-robber.c
	$(CC) $(GCC_CFLAGS) -o mac-robber mac-robber.c

linux: 
	$(CC) $(GCC_CFLAGS) -D_FILE_OFFSET_BITS=64 -o mac-robber mac-robber.c

linux_notstatic: 
	$(CC) -D_FILE_OFFSET_BITS=64 -o mac-robber mac-robber.c

sun:
	cc $(SUN_CFLAGS) -o mac-robber mac-robber.c

simple:
	$(CC) -o mac-robber mac-robber.c

clean:
	rm -f mac-robber *core

indent:
	indent *.c
