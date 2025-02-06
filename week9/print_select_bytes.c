// Print Select Bytes from a FIle
// print_select_bytes.c
//
// Written by Caitlin Wong (z5477471)
// on the 23/07/2024

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *file = fopen(argv[1], "rb");

    for (int i = 2; i < argc; i++) {
        long position = strtol(argv[i], NULL, 10);
        int byte;

        if (fseek(file, position, SEEK_SET) != 0) {
            continue;
        }

        byte = fgetc(file);

        printf("%d - 0x%02X ", byte, byte);

        if (isprint(byte)) {
            printf("- '%c'", (char)byte);
        }

        printf("\n");
    }
    return 0;
}
