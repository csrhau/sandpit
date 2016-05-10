CC=gcc
CFLAGS=-I.
DEPS = sampling.h

.PHONY: all
all: psamp.x

%.o: %.c $(DEPS)
		$(CC) -c -o $@ $< $(CFLAGS)

psamp.x: main.o sampling.o
		gcc -o psamp.x main.o sampling.o

clean: 
	rm -f *.o
	rm -f psamp.x
