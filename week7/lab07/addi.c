// generate the encoded binary for an addi instruction, including opcode and operands
// Written by Caitlin Wong (z5477471)
// on the 09/07/2024

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"

// return the encoded binary MIPS for addi $t,$s, i
uint32_t addi(int t, int s, int i) {
    return 0x20000000 | ((uint32_t)s) << 21 | ((uint32_t)t) << 16 | (i & 0xFFFF);

}
