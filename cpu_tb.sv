`timescale 1ns/1ns
module cpu_tb ;
    logic [31:0] instruction;
    logic [3:0] alu_con;
    logic reg_wr,mem_read,mem_write,alu_mux_1,alu_mux_2,pc_jump_mux;
    logic [1:0] wr_bck_mux;
    logic [2:0] sign_extend, func3_to_mem, branch_type;

    CPU uut (instruction, alu_con,reg_wr,mem_read,mem_write,alu_mux_1,alu_mux_2,pc_jump_mux,wr_bck_mux,sign_extend,func3_to_mem,branch_type);
    initial begin 
        instruction =32'hfb042783;
        #1;
        instruction =32'h00579593;
        #1;
        instruction =32'hfb442783;
        #1;
        // instruction =32'h00022023;
        // #1;
        // instruction =32'h00022e83;
        // #1;
        // instruction =32'h12345437;
        // #1;
        // instruction =32'h00004917;
        // #1;
        // instruction =32'h00401263;
        // #1;
        // instruction =32'h0040016f;
        // #1;
        // instruction =32'h00000fe7;
        // #1;
        // instruction =32'h00310233;
        // #1;
        // instruction =32'h00310233;
        // #1;
        // instruction =32'h00310233;
        // #1;
        // instruction =32'h00310233;
        // #1;
        $stop;

    end
    
endmodule