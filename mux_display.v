module mux_display (input [3:0]a, input [3:0]b, input [3:0]c, input [3:0]d,input [3:0]e,input [3:0]f,input [3:0]g,input [3:0]h, input [2:0]sel,output reg [3:0]out);

	
	always@ (*)
		 begin 
			case (sel)
				3'b000 : out <= a;
				3'b001 : out <= b;
				3'b010 : out <= c;
				3'b011 : out <= d;
				3'b100 : out <= e;
				3'b101 : out <= f;
				3'b110 : out <= g;
				3'b111 : out <= h;
			endcase
		end
endmodule
