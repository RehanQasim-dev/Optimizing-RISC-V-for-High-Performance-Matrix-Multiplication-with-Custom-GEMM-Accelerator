module mux_2x1 (input logic [31:0] A,B, input logic sel, output logic [31:0] out);
    always_comb begin : blockName
            case (sel)
            1'b0 : out=A;
            1'b1 : out=B;
            endcase
    end

endmodule