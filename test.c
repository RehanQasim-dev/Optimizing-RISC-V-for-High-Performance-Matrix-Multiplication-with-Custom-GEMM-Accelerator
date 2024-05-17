#include <stdio.h>

void print_digits(int num) {
    if (num < 0) {
        printf("-");
        num = -num;
    }

    // Define a mask to isolate the last digit
    int mask = 0xF;

    // Define the maximum number of digits in a 32-bit signed integer
    int num_digits = 10;

    // Loop through each digit from right to left
    for (int i = 0; i < num_digits; i++) {
        // Extract the last digit using bitwise AND operation with the mask
        int digit = (num >> (i * 4)) & mask;

        // Print the extracted digit
        printf("%d", digit);
    }

    printf("\n");
}

int main() {
    int num = -123456789;
    print_digits(num);
    return 0;
}
