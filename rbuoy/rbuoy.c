////////////////////////////////////////////////////////////////////////
// COMP1521 24T2 --- Assignment 2: `rbuoy', a simple file synchroniser
// <https://cgi.cse.unsw.edu.au/~cs1521/24T2/assignments/ass2/index.html>
//
// Written by Caitlin Wong (z5477471) on 26/07/2024.
// This program copies and sends a file to a different 'computer' 
// but takes in regard any identical elements and only sends 
// the elements changed.
//
// 2023-07-12   v1.0    Team COMP1521 <cs1521 at cse.unsw.edu.au>


#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <math.h>

#include "rbuoy.h"

// Extra Constants
const char *const MSG_ERROR_FILE_OPEN  = "ERROR: Could not open file.\n";
const char *const MSG_ERROR_FILE_STAT  = "ERROR: Could not stat file.\n";
const char *const INVALID_FILE  = "ERROR: Invalid file.\n";
const char *const RECORDS_ERROR  = "ERROR: Could not read number of records.\n";
const char *const BYTES_READ_ERROR  = "ERROR: Failed to read bytes\n";
const char *const INVALID_PATHNAME_LEN  = "ERROR: Invalid pathname length.\n";
const char *const INVALID_NUM_BLOCKS  = "ERROR: Invalid number of blocks.\n";

// Extra Function prototypes
void process_pathname(char *pathname, FILE *out_path);
void le_2byte(FILE *file, uint16_t value);
void le_3byte(FILE *file, uint32_t value);
void check_extra_bytes(FILE *in_path);
void process_tbbi(FILE *out_path, FILE *in_path);
void tbbi_hashes(char *pathname, uint32_t num_blocks, 
                 FILE *in_path, unsigned char *matches);
char *process_path(FILE *out_path, FILE *in_path);
int read_3_bytes(FILE *in_path);
uint8_t *process_matches_updates(char *pathname, FILE *out_path, 
                                 FILE *in_path, int num_blocks);
uint32_t filesize_mode(char *pathname, FILE *out_path);
FILE *process_updates(char *pathname, int num_blocks, uint8_t *matches, 
                     FILE *out_path, uint32_t file_size);
char *read_pathname(FILE *in_path);
FILE *create_file(char *pathname, int file_size);
void apply_updates(FILE *in_path, FILE *file);
void get_file_mode(mode_t st_mode, char mode[MODE_SIZE]);
void set_file_mode(char *pathname, char mode[MODE_SIZE]);


/// @brief Create a TABI file from an array of pathnames.
/// @param out_pathname A path to where the new TABI file should be created.
/// @param in_pathnames An array of strings containing, in order, the files
//                      that should be placed in the new TABI file.
/// @param num_in_pathnames The length of the `in_pathnames` array. In
///                         subset 5, when this is zero, you should include
///                         everything in the current directory.
void stage_1(char *out_pathname, char *in_pathnames[], size_t num_in_pathnames) {
    // Open the out_file in binary write form
    FILE *out_path = fopen(out_pathname, "wb");

    if (out_path == NULL) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    // Write "TABI" magic number
    fwrite(TYPE_A_MAGIC, 1, MAGIC_SIZE, out_path);

    // Write number of records
    fputc((unsigned char)num_in_pathnames, out_path);

    // Process each input pathname
    for (size_t i = 0; i < num_in_pathnames; i++) {
        char *pathname = in_pathnames[i];
        process_pathname(pathname, out_path);  
    }
    fclose(out_path);
}

/// @brief Process a given pathname's length, its 
//         number of blocks and hashes of a record
/// @param pathname The pathname of the file of a record
/// @param out_path The path to where the new TABI file is to be created
void process_pathname(char *pathname, FILE *out_path) {
    size_t pathname_len = strlen(pathname);
    struct stat st;

    // Write pathname & its length to out_path
    le_2byte(out_path, (uint16_t)pathname_len);
    fwrite(pathname, 1, pathname_len, out_path);

    // Check if the file was correctly stat
    if (stat(pathname, &st) != 0) {
        fprintf(stderr, MSG_ERROR_FILE_STAT);
        exit(1);
    }

    size_t file_size = st.st_size;
    size_t num_blocks = number_of_blocks_in_file(file_size);

    // Write the number of blocks
    le_3byte(out_path, (uint32_t)num_blocks);

    // Open the input file in binary read format
    FILE *in_file = fopen(pathname, "rb");
    if (in_file == NULL) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    // Computes the hashes for each block
    for (size_t block = 0; block < num_blocks; block++) {
        unsigned char buffer[BLOCK_SIZE];
        size_t bytes_read = fread(buffer, 1, BLOCK_SIZE, in_file);

        uint64_t hash = hash_block((char *)buffer, bytes_read);

        for (int j = 0; j < 8; j++) {
            fputc((hash >> (8 * j)) & 0xFF, out_path);
        }
    }

    fclose(in_file);
}

