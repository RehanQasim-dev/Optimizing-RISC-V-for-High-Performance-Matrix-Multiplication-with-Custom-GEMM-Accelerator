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
    MATMUL(2, 3, 2, A, B, C); // Typecasting C to the correct type

    for (int i = 0; i < 2; i++)
    {
        for (int w = 0; w < 2; w++)
        {
            asm("mv t6, %0" : : "r"(C[i][w]));
            for (int o = 0; o < 1000000; o++){} // Delay loop
            
        }
    }

    for (int o = 0; o < 1000000; o++){} // Delay loop

    while (1)
    {
        // Infinite loop to prevent the program from exiting
    }
    return 0;
}
