module pipelined_control (
    input logic clk, reset,stall, reg_wr, mem_write, mem_read, pc_jump_mux, BR_taken,
    input logic [1:0] wr_bck_mux,
    input logic [2:0] func3_to_mem,
    input logic csr_reg_rd, csr_reg_wr, csr_return,
    output logic reg_wr_flip,mem_write_flip,mem_read_flip,pc_jump_mux_flip,BR_taken_flip,
    output logic [1:0] wr_bck_mux_flip,
    output logic [2:0] func3_to_mem_flip,
    output logic csr_reg_rd_flip, csr_reg_wr_flip, csr_return_flip
);
    always_ff @( posedge clk ) begin : blockName
        if (reset) begin
            reg_wr_flip<='0;
            mem_read_flip<='0;
            mem_write_flip<='0;
            wr_bck_mux_flip<='0;
            func3_to_mem_flip<='0;
            pc_jump_mux_flip<='0;
            BR_taken_flip<='0;
            csr_reg_rd_flip<='0;
            csr_reg_wr_flip<='0;
            csr_return_flip<='0;
        end
        else begin
            if (stall ) begin
                reg_wr_flip<=reg_wr_flip;
            mem_read_flip<=mem_read_flip;
            mem_write_flip<=mem_write_flip;
            wr_bck_mux_flip<=wr_bck_mux_flip;
            func3_to_mem_flip<=func3_to_mem_flip;
            pc_jump_mux_flip<=pc_jump_mux_flip;
            BR_taken_flip<= BR_taken_flip;
            csr_reg_rd_flip<= csr_reg_rd_flip;
            csr_reg_wr_flip<= csr_reg_wr_flip;
            csr_return_flip<=csr_return_flip;
                
            end
            else begin
            reg_wr_flip<=reg_wr;
            mem_read_flip<=mem_read;
            mem_write_flip<=mem_write;
            wr_bck_mux_flip<=wr_bck_mux;
            func3_to_mem_flip<=func3_to_mem;
            pc_jump_mux_flip<=pc_jump_mux;
            BR_taken_flip<= BR_taken;
            csr_reg_rd_flip<= csr_reg_rd;
            csr_reg_wr_flip<= csr_reg_wr;
            csr_return_flip<=csr_return;
            end
        end
    end
endmodule