// Writes a given value of 2-bytes as a 16-bit, little-endian 
void le_2byte(FILE *file, uint16_t value) {
    fputc(value & 0xFF, file);
    fputc((value >> 8) & 0xFF, file);
}

// Writes a given value of 3-bytes as a 24-bit, little-endian
void le_3byte(FILE *file, uint32_t value) {
    fputc(value & 0xFF, file);
    fputc((value >> 8) & 0xFF, file);
    fputc((value >> 16) & 0xFF, file);
}

// Checks if a given character is [a-zA-Z0-9.-_]
bool is_valid_char(char c) {
    return ((c >= 'a' && c <= 'z') ||
            (c >= 'A' && c <= 'Z') ||
            (c >= '0' && c <= '9') ||
            c == '.' || c == '-' || c == '_');
}

// Checks if a path's name is valid 
bool is_valid_pathname(char *pathname, size_t length) {
    for (size_t i = 0; i < length; i++) {
        if (!is_valid_char(pathname[i])) {
            return false;
        }
    }
    return true;
}

/// @brief Create a TBBI file from a TABI file.
/// @param out_pathname A path to where the new TBBI file should be created.
/// @param in_pathname A path to where the existing TABI file is located.
void stage_2(char *out_pathname, char *in_pathname) {
    // Open the out_file and in_path files
    FILE *out_path = fopen(out_pathname, "wb");
    FILE *in_path = fopen(in_pathname, "rb");
    if (out_path == NULL || in_path == NULL) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    // Write "TBBI" magic number
    fwrite(TYPE_B_MAGIC, 1, MAGIC_SIZE, out_path);

    // Read and verify "TABI" magic number
    char magic[MAGIC_SIZE];
    fread(magic, 1, MAGIC_SIZE, in_path);
    if (strncmp(magic, TYPE_A_MAGIC, MAGIC_SIZE) != 0) {
        fprintf(stderr, INVALID_FILE);
        exit(1);
    }

    // Read and write the number of records from TABI to TBBI
    int num_records = fgetc(in_path);
    if (num_records == EOF) {
        fprintf(stderr, RECORDS_ERROR);
        exit(1);
    }
    fputc((unsigned char)num_records, out_path);

    // Process each record
    for (int i = 0; i < num_records; i++) {
        process_tbbi(out_path, in_path);
    }

    // Error checking if there are still any bytes left
    check_extra_bytes(in_path);
    fclose(in_path);
    fclose(out_path);
}

/// @brief Checks the end of a given file to see if any extra 
///        bytes are left over which haven't been read.
/// @param in_path The path to the file which is going to be read
void check_extra_bytes(FILE *in_path) {
    long current_position = ftell(in_path);
    fseek(in_path, 0, SEEK_END);
    long end_position = ftell(in_path);
    fseek(in_path, current_position, SEEK_SET);

    if (current_position < end_position) {
        fprintf(stderr, "ERROR: Extra bytes detected.\n");
        exit(1);
    }
}

