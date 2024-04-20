module tb_Uart ();
  logic CLK, reset;
  logic Tx, tx_busy, tx_byte, byte_ready;
  logic [7:0] data_in;
  UART dut (
      .Tx(Tx),
      .tx_busy(tx_busy),
      .byte_ready(byte_ready),
      .tx_byte(tx_byte),
      .CLK(CLK),
      .reset(reset),
      .IN_Data(data_in)
  );
  initial begin
    CLK <= 1'b0;
    forever begin
      #5 CLK = ~CLK;
    end
  end
  initial begin
    reset <= 1'b1;
    data_in <= 8'b1010_1010;
    byte_ready <= 1'b0;
    tx_byte <= 1'b0;
    @(posedge CLK);
    reset <= 1'b0;
    @(posedge CLK);
    byte_ready <= 1'b1;
    repeat (10) @(posedge CLK);
    tx_byte <= 1'b1;
    byte_ready <= 1'b0;
    repeat (855) @(posedge CLK);
    $stop;
  end
endmodule
