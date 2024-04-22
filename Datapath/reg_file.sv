module reg_file (
    input logic clk,
    reset,
    write_reg,
    input logic [4:0] rd,
    rs1,
    rs2,
    input logic [31:0] data_in,
    output logic [31:0] to_alu_1,
    to_alu_2,
    to_leds
);

  logic [31:0] reg_mem[31:0];
  // initial begin 
  // 	$readmemh("C:/Users/Prince/Desktop/rv32_for_fyp/reg_int.txt",reg_mem);
  // 	end
  logic valid_rs1;
  logic valid_rs2;
  logic valid_rd;



  always_comb begin
    //if (rs1 == 5'd1) to_alu_1 = 32'd10;		

    if (valid_rs1) to_alu_1 = reg_mem[rs1];
    else if (~valid_rs1) to_alu_1 = 0;

  end

  always_comb begin
    //if (rs2 == 5'd2) to_alu_2 = 32'd8;
    if (valid_rs2) to_alu_2 = reg_mem[rs2];
    else if (~valid_rs2) to_alu_2 = 0;

  end

  always_ff @(negedge clk) begin
    //if (reset) reg_mem <= {default: 32'b0};  no need to
    if (write_reg & valid_rd) begin
      reg_mem[rd] <= data_in;
    end
  end


  assign valid_rs1 = |rs1;
  assign valid_rs2 = |rs2;
  assign valid_rd  = |rd;
  assign to_leds   = reg_mem[13];


endmodule