/// @brief Process a given pathname's length, its 
//         number of blocks and matches of a TABI file
/// @param out_path The path to where the new TBBI file is to be created
/// @param in_path The path to the TABI file which is going to be read
void process_tbbi(FILE *out_path, FILE *in_path) {
    // Read the pathname length
    int byte1 = fgetc(in_path);
    int byte2 = fgetc(in_path);
    if (byte1 == EOF || byte2 == EOF) {
        fprintf(stderr, BYTES_READ_ERROR);
        exit(1);
    }

    uint16_t pathname_len = (uint16_t)byte1 | ((uint16_t)byte2 << 8);
    if (pathname_len <= 0) {
        fprintf(stderr, INVALID_PATHNAME_LEN);
        exit(1);
    }

    // Allocate space for pathname and read it
    char *pathname = malloc(pathname_len + 1);
    fread(pathname, 1, pathname_len, in_path);
    pathname[pathname_len] = '\0';
    if (strlen(pathname) != pathname_len) {
        fprintf(stderr, "ERROR: Bad pathname.\n");
        exit(1);
    }

    // Read the number of blocks
    uint32_t num_blocks = fgetc(in_path);
    num_blocks |= fgetc(in_path) << 8;
    num_blocks |= fgetc(in_path) << 16;
    if (num_blocks < 0 || num_blocks > 16777215) {
        fprintf(stderr, INVALID_NUM_BLOCKS);
        exit(1);
    }

    // Calculate the number of match bytes and allocate memory for matches
    size_t num_match_bytes = num_tbbi_match_bytes(num_blocks);
    unsigned char *matches = calloc(num_match_bytes, sizeof(unsigned char));

    // Compute hashes from TABI file and write corresponding bit
    tbbi_hashes(pathname, num_blocks, in_path, matches);

    // Write pathname length, pathname, number of blocks and matches
    le_2byte(out_path, pathname_len);
    fwrite(pathname, 1, pathname_len, out_path);
    le_3byte(out_path, num_blocks);
    fwrite(matches, 1, num_match_bytes, out_path);

    free(pathname);
    free(matches);
}

/// @brief Computes the hashes of a TABI file and writes a 
//         corresponding bit to a TBBI file depending on its updates.
/// @param pathname The pathname of the file of a record
/// @param num_blocks The number of blocks in the sender's version of the file
/// @param in_path The path to the TABI file which is going to be read
/// @param matches Sequence of bits for each TABI hash in the file
void tbbi_hashes(char *pathname, uint32_t num_blocks, 
                 FILE *in_path, unsigned char *matches) {
    FILE *file = fopen(pathname, "rb");

    for (size_t block = 0; block < num_blocks; block++) {
        // Read the hash from the TABI file
        uint64_t tabi_hash = 0;
        for (int j = 0; j < 8; j++) {
            tabi_hash |= ((uint64_t)fgetc(in_path)) << (8 * j);
        }

        if (file != NULL) {
            // Read the block from the input file
            unsigned char buffer[BLOCK_SIZE];
            size_t bytes_read = fread(buffer, 1, BLOCK_SIZE, file);

            // Compute the hash
            uint64_t file_hash = hash_block((char *)buffer, bytes_read);

            // Compare hashes and set the corresponding bit in matches
            if (file_hash == tabi_hash) {
                matches[block / 8] |= 1 << (7 - (block % 8));
            }
        }
    }

    if (file != NULL) {
        fclose(file);
    }
}


/// @brief Create a TCBI file from a TBBI file.
/// @param out_pathname A path to where the new TCBI file should be created.
/// @param in_pathname A path to where the existing TBBI file is located.
void stage_3(char *out_pathname, char *in_pathname) {
    // Open the out_file and in_file for processing
    FILE *out_path = fopen(out_pathname, "wb");
    FILE *in_path = fopen(in_pathname, "rb");
    if (out_path == NULL || in_path == NULL) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    // Write "TCBI" magic number
    fwrite(TYPE_C_MAGIC, 1, MAGIC_SIZE, out_path);

    // Read and verify "TBBI" magic number
    char magic[MAGIC_SIZE];
    fread(magic, 1, MAGIC_SIZE, in_path);
    if (strncmp(magic, TYPE_B_MAGIC, MAGIC_SIZE) != 0) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    // Read and write the number of records
    int num_records = fgetc(in_path);
    if (num_records == EOF) {
        fprintf(stderr, RECORDS_ERROR);
        exit(1);
    }
    fputc((unsigned char)num_records, out_path);

    // Process each record
    for (int i = 0; i < num_records; i++) {
        char *pathname = process_path(out_path, in_path);
        uint32_t file_size = filesize_mode(pathname, out_path);
        int num_blocks = read_3_bytes(in_path);
        uint8_t *matches = process_matches_updates(pathname, out_path, 
                                                   in_path, num_blocks);

        FILE *file = process_updates(pathname, num_blocks, matches, 
                                     out_path, file_size);

        free(matches);
        free(pathname);
        fclose(file);
    }

    // Error checking if there are still any bytes left
    check_extra_bytes(in_path);
    fclose(in_path);
    fclose(out_path);
}

