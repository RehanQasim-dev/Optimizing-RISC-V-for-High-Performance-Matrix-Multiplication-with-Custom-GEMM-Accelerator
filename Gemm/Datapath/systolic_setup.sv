
module systolic_setup #(
    parameter DATA_WIDTH = 8,
    parameter PORTS = 8
) (
    input clk,
    input logic [PORTS-1:0][DATA_WIDTH-1:0] in,
    output logic [PORTS-1:0][DATA_WIDTH-1:0] out
);

  genvar i;
  assign out[0] = in[0];
  for (i = 1; i < PORTS; i++) begin
    pipeline_gen #(
        .data_type(logic [DATA_WIDTH-1:0]),
        .Number(i)
    ) pipeline_gen_instance (
        .clk(clk),
        .a  (in[i]),
        .y  (out[i])
    );
  end
endmodule
