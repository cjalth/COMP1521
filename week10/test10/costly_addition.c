#include <stdlib.h>
#include <pthread.h>

void *increment_and_sleep(void *arg);

void costly_addition(int num) {
    pthread_t threads[num];

    // Create threads for each call to increment_and_sleep
    for (int i = 0; i < num; ++i) {
        pthread_create(&threads[i], NULL, increment_and_sleep, NULL);
    }

    // Wait for each thread to finish
    for (int i = 0; i < num; ++i) {
        pthread_join(threads[i], NULL);
    }
}
