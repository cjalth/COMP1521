#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spawn.h>
#include <sys/wait.h>

#define MAX_LINE_LENGTH 1024

int main(int argc, char **argv)
{
    char *command = argv[1];
    char line[MAX_LINE_LENGTH];

    while (fgets(line, sizeof(line), stdin) != NULL) {
        // Remove the newline character from the end of the line
        line[strcspn(line, "\n")] = '\0';

        // Arguments for the posix_spawn
        char *spawn_argv[] = {command, line, NULL};
        char *spawn_envp[] = {NULL};

        pid_t pid;
        if (posix_spawn(&pid, command, NULL, NULL, spawn_argv, spawn_envp) == 0) {
            // Wait for the child process to complete
            waitpid(pid, NULL, 0);
        }
    }

    return EXIT_SUCCESS;
}