/// @brief Gets the pathname and its length from a TBBI file and 
///        writes it to a new TCBI file.
/// @param out_path A path to where the new TCBI file should be created.
/// @param in_path A path to where the existing TBBI file is located.
char *process_path(FILE *out_path, FILE *in_path) {
    // Read the pathname length
    int byte1 = fgetc(in_path);
    int byte2 = fgetc(in_path);
    if (byte1 == EOF || byte2 == EOF) {
        fprintf(stderr, BYTES_READ_ERROR);
        exit(1);
    }
    uint16_t pathname_len = (uint16_t)byte1 | ((uint16_t)byte2 << 8);

    if (pathname_len <= 0) {
        fprintf(stderr, INVALID_PATHNAME_LEN);
        exit(1);
    }

    // Allocate space for pathname and read it
    char *pathname = malloc(pathname_len + 1);
    fread(pathname, 1, pathname_len, in_path);
    pathname[pathname_len] = '\0';

    if (strlen(pathname) != pathname_len) {
        fprintf(stderr, "ERROR: Bad pathname.\n");
        exit(1);
    }

    // Write the pathname length
    le_2byte(out_path, pathname_len);

    // Write the pathname
    fwrite(pathname, 1, pathname_len, out_path);

    return pathname;
}

/// @brief Reads 3 bytes as a 24-bit little-endian from a given path to a file
/// @param in_path A path to where the existing TBBI file is located.
int read_3_bytes(FILE *in_path) {
    // Reads 3 bytes, little-endian
    int byte1_b = fgetc(in_path);
    int byte2_b = fgetc(in_path);
    int byte3_b = fgetc(in_path);
    if (byte1_b == EOF || byte2_b == EOF || byte3_b == EOF) {
        fprintf(stderr, BYTES_READ_ERROR);
        exit(1);
    }

    int read_bytes = byte1_b | (byte2_b << 8) | (byte3_b << 16);
    return read_bytes;
}

/// @brief Reads the matches from the TBBI file, calculates the number of 
///        updates in the record and writes it to the TCBI file.
/// @param pathname The pathname of the file of a record
/// @param out_path A path to where the new TCBI file should be created.
/// @param in_path A path to where the existing TBBI file is located.
/// @param num_blocks The number of blocks in the TBBI file.
uint8_t *process_matches_updates(char *pathname, FILE *out_path, 
                                 FILE *in_path, int num_blocks) {
    size_t matches_len = num_tbbi_match_bytes(num_blocks);

    uint8_t *matches = malloc(matches_len);
    size_t bytes_read = fread(matches, 1, matches_len, in_path);

    if (num_blocks > 0 && bytes_read != matches_len) {
        fprintf(stderr, "ERROR: Can\'t read correct blocks.\n");
        exit(1);
    }

    uint32_t num_updates = 0;
    for (int j = 0; j < num_blocks; j++) {
        int byte_index = j / 8;
        int bit_index = j % 8;
        
        // Check if the bit at bit_index in matches[byte_index] is 0
        if ((matches[byte_index] & (1 << (7 - bit_index))) == 0) {
            num_updates++;
        }
    }

    // Process padding bits
    for (int j = num_blocks; j < ((num_blocks + 7) / 8) * 8; j++) {
        int byte_index = j / 8;
        int bit_index = j % 8;

        // Check if the bit at bit_index in matches[byte_index] is 1
        if ((matches[byte_index] & (1 << (7 - bit_index))) != 0) {
            fprintf(stderr, "ERROR: invalid padding detected\n");
            exit(1);
        }
    }

    // Write the number of updates
    le_3byte(out_path, num_updates);
    return matches;
}

/// @brief Computes the file size, type and permissions of the sender's file.
/// @param pathname The pathname of the file of a record
/// @param out_path A path to where the new TCBI file should be created.
uint32_t filesize_mode(char *pathname, FILE *out_path) {
    // Stats the file
    struct stat file_stat;
    if (stat(pathname, &file_stat) == -1) {
        fprintf(stderr, MSG_ERROR_FILE_STAT);
        free(pathname);
        exit(1);
    } 

    // Finds the mode of the file
    char mode[MODE_SIZE];
    get_file_mode(file_stat.st_mode, mode);

    // Write the mode
    fwrite(mode, 1, MODE_SIZE, out_path);

    // Write the file size
    uint32_t file_size = file_stat.st_size;
    fwrite(&file_size, sizeof(file_size), 1, out_path);

    return file_size;
}

