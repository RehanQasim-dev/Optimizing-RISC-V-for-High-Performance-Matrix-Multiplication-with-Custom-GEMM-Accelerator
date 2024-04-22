module pipeline_gen #(

    parameter type data_type = logic [3:0],
    parameter Number = 1
) (
    input clk,
    input data_type a,
    output data_type y
);
  data_type [Number-1:0] internal;
  genvar i;
  for (i = 0; i < Number; i++) begin
    if (i == 0) begin
      always_ff @(posedge clk) begin : blockName
        internal[i] <= a;
      end
    end else begin
      always_ff @(posedge clk) begin : blockName
        internal[i] <= internal[i-1];
      end
    end
  end
  assign y = internal[Number-1];

endmodule
