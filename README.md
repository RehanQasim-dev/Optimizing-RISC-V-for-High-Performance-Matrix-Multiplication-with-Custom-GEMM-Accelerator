# A GEMM (General Matrix Multiplier) Co-processor

This Project is a Martix multiplier Co-processor integrated with a RISC-V 3-stage pipelined processor with integrated UART peripheral. Currently, the core implements RV32IMZicsr ISA based on User-level ISA Version 2.0 and Privileged Architecture Version 1.11 supporting only M mode. The following are the key features of this project:

## Key Features
- 32-bit RISC-V ISA core that supports base integer (I) and multiplication and division (M),  and Zicsr (Z) extensions (RV32IMZicsr) with a custom GEMM Co-processor.
- Supports 8-bit signed input matrix elements and 32-bit signed output matrix elements.
- Supports Dual port data memory of 16 banks that is synthesizable in Vivado.
- Supports user input for Matrix by both data memory and UART.
- Support for any size of matrix by using Runtime tiling provided by our GEMM.h file.
- Overlapping of configuration and computation stages in GEMM to hide the latency of the configuration.
- Support for performance monitoring in hardware by CSR counters.
- Comprehensive random testing of GEMM with different matrix sizes and element values.

### System Design Overview
The GEMM Co-processor is a loosely coupled Co-processor that can be configured by its memory-mapped registers. So we don't need to change the core's datapath and control that's the case with tightly coupled co-processors and we can easily integrate it with existing cores We have used a Dual port data memory with a 32-bit interface with RISCV-V core and a 128-bit wide interface with GEMM. The main unit of GEMM consists of 16x16 systolic array of MAC units. The GEMM is optimized to overlap the the computations in case when we need to process multiple tiles for a matrix. The architecture also overlaps the configuration and computation activities of the coprocessor which enables us to approach the ideal performance gain of 256x as the matrix size increases.
![Block Diagram](./pdf/GEMM.png)

The block diagram shows the connectivity of the core with memory, GEMM, and UART peripherals using the data bus. Instruction memory is a form of ROM and is built into the RISC-V core for our case.

###  Memory Map
The memory map for the Gemm and UART is provided in the following table.
| Base Address        |    Description            |
|:-------------------:|:-------------------------:|
| 0x8000_0000         |      UART                 |
| 0x9000_0000         |      GEMM_A               |
| 0x9000_0004         |      GEMM_B               |
| 0x9000_0008         |      GEMM_C               |
| 0x9000_000C         |      GEMM_stride_A        |
| 0x9000_0010         |      GEMM_stride_B        |
| 0x9000_0014         |      GEMM_control         |
| 0x9000_0018         |      GEMM_DIM             |

## Operations Overview:
The following diagram shows the all the components of the system and the operations performed on each stage.

![Operation Flow Diagram](./pdf/Operation%20Flow%20Diagram.png)
## Architectural Details:

| Parameter                        | Value             |
|----------------------------------|-------------------|
| Input size                       | 8 bits (signed)   |
| Result size                      | 32 bits           |
| DataFlow                         | Weight Stationary |
| Systolic Array Size              | 16 x 16           |
| Core Size                        | 8 x 8             |
| Number of Cores                  | 4                 |
| Data memory Banks (dual port)    | 16                |
| Banks Port Widths                | 8 bits            |
| Accumulator Size                 | 16 x 32           |

## Performance Comparison:
The table below compares the performance of the GEMM Co-processor with the RISC-V scalar core. The cycle counts for the RISC-V core are empirically calculated, assuming no control hazards, using the following formulas:
- Loading matrices: MxK + KxN
- Computation: 2xMxKxN
- Storing the result matrix: MxN  

| A (M,K) | B (K,N) | GEMM cycles | Core Cycles (emp.) | Performance Gain |
|---------|---------|-------------|--------------------|------------------|
| (60, 60)| (60, 60)| 3119        | 442,800            | 142x             |
| (60, 8) | (8, 60) | 659         | 62,160             | 94x              |
| (8, 60) | (60, 8) | 248         | 8,704              | 35x              |
| (8, 8)  | (8, 8)  | 48          | 1,216              | 25x              |

