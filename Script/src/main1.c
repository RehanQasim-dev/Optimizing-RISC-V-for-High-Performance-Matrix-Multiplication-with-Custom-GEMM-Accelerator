#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "gemm.h"

// int32_t C[M][N];
//register int asm ("r10");

void load_value_reg (int x);

void delay  (int i);

void main()

{

    uint8_t A[2][3] = {{1, 2, 3},
                       {4, 5, 6}};
    uint8_t B[3][2] = {{7, 8},
                       {9, 7},
                       {11, 12}};
    uint32_t C[2][2];
    // Result matrix C

    // Call the matrix multiplication function
    MATMUL(2, 3, 2, A, B, C);

    for (int i=0 ; i<2; i++){
        for (int w=0; w<0;w++){
            load_value_reg(C[i][w]);
        }
    }
}

void delay (int i){
    for (int e=0 ; e < i ; e++){}
}

void load_value_reg (int x){
    asm("mv a0, %0" : : "r" (x));
	delay(1000000000);
}
