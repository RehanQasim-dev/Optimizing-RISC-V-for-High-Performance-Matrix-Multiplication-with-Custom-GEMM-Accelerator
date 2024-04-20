`timescale 1ns/1ns
module branch_con_tb;

	logic [31:0] a,b ;
	 assign a= 31'd10;
	 assign b=31'd16;
	 
	 logic [2:0] alu_con;
	 
	 logic  out;
	 
	 branch_con uut (a,b,alu_con,out);
		initial begin 
		
		alu_con=3'd0;
		#1;
		alu_con=3'd1;
		#1;
		alu_con=3'd2;
		#1;
		alu_con=3'd3;
		#1;
		alu_con=3'd4;
		#1;
		alu_con=3'd5;
		#1;
		alu_con=3'd6;
		#1;
		alu_con=3'd07;
		#1;
		$stop;
		end
		
		
endmodule