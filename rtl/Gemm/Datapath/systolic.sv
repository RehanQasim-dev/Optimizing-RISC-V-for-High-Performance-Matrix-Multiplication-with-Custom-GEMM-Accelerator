// `include "mac.sv"
import Config::*;
module systolic (
    input logic clk,
    rst,
    input logic [SMALL_SYS_ROWS-1:0] if_en,
    input logic [SMALL_SYS_COLS-1:0] wfetch,
    input logic [SMALL_SYS_COLS-1:0] wfetch_halt,
    input logic [SMALL_SYS_ROWS-1:0][A_BITWIDTH-1:0] if_data,
    input logic [SMALL_SYS_COLS-1:0][A_BITWIDTH-1:0] wdata,
    input logic [SMALL_SYS_COLS-1:0][P_BITWIDTH-1:0] bias,
    output logic [SMALL_SYS_COLS-1:0][P_BITWIDTH-1:0] of_data,
    output logic [SMALL_SYS_ROWS-1:0][A_BITWIDTH-1:0] if_data_out,
    output logic [SMALL_SYS_ROWS-1:0] if_en_out,
    output logic [SMALL_SYS_COLS-1:0] wfetch_out,
    output logic [SMALL_SYS_COLS-1:0][A_BITWIDTH-1:0] wdata_out
);
  /////////////////////////////////////////////////////////////////////
  logic [SMALL_SYS_ROWS-1:0][SMALL_SYS_COLS-2:0][A_BITWIDTH-1:0] A_data;
  logic [SMALL_SYS_ROWS-1:0][SMALL_SYS_COLS-2:0]                 A_ready;
  logic [SMALL_SYS_ROWS-2:0][SMALL_SYS_COLS-1:0][W_BITWIDTH-1:0] W_data;
  logic [SMALL_SYS_ROWS-2:0][SMALL_SYS_COLS-1:0]                 W_ready;
  logic [SMALL_SYS_ROWS-2:0][SMALL_SYS_COLS-1:0][P_BITWIDTH-1:0] P_data;

  genvar i, j;
  for (i = 0; i < SMALL_SYS_ROWS; i++) begin
    for (j = 0; j < SMALL_SYS_COLS; j++) begin
      //for control signals flowing downward
      if (i == 0 && j == 0)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(if_en[i]),
            .A_ready(A_ready[i][j]),
            .A_in(if_data[i]),
            .A_out(A_data[i][j]),
            .W_en(wfetch[j] & wfetch_halt[j]),
            .W_ready(W_ready[i][j]),
            .W_in(wdata[j]),
            .W_out(W_data[i][j]),
            .P_in(bias[j]),
            .P_out(P_data[i][j])
        );
      else if (i == 0 && j == SMALL_SYS_COLS - 1)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(A_ready[i][j-1]),
            .A_ready(if_en_out[i]),
            .A_in(A_data[i][j-1]),
            .A_out(if_data_out[i]),
            .W_en(wfetch[j] & wfetch_halt[j]),
            .W_ready(W_ready[i][j]),
            .W_in(wdata[j]),
            .W_out(W_data[i][j]),
            .P_in(bias[j]),
            .P_out(P_data[i][j])
        );

      else if (i == 0)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(A_ready[i][j-1]),
            .A_ready(A_ready[i][j]),
            .A_in(A_data[i][j-1]),
            .A_out(A_data[i][j]),
            .W_en(wfetch[j] & wfetch_halt[j]),
            .W_ready(W_ready[i][j]),
            .W_in(wdata[j]),
            .W_out(W_data[i][j]),
            .P_in(bias[j]),
            .P_out(P_data[i][j])
        );

      if (i == SMALL_SYS_ROWS - 1 && j == 0)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(if_en[i]),
            .A_ready(A_ready[i][j]),
            .A_in(if_data[i]),
            .A_out(A_data[i][j]),
            .W_en(W_ready[i-1][j] & wfetch_halt[j]),
            .W_ready(wfetch_out[j]),
            .W_in(W_data[i-1][j]),
            .W_out(wdata_out[j]),
            .P_in(P_data[i-1][j]),
            .P_out(of_data[j])
        );

      else if (i == SMALL_SYS_ROWS - 1 && j == SMALL_SYS_COLS - 1)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(A_ready[i][j-1]),
            .A_ready(if_en_out[i]),
            .A_in(A_data[i][j-1]),
            .A_out(if_data_out[i]),
            .W_en(W_ready[i-1][j] & wfetch_halt[j]),
            .W_ready(wfetch_out[j]),
            .W_in(W_data[i-1][j]),
            .W_out(wdata_out[j]),
            .P_in(P_data[i-1][j]),
            .P_out(of_data[j])
        );

      else if (i == SMALL_SYS_ROWS - 1)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(A_ready[i][j-1]),
            .A_ready(A_ready[i][j]),
            .A_in(A_data[i][j-1]),
            .A_out(A_data[i][j]),
            .W_en(W_ready[i-1][j] & wfetch_halt[j]),
            .W_ready(wfetch_out[j]),
            .W_in(W_data[i-1][j]),
            .W_out(wdata_out[j]),
            .P_in(P_data[i-1][j]),
            .P_out(of_data[j])
        );

      //for control signals flowing rightward
      if (i != SMALL_SYS_ROWS - 1 && i != 0 && j == 0)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(if_en[i]),
            .A_ready(A_ready[i][j]),
            .A_in(if_data[i]),
            .A_out(A_data[i][j]),
            .W_en(W_ready[i-1][j] & wfetch_halt[j]),
            .W_ready(W_ready[i][j]),
            .W_in(W_data[i-1][j]),
            .W_out(W_data[i][j]),
            .P_in(P_data[i-1][j]),
            .P_out(P_data[i][j])
        );

      else if (i != SMALL_SYS_ROWS - 1 && i != 0 && j == SMALL_SYS_COLS - 1)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(A_ready[i][j-1]),
            .A_ready(if_en_out[i]),
            .A_in(A_data[i][j-1]),
            .A_out(if_data_out[i]),
            .W_en(W_ready[i-1][j] & wfetch_halt[j]),
            .W_ready(W_ready[i][j]),
            .W_in(W_data[i-1][j]),
            .W_out(W_data[i][j]),
            .P_in(P_data[i-1][j]),
            .P_out(P_data[i][j])
        );
      else if (i != SMALL_SYS_ROWS - 1 && i != 0 && j != 0 && j != SMALL_SYS_COLS - 1)
        mac mac_instance (
            .clk(clk),
            .rst(rst),
            .A_en(A_ready[i][j-1]),
            .A_ready(A_ready[i][j]),
            .A_in(A_data[i][j-1]),
            .A_out(A_data[i][j]),
            .W_en(W_ready[i-1][j] & wfetch_halt[j]),
            .W_ready(W_ready[i][j]),
            .W_in(W_data[i-1][j]),
            .W_out(W_data[i][j]),
            .P_in(P_data[i-1][j]),
            .P_out(P_data[i][j])
        );
    end
  end
endmodule
