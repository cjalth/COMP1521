#include "bit_rotate.h"

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {
    // Make sure n_rotations is between [0,15]
    n_rotations %= 16; 

    if (n_rotations < 0) {
        n_rotations += 16;
    }

    return (bits << n_rotations) | (bits >> (16 - n_rotations));
}
