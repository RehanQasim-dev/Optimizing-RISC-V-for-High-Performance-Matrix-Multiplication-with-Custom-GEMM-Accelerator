module adder (input logic [31:0]add_in , output logic [31:0]add_out);

	assign add_out= add_in + 32'd4;

endmodule
