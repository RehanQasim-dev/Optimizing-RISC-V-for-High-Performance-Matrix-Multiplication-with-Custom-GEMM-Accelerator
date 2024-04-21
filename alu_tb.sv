`timescale 1ns/1ns
module alu_tb;

	logic [31:0] a,b ;
	//  assign a= 31'd10;
	//  assign b=31'd16;
	 
	 logic [3:0] alu_con;
	 
	 logic [31:0] out;
	 
	 ALU uut (a,b,alu_con,out);
		initial begin 
		a= 31'd10;
	  b=31'd16;
		alu_con=4'd0;
		#1;
		alu_con=4'd1;
		#1;
		alu_con=4'd2;
		#1;
		alu_con=4'd3;
		#1;
		alu_con=4'd4;
		#1;
		alu_con=4'd5;
		#1;
		alu_con=4'd6;
		#1;
		alu_con=4'd7;
		#1;
		alu_con=4'd8;
		#1;
		alu_con=4'd9;
		#1;
		alu_con=4'd10;
		#1;
		alu_con=4'd11;a=-32'd10; b = 32'd4; 
		#1;
		
		alu_con=4'd12; 
		#1;
		alu_con=4'd13;
		#1;
		alu_con=4'd14;
		#1;
		alu_con=4'd14;a=b; b = -32'd10;
		#1;

		$stop;
		end
		
		
endmodule