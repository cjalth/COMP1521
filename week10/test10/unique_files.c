#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int main(int argc, char **argv) {
    // Array to store encountered inode numbers
    ino_t *inode_numbers = (ino_t *)calloc(argc -1, sizeof(ino_t));

    // Iterate through each file
    for (int i = 1; i < argc; ++i) {
        struct stat file_stat;

        // Get file information
        stat(argv[i], &file_stat);

        // Check if the inode number has been encountered before
        int encountered = 0;
        int j = 0;
        while (j < i && encountered == 0) {
            encountered = (inode_numbers[j] == file_stat.st_ino);
            j++;
        }

        // If not encountered, print the file's name and store the inode number
        if (encountered == 0) {
            printf("%s\n", argv[i]);
            inode_numbers[i - 1] = file_stat.st_ino;
        }
    }

    // Free allocated memory
    free(inode_numbers);

    return EXIT_SUCCESS;
}