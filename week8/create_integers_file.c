// Create a File of Integers
// create_integers_file.c
//
// Written by Caitlin Wong (z5477471) 
// on the 15/07/2024

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    const char *filename = argv[1];
    int start = atoi(argv[2]);
    int end = atoi(argv[3]);

    FILE *file = fopen(filename, "w");

    // Write integers to the file
    for (int i = start; i <= end; i++) {
        fprintf(file, "%d\n", i);
    }
    fclose(file);
    return 0;
}