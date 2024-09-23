
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
      .A_WID(15),
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
  // SystemVerilog does not support dynamic array sizes in module scope, 
  // so we use the maximum expected sizes and only use portions as needed.
  localparam MAX_SIZE = 300 ;  // Maximum dimension size for matrices
  localparam MAX_VAL = 256;  // Maximum value for matrix elements
  // localparam MIN_VAL = -128;  // minimum value for matrix elements
  reg signed [MAX_SIZE-1:0][ 7:0] A[MAX_SIZE];
  reg signed [MAX_SIZE-1:0][ 7:0] B[MAX_SIZE];
  reg signed [MAX_SIZE-1:0][31:0] C[MAX_SIZE];
 integer temp;
 logic [31:0] temp2;
  int A_addr, B_addr, C_addr;
  int file_handle;
int Tile_A_Address, Tile_B_Address, Tile_C_Address;
int remaining_n;
int remaining_m ;
int remaining_k ;

int current_n = 0;
int current_m = 0;
int current_k = 0;
int cols_to_process, rows_to_process, rows_to_process_k;
logic is_last;
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
    file_handle = $fopen("./log_test_vivado.csv", "w");
    for (int test_no = 0; test_no < 200; test_no++) begin
      $display(
          "------------------------------------Test No %d--------------------------------------",
          test_no + 1);
      M = $urandom_range(2, MAX_SIZE);
      N = $urandom_range(2, MAX_SIZE);
      K = $urandom_range(2, MAX_SIZE);
      M = MAX_SIZE;
      // N = MAX_SIZE;
      // K = MAX_SIZE;
      A_addr = 0;
      B_addr = M * K;
      C_addr = B_addr + K * N;

      for (int i = 0; i < M; i++) begin
        for (int j = 0; j < K; j++) begin
          temp = $random % 256; // $random generates a large number; % 256 limits it to 8 bits
        
        // Convert the number to the range -128 to 127
        if (temp > 127) begin
            A[i][j] = temp - 256;
        end else begin
            A[i][j]  = temp;
        end
        end
      end
      // assign A='{'{3,-8,0,-17,-5,-2,6,-12,-12,-18,5},'{-19,-8,-7,7,-2,6,-8,-8,-1,-16,1},'{3,2,-5,4,-8,-18,10,-1,-13,-11,-7},'{-5,2,0,10,-8,0,-6,9,-13,-5,-15},'{6,-19,8,-18,-7,-19,-4,-7,2,-5,-8},'{4,6,-12,9,6,4,2,-2,-10,3,9},'{4,-19,0,-14,0,6,9,-4,7,3,8},'{2,-8,6,3,-2,-3,-4,-14,-9,-16,9},'{-9,-15,-5,-14,7,-8,-15,-10,7,-17,7},'{-14,6,4,3,5,-14,9,-2,0,1,8},'{-6,8,4,-19,1,0,1,-4,-13,-1,0}};

      // Display matrix A in Python-compatible format
      // $display("Matrix A = [");
      // for (int i = 0; i < M; i++) begin
      //   $write("    [");
      //   for (int j = 0; j < K; j++) begin
      //     $write("%d", $signed(A[i][j]));
      //     if (j < K-1) $write(", ");
      //   end
      //   $write("]");
      //   if (i < M-1) $display(",");
      //   else $display("");
      // end
      // $display("]");
      // $display(""); // Extra line for separation

      // $display("%p",A);
      for (int i = 0; i < K; i++) begin
        for (int j = 0; j < N; j++) begin
           temp = $random % 256; // $random generates a large number; % 256 limits it to 8 bits
        
        // Convert the number to the range -128 to 127
        if (temp > 127) begin
            B[i][j] = temp - 256;
        end else begin
            B[i][j]  = temp;
        end

        end
      end
      // assign B='{'{7,-4,-8,9,-1,3,-12,9,9,2,4},'{-2,-2,2,1,-14,0,10,-16,-14,4,-15},'{-3,-13,-7,-5,9,-15,-19,-11,-15,-7,-13},'{-18,0,2,-18,2,6,8,7,-19,-3,-14},'{2,7,1,-2,-1,9,-3,8,-5,-17,-12},'{5,-13,6,0,-6,5,-7,9,2,8,2},'{-8,-15,-11,-19,6,10,0,4,0,3,1},'{-5,6,-15,1,-18,-15,6,-4,1,-3,-12},'{-1,-5,-4,9,-19,-19,-10,-2,3,0,-6},'{1,-10,-17,7,2,0,3,-14,-19,-2,9},'{1,-19,0,-13,0,2,-4,-7,-12,1,-15}};
      // $display("Matrix B = [");
      // for (int i = 0; i < K; i++) begin
      //   $write("    [");
      //   for (int j = 0; j < N; j++) begin
      //     $write("%d", $signed(B[i][j]));
      //     if (j < N-1) $write(", ");
      //   end
      //   $write("]");
      //   if (i < K-1) $display(",");
      //   else $display("");
      // end
      // $display("]");
      // $display(""); // Extra line for separation
      // $display("%p",B);
      // ------------------------------------------------------------------
      $display("M=%d, K=%d, N=%d ", M, K, N);
      for (i = 0; i < M; i++) begin
        for (j = 0; j < N; j++) begin
          C[i][j] = 0;
          for (k = 0; k < K; k++) begin
            temp2=$signed(A[i][k]) * $signed(B[k][j]);
            C[i][j] = C[i][j]+temp2;
          end
        end
      end

      // $display("Matrix C = [");
      // for (int i = 0; i < M; i++) begin
      //   $write("    [");
      //   for (int j = 0; j < N; j++) begin
      //     $write("%d", $signed(C[i][j]));
      //     if (j < N-1) $write(", ");
      //   end
      //   $write("]");
      //   if (i < M-1) $display(",");
      //   else $display("");
      // end
      // $display("]");
      // $display(""); // Extra line for separation



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
      // Assuming the following variables and constants are defined elsewhere:
