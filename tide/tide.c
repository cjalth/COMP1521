////////////////////////////////////////////////////////////////////////////////
// COMP1521 23T3 --- Assignment 2: `tide', a terribly insecure (file) decryptor
// <https://www.cse.unsw.edu.au/~cs1521/23T3/assignments/ass2/index.html>
//
// 2023-10-25   v1.0    Team COMP1521 <cs1521 at cse.unsw.edu.au>
// 
// This program was written by Caitlin Wong (z5477471) on 30/10/2023.

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "tide.h"

// Add any extra #defines here.
#define CIPHER_BLOCK_SIZE 16

// Add any extra function signatures here.
void print_file_info(const char *file_path, const char *filename, const char *print_name);
void search_by_filename_recursive(char *search_string, char *current_path,
                                  char *matches[], int *match_count);
void search_content_recursive(const char *dir_path, const char *search_bytes, 
                              int size, content_result *results[], int *result_count);
void search_from_file(const char *file_path);
int count_content_matches(FILE *file, const char *search_bytes, int size);

// Some provided strings which you may find useful. Do not modify.
const char *const MSG_ERROR_FILE_STAT  = "Could not stat file.\n";
const char *const MSG_ERROR_FILE_OPEN  = "Could not open file.\n";
const char *const MSG_ERROR_CHANGE_DIR = "Could not change directory.\n";
const char *const MSG_ERROR_DIRECTORY  =
    "tide does not support encrypting directories.\n";
const char *const MSG_ERROR_READ       =
    "group does not have permission to read this file.\n";
const char *const MSG_ERROR_WRITE      =
    "group does not have permission to write here.\n";
const char *const MSG_ERROR_RESERVED   =
    "'.' and '..' are reserved filenames, please search for something else.\n";

/////////////////////////////////// SUBSET 0 ///////////////////////////////////

// Print the name of the current directory the program is operating in.
void print_current_directory(void) {
    char pathname[MAX_PATH_LEN]; 

    // Gets the current working directory through the pathname 
    // and the size of the pathname array and sees if it's NULL
    if (getcwd(pathname, sizeof pathname) != NULL) {

        // Prints the line and what the current directory is.
        printf("The current directory is: %s\n", pathname);  
    }
}

// Change the current directory to the given pathname. 
void change_current_directory(char *directory) {
    // Changes the current directory to the one inputted
    if (chdir(directory) == 0) {
        printf("Moving to %s\n", directory);

        // If the input was '~', goes to the home directory path
    } else if (directory[0] == '~') {
        const char *home = getenv("HOME");
        
        // If the change to home was successful
        if (chdir(home) == 0) {
            printf("Moving to %s\n", home);
        }
    } else {
        // Prints an error message if the directory didn't change.
        printf("%s", MSG_ERROR_CHANGE_DIR);
    }

}

// Lists all the files and folders in the current directory with 
// their permissions, sorted into alphabetical order.
void list_current_directory(void) {   
    // Creates a pointer to a char array of the filenames 
    char *files[MAX_LISTINGS];
    int num_entries = 0;

    // Opens the current directory
    DIR *dir = opendir(".");
    if (dir) {
        struct dirent *entry;
        // Reads all the entries in the directory
        while ((entry = readdir(dir)) != NULL) {
            // Stores all filenames into the array 
            // and increases the entry's amount counter
            if (num_entries < MAX_LISTINGS) {
                files[num_entries] = strdup(entry->d_name);
                num_entries++;
            }
        }
        // Close directory
        closedir(dir);
    }

    // If there are entries, sorts them into alphabetical order.
    if (num_entries > 0) {
        // Sort the filenames
        sort_strings(files, num_entries);

        // Gets the current directory path
        char current_directory[MAX_PATH_LEN];
        if (getcwd(current_directory, sizeof(current_directory)) == NULL) {
            perror("getcwd");
            exit(EXIT_FAILURE);
        }

        // Print the sorted alphabetical list with directory and file permissions
        for (int i = 0; i < num_entries; i++) {
            print_file_info(current_directory, files[i], files[i]);   
        }
    }
}

