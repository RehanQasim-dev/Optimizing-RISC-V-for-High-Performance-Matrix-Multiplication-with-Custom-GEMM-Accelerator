module Uart_Mux_2x1(out, IN1, IN2, sel);

    output logic  out;
    input logic IN1, IN2;
    input logic sel;

    always_comb begin
        case(sel)
            1'b0: begin
                out = IN1;
            end

            1'b1: begin
                out = IN2;
            end
        endcase
    end

endmodule