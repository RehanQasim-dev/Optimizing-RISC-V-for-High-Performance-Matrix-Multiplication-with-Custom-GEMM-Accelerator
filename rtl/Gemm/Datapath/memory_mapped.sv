`define base_addr 32'h9000_0000

module memory_mapped (
    input logic clk,
    rst,
    read_all_buffers,
    input logic system_bus_en,
    system_bus_rdwr,
    logic [31:0] system_bus_wr_data,
    system_bus_addr,
    output logic [31:0] system_bus_rd_data,
    tile_A_addr,
    tile_B_addr,
    tile_C_addr,
    tile_A_stride,
    tile_B_stride,
    logic [4:0] ksize,
    msize,
    nsize,
    logic store,
    overwrite,
    output logic conf_empty
);

  // Signals for tile_A_addr buffer
  logic tile_A_addr_wr_en;  // Read enable for tile_A_addr buffer
  logic tile_A_buff_empty;  // Empty status for tile_A_addr buffer
  logic tile_A_buff_full;  // Full status for tile_A_addr buffer

  // Signals for tile_B_addr buffer
  logic tile_B_addr_wr_en;  // Read enable for tile_B_addr buffer
  logic tile_B_buff_empty;  // Empty status for tile_B_addr buffer
  logic tile_B_buff_full;  // Full status for tile_B_addr buffer

  // Signals for tile_C_addr buffer
  logic tile_C_addr_wr_en;  // Read enable for tile_C_addr buffer
  logic tile_C_buff_empty;  // Empty status for tile_C_addr buffer
  logic tile_C_buff_full;  // Full status for tile_C_addr buffer

  // Signals for tile_A_stride buffer
  logic tile_A_stride_wr_en;  // Read enable for tile_A_stride buffer
  logic tile_A_stride_buff_empty;  // Empty status for tile_A_stride buffer
  logic tile_A_stride_buff_full;  // Full status for tile_A_stride buffer

  // Signals for tile_B_stride buffer
  logic tile_B_stride_wr_en;  // Read enable for tile_B_stride buffer
  logic tile_B_stride_buff_empty;  // Empty status for tile_B_stride buffer
  logic tile_B_stride_buff_full;  // Full status for tile_B_stride buffer

  // Signals for GEMM_control buffer
  logic GEMM_control_wr_en;  // Read enable for GEMM_control buffer
  logic [31:0] GEMM_control;  // Data output for GEMM_control buffer
  logic GEMM_control_buff_empty;  // Empty status for GEMM_control buffer
  logic GEMM_control_buff_full;  // Full status for GEMM_control buffer

  // Signals for tile_dimension buffer
  logic tile_dimension_wr_en;  // Read enable for tile_dimension buffer
  logic [31:0] tile_dimension;  // Data output for tile_dimension buffer
  logic tile_dimension_buff_empty;  // Empty status for tile_dimension buffer
  logic tile_dimension_buff_full;  // Full status for tile_dimension buffer
  // Buffer for tile_A_addr

  buffer #(
      .DEPTH (2),
      .DWIDTH(32)
  ) tileA_addr_buffer (
      .rst  (rst),
      .clk  (clk),
      .wr_en(tile_A_addr_wr_en),
      .rd_en(read_all_buffers),
      .din  (system_bus_wr_data),
      .dout (tile_A_addr),
      .empty(tile_A_buff_empty),
      .full (tile_A_buff_full)
  );
  // Buffer for tile_B_addr
  buffer #(
      .DEPTH (2),
      .DWIDTH(32)
  ) tileB_addr_buffer (
      .rst  (rst),
      .clk  (clk),
      .wr_en(tile_B_addr_wr_en),
      .rd_en(read_all_buffers),
      .din  (system_bus_wr_data),
      .dout (tile_B_addr),
      .empty(tile_B_buff_empty),
      .full (tile_B_buff_full)
  );

  // Buffer for tile_C_addr
  buffer #(
      .DEPTH (2),
      .DWIDTH(32)
  ) tileC_addr_buffer (
      .rst  (rst),
      .clk  (clk),
      .rd_en(read_all_buffers),
      .wr_en(tile_C_addr_wr_en),
      .din  (system_bus_wr_data),
      .dout (tile_C_addr),
      .empty(tile_C_buff_empty),
      .full (tile_C_buff_full)
  );

  // Buffer for tile_A_stride
  buffer #(
      .DEPTH (2),
      .DWIDTH(32)
  ) tileA_stride_buffer (
      .rst  (rst),
      .clk  (clk),
      .wr_en(tile_A_stride_wr_en),
      .rd_en(read_all_buffers),
      .din  (system_bus_wr_data),
      .dout (tile_A_stride),
      .empty(tile_A_stride_buff_empty),
      .full (tile_A_stride_buff_full)
  );

  // Buffer for tile_B_stride
  buffer #(
      .DEPTH (2),
      .DWIDTH(32)
  ) tileB_stride_buffer (
      .rst  (rst),
      .clk  (clk),
      .wr_en(tile_B_stride_wr_en),
      .rd_en(read_all_buffers),
      .din  (system_bus_wr_data),
      .dout (tile_B_stride),
      .empty(tile_B_stride_buff_empty),
      .full (tile_B_stride_buff_full)
  );

  // Buffer for GEMM_control
  buffer #(
      .DEPTH (2),
      .DWIDTH(32)
  ) GEMM_control_buffer (
      .rst  (rst),
      .clk  (clk),
      .wr_en(GEMM_control_wr_en),
      .rd_en(read_all_buffers),
      .din  (system_bus_wr_data),
      .dout (GEMM_control),
      .empty(GEMM_control_buff_empty),
      .full (GEMM_control_buff_full)
  );

  // Buffer for tile_dimension
  buffer #(
      .DEPTH (2),
      .DWIDTH(32)
  ) tile_dimension_buffer (
      .rst  (rst),
      .clk  (clk),
      .wr_en(tile_dimension_wr_en),
      .rd_en(read_all_buffers),
      .din  (system_bus_wr_data),
      .dout (tile_dimension),
      .empty(tile_dimension_buff_empty),
      .full (tile_dimension_buff_full)
  );


  always_comb begin
    tile_A_addr_wr_en = 0;
    tile_B_addr_wr_en = 0;
    tile_C_addr_wr_en = 0;
    tile_A_stride_wr_en = 0;
    tile_B_stride_wr_en = 0;
    GEMM_control_wr_en = 0;
    tile_dimension_wr_en = 0;
    if (system_bus_en && system_bus_rdwr)

      case (system_bus_addr)
        `base_addr: tile_A_addr_wr_en = 1;
        `base_addr + 4: tile_B_addr_wr_en = 1;
        `base_addr + 8: tile_C_addr_wr_en = 1;
        `base_addr + 12: tile_A_stride_wr_en = 1;
        `base_addr + 16: tile_B_stride_wr_en = 1;
        `base_addr + 20: GEMM_control_wr_en = 1;
        `base_addr + 24: tile_dimension_wr_en = 1;
      endcase
  end
  always_comb begin
    if (system_bus_en && !system_bus_rdwr)
      case (system_bus_addr)
        `base_addr: system_bus_rd_data = {31'd0, tile_A_buff_full};
        // `base_addr+4: tile_B_addr_wr_en=1;
        // `base_addr+8: tile_C_addr_wr_en=1;
        // `base_addr+12: tile_A_stride_wr_en=1;
        // `base_addr+16: tile_B_stride_wr_en=1;
        // `base_addr+20: GEMM_control_wr_en=1;
        `base_addr + 24: system_bus_rd_data = {31'b0, tile_dimension_buff_empty};
        default: system_bus_rd_data = 0;
      endcase
    else begin
      system_bus_rd_data = 0;
    end
  end
  assign conf_empty = tile_dimension_buff_empty;
  assign store = GEMM_control[0];
  assign overwrite = GEMM_control[1];
  assign msize = tile_dimension[4:0];
  assign ksize = tile_dimension[9:5];
  assign nsize = tile_dimension[14:10];
endmodule
