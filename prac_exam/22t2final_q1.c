// COMP1521 22T2 ... final exam, question 1

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int count_zero_bits(uint32_t x) {
	int count = 0;

	int i = 0;

	while (i < sizeof(x) * 8) {
		if (!(x & (1u << i))) {
			count++;
		}
		i++;
	}
	return count;
}

// AND 
1100 & 1010 = 1000;

// OR
1100 | 1010 = 1110;

// XOR
1100 ^ 1010 = 0110;

// NOT
~1100 = 0011;

// LEFT
0011 << 2 = 1100;

// RIGHT
0011 >> 2 = 0000;


uint8_t x = 15;
// 00001111 in binary
x = x << 4;

if ((c & 0x80) == 0x00) {
	// 1-byte character: 0xxxxxxx
} else if ((c & 0xE0) == 0xC0) {
	// 2-byte character: 110xxxxx
	fgetc(file);  // Skip the next byte as part of this character
} else if ((c & 0xF0) == 0xE0) {
	// 3-byte character: 1110xxxx
	fgetc(file);  // Skip the next 2 bytes as part of this character
	fgetc(file);
} else if ((c & 0xF8) == 0xF0) {
	// 4-byte character: 11110xxx
	fgetc(file);  // Skip the next 3 bytes as part of this character
	fgetc(file);
	fgetc(file);
}



