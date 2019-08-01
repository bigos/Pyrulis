CFLAGS = -g -Wall
GTKFLAGS1 = `pkg-config --cflags gtk+-3.0`

clean:
	rm -f a.out test foo.o libfoo.so

# compile C library
step1: foo.h foo.c
	gcc -c -Wall -Werror -fpic foo.c

# create shared library
step2: step1
	gcc -shared -o libfoo.so foo.o

# create executable using the library
step3: step2
	gcc -L. -Wall -o test main.c -lfoo

# run the executable
run: step3
	LD_LIBRARY_PATH=`pwd`/foo::$LD_LIBRARY_PATH ./test
