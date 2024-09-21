import Config::*;
module gemm_decoder (
    input logic clk,
    input logic [4:0] ksize,
    nsize,
    output logic [1:0] mode,
    output logic if_mux_sel,
    output logic w_mux_sel

);

  // Define the conditions for Tallwave and Widewave
  assign Tallwave = ksize <= SMALL_SYS_ROWS;
  assign Widewave = nsize > SMALL_SYS_COLS;

  // Use always_comb to determine the mode based on the conditions
  always_comb begin
    if (!Tallwave && Widewave) begin
      mode = 2'b00;
      if_mux_sel = 1;
      w_mux_sel = 0;
      // w_mux_sel[1] = 0;
    end else if (!Tallwave && !Widewave) begin
      mode = 2'b01;  //vertical
      if_mux_sel = 1;
      w_mux_sel = 0;
      // w_mux_sel[1] = 'x;
    end else if (Tallwave && Widewave) begin
      mode = 2'b10;  //
      if_mux_sel = 0;
      w_mux_sel = 1;
      // w_mux_sel[1] = 1;
//    end else if (Tallwave && !Widewave) begin
    end else begin

      mode = 2'b11;
      if_mux_sel = 0;
      w_mux_sel = 1;
      // w_mux_sel[1] = 'x;
    end
    
  end
endmodule
