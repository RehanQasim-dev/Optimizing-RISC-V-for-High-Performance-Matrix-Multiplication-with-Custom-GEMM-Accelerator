#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "gemm.h"

void load_value_reg(int x);
    int8_t A[3][3] = {
    {   3,   -3,    1 },
    {  -1,   -6,    0 },
    {  -7,   -5,   -6 },
};
int8_t B[3][3] = {
    {   0,   -1,   -5 },
    {   0,    0,    4 },
    {   1,   -4,   -7 },
};
    
    int32_t C[3][3]; // Declaring C on the stack
int main()
{
    asm("mv t6, %0" : : "r"(67)); // Not sure why this line is here, it sets register t6 to 67

    // Call the matrix multiplication function
    MATMUL(3, 3, 3, A, B, C); // Typecasting C to the correct type

    for (int i = 0; i < 3; i++)
    {
        for (int w = 0; w < 3; w++)
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

