// COMP1521 22T3 ... final exam, question 4

#include <stdint.h>

int _22t3final_q4(uint32_t x) {
    int count = 0;
    int max = 0;

    while (x != 0) {
        if (x & 1) {
            count++;
        } else {
            count = 0;
        }
        if (count > max) {
            max = count;
        }
        x = x >> 1;
    }
    return max;
}
