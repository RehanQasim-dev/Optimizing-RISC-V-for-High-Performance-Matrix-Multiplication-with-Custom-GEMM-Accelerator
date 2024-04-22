module frequency_divider (
    input  logic clk,
    output logic slow_clk
);
  logic [2:0] counter;

  always_ff @(posedge clk) begin : blockName
    counter <= counter + 2'b1;
  end
  assign slow_clk = counter[2];
endmodule
