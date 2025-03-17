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
void MATMUL(uint32_t A_rows, uint32_t A_cols, uint32_t B_cols, int8_t A[A_rows][A_cols], int8_t B[A_cols][B_cols], int32_t C[A_rows][B_cols])
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
        cols_to_process = (remaining_n >= SYS_COLS) ? SYS_COLS : remaining_n;

        while (remaining_m > 0)
        {
            rows_to_process = (remaining_m >= ACCUM_SIZE) ? ACCUM_SIZE : remaining_m;

            while (remaining_k > 0)
            {
                rows_to_process_k = (remaining_k >= SYS_ROWS) ? SYS_ROWS : remaining_k;

                bool is_last = (current_k + SYS_ROWS >= A_cols);

                Tile_A_Address = (uint32_t)&(A[current_m][current_k]);
                Tile_B_Address = (uint32_t)&(B[current_k + rows_to_process_k - 1][current_n]);
                Tile_C_Address = (uint32_t)&(C[current_m][current_n]);

                Configure_GEMM(Tile_A_Address, Tile_B_Address, Tile_C_Address, A_cols, B_cols, rows_to_process, rows_to_process_k, cols_to_process, (current_k == 0), is_last);

                while (GEMM_A == 1)
                {
                    // Wait for the slot to become available
                }

                remaining_k -= rows_to_process_k;

                current_k = A_cols - remaining_k;
            }
            current_k = 0;
            remaining_m -= rows_to_process;

            current_m = A_rows - remaining_m;
            remaining_k = A_cols;
        }
        current_m = 0;
        remaining_n -= cols_to_process;

        current_n = B_cols - remaining_n;
        remaining_m = A_rows;
    }

    while (GEMM_DIM != 1)
    {
        // check if GEMM is done
    }
}
void core_matmul(int32_t rows, int32_t cols_A, int32_t cols_B, int8_t A[rows][cols_A], int8_t B[cols_A][cols_B], int32_t C[rows][cols_B])
{
    for (int32_t i = 0; i < rows; i++)
    {
        for (int32_t j = 0; j < cols_B; j++)
        {
            C[i][j] = 0;
            for (int32_t k = 0; k < cols_A; k++)
            {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

#define TIMER_START                                 \
    {                                               \
        asm("csrrw x0, mcycle, %0" ::"r"(1));       \
        asm("csrrw x0, mcounteren, %0" : : "r"(1)); \
    }
#define TIMER_STOP                                  \
    {                                               \
        asm("csrrw x0, mcounteren, %0" : : "r"(0)); \
    }
uint32_t read_cycles(void)
{
    uint32_t r;
    asm("csrrw %0, mcycle,x0" : "=r"(r));
    return r;
}