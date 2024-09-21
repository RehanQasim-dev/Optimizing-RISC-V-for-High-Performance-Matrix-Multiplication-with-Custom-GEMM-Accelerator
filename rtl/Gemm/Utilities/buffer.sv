import Config::*;
module buffer #(
    parameter DEPTH  = 8,
    parameter DWIDTH = 16

) (
    input rst,  //
    clk,  //
    wr_en,  //
    rd_en,  //
    input [DWIDTH-1:0] din,  //
    output reg [DWIDTH-1:0] dout,  //
    output empty,  //
    full  //
);
  reg [$clog2(DEPTH):0] wptr;
  reg [$clog2(DEPTH):0] rptr;
  reg [DWIDTH-1 : 0] fifo[DEPTH];

  // initial begin
  //   fifo = '{default: '0};
  //   $readmemh(filename, fifo);
  //   wptr <= DUMP_LEN;
  //   rptr <= 0;
  // end

  always @(posedge clk) begin
    if (rst) begin
      fifo <= '{default: '0};
      wptr <= '0;
    end else begin
      if (wr_en & (!full || rd_en)) begin
        fifo[wptr[$clog2(DEPTH)-1:0]] <= din;
        wptr <= wptr + 1;
      end
    end
  end
  always @(posedge clk) begin
    if (rst) begin
      rptr <= 0;
    end else begin
      if (rd_en & !empty) begin
        rptr <= rptr + 1;
      end
      // else if (empty) dout <= 0;
    end
  end
  assign dout = fifo[rptr[$clog2(DEPTH)-1:0]];
  assign full = wptr[$clog2(
      DEPTH
  )] != rptr[$clog2(
      DEPTH
  )] && wptr[$clog2(
      DEPTH
  )-1:0] == rptr[$clog2(
      DEPTH
  )-1:0];
  assign empty = wptr == rptr;
endmodule
