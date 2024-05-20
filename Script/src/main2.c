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

void UART_SendNumber(int32_t number) {
    char buffer[11];  // Buffer to hold digits, max 10 digits for 32-bit number + null terminator
    int index = 0;
    
    // Handle the case when the number is 0
    if (number == 0) {
        Uetrv32_Uart_Tx('0');
        return;
    }

    // Extract digits from the number
    while (number > 0) {
        buffer[index++] = (number % 10) + '0'; // Convert digit to character
        number /= 10;
    }

    // Digits are in reverse order, so send them in reverse
    for (int i = index - 1; i >= 0; i--) {
        Uetrv32_Uart_Tx(buffer[i]);
    }
}

int main() {
    Uetrv32_Uart_Init(1301);

    // Define a 2D matrix
    int8_t A[2][3] = {{-16, -102, 3},
                       {49, 53, -67}};
    int8_t B[3][2] = {{76, 8},
                       {99, -72},
                       {-101, 12}};
    
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
        UART_SendNumber(a);
    
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
