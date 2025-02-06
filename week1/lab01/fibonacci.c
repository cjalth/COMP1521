// Calculating the Fibonacci Sequence The (Not So) Fast Way
// fibonacci.c
//
// Written by Caitlin Wong (z5477471)
// on 17/09/2023
//
// This program reads a line of input containing a natural 
// number and prints the corresponding Fibonacci number

#include <stdio.h>
#include <stdlib.h>

#define SERIES_MAX 30

int fib(int n);

int main(void) {
    int n;
    while (scanf("%d", &n) == 1) {
        if (n <= 0 || n > SERIES_MAX) {
            printf("0\n");
        } else {
            printf("%d\n", fib(n));
        }
    }
    return EXIT_SUCCESS;
}

int fib(int n) {
    if (n <= 0) {
        return 0;
    } else if (n == 1 || n == 2) {
        return 1;
    } else {
        return fib(n - 1) + fib(n - 2);
    }
}
