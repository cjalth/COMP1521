#include <stdint.h>

/**
 * Return the provided value but with its bytes reversed.
 *
 * For example, 22t2final_q3(0x12345678) => 0x78563412
 *
 * *Note* that your task is to
 * reverse the order of *bytes*,
 * *not* to reverse the order of bits.
 **/

uint32_t _22t2final_q3(uint32_t value) {
    uint32_t byte1 = value & 0xFF;
    uint32_t byte2 = (value >> 8) & 0xFF;
    uint32_t byte3 = (value >> 16) & 0xFF;
    uint32_t byte4 = (value >> 24) & 0xFF;

    return (byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4;
}

// OR 
uint32_t anothersolution(uint32_t value) {
    uint32_t b1 = value >> 24 & 0xFF;
    uint32_t b2 = value >> 16 & 0xFF;
    uint32_t b3 = value >> 8 & 0xFF;
    uint32_t b4 = value & 0xFF;

    return (b1 << 0) | (b2 << 8) | (b3 << 16) | (b4 << 24);
}