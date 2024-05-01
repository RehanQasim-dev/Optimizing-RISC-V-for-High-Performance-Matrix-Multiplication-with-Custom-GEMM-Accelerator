#include <stdint.h>
#include <stdbool.h>
#define GEMM_A (*((volatile uint32_t *)(0x90000000UL)))
#define GEMM_B (*((volatile uint32_t *)(0x90000004UL)))
#define GEMM_C (*((volatile uint32_t *)(0x90000008UL)))
#define GEMM_stride_A (*((volatile uint32_t *)(0x9000000CUL)))
#define GEMM_stride_B (*((volatile uint32_t *)(0x90000010UL)))
#define GEMM_control (*((volatile uint32_t *)(0x90000014UL)))
#define GEMM_DIM (*((volatile uint32_t *)(0x90000018UL)))
#define ACCUM_SIZE 16
#define SYS_ROWS 16
#define SYS_COLS 16
#define Configure_GEMM(A_addr, B_addr, C_addr, A_stride, B_stride, msize, ksize, nsize, overwrite, store) \
    {                                                                                                     \
        GEMM_stride_A = A_stride;                                                                         \
        GEMM_stride_B = B_stride;                                                                         \
        GEMM_A = A_addr;                                                                                  \
        GEMM_B = B_addr;                                                                                  \
        GEMM_C = C_addr;                                                                                  \
        GEMM_control = (overwrite << 1) | store;                                                          \
        GEMM_DIM = msize | (ksize << 5) | (nsize << 10);                                                  \
    }
void MATMUL( uint32_t A_rows, uint32_t A_cols, uint32_t B_cols,uint8_t A[A_rows][A_cols], uint8_t B[A_cols][B_cols], uint8_t C[A_rows][B_cols])
{

    uint32_t Tile_A_Address, Tile_B_Address, Tile_C_Address;
    uint32_t remaining_n = B_cols;
    uint32_t remaining_m = A_rows;
    uint32_t remaining_k = A_cols;

    uint32_t current_n = 0;
    uint32_t current_m = 0;
    uint32_t current_k = 0;
    uint32_t cols_to_process, rows_to_process, rows_to_process_k;
    while (remaining_n > 0)
    {
        asm("mv t6, %0" : : "r"(0x1));
            // for (int o =0; o<1000000; o++){}
        cols_to_process = (remaining_n >= SYS_COLS) ? SYS_COLS : remaining_n;

        while (remaining_m > 0)
        {asm("mv t6, %0" : : "r"(0x3));
            // for (int o =0; o<1000000; o++){}
            rows_to_process = (remaining_m >= ACCUM_SIZE) ? ACCUM_SIZE : remaining_m;

            while (remaining_k > 0)
            {
                asm("mv t6, %0" : : "r"(0x6));
            // for (int o =0; o<1000000; o++){}
                rows_to_process_k = (remaining_k >= SYS_ROWS) ? SYS_ROWS : remaining_k;

                bool is_last = (current_k + SYS_ROWS >= A_cols);

                Tile_A_Address = &(A[current_m][current_k]);
                Tile_B_Address = &(B[current_k + rows_to_process_k - 1][current_n]);
                Tile_C_Address = &(C[current_m][current_n]);
            asm("mv t6, %0" : : "r"(0x10));
            // for (int o =0; o<1000000; o++){}
                Configure_GEMM(Tile_A_Address, Tile_B_Address, Tile_C_Address, A_cols, B_cols, rows_to_process, rows_to_process_k, cols_to_process, (current_k == 0), is_last);
asm("mv t6, %0" : : "r"(0x16));
            // for (int o =0; o<1000000; o++){}
                while (GEMM_A == 1)
                {
                    // Wait for the slot to become available
                }

                asm("mv t6, %0" : : "r"(0x19));
            // for (int o =0; o<1000000; o++){}
                remaining_k -= rows_to_process_k;

                current_k = A_cols - remaining_k;
            }

             asm("mv t6, %0" : : "r"(0x1a));
            // for (int o =0; o<1000000; o++){}
            remaining_m -= rows_to_process;

            current_m = A_rows - remaining_m;
            remaining_k = A_cols;
        }
        asm("mv t6, %0" : : "r"(0x1d));
            // for (int o =0; o<1000000; o++){}
        remaining_n -= cols_to_process;

        current_n = B_cols - remaining_n;
        remaining_m = A_rows;
        asm("mv t6, %0" : : "r"(0x1e));
            // for (int o =0; o<1000000; o++){}
    }
     asm("mv t6, %0" : : "r"(0x20));
            // for (int o =0; o<1000000; o++){}
    while (GEMM_DIM != 1)
    {
        // check if GEMM is done
    }

     asm("mv t6, %0" : : "r"(0x2f));
            // for (int o =0; o<1000000; o++){}
}