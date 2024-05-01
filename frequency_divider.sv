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



led = 0x01 ----> line 35 inside first while loop

led = 0x03 ----> line 41 inside second while loop

led = 0x06 ----> line 46 inside third while loop

led = 0x10 ----> line 59 entering configure gemm

led = 0x16 ----> line 59 exiting gemm configure and before fourth while loop to wait for gemm to be availbe

led = 0x19 ----> line 62 exiting loop 4

led = 0x1a ----> line 72 exiting loop third

led = 0x1d ----> line 80 exiting second loop

led = 0x1e ----> line 89 before exiting first loop

led = 0x20 ----> line 89 after exiting first loop and entering fifth loop

led = 0x2f ----> line 92 exiting fifth loop


03d0 