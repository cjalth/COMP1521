// Create a Binary File
// create_binary_file.c
//
// Written by Caitlin Wong (z5477471) 
// on the 15/07/2024

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    // Open in write binary
    FILE *file = fopen(argv[1], "wb");

    for (int i = 2; i < argc; i++) {
        int value = atoi(argv[i]);

        if (value < 0 || value > 255) {
            // Remove file if created
            remove(argv[1]);
            return 0;
        }
        // Write the byte to the file
        fputc((unsigned char)value, file);
    }

    return 0;
}
