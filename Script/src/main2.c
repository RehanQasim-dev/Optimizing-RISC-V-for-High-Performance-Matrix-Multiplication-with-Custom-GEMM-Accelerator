#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "gemm.h"
#include "uart.h"
#include <stdlib.h>
#define M 20
#define K 20
#define N 20
int8_t A[M][K] = {
    { -90,    7,  -80,  107,  -84,  -13,  -31,  -72,  -48,  -47,  -32,   46, -108, -107,  100, -117, -112,  -89,  -56,   69 },
    {  62,  110,  -41,   11,  103,  -61,   48,  -82, -105,  -14,   -1, -125,   -7,  -99,  -77, -121,   46,  -48,  -84,   69 },
    {  25, -118,   89,  115,   52,  -29,  -25,   27, -127,  -51, -117, -117,   87,  116,  -23,   68,  -64,   17,   11,  -94 },
    { -39,   66,  114,  -49,   68,  108, -112,  -13,  106,  -66,   61,   81,   37,   32,   91,  -69,   79,  107,  108,  -76 },
    {-110,  -77,    8,  -77, -127,   15,   97,  -56,  124,   39,   25,   36,  -47,   38,   76,  -68, -115,  -20,  -43, -125 },
    { -10,   22,  -66,  -64,   93,   42,   39,  108,  -55,   20,  124,   23,  -57, -123,  -72,   95,    9,   76,   99,  -63 },
    {  29, -109,   87,  -76,   18,  -34,  -36,  -73,   50,  119,   54,   32,    4,  -56,   62,   93,   64,  -37,  -90,  -81 },
    {  92, -125,   44,   15,  -92,  108,  -10,   49,   90,  -73,  -83,   14,   27,   11,  -68,   23,   50, -117, -117,   12 },
    {  -9,   43,   90,   84,   92,   -2,   30,   71,  112,   -8,  -15,    5,  -56,  -90,   78, -101,  -85,   89,  108,  -69 },
    { -36,  125, -117, -111,  -91,   84,  -49, -108,  -62,  -42,  -83,   65,  -55,  -39,  -76,  -54,   24,  -56,  -11,  -90 },
    {  26,  -81,  -24,  -66,  -52,  -73,   68,   -1,   79,  -64,   53,   11, -107,   -4,   80,    7, -113,   59,  -33,   64 },
    { -33,   75,  -10,   47,   77,  -88,  -35,  121,  105,   20, -107,  -57,  -77,  -88,  -71,  -27, -111,  -95,   88,   70 },
    { -58,   15,  -98, -113, -114,    0,  123,  110, -115,   14,   61,   48,   53,   81,  -66,   18, -107,  -93,   62,  -10 },
    {  79,   93,   14,  -48,  -31,   71,   66, -113,  101,   45,   11,  -33,   90,   92, -102,   72,   39,  117,  -49,  -26 },
    { 115,  -43,  -20,  -89,   67,  105,  -47,   21,   53,  -77,   95,   54,  -22, -100,  109, -116,  -39,   43,   54,  -38 },
    {-124,   -5,   56,  117,   93,   47,  121,   -4,   65,  -44,   -2,  -89,  -84,   92, -106,   15,  -44,   42,  -39,   20 },
    {   6, -122,   48,    2,  -71,   -4,  118,  115,  -19,   42,    8,   75,   73,  105,  116,   63,   46,  -48,   91,   81 },
    {  14,  -50,  -37,  -17,  125,   36,   85,  -19,  -80,  109,  -22,  105,   99,  -48, -118,  -53,    0,   -7,  -46,  -75 },
    {   3, -103,  119,  -28,  -74, -117,   95, -127,    1,  -80,  -74,   97,   99,   93,  -35,  107,  -51,   12,   41,  -81 },
    { -57,  116, -115,   82,   94,   20,  -63,  -74,   36,   89,   44,   87, -116,   81,   11,  -47,   70,  108,   98,   64 },
};
int8_t B[K][N] = {
    {  54,  -15,   10,    5, -107,  125,   12,  -92,   67,  -69,  -83,   -3,   78,   77,   77,   83,  -10,   36,   26,   98 },
    { 127,   86,   44,   -2,  -42,   32,   89,   67,  -78, -110,  -70,  -31,  -14,  107,  -72,  108,   11,  109,  -49,  -38 },
    {  65,  -26, -106,   73,   32,   29,   33,   53,   26, -112, -115,   79,  -98,   60,  117, -105,   54,   39,   65,  -41 },
    { -20,  -78,  -37,  -54,  -35,   98,   11,  -21, -106,  -63,  106,   92,  -85,  -36,   -1,  -92,  -38,  -63,  -90,  -15 },
    {   7,  102,  -29,  114,   48,  -22,   67,   68,   79,  -56,  -18,   -8, -105,  125,  -14, -127,   50,  -38,   88,   96 },
    {  -5,   20, -104,  118,   59,  101,  -44,  125,   57,  -19,   94,   68, -107,  111,  127,   50,   59,   83,  121,  -69 },
    {  88,   29,  -51,   56,  119,   71,  -14,  -96,   -3,  -91,   42,  120,  -80,  -99,   77,  -27,  -85,  -69,  -65,  -66 },
    {  39, -100,  -90,  123,  106,  -17,   85,  127,   76,  -39,   28,  117,   61,   71,  -49, -126, -128,   -5,   28, -122 },
    { -38,   32,   86,  -20,   72,  -99, -125,  117,   77, -125,  -57,  -96,  107,  110,   70,  -77,  100, -126,  -38,  -92 },
    { -30,  -46,  111,  -46,   71,   96,  -85,    5,  -19,   69,  -71,  -61,   98,    3,   13, -110,   24,   -8,  -78,  109 },
    {  -8,  -85,  110,  112,   78,   35,    5,  -13,   49,   27,   60,   38, -105,  -52,  -64,   80,   84,  101,   59,  -26 },
    { -69, -126,   40,   61,   82,   64,  -13,   -7,   -8,   61,   31,   83,   56,  -35, -115,  -54,  -17, -107,  -65, -111 },
    {  64,   -1,   82,   44,  -99,  -12, -101,  -17,    8,   36,  -95,  -42,   36,   74,   67,   -1,   -3,  -20,   52,  125 },
    {  76,    0,  103,  109,  -34, -127,   98,   86,   60,  -91,  -64,   97,  -70,  -71,   80, -126,   16,  -17,   41,  -94 },
    {  28,  -92,  -91,   90,  -36,  -83,  -13,  -39,   91,  -70,  117,  -54,   91,   42,   12,  115,   10,  -91,  -93, -113 },
    {   5, -104,  -90, -113,  -27,  -49,   -5,   44, -117,   66,   76,  -63,  -29,  -60,  -59,  -39,   58,  -22,  -56,  -81 },
    { 110,    4,  -13,  -52,   -2,   74, -128,   80,   62,  -46,  -32,  124,  -47,   82,  -45,   46, -100,  -85,    2,   41 },
    {  19, -116,  -24,  -47,   75,  -50,   73,  -69,   51,   62,  -85,   -6,   54,  -99,   -8,  -15,  115,   45,  106,  -97 },
    {-107,    1,  -31,  -99,  -18,    9,   12, -114,   -6,  105,   18,   65,  -42,  -40,  -93,  -64, -104,   62,  -95,   48 },
    { -18, -128,   66,  -79,   97,   78, -106,  -19,  -32,  -58,  -66, -113,  -30, -104,  -20,  -42,   63,   73,  -27,   10 },
};
int main() {
    
    Uetrv32_Uart_Init(BAUD_DIV);
    
    int32_t C[M][N]; 
    TIMER_START
    MATMUL(M, K,N, A, B, C);
    TIMER_STOP
    uint32_t cycles=read_cycles();
    // asm("csrrw t6, mcycle,x0"  );
    // int Cycles_passed;
    // asm ("csrrw %0, mcycle,x0"  : "=r" (Cycles_passed));
    // int i = (read_cycles());
    // asm ("mv t6, %0": : "r"(i));
    // TIMER_START
    // core_matmul(M, K, N, A, B, C);
    // TIMER_STOP
    printMatrix(M,N,C);    
    UART_SendNumber(read_cycles());
    return 0;
}

