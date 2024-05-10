#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "gemm.h"

void load_value_reg(int x);
    uint8_t A[8][8] = {
    { -67,  -80,   50,  -95,  -26,   93,   98,  -31 },
    {  25,   48,    1,  -30,   84,   19,   13,   13 },
    { -24,  -44,   47,   99,   30,    6,   31,  -72 },
    { -75,  -91,  -99,   -5,   94,  -21,  -60,  -78 },
    {  57,   79,    3,  -99,  -93,  -66,    6,   87 },
    {  21,  -73,   92,  -86,  -61,  -61,  -83,  -20 },
    { -54,   20,  -26,  -61,  -38,  -57,   11,   31 },
    {   7,   52,  -56,   45,  -23,  -34,  -84,   16 },
};
uint8_t B[8][8] = {
    { -31,   26,  -47,   95,   63,  -75,    8,  -74 },
    { -67,  -75,  -88,  -42,  -10,  -10,  -39,   39 },
    { -78,   93,   70,   16,   -6,   18,  -12,  -42 },
    { -74,   50,  -78,  -65,   65,  -27,   59,  -57 },
    {   7,   17,   50,   37,   14,  -86,   62,   92 },
    {  62,   77,   77,  -42,   23,  -92,  -56,    5 },
    {  26,   68,  -58,  -86,   73,   68,   36,   58 },
    { -21,   87,   46,  -61,  -41,  -91,  -11,  -81 },
};
    
    uint32_t C[8][8]; // Declaring C on the stack
int main()
{
    asm("mv t6, %0" : : "r"(67)); // Not sure why this line is here, it sets register t6 to 67

    // Call the matrix multiplication function
    MATMUL(8, 8, 8, A, B, C); // Typecasting C to the correct type

    for (int i = 0; i < 13; i++)
    {
        for (int w = 0; w < 13; w++)
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

