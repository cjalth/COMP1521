// Transform All Uppercase letters to Lowercase
// no_uppercase.c
//
// Written by Caitlin Wong (z5477471)
// on 27/05/2024
//
// This program reads characters frm is input and writes 
// the same characters to its output but all uppercase 
// letters are replaced with their lower case equivalent.

#include <stdio.h>
#include <ctype.h>

int main(void) {
	char letter;
	while ((letter = getchar()) != EOF) {
		putchar(tolower(letter));
	}

	return 0;
}

