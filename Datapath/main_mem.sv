module main_mem (input logic clk,input logic reset, input logic [31:0]address,data_store, input logic write_en, read_en, input logic [2:0]func3, output logic[31:0] data_out, output logic valid,output logic [31:0] led_display, output logic uart_output, output logic uart_busy);

	logic [31:0]data_from_mem,address_to_mem,data_out_to_mem;
	logic [3:0] mask;
	logic cs;
	logic mem_rd_wr;
	logic [7:0] data_to_uart;
	logic load_uart;
	logic transfer_uart_byte, transfer_byte_flip, uart_done;

	always_ff @(posedge clk) transfer_byte_flip <=transfer_uart_byte; 


	mem_unit LOAD_STORE (read_en,write_en,func3,address,data_store,data_from_mem,data_out,address_to_mem,data_out_to_mem,cs,mem_rd_wr,mask, data_to_uart, load_uart, transfer_uart_byte, uart_done, uart_busy);
	mem_data data_memory (clk,address_to_mem,data_out_to_mem,mem_rd_wr,cs,mask,data_from_mem, valid, led_display);
	UART uart_module (   .Tx(uart_output),.tx_busy(uart_busy),.byte_ready(load_uart),.tx_byte(transfer_byte_flip),.CLK(clk),.reset(reset),.IN_Data(data_to_uart), .uart_done(uart_done));
endmodule
