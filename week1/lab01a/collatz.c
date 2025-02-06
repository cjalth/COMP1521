// (Dis)Proving the Collatz Conjecture
// collatz.c
//
// Written by Caitlin Wong (z5477471)
// on 27/05/2024
//
// This program reads command line arguments and prints 
// the collatz chain for that particular number.

#include <stdio.h>
#include <stdlib.h>

void collatz(int n);

int main(int argc, char *argv[]) {
	if (argc != 2) {
		printf("Usage: %s NUMBER\n", argv[0]);
		return EXIT_FAILURE;
	} else {
		collatz(atoi(argv[1]));
	}
	return EXIT_SUCCESS;
}

void collatz(int n) {
	printf("%d\n", n);
	if (n == 1) {
		return;
	} else if (n % 2 == 1) {
		// Odd number
		collatz(3 * n + 1);
	} else {
		// Even number
		collatz(n / 2);
	}	
}
