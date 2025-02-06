// Print the Bytes of A File
// print_bytes.c
//
// Written by Caitlin Wong (z5477471) 
// on the 15/07/2024

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    // Open in read binary 
    FILE *file = fopen(argv[1], "rb");
    int byte;
    int i = 0;

    while ((byte = fgetc(file) ) != EOF) {
        int print = isprint(byte);
        printf("byte %4d: %3d 0x%02x", i, byte, byte);

        if (print) {
            printf(" '%c'", byte);
        }
        printf("\n");
        i++;
    }
    return 0;
}