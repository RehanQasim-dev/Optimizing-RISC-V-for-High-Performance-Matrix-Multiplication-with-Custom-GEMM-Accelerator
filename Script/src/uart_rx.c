// #include <stdint.h>
// #include "uart.h"

// #define MAX_MATRIX_SIZE 100

// // Function prototypes
// uint8_t Get_Data_Byte(void);
// void Start_App_Program(void);
// void Transfer_Executable(void);
// void Transfer_Matrix(void);
// void Store_Matrix(uint32_t rows, uint32_t cols);

// void main(void) {
//     uint8_t rx_byte = 0;

//     // Initialize UART with desired baudrate
//     Uetrv32_Uart_Init(BAUD_DIV);

//     Uetrv32_Uart_Tx((uint32_t) 'W');
//     Uetrv32_Uart_Tx((uint32_t) 'a');
//     Uetrv32_Uart_Tx((uint32_t) 'i');
//     Uetrv32_Uart_Tx((uint32_t) 't');
//     Uetrv32_Uart_Tx((uint32_t) 'i');
//     Uetrv32_Uart_Tx((uint32_t) 'n');
//     Uetrv32_Uart_Tx((uint32_t) 'g');
//     Uetrv32_Uart_Tx((uint32_t) '\n');
//     Uetrv32_Uart_Tx((uint32_t) '\r');

//     // Transfer matrix data
//     Transfer_Matrix();

//     Uetrv32_Uart_Tx((uint32_t) 'D');
//     Uetrv32_Uart_Tx((uint32_t) 'o');
//     Uetrv32_Uart_Tx((uint32_t) 'n');
//     Uetrv32_Uart_Tx((uint32_t) 'e');
//     Uetrv32_Uart_Tx((uint32_t) '\n');
//     Uetrv32_Uart_Tx((uint32_t) '\r');

//     // Wait for 'a' to be received before finishing
//     while (rx_byte != 'a') {
//         rx_byte = (uint8_t) Uetrv32_Uart_Rx();
//     }

//     return;
// }

// /************************************************************************
//  * Transfer matrix data to the memory.
//  *
//  ***********************************************************************/
// void Transfer_Matrix(void) {
//     uint8_t rx_byte = 0;
//     char prefix[6] = {0}; // 5 characters for "A_mat" + 1 null terminator
//     int i = 0;

//     // Wait for the start string "A_mat\n\r"
//     while (i < 6) {
//         rx_byte = (uint8_t) Uetrv32_Uart_Rx();
//         prefix[i++] = rx_byte;
//     }

//     if (prefix[0] == 'A' && prefix[1] == '_' && prefix[2] == 'm' && prefix[3] == 'a' && prefix[4] == 't' && prefix[5] == '\n') {
//         // Confirm the carriage return
//         rx_byte = (uint8_t) Uetrv32_Uart_Rx();
//         if (rx_byte == '\r') {
//             // Get the matrix dimensions
//             uint32_t rows = Get_Data_Byte();
//             uint32_t cols = Get_Data_Byte();

//             // Store the matrix with the given dimensions
//             Store_Matrix(rows, cols);
//         } else {
//             Uetrv32_Uart_Tx((uint32_t) 'E');
//             Uetrv32_Uart_Tx((uint32_t) 'r');
//             Uetrv32_Uart_Tx((uint32_t) 'r');
//             Uetrv32_Uart_Tx((uint32_t) 'o');
//             Uetrv32_Uart_Tx((uint32_t) 'r');
//             Uetrv32_Uart_Tx((uint32_t) '\n');
//             Uetrv32_Uart_Tx((uint32_t) '\r');
//         }
//     } else {
//         Uetrv32_Uart_Tx((uint32_t) 'E');
//         Uetrv32_Uart_Tx((uint32_t) 'r');
//         Uetrv32_Uart_Tx((uint32_t) 'r');
//         Uetrv32_Uart_Tx((uint32_t) 'o');
//         Uetrv32_Uart_Tx((uint32_t) 'r');
//         Uetrv32_Uart_Tx((uint32_t) '\n');
//         Uetrv32_Uart_Tx((uint32_t) '\r');
//     }
// }

// /************************************************************************
//  * Store matrix data received via UART into memory.
//  *
//  ***********************************************************************/
// void Store_Matrix(uint32_t rows, uint32_t cols) {
//     uint32_t i = 0, j = 0;
//     if (rows > MAX_MATRIX_SIZE || cols > MAX_MATRIX_SIZE) {
//         Uetrv32_Uart_Tx((uint32_t) 'E');
//         Uetrv32_Uart_Tx((uint32_t) 'r');
//         Uetrv32_Uart_Tx((uint32_t) 'r');
//         Uetrv32_Uart_Tx((uint32_t) 'o');
//         Uetrv32_Uart_Tx((uint32_t) 'r');
//         Uetrv32_Uart_Tx((uint32_t) '\n');
//         Uetrv32_Uart_Tx((uint32_t) '\r');
//         return;
//     }

