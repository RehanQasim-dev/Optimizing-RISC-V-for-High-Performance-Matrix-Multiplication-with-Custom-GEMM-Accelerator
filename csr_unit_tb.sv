`timescale 1ns/1ns
module csr_unit_tb ;

    logic clk, reset, csr_reg_rd, csr_reg_wr, interupt;
    logic [31:0] write_data, pc, pc_for_inst_mem, data_out_to_reg, csr_address;

    csr_unit UUT(clk, reset, pc, write_data, csr_address, csr_reg_rd, csr_reg_wr,interupt, data_out_to_reg, pc_for_inst_mem);
        initial begin
            clk <= 1'b0;
            forever #1 clk <= ~clk;

        end

        initial begin
            reset =1'b1; interupt =1'b0;
            @(posedge clk);

            reset =1'b0; write_data = 32'h0000_0000; csr_address = 32'h 0000_0000; csr_reg_rd =1'b0; csr_reg_wr =1'b0;
            @(posedge clk);

            write_data = 32'h1230_0abc; csr_address = 32'h 0000_0300; csr_reg_rd =1'b1; csr_reg_wr =1'b0;
            @(posedge clk);

            write_data = 32'h1230_0001; csr_address = 32'h 0000_0300; csr_reg_rd =1'b1; csr_reg_wr =1'b1;
            @(posedge clk);


            write_data = 32'h1230_0002; csr_address = 32'h 0000_0304; csr_reg_rd =1'b1; csr_reg_wr =1'b1;
            @(posedge clk);

            
            write_data = 32'h1230_0003; csr_address = 32'h 0000_0305; csr_reg_rd =1'b1; csr_reg_wr =1'b1;
            @(posedge clk);

            
            write_data = 32'h1230_0004; csr_address = 32'h 0000_0341; csr_reg_rd =1'b1; csr_reg_wr =1'b1;
            @(posedge clk);

            
            write_data = 32'h1230_0005; csr_address = 32'h 0000_0342; csr_reg_rd =1'b1; csr_reg_wr =1'b1;
            @(posedge clk);

            
            write_data = 32'h1230_0007; csr_address = 32'h 0000_0344; csr_reg_rd =1'b1; csr_reg_wr =1'b1;
            @(posedge clk);

            $stop;
        end

endmodule