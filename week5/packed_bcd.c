// This program, given an eight-digit packed binary-coded 
// decimal value, it returns the corresponding integer.

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define N_BCD_DIGITS 8

uint32_t packed_bcd(uint32_t packed_bcd);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        long l = strtol(argv[arg], NULL, 0);
        assert(l >= 0 && l <= UINT32_MAX);
        uint32_t packed_bcd_value = l;

        printf("%lu\n", (unsigned long)packed_bcd(packed_bcd_value));
    }

    return 0;
}

// given a packed BCD encoded value between 0 .. 99999999
// return the corresponding integer
uint32_t packed_bcd(uint32_t packed_bcd_value) {
    uint32_t result = 0;
    uint32_t value = 1;

    for (int i = 0; i < N_BCD_DIGITS; i++) {
        uint32_t bcd_digit = (packed_bcd_value >> (4 * i)) & 0x0F;

        result = result + bcd_digit * value;
        value = value * 10;
    }

    return result;
}