// A function for printing file permissions and other information of a file.
// Used in the functions:
//      - list_current_directory
//      - search_by_filename
void print_file_info(const char *current_directory, const char *filename,
                     const char *print_name) {
    // Creates a file path in an array
    char file_path[MAX_PATH_LEN];
    snprintf(file_path, sizeof(file_path), "%s/%s", current_directory, filename);

    // Struct for storing the file information
    struct stat file_stat;

    // The retrieval of the file information
    if (stat(file_path, &file_stat) == -1) {
        perror(file_path);
        printf(MSG_ERROR_FILE_STAT);
        exit(EXIT_FAILURE);
    }

    // Check if it's a directory or a regular file
    char *file_type = (S_ISDIR(file_stat.st_mode)) ? "d" : "-";
    
    // Checks user permissions
    char user_perms[4];
    user_perms[0] = (file_stat.st_mode & S_IRUSR) ? 'r' : '-';
    user_perms[1] = (file_stat.st_mode & S_IWUSR) ? 'w' : '-';
    user_perms[2] = (S_ISDIR(file_stat.st_mode) && (file_stat.st_mode & S_IXUSR)) ? 'x' : '-';
    user_perms[3] = '\0';

    // Checks group permissions
    char group_perms[4];
    group_perms[0] = (file_stat.st_mode & S_IRGRP) ? 'r' : '-';
    group_perms[1] = (file_stat.st_mode & S_IWGRP) ? 'w' : '-';
    group_perms[2] = (S_ISDIR(file_stat.st_mode) && (file_stat.st_mode & S_IXGRP)) ? 'x' : '-';
    group_perms[3] = '\0';

    // Checks other permissions
    char other_perms[4];
    other_perms[0] = (file_stat.st_mode & S_IROTH) ? 'r' : '-';
    other_perms[1] = (file_stat.st_mode & S_IWOTH) ? 'w' : '-';
    other_perms[2] = (S_ISDIR(file_stat.st_mode) && (file_stat.st_mode & S_IXOTH)) ? 'x' : '-';
    other_perms[3] = '\0';

    // Prints all the file information in the right format
    if (strcmp(filename, print_name) == 0) {
        printf("%s%s%s%s\t%s\n", file_type, user_perms, group_perms, other_perms, filename);
    } else {
        printf("%s%s%s%s\t%s\n", file_type, user_perms, group_perms, other_perms, print_name);
    }

    
}

/////////////////////////////////// SUBSET 1 ///////////////////////////////////

// Check whether the file meets the criteria to be encrypted.
bool is_encryptable(char *filename) {
    struct stat file_stat;
    char copy_filename[PATH_MAX];

    // Makes a copy of filename to avoid making changes to it
    strcpy(copy_filename, filename);

    // Checks if the file can be stat
    if (stat(copy_filename, &file_stat) != 0) {
        printf("%s", MSG_ERROR_FILE_STAT);
        return false;
    }
    // Checks if the file is a regular file
    if (!S_ISREG(file_stat.st_mode)) {
        printf("%s", MSG_ERROR_DIRECTORY);
        return false;
    }
    // Checks if the group has read permission
    if (!(file_stat.st_mode & S_IRGRP)) {
        printf("%s", MSG_ERROR_READ);
        return false;
    }
    // Gets the target directory
    char target_directory[PATH_MAX];
    strncpy(target_directory, filename, PATH_MAX);
    char *last_slash = strrchr(target_directory, '/');
    if (last_slash != NULL) {
        *last_slash = '\0';
    } else {
        // If no '/', use the current working directory
        getcwd(target_directory, PATH_MAX);
    } 

    // Check if the group has write permission in the target directory
    if (!(file_stat.st_mode & S_IWGRP)) {
        printf("%s", MSG_ERROR_WRITE);
        return false;
    } 

    // All conditions met, the file is encryptable
    return true;
}

