CFLAGS = -g -Wall
GTKFLAGS1 = `pkg-config --cflags gtk+-3.0`

main: main.c
	gcc $(CFLAGS) $(GTKFLAGS1) main.c -o main

clean:
	rm -f main main.o a.out
