CFLAGS = -g -Wall
GTKFLAGS1 = `pkg-config --cflags gtk+-3.0`

main: main.c
	gcc $(CFLAGS) $(GTKFLAGS1) main.c -o main

clean:
	rm -f a.out main main.o foo.o libfoo.so

step1: foo.h foo.c
	gcc -c -Wall -Werror -fpic foo.c

step2: step1
	gcc -shared -o libfoo.so foo.o

step3: step2
	gcc -L. -Wall -o test main.c -lfoo
