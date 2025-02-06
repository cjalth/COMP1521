// COMP1521 22T3 ... final exam, question 7

#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

char *_22t3final_q7(char *str) {
    char *new_str = malloc(strlen(str) + 1);

    // TODO: replace the following line with your code
    strcpy(new_str, str);

    return new_str;
}



