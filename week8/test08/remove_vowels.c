#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    // Makes and stores the files in pointers, r for read and w for write
    FILE *input_file = fopen(argv[1], "r");
    FILE *output_file = fopen(argv[2], "w");

    int letter;

    // While loop until the end of the read file
    while ((letter = fgetc(input_file)) != EOF) {
        // Checks if the letter is not a vouwel
        if (letter != 'a' && letter != 'e' && 
            letter != 'i' && letter != 'o' && 
            letter != 'u' && letter != 'A' && 
            letter != 'E' && letter != 'I' &&
            letter != 'O' && letter != 'U') {
            // Puts the consonant in the write file and prints it
            fputc(letter, output_file);
        }
    }
    return 0;
}
