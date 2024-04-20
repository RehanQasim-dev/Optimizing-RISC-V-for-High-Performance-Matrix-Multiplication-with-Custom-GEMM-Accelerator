`timescale 1ns/1ns

module reg_file_tb();

	logic clk=1;
	logic [31:0]data_in;
	logic write_en,reset;
	logic [4:0] rs1,rs2,rd;
	logic [31:0] data_out_1,data_out_2;

	assign data_in =32'h01114444;
    assign write_en=1'b1;
	reg_file UUT (clk,reset, write_en,rs1,rs2,rd,data_in,data_out_1,data_out_2);
	initial begin 
	forever #10 clk<=~clk;
	end
	
	initial begin 
        rs1=5'd0; rs2=5'd0; rd= 5'd0; reset=1;
        @(posedge clk);
        rs1=5'd0; rs2=5'd2; rd= 5'd0; reset=0;
        @(posedge clk);
        rs1=5'd3; rs2=5'd4; rd= 5'd2; reset=0;
        @(posedge clk);
        rs1=5'd3; rs2=5'd2; rd= 5'd4; reset=0;
        @(posedge clk);
        rs1=5'd3; rs2=5'd4; rd= 5'd5; reset=0;
        @(posedge clk);
        rs1=5'd4; rs2=5'd5; rd= 5'd6; reset=0;
        @(posedge clk);
        rs1=5'd4; rs2=5'd23; rd= 5'd7; reset=0;
        @(posedge clk);



        rs1=5'd0; rs2=5'd0; rd= 5'd8; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd9; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd10; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd11; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd12; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd13; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd14; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd15; reset=0;
        @(posedge clk);
        rs1=5'd0; rs2=5'd0; rd= 5'd16; reset=0;
        @(posedge clk);
        
        rs1=5'd0; rs2=5'd0; rd= 5'd17; reset=0;
        @(posedge clk);
        
        rs1=5'd0; rs2=5'd0; rd= 5'd018; reset=0;
        @(posedge clk);
        
        rs1=5'd0; rs2=5'd0; rd= 5'd019; reset=0;
        @(posedge clk);
        
        rs1=5'd0; rs2=5'd0; rd= 5'd20; reset=0;
        @(posedge clk);
        $stop;
        end 
 
endmodule