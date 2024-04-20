module inst_mem (input logic [31:0]pc, output logic [31:0] inst_out);
	logic	[31:0] inst_ruction [100:0];
	logic [31:0] address;
	assign address=pc;
	initial begin 	
		$readmemh ("ICACHE.mem", inst_ruction);
	end

	assign inst_out = inst_ruction [address[31:2]];

endmodule

