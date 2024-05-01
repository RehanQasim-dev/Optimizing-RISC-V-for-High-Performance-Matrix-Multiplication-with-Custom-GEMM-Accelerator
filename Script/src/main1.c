#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "gemm.h"

// int32_t C[M][N];
// register int asm ("r10");

void load_value_reg(int x);


void main()

{

    uint8_t A[2][3] = {{1, 2, 3},
                       {4, 5, 6}};
    uint8_t B[3][2] = {{7, 8},
                       {9, 7},
                       {11, 12}};
    uint32_t C[2][2];
    // Result matrix C
    asm("mv t6, %0" : : "r"(67));
    // Call the matrix multiplication function
    MATMUL(2, 3, 2, A, B, C);
    int qw =0;
    for (int i = 0; i < 2; i++)
    {
        for (int w = 0; w < 2; w++)
        {
            qw = qw + C[i][w];
            asm("mv t6, %0" : : "r"(qw));
            for (int o =0; o<1000000; o++){}
            // for (uint32_t e = 0; e < 10000000; e++){
            // }
        }
    }
    asm("mv t6, %0" : : "r"(qw));
     for (int o =0; o<1000000; o++){}
    while (1){
        
        }
    }