// XOR the contents of the given file with a set key, and write the result to
// a new file.
void xor_file_contents(char *src_filename, char *dest_filename) {
    // Opens the source file in binary read mode
    FILE *src_file = fopen(src_filename, "rb");
    // Prints error message if file can't be opened
    if (src_file == NULL) {
        printf(MSG_ERROR_FILE_OPEN);
        return;
    }

    // Opens the destination file in binary write mode
    FILE *dest_file = fopen(dest_filename, "wb");
    // Prints error message if file can't be opened
    if (dest_file == NULL) {
        printf(MSG_ERROR_FILE_OPEN);
        fclose(src_file);
        return;
    }

    int byte;
    // Reads all the bytes until the end of the file
    while ((byte = fgetc(src_file)) != EOF) {
        // XOR each byte with XOR_BYTE_VALUE
        byte ^= XOR_BYTE_VALUE;

        // Writes the result to the destination file
        fputc(byte, dest_file);
    }
    // Close both files
    fclose(src_file);
    fclose(dest_file);
}

/////////////////////////////////// SUBSET 2 ///////////////////////////////////

// Search the current directory and its subdirectories for filenames containing
// the search string.
void search_by_filename(char *search_string) {
    // Checks for reserved filenames
    if (strcmp(search_string, ".") == 0 || strcmp(search_string, "..") == 0) {
        printf("%s", MSG_ERROR_RESERVED);
        return;
    }
    char *matches[MAX_LISTINGS];
    int match_count = 0;

    // Start the search from the current working directory
    search_by_filename_recursive(search_string, ".", matches, &match_count);

    if (match_count > 0) {
        // Sort the matched file paths into alphabetical order
        sort_strings(matches, match_count);
        
        // Prints how many files have the input in its name
        printf("Found in %d filename%s.\n", match_count, (match_count > 1) ? "s" : "");

        // Prints the files and its permissions with the input
        // in its name until the match count is met
        for (int i = 0; i < match_count; i++) {
            print_file_info(".", matches[i], matches[i]);
            free(matches[i]);
        }
    } else {
        // Print if no files match the input
        printf("Found in 0 filenames.\n");
    }
}

// A recursive function which checks for files in the selected directory
// and its subdirectories based off an inputted search string. 
// The amount matched are then returned.
void search_by_filename_recursive(char *search_string, char *current_path,
                                  char *matches[], int *match_count) {
    DIR *dir;
    struct dirent *entry;

    // Opens the selected directory
    if ((dir = opendir(current_path)) == NULL) {
        perror("opendir");
        return;
    }

    while ((entry = readdir(dir)) != NULL) {
        // Checks if the entry is not "." and ".."
        if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
            // Constructs full path of the entry
            char entry_path[MAX_PATH_LEN];
            snprintf(entry_path, MAX_PATH_LEN, "%s/%s", current_path, entry->d_name);

            // Checks if the entry is a directory
            struct stat directory;
            if (stat(entry_path, &directory) == 0 && S_ISDIR(directory.st_mode)) {
                // Recursively search subdirectories
                search_by_filename_recursive(search_string, entry_path, matches, match_count);
            }

            // Checks if the entry's name contains the search string
            if (strstr(entry->d_name, search_string) != NULL) {
                // Allocates memory for the matched file path and copies it
                matches[*match_count] = strdup(entry_path);
                (*match_count)++;
            }
        }
    }
    // Closes the selected directory
    closedir(dir);
}


// Search the current directory and its subdirectories for files containing the
// provided search bytes.
void search_by_content(char *search_bytes, int size) {
    content_result *results[MAX_LISTINGS];
    int result_count = 0;

    // Start the search in the current working directory
    search_content_recursive(".", search_bytes, size, results, &result_count);

    // Sort the results and print them
    sort_content_results(results, result_count);

    if (result_count > 0) {
        // Prints how many files the content was found in
        printf("Found in %d file%s.\n", result_count, result_count == 1 ? "" : "s");
        for (int i = 0; i < result_count; i++) {
            printf("%d: %s\n", results[i]->matches, results[i]->filename);
            free(results[i]->filename);
            free(results[i]);
        }
    } else {
        printf("Found in 0 files.\n");
    }
}

