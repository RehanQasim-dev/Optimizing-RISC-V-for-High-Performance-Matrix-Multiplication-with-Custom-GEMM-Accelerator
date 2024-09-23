module PC_flip (input logic clk,reset,stall, input logic[31:0]address_in, output logic [31:0] address_out );


	always_ff@(posedge clk ) begin 

		if (reset)
			address_out<= 32'b0;
		else if (stall) address_out<=address_out;
		else address_out <= address_in;

	end 

endmodule
