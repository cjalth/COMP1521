#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    // Opens both files in binary read mode and stores in a file pointer
    FILE *file_1 = fopen(argv[1], "rb");
    FILE *file_2 = fopen(argv[2], "rb");

    int byte_number = 0;
    int byte_1;
    int byte_2;

    while (1) {
        // Reads bytes from file_1 and file_2 and stores it into 2 different bytes
        byte_1 = fgetc(file_1);
        byte_2 = fgetc(file_2);

        // Checks if the bytes are different or the bytes have reached the end of the files
        if (byte_1 != byte_2 || byte_1 == EOF || byte_2 == EOF) {
            // If only 1 file reached the end of the file
            if (((byte_1 == EOF) && (byte_2 != EOF)) || ((byte_2 == EOF) && (byte_1 != EOF))) {
                printf("EOF on %s\n", byte_1 == EOF ? argv[1] : argv[2]);
                // If the 2 bytes aren't equal
            } else if (byte_1 != byte_2) {
                printf("Files differ at byte %d\n", byte_number);
                // if both files have reached the end and they're the same
            } else if (byte_1 == EOF && byte_2 == EOF) {
                printf("Files are identical\n");
            } 
            return 0;
        }
        byte_number++;
    }
    return 0;
}

