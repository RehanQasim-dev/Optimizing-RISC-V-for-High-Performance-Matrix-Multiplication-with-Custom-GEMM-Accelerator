module ALU (input logic [31:0] A, B, input logic [3:0] ALU_CON, output logic [31:0] out_result);
	
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
		default out_result = 0;
		endcase
		end

endmodule


		
