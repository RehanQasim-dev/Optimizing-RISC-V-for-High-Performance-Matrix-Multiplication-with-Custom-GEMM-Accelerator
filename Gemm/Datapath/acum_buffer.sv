import Config::*;
module acum_buffer (
    input logic clk,
    rst,
    valid,
    store,
    rd_en,
    overwrite,
    input logic [3:0][23:0] i_data,
    output logic [127:0] o_data,
    output logic empty
);

  logic [127:0] din_1;
  logic [127:0] dout_1;
  buffer #(
      .DEPTH (16),
      .DWIDTH(128)
  ) accumulator (
      .rst  (rst),
      .clk  (clk),
      .wr_en(wr_en_1),
      .rd_en(rd_en_1),
      .din  (din_1),
      .dout (dout_1),
      .empty(empty_),
      .full ()
  );
  buffer #(

      .DEPTH (16),
      .DWIDTH(128)
  ) buffer_instance (
      .rst  (rst),
      .clk  (clk),
      .wr_en(wr_en_2),
      .rd_en(rd_en),
      .din  (din_1),
      .dout (o_data),
      .empty(empty),
      .full ()
  );

  genvar i;
  for (i = 0; i < 4; i++) begin
    assign din_1[(i+1)*32-1:i*32] = overwrite ? i_data[i] : dout_1[(i+1)*32-1:i*32] + i_data[i];
  end
  assign wr_en_1 = ~store && valid;
  assign wr_en_2 = store && valid;
  assign rd_en_1 = ~overwrite && valid;

endmodule

