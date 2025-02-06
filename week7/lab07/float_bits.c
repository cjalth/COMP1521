// Extract the 3 parts of a float using bit operations only
// Written by Caitlin Wong (z5477471)
// on 09/07/2024

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// separate out the 3 components of a float
float_components_t float_bits(uint32_t f) {
    float_components_t components;
    components.fraction = f & 0x007FFFFF;    // Fraction bits (bits 0-22)
    components.exponent = (f >> 23) & 0xFF; // Exponent bits (bits 23-30)
    components.sign = (f >> 31) & 0x01;     // Sign bit (bit 31)
    return components;
}

// given the 3 components of a float
// return 1 if it is NaN, 0 otherwise
int is_nan(float_components_t f) {
    return (f.exponent == 0xFF) && (f.fraction != 0);
}

// given the 3 components of a float
// return 1 if it is inf, 0 otherwise
int is_positive_infinity(float_components_t f) {
    return (f.exponent == 0xFF) && (f.fraction == 0) && (f.sign == 0);
}

// given the 3 components of a float
// return 1 if it is -inf, 0 otherwise
int is_negative_infinity(float_components_t f) {
    return (f.exponent == 0xFF) && (f.fraction == 0) && (f.sign == 1);
}

// given the 3 components of a float
// return 1 if it is 0 or -0, 0 otherwise
int is_zero(float_components_t f) {
    return (f.exponent == 0) && (f.fraction == 0);
}