// A, B, C arrays
// SUPER_SYS_COLS, 16, SUPER_SYS_ROWS constants
// GEMM_A, GEMM_DIM signals
// Configure_GEMM function


      remaining_n = N;
      remaining_m = M;
      remaining_k = K;
      current_n = 0;
      current_m = 0;
      current_k = 0;
    while (remaining_n > 0) begin
        cols_to_process = (remaining_n >= SUPER_SYS_COLS) ? SUPER_SYS_COLS : remaining_n;
      // $display("hello now in remaing_n loop\n : %d",remaining_n);
        while (remaining_m > 0) begin
                // $display("hello now in remaing_m loop\n : %d",remaining_m);

            rows_to_process = (remaining_m >= 16) ? 16 : remaining_m;

            while (remaining_k > 0) begin
                    // $display("hello now in remaing_k loop\n : %d", remaining_k);

                rows_to_process_k = (remaining_k >= SUPER_SYS_ROWS) ? SUPER_SYS_ROWS : remaining_k;

                last = (current_k + SUPER_SYS_ROWS >= K);
                first = (current_k == 0);
                Tile_A_Address = A_addr + current_m * K + current_k;
                Tile_B_Address = B_addr+(current_k + rows_to_process_k - 1)*N+current_n;
                Tile_C_Address = C_addr + current_m * N + current_n;
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
            system_bus_wr_data <= rows_to_process | rows_to_process_k << 5 | cols_to_process << 10;
            // $display("msize=%d, nsize=%d, ksize=%d", msize, nsize, ksize);
            @(posedge clk);
            system_bus_en   <= 1;
            system_bus_rdwr <= 0;
            system_bus_addr <= `base_addr;  //check if GEMM is FULLL
            @(posedge clk);
            while (system_bus_rd_data == 1'b1) begin
              @(posedge clk);
              // $display("hello now in hell forever\n");
              // Wait for the GEMM operation to complete;
            end

            remaining_k -= rows_to_process_k;
            current_k = K - remaining_k;
            end
            current_k = 0;
            remaining_m -= rows_to_process;
            current_m = M - remaining_m;
            remaining_k = K;
        end
        current_m = 0;
        remaining_n -= cols_to_process;
        current_n = N - remaining_n;
        remaining_m = M;
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
      // $display("the dimensions are(M,K,N) : %0d , %0d , %0d \n", M, K, N );

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
            if ($signed(C[count_rows_compared][i]) != $signed(interface_wr_data[i%4])) begin
              $display("Mismatch found C[%0d][%0d] = %0d , interface_wr_data[%0d] = %0d",
                       count_rows_compared, i, $signed(C[count_rows_compared][i]), i,
                       $signed(interface_wr_data[i%4]));
            end
          end
          count_rows_compared++;
        end
      end
      $display("Matrix Test Passed");
    end

  end


endmodule
