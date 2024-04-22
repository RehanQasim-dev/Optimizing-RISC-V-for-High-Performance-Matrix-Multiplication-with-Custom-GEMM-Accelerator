module muxes #(
    parameter WIDTH = 1
) (
    input logic [7:0] mux_sel,
    logic [7:0][WIDTH-1:0] data2,
    logic [7:0][WIDTH-1:0] data1,
    output logic [7:0][WIDTH-1:0] out

);

  genvar i;

  for (i = 0; i < 8; i++) begin
    assign out[i] = mux_sel[i] ? data2[i] : data1[i];
  end

endmodule
