module x7segb8 (
    input logic [31:0] x,
    input logic clk,
    input logic clr,
    output logic [6:0] a_to_g,
    output logic [7:0] an,
    output logic dp
);

  logic [ 2:0] s;
  logic [ 3:0] digit;
  logic [ 7:0] aen;
  logic [17:0] clkdiv;

  assign dp = 1;
  assign s = clkdiv[15:13];
  // set aen(3 downto 0) for leading blanks
  assign aen[7] = x[31] | x[30] | x[29] | x[28];
  assign aen[6] = x[31] | x[30] | x[29] | x[28] | x[27] | x[26] | x[25] | x[24];
  assign aen[5] = x[31] | x[30] | x[29] | x[28] | x[27] | x[26] | x[25] | x[24] |
                   x[23] | x[22] | x[21] | x[20];
  assign aen[4] = x[31] | x[30] | x[29] | x[28] | x[27] | x[26] | x[25] | x[24] |
                   x[23] | x[22] | x[21] | x[20] | x[19] | x[18] | x[17] | x[16];
  assign aen[3] = x[31] | x[30] | x[29] | x[28] | x[27] | x[26] | x[25] | x[24] |
                   x[23] | x[22] | x[21] | x[20] | x[19] | x[18] | x[17] | x[16] |
                   x[15] | x[14] | x[13] | x[12];
  assign aen[2] = x[31] | x[30] | x[29] | x[28] | x[27] | x[26] | x[25] | x[24] |
                   x[23] | x[22] | x[21] | x[20] | x[19] | x[18] | x[17] | x[16] |
                   x[15] | x[14] | x[13] | x[12] | x[11] | x[10] | x[9] | x[8];
  assign aen[1] = x[31] | x[30] | x[29] | x[28] | x[27] | x[26] | x[25] | x[24] |
                   x[23] | x[22] | x[21] | x[20] | x[19] | x[18] | x[17] | x[16] |
                   x[15] | x[14] | x[13] | x[12] | x[11] | x[10] | x[9] | x[8] |
                   x[7] | x[6] | x[5] | x[4];
  assign aen[0] = 1;  // digit 0 always on

  // Quad 4-to-1 MUX: mux44
  always_comb begin
    case (s)
      3'b000:  digit = x[3:0];
      3'b001:  digit = x[7:4];
      3'b010:  digit = x[11:8];
      3'b011:  digit = x[15:12];
      3'b100:  digit = x[19:16];
      3'b101:  digit = x[23:20];
      3'b110:  digit = x[27:24];
      default: digit = x[31:28];
    endcase
  end

  // 7-segment decoder: hex7seg
  always_comb begin
    case (digit)
      4'h0: a_to_g = 7'b0000001;  // 0
      4'h1: a_to_g = 7'b1001111;  // 1
      4'h2: a_to_g = 7'b0010010;  // 2
      4'h3: a_to_g = 7'b0000110;  // 3
      4'h4: a_to_g = 7'b1001100;  // 4
      4'h5: a_to_g = 7'b0100100;  // 5
      4'h6: a_to_g = 7'b0100000;  // 6
      4'h7: a_to_g = 7'b0001101;  // 7
      4'h8: a_to_g = 7'b0000000;  // 8
      4'h9: a_to_g = 7'b0000100;  // 9
      4'hA: a_to_g = 7'b0001000;  // A
      4'hB: a_to_g = 7'b1100000;  // b
      4'hC: a_to_g = 7'b0110001;  // C
      4'hD: a_to_g = 7'b1000010;  // d
      4'hE: a_to_g = 7'b0110000;  // E
      default: a_to_g = 7'b0111000;  // F
    endcase
  end

  // Digit select: ancode
  always_comb begin
    an = 8'b11111111;
    if (aen[s]) begin
      an[s] = 1'b0;
    end
  end


  // Clock divider
  always_ff @(posedge clk) begin
    if (clr) begin
      clkdiv <= 18'b0;
    end else begin
      clkdiv <= clkdiv + 18'b1;
    end
  end
endmodule
