// Remove Uneven Lines of Input
// no_odd_lines.c
//
// Written by Caitlin Wong (z5477471)
// on 27/05/2024
//
// This program reads an input and only prints 
// lines with an even number of characters.


#include <stdio.h>
#include <string.h>

#define MAX_CHAR 1024

int main(void) {
	char line[MAX_CHAR];
	while (fgets(line, MAX_CHAR, stdin) != NULL) {
		if ((strlen(line) % 2) == 0) {
			fputs(line, stdout);
		}
	}
	return 0;
}