#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "gemm.h"
#include "uart.h"
#include <stdlib.h>
void Uetrv32_Uart_Init(uint32_t baud) {
  
  UART_Module.baud = baud;
}


/**********************************************************************//**
 * UART data transmit. This is a blocking function.
 *
 **************************************************************************/
void Uetrv32_Uart_Tx(uint32_t tx_data) {
  
  while ((UART_Module.status & 0x01) == 0);
	UART_Module.tx_data = tx_data;             // trigger transfer
    // printf("%c",tx_data);
  return ;
}

int main() {
    Uetrv32_Uart_Init(1301);

    // Define a 2D matrix
    int8_t A[2][3] = {{-16, -102, 3},
                       {49, 53, -67}};
    int8_t B[3][2] = {{7, 8},
                       {9, 7},
                       {11, 12}};
    
    int32_t C[2][2]; // Declaring C on the stack

    int rows = 2; // Number of rows in the matrix
    int cols = 2; // Number of columns in the matrix
    MATMUL(2, 3, 2, A, B, C); // Typecasting C to the correct type

    // Loop over the matrix
for (int i = 0; i < rows; i++) {
    // Print opening bracket for each row
    Uetrv32_Uart_Tx('[');

    for (int j = 0; j < cols; j++) {
        int a = C[i][j];
        if (a < 0) {
            Uetrv32_Uart_Tx('-');
            a = -a;
        }
        if (a>=100){
        Uetrv32_Uart_Tx('1');
        if ( a<110 && a>=100){
            Uetrv32_Uart_Tx('0'); 
        }
        a = a- 100;
        }
        if (a >= 90) {
        Uetrv32_Uart_Tx('9'); 
        a= a-90;
        }
        if (a >= 80) {
        Uetrv32_Uart_Tx('8'); 
        a= a-80;
        }
        if (a >= 70) {
        Uetrv32_Uart_Tx('7'); 
        a= a-70;
        }
        if (a >= 60) {
        Uetrv32_Uart_Tx('6'); 
        a= a-60;
        }
        if (a >= 50) {
        Uetrv32_Uart_Tx('5'); 
        a= a-50;
        }
        if (a >= 40) {
        Uetrv32_Uart_Tx('4'); 
        a= a-40;
        }
        if (a >= 30) {
        Uetrv32_Uart_Tx('3'); 
        a= a-30;
        }
        if (a >= 20) {
        Uetrv32_Uart_Tx('2'); 
        a= a-20;
        }
        if (a >= 10) {
        Uetrv32_Uart_Tx('1'); 
        a= a-10;
        }
        if (a >= 0) {
        Uetrv32_Uart_Tx(a + '0'); 
        }
    
        if (j < cols - 1) {
            Uetrv32_Uart_Tx(',');
            Uetrv32_Uart_Tx(' ');
        }
    }

    // Print closing bracket for each row
    Uetrv32_Uart_Tx(']');

    // Add a newline character after each row except the last one
    if (i < rows - 1) {
        Uetrv32_Uart_Tx('\n');
        Uetrv32_Uart_Tx('\r');
    }
}
    return 0;
}