// Search the current directory and its subdirectories for files containing the
// provided search bytes from a provided file. 
void search_from_file(const char *file_path) {

    // Opens the file in read mode
    FILE *file = fopen(file_path, "r");
    if (file == NULL) {
        perror("fopen");
        return;
    }

    char search_bytes[256];
    while (fgets(search_bytes, sizeof(search_bytes), file) != NULL) {
        // Remove newline character from input
        char *newline = strchr(search_bytes, '\n');
        if (newline != NULL) {
            *newline = '\0';
        }
        // Searches the content of the opened file in other files 
        search_by_content(search_bytes, strlen(search_bytes));
    }

    fclose(file);
}

// A recursive function which checks for files in the selected directory
// and its subdirectories based off an inputted search string. 
// The amount matched are then returned.
void search_content_recursive(const char *dir_path, const char *search_bytes,
                              int size, content_result *results[], int *result_count) {
    DIR *dir = opendir(dir_path);
    if (dir == NULL) {
        perror("opendir");
        return;
    }

    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_type == DT_DIR) {
            // Ignore "." and ".." directories
            if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
                char sub_dir_path[PATH_MAX];
                snprintf(sub_dir_path, PATH_MAX, "%s/%s", dir_path, entry->d_name);
                search_content_recursive(sub_dir_path, search_bytes, size, results, result_count);
            }
        } else if (entry->d_type == DT_REG) {
            // Check if the file content contains the search bytes
            char file_path[PATH_MAX];
            snprintf(file_path, PATH_MAX, "%s/%s", dir_path, entry->d_name);

            FILE *file = fopen(file_path, "rb");
            if (file != NULL) {
                int matches = count_content_matches(file, search_bytes, size);
                fclose(file);
                if (matches > 0) {
                    content_result *result = malloc(sizeof(content_result));
                    if (result != NULL) {
                        result->matches = matches;

                        // Allocate memory for filename and copy the file path
                        result->filename = malloc(strlen(file_path) + 1);
                        if (result->filename != NULL) {
                            strcpy(result->filename, file_path);
                            results[(*result_count)++] = result;
                        } else {
                            free(result);
                        }
                    }
                }
            } else {
                perror("fopen");
            }
        }
    }

    closedir(dir);
}

// counts how many matches are found of the content
int count_content_matches(FILE *file, const char *search_bytes, int size) {
    // Check if the file pointer is valid
    if (file == NULL) {
        perror("fopen");
        return -1; // Return an error code
    }

    int matches = 0;
    char buffer[size];

    // Read the file content in chunks
    size_t bytes_Read;
    while ((bytes_Read = fread(buffer, 1, size, file)) == size) {
        // Compare the read chunk with the search bytes
        if (memcmp(buffer, search_bytes, size) == 0) {
            matches++;
        }

        // Move the file pointer back by size bytes to overlap matches
        fseek(file, -bytes_Read + 1, SEEK_CUR);
    }

    return matches;
}

/////////////////////////////////// SUBSET 3 ///////////////////////////////////

char *shift_encrypt(char *plaintext, char password[CIPHER_BLOCK_SIZE]) {
    char *ciphertext = malloc(CIPHER_BLOCK_SIZE);
    for (int i = 0; i < CIPHER_BLOCK_SIZE; i++) {
        ciphertext[i] = (plaintext[i] << (password[i] % 8)) | (plaintext[i] >> (8 - (password[i] % 8)));
    }
    return ciphertext;
}

char *shift_decrypt(char *ciphertext, char password[CIPHER_BLOCK_SIZE]) {
    char *plaintext = malloc(CIPHER_BLOCK_SIZE);
    for (int i = 0; i < CIPHER_BLOCK_SIZE; i++) {
        plaintext[i] = (ciphertext[i] >> (password[i] % 8)) | (ciphertext[i] << (8 - (password[i] % 8)));
    }
    return plaintext;
}

