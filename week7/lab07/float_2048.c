// Multiply a float by 2048 using bit operations only
// Written by Caitlin Wong (z5477471)
// on 09/07/2024

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// float_2048 is given the bits of a float f as a uint32_t
// it uses bit operations and + to calculate f * 2048
// and returns the bits of this value as a uint32_t
//
// if the result is too large to be represented as a float +inf or -inf is returned
//
// if f is +0, -0, +inf or -inf, or Nan it is returned unchanged
//
// float_2048 assumes f is not a denormal number
//
uint32_t float_2048(uint32_t f) {
    uint32_t sign = f >> 31;
    uint32_t exponent = (f >> 23) & 0xFF;
    uint32_t fraction = f & 0x7FFFFF;

    // If the original float is NaN, +inf, -inf, or zero, return it unchanged.
    if (exponent == 0xFF || f == 0 || f == 0x80000000) {
        return f;
    }

    // Adjust the exponent to represent multiplication by 2048 (2^11).
    exponent += 11;

    // Check if result is too large
    if (exponent >= 0xFF) {
        // Set to +inf and -inf
        return (sign == 0) ? 0x7F800000 : 0xFF800000;
    }

    return (sign << 31) | (exponent << 23) | fraction;
}
