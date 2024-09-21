#include <stdint.h>
#include "gemm.h"
#include "uart.h"

void main(void) {
    Uetrv32_Uart_Rx();
    int8_t rx_byte = 0;
    uint32_t M,K,N;
    // Initialize UART with desired baudrate
    Uetrv32_Uart_Init(BAUD_DIV);
    while (1) {
        UETrv32_Uart_Print("\n\r");
        UETrv32_Uart_Print("----------------------------------------------------------------\n\r");
        UETrv32_Uart_Print("Enter dim_M:");
        M = Get_Data_Word();
        UART_Send_32bit_number(M);
        UETrv32_Uart_Print("\n\rEnter dim_K:");
        K = Get_Data_Word();
        UART_Send_32bit_number(K);
        UETrv32_Uart_Print("\n\rEnter dim_N:");
        N = Get_Data_Word();
        UART_Send_32bit_number(N);
        int8_t A[M][K];
        int8_t B[K][N];
        int32_t C[M][N];
        for (int i = 0; i < M; i++) {
            for (int j = 0; j < K; j++) {
                A[i][j]= (int8_t) Uetrv32_Uart_Rx();
            }
        }
        UETrv32_Uart_Print("\n\rMatrix A is Received! ");
        for (int i = 0; i < K; i++) {
            for (int j = 0; j < N; j++) {
                B[i][j]= (int8_t) Uetrv32_Uart_Rx();
            }
        }
        UETrv32_Uart_Print("\n\rMatrix B is Received! ");
        UETrv32_Uart_Print("\n\r");
        UETrv32_Uart_Print("\n\rMatrix A: ");
        display_input_matrix(M,K,A);
        UETrv32_Uart_Print("\n\rMatrix B: ");
        display_input_matrix(K,N,B);
        TIMER_START
        MATMUL(M, K,N, A, B, C);
        TIMER_STOP
        uint32_t cycles=read_cycles();
        UETrv32_Uart_Print("\n\rNo of cycles taken on GEMM: ");
        UART_Send_32bit_number(cycles);
        UETrv32_Uart_Print("\n\r");
        UETrv32_Uart_Print("\n\rMatrix C: ");
        display_result_matrix(M,N,C);
        UETrv32_Uart_Print("\n\r........Now performing matrix multiplications on RISC-V....... ");
        TIMER_START
        core_matmul(M, K,N, A, B, C);
        TIMER_STOP
        uint32_t cycles_core=read_cycles();
        UETrv32_Uart_Print("\n\rNo of cycles taken on RISC-V Core: ");
        UART_Send_32bit_number(cycles_core);
        UETrv32_Uart_Print("\n\r");
    }

    return;
}
