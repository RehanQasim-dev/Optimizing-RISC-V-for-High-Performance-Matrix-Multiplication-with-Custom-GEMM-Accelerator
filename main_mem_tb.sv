`timescale 1ns/1ns

module main_mem_tb();

	logic clk=1;
	logic [31:0] address,data_in;
	logic read_en,write_en;
	logic [2:0] func3;
	logic [31:0] data_out; logic e;
	logic valid, uart_output, uart_busy, reset;
	logic [31:0] led_display;
	assign data_in =32'h01114444;

	main_mem UUT (clk,reset, address,data_in, write_en, read_en,func3,data_out, valid, led_display, uart_output, uart_busy);
	initial begin 
	forever #10 clk<=~clk;
	end
	
	initial begin 
		reset=1'b1; @(posedge clk);
		reset=1'b0; @(posedge clk );

	address=32'h8000_0000 ; write_en=1; read_en=0; func3=3'b000;
	@(posedge clk);
	
	repeat (2000) begin 
		e=clk;@(posedge clk);
	end
	
	reset=1'b1; @(posedge clk);
	reset=1'b0; @(posedge clk );

	address=32'h8000_0001 ; write_en=1; read_en=0; func3=3'b000;
	@(posedge clk);
	
	reset=1'b1;@(posedge clk);
	reset=1'b0; @(posedge clk );

	repeat (2000) begin 
		e=clk;@(posedge clk);
	end
	address=32'h8000_0002 ; write_en=1; read_en=0; func3=3'b000;
	@(posedge clk);
	
	reset=1'b1; @(posedge clk);
	reset=1'b0; @(posedge clk );

	repeat (2000) begin 
		e=clk;@(posedge clk);
	end
	address=32'h8000_0003 ; write_en=1; read_en=0; func3=3'b000;
	@(posedge clk);

	// address=32'h00000001 ; write_en=1; read_en=0; func3=3'b000;
	// @(posedge clk);
	// address=32'h00000002 ; write_en=1; read_en=0; func3=3'b000;
	// @(posedge clk);
	// address=32'h00000003 ; write_en=1; read_en=0; func3=3'b000;
	// @(posedge clk);
	// address=32'h00000004 ; write_en=1; read_en=0; func3=3'b001;
	// @(posedge clk);
	// address=32'h00000006 ; write_en=1; read_en=0; func3=3'b001;
	// @(posedge clk);
	// address=32'h00000008 ; write_en=1; read_en=0; func3=3'b010;
	// @(posedge clk);



	// address=32'h00000000 ; write_en=0; read_en=1; func3=3'b000;
	// @(posedge clk);
	// address=32'h00000001 ; write_en=0; read_en=1; func3=3'b000;
	// @(posedge clk);
	// address=32'h00000002 ; write_en=0; read_en=1; func3=3'b000;
	// @(posedge clk);
	// address=32'h00000003 ; write_en=0; read_en=1; func3=3'b000;
	// @(posedge clk);
	// address=32'h00000000 ; write_en=0; read_en=1; func3=3'b100;
	// @(posedge clk);
	// address=32'h00000001 ; write_en=0; read_en=1; func3=3'b100;
	// @(posedge clk);
	// address=32'h00000002 ; write_en=0; read_en=1; func3=3'b100;
	// @(posedge clk);
	// address=32'h00000003 ; write_en=0; read_en=1; func3=3'b100;
	// @(posedge clk);
	// address=32'h00000000 ; write_en=0; read_en=1; func3=3'b101;
	// @(posedge clk);
	
	// address=32'h00000001 ; write_en=0; read_en=1; func3=3'b101;
	// @(posedge clk);
	
	// address=32'h00000000 ; write_en=0; read_en=1; func3=3'b001;
	// @(posedge clk);
	
	// address=32'h00000002 ; write_en=0; read_en=1; func3=3'b101;
	// @(posedge clk);
	
	// address=32'h00000000 ; write_en=0; read_en=1; func3=3'b010;
	// @(posedge clk);
	
	end 
 
endmodule