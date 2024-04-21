module mem_unit (input logic read_en, write_en,input logic [2:0] func3, input logic [31:0] address, input logic [31:0] data_in, input logic [31:0] data_from_mem, output logic [31:0] data_out_to_riscv, output logic [31:0] address_to_mem, output logic [31:0] data_out_to_mem, output logic cs , output logic mem_read, output logic [3:0] mask, output logic [7:0] data_to_uart, output logic load_uart,output logic transfer_byte,input logic uart_done, input logic uart_busy);
	

		logic [31:0] data_from_reg_mem;
		assign data_out_to_riscv = data_from_reg_mem;
		assign address_to_mem = address;
	//	assign data_out_to_mem = data_in;
		
		
		always_comb begin : store_operations
	
		transfer_byte=1'b0;
		load_uart= 1'b0;
		mask='0;
		mem_read='0;
		cs=1'b0;
			if (read_en) begin 
						mask = 4'b1111;
						mem_read= 1;
						cs=1'b0;
						//mem_write=1;
	
								end
			else if (write_en)	begin 
				if (~address[31]) begin 
					case (func3)
					3'b000 : begin // store byte :from func3
							case (address[1:0])
							2'b00 : begin mask = 4'b0001;
								mem_read=0;
								data_out_to_mem[7:0]=data_in[7:0];
								cs=1'b0;
									end

							2'b01 : begin mask =4'b0010;
								mem_read=0;
								data_out_to_mem[15:8]=data_in[15:8];
								cs=1'b0;
									end

							2'b10 : begin mask=4'b0100;
								data_out_to_mem[23:16]=data_in[23:16];
								mem_read = 0;
								cs=1'b0;
									end

							2'b11 : begin mask=4'b1000;
								mem_read=0;
								cs=1'b0;
								data_out_to_mem[31:24]=data_in[31:24];
									end
							default begin mask=4'b0000; mem_read=0; data_out_to_mem=0; end
							endcase
								end
					3'b001 : begin //store half word :form func3
							case (address[1])
							1'b0 : begin 
									mem_read=0;							
									mask = 4'b0011;
									data_out_to_mem[15:0]=data_in[15:0];
									cs=1'b0;
											end
					
							1'b1 : begin 
									mem_read=0;							
									mask = 4'b1100;
									cs=1'b0;
									data_out_to_mem[31:16]=data_in[31:16];
											end
							default begin mem_read=0;							
									mask = 4'b0000;
									data_out_to_mem=data_in;
						
											end
                            	endcase
                            	end
					3'b010 : begin // store word :from func3 
								mem_read=0;
							
								mask=4'b1111;
								data_out_to_mem=data_in;
								cs=1'b0;
								end
					endcase 
			end

				else if (address[31] ) begin  // uart transmission
					transfer_byte=1'b0;
					load_uart=1'b0;
						if (~uart_done & ~uart_busy) begin
							if (func3 == 3'b000) begin 
								case (address[1:0])
								2'b00 : begin 
									data_to_uart=data_in[7:0];
									cs=1'b1;
									transfer_byte=1'b1;
									load_uart=1'b1;
										end

								2'b01 : begin 
									mem_read=0;
									data_to_uart=data_in[15:8];
									cs=1'b1;
									transfer_byte=1'b1;
									load_uart=1'b1;
										end

								2'b10 : begin 
									data_to_uart=data_in[23:16];
									cs=1'b1;
									transfer_byte=1'b1;
									load_uart=1'b1;
										end

								2'b11 : begin 
									cs=1'b1;
									transfer_byte=1'b1;
									load_uart=1'b1;
									data_to_uart=data_in[31:24];
										end
								endcase
							end
							else if (uart_busy & ~uart_done) begin 
								transfer_byte=1'b1;
								load_uart=1'b0;

								end
							else if ( ~uart_busy & uart_done) begin
								transfer_byte=1'b0;
								load_uart=1'b0;
							end
						end
				end
			end
			

			end
	
		always_comb begin // the load type and sign extend
			if(read_en) begin 
				case (func3)
				3'b010 : data_from_reg_mem = data_from_mem; // WORD read
				3'b101 : begin // halfword unsigned
								case (address[1])
								
									1'b0 : data_from_reg_mem = {16'b0, data_from_mem[15:0]};
									1'b1 : data_from_reg_mem = {16'b0, data_from_mem[31:16]};
								default : data_from_reg_mem = '0;
								endcase
								end
				3'b001 : begin //halfword signed
								case (address[1])
									1'b0 : data_from_reg_mem = {{16{data_from_mem[15]}}, data_from_mem[15:0]};
									1'b1 : data_from_reg_mem = {{16{data_from_mem[31]}}, data_from_mem[31:16]};
								default : data_from_reg_mem = '0;
								endcase
								end
				3'b100 : begin //load byte unsigned
							case (address[1:0])
								2'b00 : data_from_reg_mem = {24'b0, data_from_mem[7:0]};
								2'b01 : data_from_reg_mem = {24'b0, data_from_mem[15:8]};
								2'b10 : data_from_reg_mem = {24'b0, data_from_mem[23:16]};
								2'b11 : data_from_reg_mem = {24'b0, data_from_mem[31:24]};
								default : data_from_reg_mem = '0;
							endcase
								end
				3'b000 : begin //load byte signed
								case(address[1:0])
								2'b00 : data_from_reg_mem = {{24{data_from_mem[7]}},data_from_mem[7:0]};
								2'b01 : data_from_reg_mem = {{24{data_from_mem[15]}},data_from_mem[15:8]};
								2'b10 : data_from_reg_mem = {{24{data_from_mem[23]}},data_from_mem[23:16]};
								2'b11 : data_from_reg_mem = {{24{data_from_mem[31]}},data_from_mem[31:24]};
								default : data_from_reg_mem = '0;
								endcase 
									end
				default : data_from_reg_mem = '0;
				endcase
					end
			end
endmodule
