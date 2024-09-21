//`include "buffer.sv"
import Config::*;
module accumulator (
    input logic rst,
    clk,
    [3:0]store,
    [3:0]overwrite,
    input logic [3:0] rd_en,
    input logic [3:0] true_valid,
    input logic [SUPER_SYS_COLS/4-1:0][3:0][P_BITWIDTH-1:0] i_data,
    output logic [3:0][3:0][31:0] o_data,
    output logic [3:0] empty
);
  // assign gt4=nsize>4;
  // assign gt8=nsize>8;
  // assign gt12=nsize>12;


  genvar i;
  generate
    for (i = 0; i < SUPER_SYS_COLS / 4; i = i + 1) begin
      acum_buffer acum_buffer_instance (
          .clk(clk),
          .rst(rst),
          .valid(true_valid[i]),
          .rd_en(rd_en[i]),
          .store(store[i]),
          .overwrite(overwrite[i]),
          .i_data(i_data[i]),
          .o_data(o_data[i]),
          .empty(empty[i])
      );
    end
  endgenerate
endmodule
