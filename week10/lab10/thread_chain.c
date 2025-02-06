#include <pthread.h>
#include "thread_chain.h"

#define THREAD_CHAIN_LEN 50

void *my_thread(void *data) {
    int *remaining_threads = (int *)data;

    if (*remaining_threads > 0) {
        thread_hello();

        // Decrement the count of remaining threads
        (*remaining_threads)--;

        // Create a new thread with the updated count
        pthread_t thread_handle;
        pthread_create(&thread_handle, NULL, my_thread, data);

        // Wait for the new thread to finish
        pthread_join(thread_handle, NULL);
    }

    return NULL;
}

void my_main(void) {
    int remaining_threads = THREAD_CHAIN_LEN;
    pthread_t thread_handle;
    pthread_create(&thread_handle, NULL, my_thread, &remaining_threads);

    pthread_join(thread_handle, NULL);
}
