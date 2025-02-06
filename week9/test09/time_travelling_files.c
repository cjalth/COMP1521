#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <time.h>

int main(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        struct stat file_stat;

        // Puts acees time and modificatin time in file_stat
        stat(argv[i], &file_stat);

        // Gets current time and puts it in now
        time_t now = time(NULL); 

        // Checks if either times are in the future
        if (file_stat.st_atime > now || file_stat.st_mtime > now) {
            printf("%s has a timestamp that is in the future\n", argv[i]);
        }
    }
    return 0;
}
