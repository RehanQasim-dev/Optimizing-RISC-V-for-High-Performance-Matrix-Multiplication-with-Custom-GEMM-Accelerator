
// `include "/home/abdul_waheed/Music/rv32_for_fyp/Config.sv"

import Config::*;
`define base_addr 32'h9000_0000

module tb_random_gemm();
  logic  clk , rst;
  logic system_bus_en, system_bus_rdwr;
  logic [31:0] system_bus_rd_data, system_bus_wr_data;
  logic [31:0] system_bus_addr;
  logic [4:0] interface_control;
  logic interface_rdwr;
  logic interface_en;
  logic [31:0] interface_addr;
  logic [15:0][7:0] interface_rd_data;
  logic [3:0][31:0] interface_wr_data;
  gemm DUT (
      .clk(clk),
      .rst(rst),
      .system_bus_en(system_bus_en),
      .system_bus_rdwr(system_bus_rdwr),
      .system_bus_rd_data(system_bus_rd_data),
      .system_bus_wr_data(system_bus_wr_data),
      .system_bus_addr(system_bus_addr),
      .interface_control(interface_control),
      .interface_rdwr(interface_rdwr),
      .interface_en(interface_en),
      .interface_addr(interface_addr),
      .interface_rd_data(interface_rd_data),
      .interface_wr_data(interface_wr_data)
  );

  // Additional test input signals
  logic [31:0] test_interface_addr;
  logic [15:0][7:0] test_interface_wr_data;
  logic [4:0] test_interface_control;
  logic test_interface_en;
  logic test_interface_rdwr;
  logic sel_for_test;

  // Define internal signals
  logic [31:0] selected_interface_addr;
  logic [127:0] selected_interface_wr_data;
  logic [4:0] selected_interface_control;
  logic selected_interface_en;
  logic selected_interface_rdwr;

  // Multiplexer to choose between test and original interface signals
  assign selected_interface_addr = sel_for_test ? test_interface_addr : interface_addr;
  assign selected_interface_wr_data = sel_for_test ? test_interface_wr_data : interface_wr_data;
  assign selected_interface_control = sel_for_test ? test_interface_control : interface_control; // Assuming default control value if not provided
  assign selected_interface_en = sel_for_test ? test_interface_en : interface_en; // Assuming default enable value if not provided
  assign selected_interface_rdwr = sel_for_test ? test_interface_rdwr : interface_rdwr; // Assuming default rdwr value if not provided
  memory #(
      .NUM_RAMS(16),
      .A_WID(10),
      .D_WID(8)
  ) memory_instance (
      .clk(clk),
      .interface_rdwr(selected_interface_rdwr),
      .interface_en(selected_interface_en),
      .interface_control(selected_interface_control),
      .interface_addr(selected_interface_addr),
      .interface_wr_data(selected_interface_wr_data),
      .interface_rd_data(interface_rd_data)
  );
  //clock generation
  localparam CLK_PERIOD = 10;
  initial begin
    clk <= 0;
    forever begin
      #(CLK_PERIOD / 2);
      clk <= ~clk;
    end
  end
  // //Testbench
  localparam blkn = SUPER_SYS_ROWS;
  localparam blkk = SUPER_SYS_COLS;
  localparam blkm = 16;
  int n, m, k;
  int i, j;
  int M, K, N;
  int nsize, msize, ksize;
  bit last, first;
  int Tile_A_Address, Tile_B_Address, Tile_C_Address;
  // SystemVerilog does not support dynamic array sizes in module scope, 
  // so we use the maximum expected sizes and only use portions as needed.
  localparam MAX_SIZE = 100;  // Maximum dimension size for matrices
  localparam MAX_VAL = 127;  // Maximum value for matrix elements
  localparam MIN_VAL = -128;  // minimum value for matrix elements
  logic [MAX_SIZE-1:0][ 7:0] A[MAX_SIZE];
  logic [MAX_SIZE-1:0][ 7:0] B[MAX_SIZE];
  logic [MAX_SIZE-1:0][31:0] C[MAX_SIZE];
  int A_addr, B_addr, C_addr;
  int file_handle;

  /////////////////////////////////////
  int old_sel_for_test;
  logic [31:0] cycles_count;
  initial begin
    forever begin
      @(posedge clk);
      if (old_sel_for_test == 1 && sel_for_test == 0) cycles_count <= 0;
      else cycles_count <= cycles_count + 1;
      old_sel_for_test <= sel_for_test;
    end
  end
  /////////////////////////////////////////////Unit Testing/////////////////////////////////////////////
  initial begin
    rst <= 1;
    @(posedge clk);
    rst <= 0;
    sel_for_test <= 1;
    @(posedge clk);
    file_handle = $fopen("/home/abdul_waheed/Music/rv32_for_fyp/log_test_vivado.csv", "w");
    for (int test_no = 0; test_no < 1; test_no++) begin
      $display(
          "------------------------------------Test No %d--------------------------------------",
          test_no + 1);
      M = $urandom_range(MAX_SIZE, MAX_SIZE);
      N = $urandom_range(MAX_SIZE, MAX_SIZE);
      K = $urandom_range(MAX_SIZE, MAX_SIZE);

      A_addr = 0;
      B_addr = M * K;
      C_addr = B_addr + K * N;

      for (int i = 0; i < M; i++) begin
        for (int j = 0; j < K; j++) begin
          A[i][j] = $urandom_range(MIN_VAL, MAX_VAL);
        end
      end
      for (int i = 0; i < K; i++) begin
        for (int j = 0; j < N; j++) begin
          B[i][j] = $urandom_range(MIN_VAL, MAX_VAL);
        end
      end
      $display("M=%d, K=%d, N=%d ", M, K, N);
      for (i = 0; i < M; i++) begin
        for (j = 0; j < N; j++) begin
          C[i][j] = 0;
          for (k = 0; k < K; k++) begin
            C[i][j] += A[i][k] * B[k][j];
          end
        end
      end
      //////////////////////////////////////////Store A Matrix///////////////////////////////////////////////
      for (i = 0; i < M; i++) begin
        for (j = 0; j < K; j += blkk) begin
          ksize = (j + blkk <= K) ? blkk : K % blkk;
          test_interface_addr <= A_addr + i * K + j;
          for (int l = 0; l < ksize; l++) test_interface_wr_data[l] <= A[i][j+l];
          test_interface_control <= ksize;
          test_interface_en <= 1;
          test_interface_rdwr <= 1;
          sel_for_test <= 1;
          @(posedge clk);
        end
      end
      //////////////////////////////////////////Store B Matrix///////////////////////////////////////////////
      for (i = 0; i < K; i++) begin
        for (j = 0; j < N; j += blkn) begin
          nsize = (j + blkn <= N) ? blkn : N % blkn;
          test_interface_addr <= B_addr + i * N + j;
          for (int l = 0; l < nsize; l++) test_interface_wr_data[l] <= B[i][j+l];
          test_interface_control <= nsize;
          test_interface_en <= 1;
          test_interface_rdwr <= 1;
          sel_for_test <= 1;
          @(posedge clk);
        end
      end
      //////////////////////////////////////////Do Configurations///////////////////////////////////////////////
      sel_for_test <= 0;
      for (n = 0; n < N; n += blkn) begin
        // $display("n= %d=", n);
        nsize = (n + blkn <= N) ? blkn : N % blkn;
        for (m = 0; m < M; m += blkm) begin
          msize = (m + blkm <= M) ? blkm : M % blkm;
          // $display("m = %d", m);
          for (k = 0; k < K; k += blkk) begin

            // $display("k = %d", k);
            last = (k + blkk >= K);
            first = k == 0;
            ksize = (k + blkk <= K) ? blkk : K % blkk;
            Tile_A_Address = A_addr + k + m * K;
            Tile_B_Address = B_addr + n + k * N + (ksize - 1) * N;
            Tile_C_Address = C_addr + n + m * K;
            @(posedge clk);
            system_bus_en <= 1;
            system_bus_rdwr <= 1;
            system_bus_addr <= `base_addr + 12;  //tile_A_stride
            system_bus_wr_data <= K;
            @(posedge clk);
            system_bus_addr <= `base_addr + 16;  //tile_B_stride
            system_bus_wr_data <= N;
            @(posedge clk);
            system_bus_en <= 1;
            system_bus_rdwr <= 1;
            system_bus_wr_data <= Tile_A_Address;  //tile_A_addr
            system_bus_addr <= `base_addr;
            // $display("Tile_A_addr= %d", Tile_A_Address);
            @(posedge clk);
            system_bus_addr <= `base_addr + 4;
            system_bus_wr_data <= Tile_B_Address;  //tile_B_addr
            // $display("Tile_B_addr= %d", Tile_B_Address);
            @(posedge clk);
            system_bus_addr <= `base_addr + 8;
            system_bus_wr_data <= Tile_C_Address;  //tile_C_addr
            // $display("Tile_C_addr= %d", Tile_C_Address);

            @(posedge clk);
            system_bus_addr <= `base_addr + 20;  //GEMM_control
            system_bus_wr_data <= first << 1 | last;
            @(posedge clk);
            system_bus_addr <= `base_addr + 24;  //GEMM_DIM
            system_bus_wr_data <= msize | ksize << 5 | nsize << 10;
            // $display("msize=%d, nsize=%d, ksize=%d", msize, nsize, ksize);
            @(posedge clk);
            system_bus_en   <= 1;
            system_bus_rdwr <= 0;
            system_bus_addr <= `base_addr;  //check if GEMM is FULLL
            @(posedge clk);
            while (system_bus_rd_data == 1'b1) begin
              @(posedge clk);
              // Wait for the GEMM operation to complete;
            end

          end
        end
      end
      system_bus_en   <= 1;
      system_bus_rdwr <= 0;
      system_bus_addr <= `base_addr + 24;  //check if GEMM is done
      @(posedge clk);
      while (system_bus_rd_data != 1'b1) begin
        @(posedge clk);
        // Wait for the GEMM operation to complete;
      end
      $display("the cycles are : %0d\n ",cycles_count );
      $display("the dimensions are(M,K,N) : %0d , %0d , %0d \n", M, K, N );

      $fwrite(file_handle, "%0d,%0d,%0d,%0d\n", M, K, N, cycles_count);

    end
    $fclose(file_handle);
    $finish;
  end
  // Define variables
  int count_rows_compared;
  int total_tiles, n_, nsize_, msize_, N_;

  // Initialization block
  initial begin
    forever begin

      // Wait for negedge of sel_for_test signal
      @(negedge sel_for_test);

      // Calculate total number of tiles
      // total_tiles = ((N + SUPER_SYS_COLS - 1) / SUPER_SYS_COLS) * ((M + SUPER_SYS_ROWS - 1) / SUPER_SYS_ROWS);

      // // Iterate over tiles
      // repeat (total_tiles) begin
      N_ = N;  // Set N_
      for (n_ = 0; n_ < N_; n_ += blkn) begin
        nsize_ = (n_ + blkn <= N_) ? blkn : N_ % blkn;
        // msize_ = msize;

        count_rows_compared = 0;  // Initialize count
        while (count_rows_compared < M) begin
          // Iterate over elements in row
          for (int i = n_; i < (nsize_ + n_); i++) begin
            if (i % 4 == 0) begin
              @(posedge clk);
              while (!(interface_en && interface_rdwr)) begin
                @(posedge clk);
              end
            end

            // Display comparison
            // $display("C[%0d][%0d] = %0d , interface_wr_data[%0d] = %0d", count_rows_compared, i,
            //          C[count_rows_compared][i], i, interface_wr_data[i%4]);
            if (C[count_rows_compared][i] != interface_wr_data[i%4]) begin
              $display("Mismatch found C[%0d][%0d] = %0d , interface_wr_data[%0d] = %0d, time=%0d",
                       count_rows_compared, i, C[count_rows_compared][i], i,
                       interface_wr_data[i%4], $time);
            end
          end
          count_rows_compared++;
        end
      end
      $display("Matrix Test Passed");
    end

  end


endmodule
