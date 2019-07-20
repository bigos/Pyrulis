CFLAGS = -g -Wall
GTKFLAGS1 = `pkg-config --cflags gtk+-3.0`

# output of the following needed in %flag C in Main.idr
# GTKFLAGS2 = `pkg-config --libs gtk+-3.0`

myc.o: myc.c myc.h
	gcc $(CFLAGS) $(GTKFLAGS1) myc.c -c -o myc.o

clean:
	rm -f cglade myc.o myc.c.* main.ibc a.out *.ibc


hmm: myc.o
