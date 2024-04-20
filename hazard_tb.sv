`timescale 1ns/1ns 
module hazard_tb;

    logic reg_wr, mem_read, sel_for_branch;
    logic [31:0] inst_mem, inst_exec;
    logic forward_sel_1, forward_sel_2,stall_sel,flush_sel;

    hazard_unit UUT(reg_wr, mem_read, sel_for_branch, inst_exec, inst_mem, forward_sel_1, forward_sel_2, flush_sel, stall_sel);
    initial begin
        reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
        #1;
        reg_wr=1'b1; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0013;inst_mem=32'h0000_0013; 
        #1;
        
        reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
        #1;
        reg_wr=1'b1; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h4031_02b3;inst_mem=32'h4031_02b3; 
        #1;
        
        reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
        #1;
        
        reg_wr=1'b1; mem_read=1'b1;sel_for_branch= 1'b0; inst_exec=32'b0000000_00010_00010_001_00010_0110011;inst_mem=32'b0000000_00010_00010_001_00010_0110011; 
        #1;
        
        
        reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
        #1;

        
        reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b1; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
        #1;
        $stop;
    end
endmodule