module store_controller (
    input logic clk,
    input logic rst,
    input logic can_do_store,
    input [3:0] buffer_empty,
    input logic [4:0] msize,
    nsize,
    input logic gt4,
    gt8,
    gt12,
    input logic [31:0] tile_C_addr,
    tile_B_stride,
    current_row_addr,
    output logic [3:0] rd_result,
    output logic gen_addr,
    interface_en,
    output logic [4:0] interface_control,
    output logic [31:0] next_row_addr,
    current_addr,
    output logic interface_rdwr,
    output logic done_store,
    output logic [1:0] buffer_sel
);

  // State parameters
  parameter IDLE = 3'd0, STORE0 = 3'd1, STORE1 = 3'd2, STORE2 = 3'd3, STORE3 = 3'd4;

  // State variables
  logic [2:0] cs, ns;

  // Counter for tracking the number of stores
  logic [$clog2(32)-1:0] count;
  logic ovf, count_en, count_clr;

  // Counter logic
  always_ff @(posedge clk) begin
    if (rst || count_clr) count <= 1;
    else if (count_en) count <= count + 1;
  end
  assign ovf = count == msize;
  // logic gen_addr;
  // assign gen_addr = gen_addr;
  // Main state machine logic
  always_comb begin
    gen_addr = 0;
    interface_en = 0;
    interface_control = 'x;
    next_row_addr = current_row_addr;
    current_addr = 'x;
    interface_rdwr = 1;  //write
    rd_result = 0;
    count_en = 0;
    done_store = 0;
    buffer_sel = 'x;
    count_clr = 0;
    ns = IDLE;
    case (cs)
      IDLE:
      if (can_do_store) begin
        ns = STORE0;
        next_row_addr = tile_C_addr;
        gen_addr = 1;
        count_clr = 1;
      end else begin
        gen_addr = 'x;
        interface_en = 'x;
        interface_control = 'x;
        next_row_addr = 'x;
        interface_rdwr = 'x;
        ns = IDLE;
      end
      STORE0:
      if (buffer_empty[0]) begin
        ns = STORE0;
      end else if (~buffer_empty[0] && gt4) begin
        current_addr = current_row_addr;
        interface_en = 1;
        interface_control = 5'd16;
        rd_result[0] = 1;
        buffer_sel = 0;
        ns = STORE1;
      end else if (~ovf && ~buffer_empty[0] && ~gt4) begin
        current_addr = current_row_addr;
        next_row_addr = current_row_addr + {tile_B_stride[29:0], 2'b00};
        gen_addr = 1;
        interface_en = 1;
        interface_control = {nsize[2:0], 2'b00};
        rd_result[0] = 1;
        buffer_sel = 0;
        count_en = 1;
        ns = STORE0;
      end else begin
        current_addr = current_row_addr;
        interface_en = 1;
        interface_control = {nsize[2:0], 2'b00};
        rd_result[0] = 1;
        buffer_sel = 0;
        done_store = 1;
        ns = IDLE;
      end

      STORE1:
      if (buffer_empty[1]) begin
        ns = STORE1;
      end else if (~buffer_empty[1] && gt8) begin
        current_addr = current_row_addr + 16;
        interface_en = 1;
        interface_control = 5'd16;
        rd_result[1] = 1;
        buffer_sel = 1;
        ns = STORE2;
      end else if (~ovf && ~buffer_empty[1] && ~gt8) begin
        current_addr = current_row_addr + 16;
        next_row_addr = current_row_addr + {tile_B_stride[29:0], 2'b00};
        gen_addr = 1;
        interface_en = 1;
        interface_control = {nsize - 5'd4, 2'b00};
        rd_result[1] = 1;
        buffer_sel = 1;
        count_en = 1;

        ns = STORE0;
      end else begin
        current_addr = current_row_addr + 16;
        interface_en = 1;
        interface_control = {nsize - 5'd4, 2'b00};
        rd_result[1] = 1;
        buffer_sel = 1;
        done_store = 1;
        ns = IDLE;
      end

      STORE2:
      if (buffer_empty[2]) begin
        ns = STORE2;
      end else if (~buffer_empty[2] && gt12) begin
        current_addr = current_row_addr + 32;
        interface_en = 1;
        interface_control = 5'd16;
        rd_result[2] = 1;
        buffer_sel = 2;
        ns = STORE3;
      end else if (~ovf && ~buffer_empty[2] && ~gt12) begin
        current_addr = current_row_addr + 32;
        next_row_addr = current_row_addr + {tile_B_stride[29:0], 2'b00};
        gen_addr = 1;
        interface_en = 1;
        interface_control = {nsize - 5'd8, 2'b00};
        rd_result[2] = 1;
        buffer_sel = 2;
        count_en = 1;

        ns = STORE0;
      end else begin
        current_addr = current_row_addr + 32;
        interface_en = 1;
        interface_control = {nsize - 5'd8, 2'b00};
        rd_result[2] = 1;
        buffer_sel = 2;
        done_store = 1;
        ns = IDLE;
      end

      STORE3:
      if (buffer_empty[3]) begin
        ns = STORE3;
      end else if (~ovf && ~buffer_empty[3]) begin
        current_addr = current_row_addr + 48;
        next_row_addr = current_row_addr + {tile_B_stride[29:0], 2'b00};
        gen_addr = 1;
        interface_en = 1;
        interface_control = {nsize - 5'd12, 2'b00};
        rd_result[3] = 1;
        buffer_sel = 3;
        count_en = 1;

        ns = STORE0;
      end else if (ovf && ~buffer_empty[3]) begin
        current_addr = current_row_addr + 48;
        interface_en = 1;
        interface_control = {nsize - 5'd12, 2'b00};
        rd_result[3] = 1;
        buffer_sel = 3;
        done_store = 1;
        ns = IDLE;
      end
    endcase
  end
  always_ff @(posedge clk) begin
    if (rst) cs <= IDLE;  // Reset current state to IDLE
    else cs <= ns;  // Transition to next state
  end

endmodule
