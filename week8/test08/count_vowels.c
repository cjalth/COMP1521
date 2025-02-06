#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    // Takes the second input of the command line argument
    char *filename = argv[1];

    // Opens the filename and stores it in the file pointer
    FILE *file = fopen(filename, "r");

    int i = 0;
    int letter;

    // Reads characters from file until the end of the file
    while ((letter = fgetc(file)) != EOF) {
        letter = tolower(letter);
        if (letter == 'a' || letter == 'e' || letter == 'i' 
            || letter == 'o' || letter == 'u') {
            i++;
        }
    }

    // prints the number of vowels in the file
    printf("%d\n", i);
    return 0;
}