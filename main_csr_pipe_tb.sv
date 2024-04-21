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
	logic mem_rd_wr, cs;
	logic [3:0] mask;
	logic [31:0] mem_addr, mem_write_data;
	logic [31:0] mem_read_data;
	logic mem_valid ;
	
	main_csr_pipe UUT (clk, reset, interupt,  pins_comb, seven_seg_comb,mem_rd_wr, cs, mask, mem_addr, mem_write_data,mem_read_data, mem_valid);
	 
mem_data uuet(.clk(clk),.address(mem_addr), .data_in(mem_write_data), .rd_wr_en(mem_rd_wr), .bus_cs(cs),.mask(mask), .data_out(mem_read_data),  .valid(mem_valid));


	initial begin 
		@(posedge clk) reset=1;
        @(posedge clk)
        @(posedge clk) reset =0; 
		
	end

	
endmodule 
	