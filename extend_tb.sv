`timescale 1ns/1ns
module extend_tb;

	logic [31:0] inst;
	logic [2:0] ex_xon;
	logic [31:0] out;
	
	extend uut(ex_xon,inst,out);
	initial begin 
		ex_xon=4'd0; inst=31'h03001111;
		#1;
		ex_xon=4'd1; inst=31'h04001111;
		#1;
		ex_xon=4'd2; inst=31'h15001111;
		#1;
		ex_xon=4'd3; inst=31'h06001235;
		#1;
		ex_xon=4'd4; inst=31'h07004341;
		#1;
		ex_xon=4'd5; inst=31'h08001111;
		#1;
		ex_xon=4'd6; inst=31'h09001111;
		#1
		ex_xon=4'd7; inst=31'h0a501111;
		#1;
		$stop;
		end
endmodule