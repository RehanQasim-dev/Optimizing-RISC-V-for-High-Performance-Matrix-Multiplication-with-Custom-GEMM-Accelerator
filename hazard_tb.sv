`timescale 1ns/1ns 
module hazard_tb;
    logic clk =0;
    initial begin
        forever #1 clk <= ~clk;
    end
    logic reg_wr, mem_read, sel_for_branch, reset;
    logic [31:0] inst_mem, inst_exec;
    logic forward_sel_1, forward_sel_2,stall_sel,flush_sel;

    hazard_unit UUT(.clk(clk), .reset(reset), .reg_wr(reg_wr), .mem_read(mem_read), .sel_for_branch(sel_for_branch),.interupt_sel(0), .inst_exec(inst_exec), .inst_mem(inst_mem), .forward_sel_1(forward_sel_1), .forward_sel_2(forward_sel_2), .flush_sel(flush_sel), .stall(stall_sel));
    initial begin
    //     @(posedge clk) begin reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
    //     end
    //    @(posedge clk) begin reg_wr=1'b1; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0013;inst_mem=32'h0000_0013; 
    //     end
        
    //     @(posedge clk) begin reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
    //     end
    //     @(posedge clk) begin reg_wr=1'b1; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h4031_02b3;inst_mem=32'h4031_02b3; 
    //     end
        
    //    @(posedge clk) begin reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
    //     end
        
    //    @(posedge clk) begin reg_wr=1'b1; mem_read=1'b1;sel_for_branch= 1'b0; inst_exec=32'b0000000_00010_00010_001_00010_0110011;inst_mem=32'b0000000_00010_00010_001_00010_0110011; 
    //     end
        
        
    //   @(posedge clk) begin  reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
    //     end

        
    //    @(posedge clk) begin reg_wr=1'b0; mem_read=1'b0;sel_for_branch= 1'b1; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
    //     end
        @(posedge clk) reset =1;
        @(posedge clk) 
        @(posedge clk) reset =0;
       @(posedge clk) begin reg_wr=1'b1; mem_read=1'b1;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
        end
        @(posedge clk )
       @(posedge clk) begin reg_wr=1'b1; mem_read=1'b1;sel_for_branch= 1'b0; inst_exec=32'h0000_0000;inst_mem=32'h0000_0000; 
        end
        @(posedge clk)
        @(posedge clk)
        $stop;
    end
endmodule