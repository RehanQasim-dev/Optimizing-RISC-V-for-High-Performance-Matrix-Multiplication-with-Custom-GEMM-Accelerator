module mux_4x1 (input logic [31:0] A,B,C,D, input logic [1:0]sel, output logic [31:0] out );

    always_comb begin : blockName
            case (sel)
            2'b00 : out=A;
            2'b01 : out=B;
            2'b10 : out=C;
            2'b11 : out=D; 
                
            endcase
    end

endmodule