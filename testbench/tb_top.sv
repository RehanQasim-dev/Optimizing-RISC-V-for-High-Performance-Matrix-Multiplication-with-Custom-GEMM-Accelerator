// `include "tb_top.sv"

module tb_top;
  logic clk, rst;
  top DUT (
      .clk(clk),
      .rst(rst)
  );
  //clock generation
  localparam CLK_PERIOD = 2;
  initial begin
    clk <= 1'b0;
    forever begin
      #(CLK_PERIOD / 2);
      clk <= ~clk;
    end
  end
  //Testbench

  initial begin
    rst <= 1;
    @(posedge clk);
    @(posedge clk);
    rst <= 0;
    @(posedge clk);
    //
    @(posedge clk);
    repeat (200) @(posedge clk);
    $finish;
  end

  //Monitor values at posedge
  always @(posedge clk) begin
    $display(" ");
    $display("----------------------------------------------------------");
  end

  //Value change dump

  initial begin
    $dumpfile("tb_top_dump.vcd");
    $dumpvars(1, DUT);
  end
endmodule
