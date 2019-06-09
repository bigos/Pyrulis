#include <stdio.h>

int main()
{
  /* My first simple C program */
  printf("Hi everyone!\n");

  return 0;
}

/*
gcc hello.c
produces a.out, which can be executed on at least on Linux

gcc ./hello.c -o hello
produces an executable hello

gcc -pedantic -Wall -Wextra ./hello.c -o hello
this version will be fussy about the errors
 */
