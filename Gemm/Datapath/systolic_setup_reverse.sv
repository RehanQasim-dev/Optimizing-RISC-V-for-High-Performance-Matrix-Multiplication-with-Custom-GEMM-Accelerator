
module systolic_setup_reverse #(
    parameter DATA_WIDTH = 8,
    parameter PORTS = 8
) (
    input clk,
    rst,
    input logic [PORTS-1:0][DATA_WIDTH-1:0] in,
    output logic [PORTS-1:0][DATA_WIDTH-1:0] out
);

  genvar i;
  assign out[PORTS-1] = in[PORTS-1];
  for (i = 0; i < PORTS - 1; i++) begin
    pipeline_gen #(
        .data_type(logic [DATA_WIDTH-1:0]),
        .Number(PORTS - 1 - i)
    ) pipeline_gen_instance (
        .clk(clk),
        .a  (in[i]),
        .y  (out[i])
    );
  end
endmodule