//     volatile uint8_t matrix[MAX_MATRIX_SIZE][MAX_MATRIX_SIZE];

//     for (i = 0; i < rows; i++) {
//         for (j = 0; j < cols; j++) {
//             matrix[i][j] = Get_Data_Byte();
//         }
//     }

//     // For demonstration, we can print the matrix to UART
//     for (i = 0; i < rows; i++) {
//         for (j = 0; j < cols; j++) {
//             Uetrv32_Uart_Tx((uint32_t) matrix[i][j]);
//             Uetrv32_Uart_Tx((uint32_t) ' ');
//         }
//         Uetrv32_Uart_Tx((uint32_t) '\n');
//         Uetrv32_Uart_Tx((uint32_t) '\r');
//     }
// }

// /************************************************************************
//  * Read byte from UART interface.
//  *
//  * @return 8-bit data byte.
//  ***********************************************************************/
// uint8_t Get_Data_Byte(void) {
//     return (uint8_t) Uetrv32_Uart_Rx();
// }

// #include <stdint.h>
// #include "uart.h"

// void main(void) {
//     uint8_t rx_byte = 0;

//     // Initialize UART with desired baudrate
//     Uetrv32_Uart_Init(BAUD_DIV);

//     Uetrv32_Uart_Tx((uint32_t) 'W');
//     Uetrv32_Uart_Tx((uint32_t) 'a');
//     Uetrv32_Uart_Tx((uint32_t) 'i');
//     Uetrv32_Uart_Tx((uint32_t) 't');
//     Uetrv32_Uart_Tx((uint32_t) 'i');
//     Uetrv32_Uart_Tx((uint32_t) 'n');
//     Uetrv32_Uart_Tx((uint32_t) 'g');
//     Uetrv32_Uart_Tx((uint32_t) '\n');
//     Uetrv32_Uart_Tx((uint32_t) '\r');

//     while (1) {
//         // Echo back whatever is received
//         rx_byte = (uint8_t) Uetrv32_Uart_Rx();
//         Uetrv32_Uart_Tx((uint32_t) rx_byte);
//     }

//     return;
// }
#include <stdint.h>
#include "uart.h"

void main(void) {
    Uetrv32_Uart_Rx();
    int8_t rx_byte = 0;
    // char received_string[10] = {0}; // Assuming maximum length of received string is 10
    // const char terminator[] = "hello\n\r";
    // int terminator_index = 0; // Index to track position in terminator string
    uint32_t M,K;
    // Initialize UART with desired baudrate
    Uetrv32_Uart_Init(BAUD_DIV);
    UETrv32_Uart_Print("Enter dim_M: ");
    M = (uint32_t) Uetrv32_Uart_Rx();
    Uetrv32_Uart_Tx((uint32_t) M);
    M = M-'0';
    UETrv32_Uart_Print("\n\rEnter dim_K:");
    K = (uint32_t) Uetrv32_Uart_Rx();
   
    Uetrv32_Uart_Tx((uint32_t) K);
    K = K-'0';
    int8_t A[M][K];
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < K; j++) {
            A[i][j]= (int8_t) Uetrv32_Uart_Rx();
        }
    }
    UETrv32_Uart_Print("\n\rDone Receiving: ");
    UETrv32_Uart_Print("\n\r");
    printMatrix(M,K,A);
    // Uetrv32_Uart_Tx((uint32_t) 'W');
    // Uetrv32_Uart_Tx((uint32_t) 'a');
    // Uetrv32_Uart_Tx((uint32_t) 'i');
    // Uetrv32_Uart_Tx((uint32_t) 't');
    // Uetrv32_Uart_Tx((uint32_t) 'i');
    // Uetrv32_Uart_Tx((uint32_t) 'n');
    // Uetrv32_Uart_Tx((uint32_t) 'g');
    // Uetrv32_Uart_Tx((uint32_t) '\n');
    // Uetrv32_Uart_Tx((uint32_t) '\r');
    while (1) {
        // Echo back whatever is received


        // Append received character to received_string
        // received_string[terminator_index++] = (char)rx_byte;

        // // Check if received_string matches terminator
        // if (terminator_index >= 8) {
        //     int i;
        //     int match = 1;
        //     for (i = 0; i < 8; i++) {
        //         if (received_string[i] != terminator[i]) {
        //             match = 0;
        //             break;
        //         }
        //     }
        //     if (match) {
        //         break; // Exit the loop if terminator is found
        //     }
        // }
    }

    return;
}
