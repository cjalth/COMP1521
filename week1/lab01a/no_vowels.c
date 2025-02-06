// Remove All Vowels from STDIN
// no_vowels.c
//
// Written by Caitlin Wong (z5477471)
// on 27/05/2024
//
// This program reads characters frm is input and writes 
// the same character to its output without vowels.


#include <stdio.h>
#include <ctype.h>

int text(char letter);

int main(void) {
	char letter;
	while(scanf("%c", &letter) == 1) {
		if(text(letter) == 1) {
			printf("%c", letter);
		}
	}
	return 0;
}

int text(char letter) {
	letter = tolower(letter);
	if (letter == 'a' ||
		letter == 'e' ||
		letter == 'i' ||
		letter == 'o' ||
		letter == 'u') {
		return 0;
	} else {
		return 1;
	}		
}