/// @brief Processes the updates of each record and writes the block index, 
///        update length and update data of the record.
/// @param pathname The pathname of the file of a record
/// @param num_blocks The number of blocks in the TBBI file.
/// @param matches Sequence of bits that shows the identical/different 
///                versions of the file
/// @param out_path A path to where the new TCBI file should be created.
/// @param file_size THe size of the sender;s version of the file in bytes.
FILE *process_updates(char *pathname, int num_blocks, uint8_t *matches, 
                      FILE *out_path, uint32_t file_size) {
    // Open the corresponding file based on the pathname in the TBBI record
    FILE *file = fopen(pathname, "rb");
    if (file == NULL) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    // Process each update
    for (int j = 0, update_index = 0; j < num_blocks; j++) {
        int byte_index = j / 8;
        int bit_index = j % 8;
        if ((matches[byte_index] & (1 << (7 - bit_index))) == 0) {
            // Write the block index
            le_3byte(out_path, j);

            // Calculate the update length
            uint16_t update_length = (j == num_blocks - 1) 
                                     ? (file_size % 256) : 256;
            if (update_length == 0) {
                update_length = 256;
            }

            // Write the update length
            le_2byte(out_path, update_length);

            // Allocate space for the update data and read it from the file
            uint8_t *update_data = malloc(update_length);
            fseek(file, j * 256, SEEK_SET);
            fread(update_data, 1, update_length, file);

            // Write the update data
            fwrite(update_data, 1, update_length, out_path);

            free(update_data);
            update_index++;
        }
    }
    return file;
}

// Function to get file mode as a 10-character string
void get_file_mode(mode_t st_mode, char mode[MODE_SIZE]) {
    mode[0] = (S_ISDIR(st_mode)) ? 'd' : '-';
    mode[1] = (st_mode & S_IRUSR) ? 'r' : '-';
    mode[2] = (st_mode & S_IWUSR) ? 'w' : '-';
    mode[3] = (st_mode & S_IXUSR) ? 'x' : '-';
    mode[4] = (st_mode & S_IRGRP) ? 'r' : '-';
    mode[5] = (st_mode & S_IWGRP) ? 'w' : '-';
    mode[6] = (st_mode & S_IXGRP) ? 'x' : '-';
    mode[7] = (st_mode & S_IROTH) ? 'r' : '-';
    mode[8] = (st_mode & S_IWOTH) ? 'w' : '-';
    mode[9] = (st_mode & S_IXOTH) ? 'x' : '-';
}

/// @brief Apply a TCBI file to the filesystem.
/// @param in_pathname A path to where the existing TCBI file is located.
void stage_4(char *in_pathname) {
    // Open the TCBI file
    FILE *in_path = fopen(in_pathname, "rb");
    if (in_path == NULL) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    // Read the magic number
    char magic[MAGIC_SIZE];
    fread(magic, 1, MAGIC_SIZE, in_path);
    if (strncmp(magic, TYPE_C_MAGIC, MAGIC_SIZE) != 0) {
        fprintf(stderr, INVALID_FILE);
        exit(1);
    }

    // Read the number of records
    int num_records = fgetc(in_path);
    if (num_records == EOF) {
        fprintf(stderr, RECORDS_ERROR);
        exit(1);
    }

    // Process each record
    for (int i = 0; i < num_records; i++) {
        char *pathname = read_pathname(in_path);

        // Read the mode permissions
        char mode[MODE_SIZE];
        for (int j = 0; j < MODE_SIZE; j++) {
            mode[j] = fgetc(in_path);
        }

        // Read the file size
        int byte1_f = fgetc(in_path);
        int byte2_f = fgetc(in_path);
        int byte3_f = fgetc(in_path);
        int byte4_f = fgetc(in_path);
        if (byte1_f == EOF || byte2_f == EOF 
            || byte3_f == EOF || byte4_f == EOF) {
            fprintf(stderr, BYTES_READ_ERROR);
            exit(1);
        }
        int file_size = byte1_f | (byte2_f << 8) 
                        | (byte3_f << 16) | (byte4_f << 24);

        // Read number of updates
        int num_updates = read_3_bytes(in_path);
        // Create/open the file for updating
        FILE *file = create_file(pathname, file_size);

        // Apply updates to the file
        for (int j = 0; j < num_updates; j++) {
            apply_updates(in_path, file);  
        }

        // Close the file and set its mode
        fclose(file);
        set_file_mode(pathname, mode);
        free(pathname);
    }

    // Error checking if there are still any bytes left
    check_extra_bytes(in_path);
    fclose(in_path);
}

