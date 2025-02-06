// COMP1521 22T2 ... final exam, question 5

#include <stdio.h>

void print_bytes(FILE *file, long n) {
	int i;

	// If n is positive or 0
	if (n >= 0) {
		// Checks that not all number of bytes have been read
		// or have reached end of file
		while ((n-- > 0) && (i = fgetc(file)) != EOF) {
			// prints char to stdout
			putchar(i);
		}
	} else {
		// Moves to the position n bytes from the end of the file
		fseek(file, n, SEEK_END);
		// Finds the current position and saves it in the offset
		long offset = ftell(file);
		// Rewinds back to the beginning of the file
		rewind(file);
		// can also do this: 
		// fseek(file, 0, SEEK_SET)

		// Checks that not all offset number of bytes have been read
		// or reached end of file
		while (offset-- > 0 && (i = fgetc(file)) != EOF) {
			putchar(i);
		}
		
	}
}


FILE *file = fopen(argv[1], "r");

int byte;
while ((byte = fgetc(file)) != EOF) {
	// do stuff, like printing the byte
	putchar(byte);
}

long position = ftell(file);

fseek(file, position, SEEK_SET);


rewind(file);

fputc(byte, file);

char *data = malloc(101 * sizeof(char));
size_t read_values = fread(data, sizeof(int), 100, file);

size_t written_values = fwrite(data, sizeof(int), 100, file);

char *string = fgets()

char *data = malloc(100 * sizeof(char));
while (fgets(data, 100, file) != NULL) {
	// will do something
}

fprintf(file, "Integer: %d\n", 100);

int integer;
fscanf(file, "Integer again: %d\n", &integer);

const char *input = "28";
sscanf(input, "%d", &x);

char data[100];
snprintf(data, 100, "Integer: %d", x);

int num = atoi(string);

char *environment = getenv("HOME");

setenv("HOME", "1234", 1);

// Adds/modifies a environemt variable
putenv("NEW_VAR=345");
// Removes environment variable
unset("NEW_VAR");
// Clear all environment variables
clearenv();



#include <dirent.h>
#include <stdio.h>

int main() {
	// Making a new directory
	// 1. name of the new dir
	// 2. Mode permissions (d rwx r-x r-x)
	// (d for directory, - for file)
	mkdir("newdir", 0755);

	// Opens a directory, store in *dir
    DIR *dir = opendir(".");

	// struct dirent *readdir(DIR *dirp);
    struct dirent *entry;

    if (dir) {
        while ((entry = readdir(dir)) != NULL) {
            printf("%s\n", entry->d_name);
        }
        closedir(dir);  // Close the directory when finished
    }
    return 0;
}

