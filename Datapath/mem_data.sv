module mem_data (input logic clk, input logic [31:0] address, data_in, input logic rd_wr_en, bus_cs,input logic [3:0]mask, output logic [31:0]data_out, output logic valid, output logic [31:0] led_display);
	logic [31:0]Data_mem [1024:0];
	initial begin 
	$readmemh ("C:/Users/Prince/Desktop/rv32_for_fyp/Script/build/DECACHE.mem",Data_mem);
            end
	always_ff@(posedge clk) begin //read operation
	valid =1'b0;
	if (rd_wr_en & ~bus_cs)	begin 
			/*if (mask[0]) begin 
				data_out[7:0] = Data_mem[address[31:2]][7:0];
				end
			if (mask[1]) begin 
				data_out[15:8] = Data_mem[address[31:2]][15:8];
				end
			if (mask[2]) begin 
				data_out[23:16] = Data_mem[address[31:2]][23:16];
				end
			if (mask[3]) begin 
				data_out[31:24] = Data_mem[address[31:2]][31:24];
				end*/
		data_out=Data_mem[address[31:2]];
		valid =1'b1;
			end
		end


	always_ff@(negedge clk) begin //write operation
	if (~rd_wr_en & ~bus_cs)	begin 
			if (mask[0]) begin 
				 Data_mem[address[31:2]][7:0]<=data_in[7:0];
				end
			if (mask[1]) begin 
				 Data_mem[address[31:2]][15:8]<=data_in[15:8];
				end
			if (mask[2]) begin 
				 Data_mem[address[31:2]][23:16]<=data_in[23:16];
				end
			if (mask[3]) begin 
				 Data_mem[address[31:2]][31:24]<=data_in[31:24];
				end


			end
		end

	assign  led_display = Data_mem[0][31:0];
endmodule