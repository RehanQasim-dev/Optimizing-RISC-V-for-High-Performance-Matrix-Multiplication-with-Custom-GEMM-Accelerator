module ALU (input logic [31:0] A, B, input logic [3:0] ALU_CON, output logic [31:0] out_result);
	logic signed [63:0] mul_result;
	logic a_signed_bit, b_signed_bit;
	logic signed  [32:0] A_mul, B_mul;

always_comb begin 
	if (ALU_CON == 4'b1100 | ALU_CON == 4'b1110 ) a_signed_bit = A[31];
	else	a_signed_bit=1'b0;

	if (ALU_CON == 4'b1100) b_signed_bit = B[31];
	else b_signed_bit =1'b0; 

	// if (a_signed_bit) A_mul = ~A +1'b1;
	// else A_mul = A;
	
	// if (b_signed_bit) B_mul = ~B +1'b1;
	// else B_mul = B;

end
	assign A_mul = $signed({a_signed_bit, A});
	assign B_mul = $signed({b_signed_bit, B});

	assign mul_result = A_mul * B_mul;


	always_comb begin 
		case (ALU_CON)
		4'b0000 : out_result = A+B;
		4'b0001 : out_result = A-B;
		4'b0010 : out_result = A << B[4:0];
		4'b0011 : out_result = $signed(A)<$signed(B);
		4'b0100 : out_result = A<B;
		4'b0101 : out_result = A^B;
		4'b0110 : out_result = A>>B[4:0];
		4'b0111 : out_result = A>>>B[4:0];
		4'b1000 : out_result = A|B;
		4'b1001 : out_result = A&B;
		4'b1010 : out_result = B; // this is for LUI
		4'b1011 : out_result = mul_result[31:0];	//mul lower bits
		4'b1100 : out_result = mul_result[63:32];	// mul upper bits both signed
		4'b1101 : out_result = mul_result[63:32];	// mul upper bits both unsigned
		4'b1110 : out_result = mul_result[63:32];	// mul upper bits rs1 signed, rs2 unsinged
		default out_result = 0;
		endcase
		end

endmodule


		
