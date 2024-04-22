package Config;
  parameter int SCRATCHPAD_DEPTH = 2 ** 7;

  parameter int BIAS = 0;
  parameter A_BITWIDTH = 8;
  parameter W_BITWIDTH = 8;
  parameter P_BITWIDTH = 24;
  //systolic array configuration
  parameter SMALL_SYS_ROWS = 8;
  parameter SMALL_SYS_COLS = 8;
  parameter CORE_ROWS = 2;
  parameter CORE_COLS = 2;
  parameter int SUPER_SYS_ROWS = CORE_ROWS * SMALL_SYS_ROWS;
  parameter int SUPER_SYS_COLS = SMALL_SYS_COLS * CORE_COLS;
  typedef struct packed {
    logic en, rdwr;
    logic [3:0] mask;
    logic [3:0][7:0] rd_data;
    logic [3:0][7:0] wr_data;
    logic [31:0] addr;
  } dbus_interface;

  //

  // //matrix A config
  // parameter int M = 50;
  // parameter int K = K;
  // //matrix A config
  // parameter int W_rows = K;
  // parameter int W_cols = N;
  //Instruction Memory Size
  // parameter int IBUFF_SIZE = 16;
  // parameter int INSTR_SIZE = 2;
  //Buffer depths
  // parameter int w_buffer_depth = K;
  // parameter int input_buffer_depth = M;
  // parameter int Accumulator_depth = M;
  //
  //These are original matrix sizes that we want to multiply and have to tile in case of bigger size,
  //not being used anywhere yet
  // parameter int super_A_rows = 12;
  // parameter int super_B_rows = 12;
  // parameter int super_w_rows = 8;
  // parameter int super_w_cols = 8;
  // parameter int counter_width = get_counter_width();
  // parameter int no_of_tiles = (super_w_rows / K) * (super_w_cols / N);
  // parameter int weight_dump_length = no_of_tiles * K;
  // parameter int actications_dump_length = no_of_tiles * super_A_rows;
  // function automatic int get_counter_width();
  //   if (K > N) return $clog2(K);
  //   else return $clog2(N);
  // // endfunction
  // int M = $urandom_range(2, 20);
  // int N = $urandom_range(2, 20);
  // int K = $urandom_range(2, 20);

  // typedef int A_type[M][K];
  // typedef int B_type[K][N];
  // typedef int C_type[M][N];

  // function C_type matMul(A_type A, B_type B);
  //   int i;
  //   int j;
  //   int k;
  //   C_type C;
  //   for (i = 0; i < M; i++) begin
  //     for (j = 0; j < N; j++) begin
  //       C[i][j] = 0;
  //       for (k = 0; k < K; k++) begin
  //         C[i][j] += A[i][k] * B[k][j];
  //       end
  //     end
  //   end
  //   return C;
  // endfunction

  // function B_type generate_B();
  //   B_type matrix;
  //   for (int i = 0; i < K; i++) begin
  //     for (int j = 0; j < N; j++) begin
  //       matrix[i][j] = $urandom_range(0, 255);
  //     end
  //   end
  //   return matrix;
  // endfunction

  // function A_type generate_A();
  //   A_type matrix;
  //   for (int i = 0; i < M; i++) begin
  //     for (int j = 0; j < K; j++) begin
  //       matrix[i][j] = $urandom_range(0, 255);
  //     end
  //   end
  //   return matrix;
  // endfunction

endpackage : Config
