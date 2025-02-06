// Append to a Diary File
// diary.c
//
// Written by Caitlin Wong (z5477471)
// on the 23/07/2024

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

    // Get HOME environment variable value
    char *home = getenv("HOME");

    // Make diary path file
    char diary_path[256];
    snprintf(diary_path, sizeof(diary_path), "%s/.diary", home);

    // Open diary file in append mode
    FILE *diary_file = fopen(diary_path, "a");

    // Append the command-line arguments as line in diary file
    for (int i = 1; i < argc; i++) {
        fprintf(diary_file, "%s", argv[i]);

        // Add a space between arguments
        if (i < argc - 1) {
            fprintf(diary_file, " ");
        }
    }

    // Add a newline at the end of the line
    fprintf(diary_file, "\n");
    return 0;
}