void ecb_encryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    FILE *inputFile, *outputFile;
    inputFile = fopen(filename, "rb");
    if (inputFile == NULL) {
        perror("Error opening input file");
        return;
    }

    // Construct the destination filename
    char outputFilename[MAX_PATH_LEN];
    snprintf(outputFilename, MAX_PATH_LEN, "%s.ecb", filename);

    outputFile = fopen(outputFilename, "wb");
    if (outputFile == NULL) {
        perror("Error opening output file");
        fclose(inputFile);
        return;
    }

    // Process the file in blocks of 16 bytes
    char plaintext[CIPHER_BLOCK_SIZE];
    char *ciphertext;

    while (fread(plaintext, 1, CIPHER_BLOCK_SIZE, inputFile) == CIPHER_BLOCK_SIZE) {
        ciphertext = shift_encrypt(plaintext, password);
        fwrite(ciphertext, 1, CIPHER_BLOCK_SIZE, outputFile);
        free(ciphertext);
    }

    // Close files
    fclose(inputFile);
    fclose(outputFile);
}

void ecb_decryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    FILE *inputFile, *outputFile;
    inputFile = fopen(filename, "rb");
    if (inputFile == NULL) {
        perror("Error opening input file");
        return;
    }

    // Construct the destination filename
    char outputFilename[MAX_PATH_LEN];
    snprintf(outputFilename, MAX_PATH_LEN, "%s.dec", filename);

    outputFile = fopen(outputFilename, "wb");
    if (outputFile == NULL) {
        perror("Error opening output file");
        fclose(inputFile);
        return;
    }

    // Process the file in blocks of 16 bytes
    char ciphertext[CIPHER_BLOCK_SIZE];
    char *plaintext;

    while (fread(ciphertext, 1, CIPHER_BLOCK_SIZE, inputFile) == CIPHER_BLOCK_SIZE) {
        plaintext = shift_decrypt(ciphertext, password);
        fwrite(plaintext, 1, CIPHER_BLOCK_SIZE, outputFile);
        free(plaintext);
    }

    // Close files
    fclose(inputFile);
    fclose(outputFile);
}

/////////////////////////////////// SUBSET 4 ///////////////////////////////////

void cbc_encryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    printf("TODO: COMPLETE ME");
}

void cbc_decryption(char *filename, char password[CIPHER_BLOCK_SIZE]) {
    printf("TODO: COMPLETE ME");
}

/////////////////////////////////// PROVIDED ///////////////////////////////////
// Some useful provided functions. Do NOT modify.

// Sort an array of strings in alphabetical order.
// strings:  the array of strings to sort
// count:    the number of strings in the array
// This function is to be provided to students.
void sort_strings(char *strings[], int count) {
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < count; j++) {
            if (strcmp(strings[i], strings[j]) < 0) {
                char *temp = strings[i];
                strings[i] = strings[j];
                strings[j] = temp;
            }
        }
    }
}

// Sort an array of content_result_t in descending order of matches.
// results:  the array of pointers to content_result_t to sort
// count:    the number of pointers to content_result_t in the array
// This function is to be provided to students.
void sort_content_results(content_result *results[], int count) {
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < count; j++) {
            if (results[i]->matches > results[j]->matches) {
                content_result *temp = results[i];
                results[i] = results[j];
                results[j] = temp;
            } else if (results[i]->matches == results[j]->matches) {
                // If the matches are equal, sort alphabetically.
                if (strcmp(results[i]->filename, results[j]->filename) < 0) {
                    content_result *temp = results[i];
                    results[i] = results[j];
                    results[j] = temp;
                }
            }
        }
    }
}

// Generate a random string of length RAND_STR_LEN.
// Requires a seed for the random number generator.
// The same seed will always generate the same string.
// The string contains only lowercase + uppercase letters,
// and digits 0 through 9.
// The string is returned in heap-allocated memory,
// and must be freed by the caller.
char *generate_random_string(int seed) {
    if (seed != 0) {
        srand(seed);
    }
    char *alpha_num_str =
        "abcdefghijklmnopqrstuvwxyz"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "0123456789";

    char *random_str = malloc(RAND_STR_LEN);

    for (int i = 0; i < RAND_STR_LEN; i++) {
        random_str[i] = alpha_num_str[rand() % (strlen(alpha_num_str) - 1)];
    }

    return random_str;
}
