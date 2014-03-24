# Makefile for blink_until_button example program.
# Run:
#  # make
# to assemble the PRU binary and build the C loader.

CC=gcc
CFLAGS=-c -Wall
LIBS=-lprussdrv

PASM=pasm
PASMFLAGS=-b

all: blink_until_button.bin blink_until_button

blink_until_button.bin: blink_until_button.p
	$(PASM) $(PASMFLAGS) blink_until_button.p

blink_until_button: blink_until_button.o
	$(CC) $(LIBS) $^ -o blink_until_button
	chmod +x blink_until_button

blink_until_button.o: blink_until_button.c
	gcc $(CFLAGS) blink_until_button.c

clean:
	rm blink_until_button.bin blink_until_button.o blink_until_button

.PHONY: all clean
