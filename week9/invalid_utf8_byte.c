// Given an UTF-8 string, return the index of the first invalid byte.
// If there are no invalid bytes, return -1.
// Written by Caitlin Wong (z5477471)

// Do NOT change this function's return type or signature.
int invalid_utf8_byte(char *utf8_string) {
    int i = 0;

    while (utf8_string[i] != '\0') {
        unsigned char byte = (unsigned char)utf8_string[i];

        if (byte < 0x80) {
            // Single-byte character, valid in UTF-8
            i++;
        } else if ((byte & 0xE0) == 0xC0) {
            // Two-byte character
            if ((utf8_string[i + 1] & 0xC0) != 0x80) {
                return i + 1; 
            }
            i += 2;
        } else if ((byte & 0xF0) == 0xE0) {
            // Three-byte character
            if ((utf8_string[i + 1] & 0xC0) != 0x80 
                || (utf8_string[i + 2] & 0xC0) != 0x80) {
                return (utf8_string[i + 1] & 0xC0) != 0x80 ? i + 1 : i + 2; 
            }
            i += 3;
        } else if ((byte & 0xF8) == 0xF0) {
            // Four-byte character
            if ((utf8_string[i + 1] & 0xC0) != 0x80 
                || (utf8_string[i + 2] & 0xC0) != 0x80 
                || (utf8_string[i + 3] & 0xC0) != 0x80) {
                if ((utf8_string[i + 1] & 0xC0) != 0x80) {
                    return i + 1;
                } else if ((utf8_string[i + 2] & 0xC0) != 0x80) {
                    return i + 2;
                } else {
                    return i + 3;
                }
            }
            i += 4;
        } else {
            // Invalid byte
            return i;
        }
    }
    return -1; // No invalid bytes found
}
