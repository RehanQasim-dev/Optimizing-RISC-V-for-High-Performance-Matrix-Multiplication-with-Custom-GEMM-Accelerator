`timescale 1ns / 1ns

module main_csr_pipe_tb;

  logic clk = 0;
  initial begin
    forever #1 clk <= ~clk;
  end
  logic reset;
  logic [7:0] pins_comb;
  logic [6:0] seven_seg_comb;


  soc top_instance (
      .clk(clk),
      .rst(reset),
      .an(pins_comb),
      .a_to_g(seven_seg_comb)
  );


  initial begin
    @(posedge clk) reset <= 0;
    @(posedge clk) 
    @(posedge clk) 
    @(posedge clk) 
    @(posedge clk) reset <=1;
     @(posedge clk) reset <= 0;
    @(posedge clk) 
    @(posedge clk) 
    @(posedge clk) reset <=0;
//     /
//     *reset <= 0;
// */

  end


endmodule
