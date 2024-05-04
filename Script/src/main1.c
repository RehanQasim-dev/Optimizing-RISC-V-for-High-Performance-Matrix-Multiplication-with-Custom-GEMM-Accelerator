#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "gemm.h"

void load_value_reg(int x);

int main()
{
    uint8_t A[2][3] = {{1, 2, 3},
                       {4, 5, 6}};
    uint8_t B[3][2] = {{7, 8},
                       {9, 7},
                       {11, 12}};
    
    uint32_t C[2][2]; // Declaring C on the stack

    asm("mv t6, %0" : : "r"(67)); // Not sure why this line is here, it sets register t6 to 67

    // Call the matrix multiplication function
    MATMUL(2, 3, 2, A, B, (uint32_t (*)[2])C); // Typecasting C to the correct type

    int qw = 0;
    for (int i = 0; i < 2; i++)
    {
        for (int w = 0; w < 2; w++)
        {
            qw = qw + C[i][w];
            asm("mv t6, %0" : : "r"(qw));
            for (int o = 0; o < 1000000; o++){} // Delay loop
        }
    }

    asm("mv t6, %0" : : "r"(qw)); // Not sure what this line does, it sets register t6 to qw
    for (int o = 0; o < 1000000; o++){} // Delay loop

    while (1)
    {
        // Infinite loop to prevent the program from exiting
    }
    return 0;
}
