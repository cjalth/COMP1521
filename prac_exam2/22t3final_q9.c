// COMP1521 22T3 ... final exam, question 9

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <assert.h>
#include <pthread.h>

#include "22t3final_q9.h"

/* Constants */
// DO NOT MODIFY THESE CONSTANTS.

// Number of possible combinations provided in each file.
#define POSSIBLE_COMBINATIONS 2880
// Number of characters in each line of the input file (including newline).
#define LINE_LENGTH 10
// Expected result of the expression.
#define EXPECTED_RESULT 10
// Number of threads to create.
#define NUM_THREADS 5

void *my_thread(void *data) {
    // You MUST call this function from every thread you create.
    compute_thread_hello();



    return NULL;
}


int my_main(int argc, char *argv[]) {
    assert(argc == 2);

    // TODO: modify this code to split the work evenly across multiple threads.

    FILE *stream = fopen(argv[1], "r");
    if (stream == NULL) {
        perror(argv[1]);
        exit(EXIT_FAILURE);
    }

    int counter = 0;

    char line[LINE_LENGTH + 1];
    while (fgets(line, LINE_LENGTH + 1, stream) != NULL) {
        counter += double_equals(evaluate_expression(line), EXPECTED_RESULT);
    }

    printf("%d results found!\n", counter);

    return 0;
}
