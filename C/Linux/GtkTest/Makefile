CFLAGS = -g -Wall
GTKCFLAGS = `pkg-config --cflags gtk+-3.0`
GTKLIBS =   `pkg-config --libs   gtk+-3.0`

clean:
	rm -f a.out test foo.o libfoo.so

# compile C library
step1: foo.h foo.c
	gcc $(GTKCFLAGS) -c -fpic foo.c $(GTKLIBS)

# create shared library
step2: step1
	gcc -shared -o libfoo.so foo.o

# create executable using the library
step3: step2
	gcc -L. -Wall -o test main.c -lfoo $(GTKLIBS)

# run the executable
run: step3
	LD_LIBRARY_PATH=`pwd`/foo::$LD_LIBRARY_PATH ./test