## Getting Started
The following Programs are needed for the usage of the Accelerator.
- [Vivado](https://www.xilinx.com/products/design-tools/vivado.html) for usage on Hardware.
- [toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) for compiling to binary.
- [GTKterm](https://github.com/wvdakker/gtkterm) for displaying UART transmission.

Install RISC-V [toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain). These tools can be built by following the instructions in the corresponding links or can be installed directly by running the following command

    sudo apt-get install -y gcc-riscv64-unknown-elf gtkwave

Check that these tools are installed correctly, by running `riscv64-unknown-elf-gcc -v` and `gtkterm`.

### Using GEMM.h 
Use the functions defined in [GEMM.h] (./Script/src/gemm.h). The MATMUL function is the GEMM matrix multiplication function and it handles all the configuration of GEMM in hardware and you just need to pass your matrices to it which you want to multiply and the matrix to store the result. The function accepts dimensions and the addresses of the matrix as arguments:

    MATMUL( uint32_t A_rows, uint32_t A_cols, uint32_t B_cols,int8_t A[A_rows][A_cols], int8_t B[A_cols][B_cols], int32_t C[A_rows][B_cols]);

Compile the c-code using the following command(linux):

    ./Script/make.sh
    
Compile the c-code using the following command(Windows):

    ./Script/make.bat

This compilies the c-code and makes the files [ICACHE.mem](./Script/build/ICACHE.mem) and memory files for the data memory banks that are to be read by [instruction_memory](./rtl/Core/Datapath/inst_mem.sv) and [data_memory](./rtl/Gemm/Datapath/banked_memory.sv).

You can use the counter **MCYCLE** for checking hardware cycles taken by the function. These macros are defined in [timer.h](./Script/src/gemm.h).

before calling the **MATMUL** function:

    TIMER_START
After returning from the function:

    TIMER_STOP
The value of cycles can be read into a 32-bit un-signed variable by calling the function:

    read_cycles();

### Using UART.h
To display using UART to `gtkterm` we first need to set some of the following parameters. 
- Select the Baud rate to be used. (Default: 9600)
- Calculate the UART Baud divisor and write it to c-code. (Default: 1301)
- Make sure of RISC-V frequency for calculations of Baudrate and Divisor.
- Provide Access to the port for UART transmission for both `Python` and `FPGA`.

First, we select the Baud rate to display. Then calculate the Baud-divisor by using the following formula:

![Baud_divisor](./pdf/baud%20rate.png)

The baud divisor is then set in C-code by using the function:

    Uetrv32_Uart_Init(uint32_t baud);

To print string onto UART use:

    Uetrv32_Uart_Print(string);

To print 32-bit integers use:

    UART_Send_32bit_number(uint32_t Number);

To Print Matrix to UART use:

    void display_result_matrix(int rows, int cols, int32_t matrix[rows][cols]);

To receive input from UART use:

    uint8_t Uetrv32_Uart_Rx(void);

All of the above is to be used in C-code.

### Using Python_uart to transmit to UART.
**` Warning: We have implemented this on Linux. Windows permissions for ports can be tricky.`**
Now we move to the Python script [python_uart](./python_uart.py) that we use to transmit our matrix to UART. We first need to install pyserial by:

    pip install pyserial

Then define the Port and Baud rate that you have set in the python file. Then define the Rows(M)and column(K) of Matrix A and Rows(K) and Columns(N) of Matrix B. The python script will generate a matrix of the provided dimensions of 8-bit signed integer and transmit it to UART port. It also calculates the resultant matrix and prints to the terminal.

To run the Python command use:

    sudo -E python3 python_uart.py

This allows the Python script to access the UART port and still use the non-root environment for Python.

### Displaying to GTKterm.
Open gtkterm as sudo:

    sudo gtkterm

Set the port and Baudrate in Configurations. Below is the resulant output of the Gtkterm.
