// count bits in a uint64_t

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return how many 1 bits value contains
int bit_count(uint64_t value) {
    int i = 0;
    while (value > 0) {
        if (value & 1) {
            i++;
        }
        value >>= 1;
    }
    return i;
}
