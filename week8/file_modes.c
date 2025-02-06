// Print File Modes
// file_modes.c
//
// Written by Caitlin Wong (z5477471) 
// on the 15/07/2024

#include <stdio.h>
#include <sys/stat.h>
#include <stdlib.h>

// Function to print file permissions
void printPermissions(mode_t mode) {
    // Owner permissions
    printf("%c", (mode & S_IRUSR) ? 'r' : '-');
    printf("%c", (mode & S_IWUSR) ? 'w' : '-');
    printf("%c", (mode & S_IXUSR) ? 'x' : '-');

    // Group permissions
    printf("%c", (mode & S_IRGRP) ? 'r' : '-');
    printf("%c", (mode & S_IWGRP) ? 'w' : '-');
    printf("%c", (mode & S_IXGRP) ? 'x' : '-');

    // Others permissions
    printf("%c", (mode & S_IROTH) ? 'r' : '-');
    printf("%c", (mode & S_IWOTH) ? 'w' : '-');
    printf("%c", (mode & S_IXOTH) ? 'x' : '-');
}

int main(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        struct stat fileStat;

        if (stat(argv[i], &fileStat) == -1) {
            perror("ERROR!");
        } else {
            // Determine the file type
            char fileType = (S_ISDIR(fileStat.st_mode)) ? 'd' : '-';

            // Print file type and permissions
            printf("%c", fileType);
            printPermissions(fileStat.st_mode);
            printf(" %s\n", argv[i]);
        }
    }
    return 0;
}

