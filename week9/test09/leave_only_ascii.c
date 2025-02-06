#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *inputFile = fopen(argv[1], "rb");
    // Open the temporary binary file (can read and write)
    FILE *tempFile = tmpfile();
    int character;

    // Copy only ASCII bytes to the temporary file
    // While the file hasn't ended
    while ((character = fgetc(inputFile)) != EOF) {
        if (character >= 0 && character <= 127) {
            fputc(character, tempFile);
        }
    }

    fclose(inputFile);
    rewind(tempFile);

    // Opens the input file in binary write mode
    inputFile = fopen(argv[1], "wb");

    // Copy from the temporary file back to the input file
    while ((character = fgetc(tempFile)) != EOF) {
        fputc(character, inputFile);
    }

    // Close the files
    fclose(inputFile);
    fclose(tempFile);
    return 0;
}
