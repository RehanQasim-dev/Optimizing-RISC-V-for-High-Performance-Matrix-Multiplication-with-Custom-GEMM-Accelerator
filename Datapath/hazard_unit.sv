module hazard_unit(input logic clk, reset, reg_wr,input logic mem_read,input logic sel_for_branch, interupt_sel,input logic valid,  input logic[31:0] inst_exec, inst_mem, output logic forward_sel_1, forward_sel_2, flush_sel, stall);
   logic [4:0] rs1_mem, rs2_mem,rd_exec,rd_mem, rs1_exec, rs2_exec;
   assign rs2_mem = inst_mem[24:20];
   assign rs1_mem = inst_mem[19:15];
   assign rd_exec = inst_exec [11:7];
   assign rd_mem = inst_mem [11:7];
   assign rs2_exec = inst_exec [24:20];
   assign rs1_exec = inst_exec [19:15];
   logic stall_sel, stall_for_mem_read;

localparam NORMAL = 1'b0;
  localparam STALLED = 1'b1;
  logic cs, ns;


    always_comb begin 
        forward_sel_1 = 1'b0;
        forward_sel_2 = 1'b0; 
        flush_sel = 1'b0;
        stall_sel = 1'b0;
        
        if (reg_wr & ~mem_read) begin
            if ((rs1_exec == rd_mem) &  (rd_mem != 5'b00000)) begin 
                    forward_sel_1 =1'b1;
            end
             if ((rs2_exec == rd_mem) &  (rd_mem != 5'b00000)) begin 
                    forward_sel_2 =1'b1;
            end
        end

        if (sel_for_branch | interupt_sel ) begin 
            flush_sel =1'b1;
        end
        // if (mem_read & reg_wr) begin
        //     if (~valid) begin     
        //         if ( (rd_mem != 5'b00000)) begin
        //             stall_sel=1'b1;
        //         end
        //         if ((rs1_exec == rd_mem) &  (rd_mem != 5'b00000)) begin
        //             stall_sel=1'b1;
        //         end
        //     end
        //     else if (valid) stall_sel =1'b0;

        // end

    end


  

  always_comb begin

    stall_for_mem_read = 0;
    case (cs)
      NORMAL: begin
        if (mem_read & reg_wr) begin
          stall_for_mem_read = 1;
          ns = STALLED;
        end else begin
          stall_for_mem_read = 0;
          ns = NORMAL;
        end
      end
      STALLED: begin
        stall_for_mem_read = 0;
        ns = NORMAL;
      end
    endcase
  end

  always_ff @(posedge clk) begin
    if (reset) cs <= NORMAL;
    else cs <= ns;
  end

  assign stall = stall_for_mem_read;


endmodule