/// @brief Reads the pathname of a TCBI file
/// @param in_path A path to where the existing TCBI file is located.
char *read_pathname(FILE *in_path) {
    // Read the pathname lengtH
    int byte1 = fgetc(in_path);
    int byte2 = fgetc(in_path);
    if (byte1 == EOF || byte2 == EOF) {
        fprintf(stderr, BYTES_READ_ERROR);
        exit(1);
    }
    uint16_t pathname_len = (uint16_t)byte1 | ((uint16_t)byte2 << 8);

    if (pathname_len <= 0) {
        fprintf(stderr, INVALID_PATHNAME_LEN);
        exit(1);
    }

    // Allocate space for pathname and read it
    char *pathname = malloc(pathname_len + 1);
    fread(pathname, 1, pathname_len, in_path);
    pathname[pathname_len] = '\0';

    if (strlen(pathname) != pathname_len) {
        fprintf(stderr, "ERROR: Bad pathname.\n");
        exit(1);
    }

    return pathname;
}

/// @brief Creates/Opens the file that the TCBI file has a update for
/// @param pathname The pathname of the file of a record
/// @param file_size the size of a file specified in the TCBI record
FILE *create_file(char *pathname, int file_size) {
    // Open or create the file to be updated
    FILE *file = fopen(pathname, "r+b");
    if (file == NULL) {
        fprintf(stderr, MSG_ERROR_FILE_OPEN);
        exit(1);
    }

    struct stat file_stat;
    if (stat(pathname, &file_stat) == -1) {
        fprintf(stderr, MSG_ERROR_FILE_STAT);
        exit(1);
    }

    // Write the file size
    uint32_t fsize = file_stat.st_size;
    if (fsize != file_size) {
        if (ftruncate(fileno(file), file_size) == -1) {
            fprintf(stderr, "ERROR: Unable to truncate file.\n");
            exit(1);
        }
    }

    return file;
}

// Sets a speficied file's permissions as read from 
// the mode of the TCBI file
void set_file_mode(char *pathname, char mode[MODE_SIZE]) {
    mode_t st_mode = 0;
    st_mode |= (mode[0] == 'd') ? S_IFDIR : S_IFREG;
    st_mode |= (mode[1] == 'r') ? S_IRUSR : 0;
    st_mode |= (mode[2] == 'w') ? S_IWUSR : 0;
    st_mode |= (mode[3] == 'x') ? S_IXUSR : 0;
    st_mode |= (mode[4] == 'r') ? S_IRGRP : 0;
    st_mode |= (mode[5] == 'w') ? S_IWGRP : 0;
    st_mode |= (mode[6] == 'x') ? S_IXGRP : 0;
    st_mode |= (mode[7] == 'r') ? S_IROTH : 0;
    st_mode |= (mode[8] == 'w') ? S_IWOTH : 0;
    st_mode |= (mode[9] == 'x') ? S_IXOTH : 0;

    chmod(pathname, st_mode);
}

/// @brief Applies the updates specified in the TCBI update data
/// @param in_path A path to where the existing TCBI file is located.
/// @param file The specific file that needs to be updated
void apply_updates(FILE *in_path, FILE *file) {
    // Read block index
    int block_index = read_3_bytes(in_path);

    // Read update length
    int byte1_l = fgetc(in_path);
    int byte2_l = fgetc(in_path);
    if (byte1_l == EOF || byte2_l == EOF) {
        fprintf(stderr, BYTES_READ_ERROR);
        exit(1);
    }
    int update_length = byte1_l | (byte2_l << 8);

    // Allocate space for the update data and read it
    char *update_data = malloc(update_length);
    fread(update_data, 1, update_length, in_path);

    // Seeks correct block position in file and writes update data
    fseek(file, block_index * BLOCK_SIZE, SEEK_SET);
    fwrite(update_data, 1, update_length, file);

    free(update_data);
}