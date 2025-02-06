#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    const char *filename_1 = argv[1];
    const char *filename_2 = argv[3];
    int position_1 = atoi(argv[2]);
    int position_2 = atoi(argv[4]);

    FILE *file_1 = fopen(filename_1, "rb");
    fseek(file_1, position_1, SEEK_SET);

    int byte_1 = fgetc(file_1);
    fclose(file_1);

    FILE *file_2 = fopen(filename_2, "rb");
    fseek(file_2, position_2, SEEK_SET);

    int byte_2 = fgetc(file_2);
    fclose(file_2);

    // Compare the bytes and print the result
    if ((byte_1 == byte_2) && byte_1 != EOF && byte_2 != EOF) {
        printf("byte %d in %s and byte %d in %s are the same\n",
                position_1, filename_1, position_2, filename_2);
    } else {
        printf("byte %d in %s and byte %d in %s are not the same\n",
                position_1, filename_1, position_2, filename_2);
    }

    return 0;
}
