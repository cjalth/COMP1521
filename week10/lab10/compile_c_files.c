// compile .c files specified as command line arguments
//
// if my_program.c and other_program.c is speicified as an argument then the follow two command will be executed:
// /usr/local/bin/dcc my_program.c -o my_program
// /usr/local/bin/dcc other_program.c -o other_program
// Written by Caitlin Wong (z5477471) on the 29/07/2024

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spawn.h>
#include <sys/types.h>
#include <sys/wait.h>

#define DCC_PATH "/usr/local/bin/dcc"

extern char **environ;

int compile_c_file(const char *filename) {
    char *output_filename;
    posix_spawn_file_actions_t action;
    posix_spawn_file_actions_init(&action);

    size_t len = strlen(filename);
    output_filename = malloc(len);

    strncpy(output_filename, filename, len - 2);
    output_filename[len - 2] = '\0';

    const char *dcc_args[] = {DCC_PATH, filename, "-o", output_filename, NULL};

    printf("running the command: \"");
    printf("%s", dcc_args[0]);
    printf(" %s", dcc_args[1]);
    printf(" %s", dcc_args[2]);
    printf(" %s", dcc_args[3]);
    printf("\"\n");

    pid_t pid;
    if (posix_spawn(&pid, DCC_PATH, &action, NULL, (char *const *)dcc_args, environ) != 0) {
        perror("posix_spawn");
        free(output_filename);
        return EXIT_FAILURE;
    }

    int status;
    waitpid(pid, &status, 0);

    free(output_filename);

    if (WIFEXITED(status) && WEXITSTATUS(status) == EXIT_SUCCESS) {
        return EXIT_SUCCESS;
    } else {
        return EXIT_FAILURE;
    }
}

int main(int argc, char **argv) {

    for (int i = 1; i < argc; i++) {
        if (compile_c_file(argv[i]) != EXIT_SUCCESS) {
            fprintf(stderr, "Compilation failed for file: %s\n", argv[i]);
            return EXIT_FAILURE;
        }
    }

    return EXIT_SUCCESS;
}