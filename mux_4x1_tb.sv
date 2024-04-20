`timescale  1ns/1ns
module mux_4x1_tb;

    logic [31:0]  alu_result,load_data, pc,out;
    assign pc=32'h01234567;
    assign alu_result =32'h02333333;
    assign load_data=32'h00002034;
    logic [1:0] sel;

    mux_4x1 UUT( alu_result,load_data,pc,32'h0,sel, out);
    initial begin
        sel=2'd0;
        #1;
        sel=2'd1;
        #1;
        sel=2'd2;
        #1;
        sel=2'd3;
        #1;
        $stop;

    end

endmodule