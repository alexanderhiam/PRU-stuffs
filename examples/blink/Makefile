# Makefile for pru_blink example program.
# Run:
#  # make
# to assemble the PRU binary and build the C loader.

CC=gcc
CFLAGS=-c -Wall
LIBS=-lprussdrv

PASM=pasm
PASMFLAGS=-b

all: pru_blink.bin pru_blink

pru_blink.bin: pru_blink.p
	$(PASM) $(PASMFLAGS) pru_blink.p

pru_blink: pru_blink.o
	$(CC) $(LIBS) $^ -o pru_blink
	chmod +x pru_blink

pru_blink.o: pru_blink.c
	gcc $(CFLAGS) pru_blink.c

clean:
	rm pru_blink.bin pru_blink.o pru_blink

.PHONY: all clean
