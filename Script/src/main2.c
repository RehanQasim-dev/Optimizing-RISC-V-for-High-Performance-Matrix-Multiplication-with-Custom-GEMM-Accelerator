// #include <stdio.h>
// #include <stdint.h>
// #include <stdbool.h>
// //#include "gemm.h"

// // int32_t C[M][N];
// //register int asm ("r10");

// // void display_on_led (uint32_t *C, uint32_t rows,uint32_t  colmn);

// // void delay  (int i);

// void main()

// {

//     int A[2][3] = {{1, 2, 3},
//                        {4, 5, 6}};
//     int B[3][2] = {{7, 8},
//                        {9, 7},
//                        {11, 12}};
//     int C[2][2];
//     // Result matrix C

//     // Call the matrix multiplication function
//     // MATMUL(2, 3, 2, A, B, C);
//     for (int e=0 ; e<2;e++){
//         printf("entering first loop\n");
//         for (int w=0; w<2 ;w++){
//             printf("entering second loop\n");
//             for (int r=0 ; r<3; r++){
//             printf("entering third loop\n");
//             C[e][w] +=  (A[e][r] * B[r][w]);
            
            
//             }
//             printf("%d \n", C[e][w]);
//         }
//         printf("exiting loop 1 \n");
//     }
//     printf("exited loops for calculation \n");
    
//     for (int e=0 ; e<2 ; e++ ){
//         printf("entering print loop 1\n");
//         for (int w=0; w<2 ; w++){
//             printf("entring loop 2\n");
//             printf("%d \n", C[e][w]);
//         }
//         }
    
//    // display_on_led(*C, 2,2);
// }

// // void delay (int i){
// //     for (int e=0 ; e < i ; e++){}
// // }

// // void display_on_led (uint32_t *C, uint32_t rows, uint32_t colmn){
// //     uint32_t q =0;
// //     uint32_t w=0;
// //     uint32_t value=0;
// //     for (q ; q<rows ; q++){
// //         for (w ; w<colmn ; w++){
// //             value = C[q][w];
// //             asm ("mv a0, %0": : "r"(value));
// //             delay(10000);
// //         }
// //     }
    
// // }

#include<stdio.h>


void main (void) {
    int a=0;
    int w=30;
    int r;
    r= w* w;
    asm("mv a2, %0" : : "r" (w));
    for (int e =0; e< 10000; e++){}
    asm("mv a2, %0" : : "r" (w));
    while (1){}
//     a=3;
//    asm("mv a1, %0" : : "r" (w));
//     for (int e=0 ; e < 1000; e++){}
//     a=6;
//    asm("mv a1, %0" : : "r" (a));
//     for (int e=0 ; e < 1000 ; e++){}

}
