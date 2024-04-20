`timescale  1ns/1ns
module mux_2x1_tb;

    logic [31:0] pc, alu_pc,out;
    assign pc=32'h01234567;
    assign alu_pc =31'h02333333;
    logic sel;

    mux_2x1 UUT(pc, alu_pc,sel, out);
    initial begin
        sel=0;
        #1;
        sel=1;
        #1;
        $stop;

    end

endmodule