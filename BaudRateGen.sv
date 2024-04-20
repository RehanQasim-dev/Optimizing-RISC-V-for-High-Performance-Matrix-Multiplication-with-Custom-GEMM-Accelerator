module Baud_rate_Generator (
    count_baud_of,
    CLK,
    clear_baud_count
);
  output logic count_baud_of;
  input logic CLK, clear_baud_count;
  /* localparam MAX_RATE_TX = 100000000 / (2 * 115200); */ // Baud Rate 115200
  /* localparam MAX_RATE_TX = 100000000 / (2 * 9600); */ // Baud Rate 9600
  localparam MAX_RATE_TX = 5;
  localparam TX_CNT_WIDTH = $clog2(MAX_RATE_TX);
  logic [TX_CNT_WIDTH - 1:0] txCounter = 0;
  initial begin
    count_baud_of = 1'b0;
  end
  always @(posedge CLK) begin
    if (clear_baud_count) begin
      count_baud_of <= 1'b0;
      txCounter <= 0;
    end else if (txCounter == MAX_RATE_TX[TX_CNT_WIDTH-1:0]) begin
      txCounter <= 0;
      count_baud_of <= 1'b1;
    end else begin
      txCounter <= txCounter + 1'b1;
      count_baud_of <= 1'b0;
    end
  end
endmodule
