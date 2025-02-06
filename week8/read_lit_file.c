// Read a file of little-endian integers
// read_lit_file.c
//
// Written by Caitlin Wong (z5477471) 
// on the 15/07/2024

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "ERROR!\n");
        return 1;
    }

    FILE *file = fopen(argv[1], "rb");
    if (file == NULL) {
        fprintf(stderr, "ERROR!\n");
        return 1;
    }

    // Read and validate the magic number
    char magic[3];
    if (fread(magic, 1, 3, file) != 3 || magic[0] != 'L' || magic[1] != 'I' || magic[2] != 'T') {
        fprintf(stderr, "ERROR!\n");
        fclose(file);
        return 1;
    }

    while (1) {
        // Read the number of bytes for the next integer
        int num_bytes = fgetc(file);
        if (num_bytes == EOF) {
            return 0;
        }

        num_bytes -= '0';
        if (num_bytes < 1 || num_bytes > 8) {
            fprintf(stderr, "ERROR!\n");
            fclose(file);
            return 1;
        }

        // Read the integer
        unsigned long long value = 0;
        for (int i = 0; i < num_bytes; i++) {
            int byte_value = fgetc(file);

            if (byte_value == EOF) {
                fprintf(stderr, "ERROR!\n");
                fclose(file);
                return 1;
            }
            value |= ((unsigned long long)byte_value << (i * 8));
        }
        // Print the integer
        printf("%llu\n", value);
    }
    fclose(file);
    return 0;
}



