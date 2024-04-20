`timescale 1ns/1ns 

module main_csr_pipe_tb;

	logic clk=0;
    initial begin
        forever #1 clk <= ~clk;
    end
	logic reset;
	logic interupt;
	logic [7:0] pins_comb;
	 logic [6:0] seven_seg_comb;
	 logic uart_output, uart_busy;
	main_csr_pipe UUT (clk, reset, interupt,  pins_comb, seven_seg_comb,uart_output, uart_busy);
	 



	initial begin 
		@(posedge clk) reset=1;
        @(posedge clk)
        @(posedge clk) reset =0; 
		
	end
endmodule 
	