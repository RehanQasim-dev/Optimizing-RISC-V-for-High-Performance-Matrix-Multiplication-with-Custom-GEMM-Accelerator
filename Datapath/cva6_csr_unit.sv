
module cva6_csr_unit (input logic clk, reset, input logic [31:0] pc, input logic [31:0] write_data, input logic [31:0] csr_address, input logic csr_reg_wr, csr_reg_rd,csr_return, interupt, output logic [31:0] data_out_to_reg, pc_for_inst_mem, output logic interupt_sel );

    logic [31:0] csr_mip,csr_mie, csr_mstatus, csr_mcause, csr_mtvec, csr_mepc;
    logic [31:0] csr_mip_ff,csr_mie_ff, csr_mstatus_ff, csr_mcause_ff, csr_mtvec_ff, csr_mepc_ff;
    logic  [11:0] address;
   // logic csr_mcause_en, csr_mepc_en, csr_mie_en, csr_mip_en, csr_mtvec_en, csr_mstatus_en;
    logic [31:0] pc_for_inst_mem_intrupt_return;
    logic [63:0] csr_mcycle_ff,csr_mhpmcounter_3_ff,csr_mcycle_count, csr_mhpmcounter_3_count;
    logic [31:0] csr_mcounter_en_ff,csr_mcounter_en,csr_mcycle,csr_mcycleh,csr_mhpmcounter_3, csr_mhpmcounter_3h;  
  //  logic [31:0] pc_for_intrupt_handle;
    logic interupt_csr_en,csr_mcycle_reset, csr_mhpmcounter_3_reset;

    assign address  = csr_address[11:0];
    assign pc_for_inst_mem_intrupt_return = csr_mepc_ff;
    assign interupt_sel = interupt_csr_en | csr_return;
    assign csr_mcycle = csr_mcycle_ff[31:0];
    assign csr_mcycleh = csr_mcycle_ff[63:32];
    assign csr_mhpmcounter_3= csr_mhpmcounter_3_ff[31:0];
    assign csr_mhpmcounter_3h= csr_mhpmcounter_3_ff[63:32];

    always_comb begin : read_operation
    pc_for_inst_mem='0;
    if (reset) begin 
        data_out_to_reg ='0;
        pc_for_inst_mem='0;
    end
    else begin 
            if (csr_reg_rd) begin 
                case (address) 
                //12'h302 : csr_return=1'b1;
                12'h300 : data_out_to_reg = csr_mstatus_ff; // mstatus csr
                12'h304 : data_out_to_reg = csr_mie_ff; // csr mie
                12'h305 : data_out_to_reg = csr_mtvec_ff; // csr mtvec
                12'h341 : data_out_to_reg = csr_mepc_ff;    // csr mepc
                12'h342 : data_out_to_reg = csr_mcause_ff; //csr_mcause
                12'h344 : data_out_to_reg = csr_mip_ff; // csr mip
                12'h306 : data_out_to_reg = csr_mcounter_en_ff; // csr counter enable
                12'hB00 : data_out_to_reg = csr_mcycle; // mcycle lower 32 bits
                12'hb03 : data_out_to_reg = csr_mhpmcounter_3; // mhpcounter_3 lower 32 bits
                12'hb80 : data_out_to_reg = csr_mcycleh;    // mcycle upper 32 bits
                12'hb82 : data_out_to_reg = csr_mhpmcounter_3h;// mhpcounter_3 upper 32 bits
                default data_out_to_reg = '0;
                endcase
            end
            else if (csr_return) begin
                pc_for_inst_mem = csr_mepc_ff;

            end 

            else if (interupt_csr_en) begin 
                if (csr_mtvec [1:0] == 2'b00) pc_for_inst_mem = { {csr_mtvec[31:2]}, 2'b00};
                else if (csr_mtvec [1:0] == 2'b01) pc_for_inst_mem = { {csr_mtvec[31:2], 2'b00}}  + (csr_mcause << 2);
                end
            end
        end
    
   
   always_comb begin : write_operation
        csr_mip[11] = 0;
        csr_mcycle_reset =1'b0;
        csr_mhpmcounter_3_reset =1'b0;
        if (reset) begin 
            csr_mcause='0;
            csr_mie = 32'b0;
            csr_mip='0;
            csr_mtvec='0;
            csr_mepc='0;
            csr_mstatus='0;
            csr_mcounter_en = '0;
            // csr_mcycle_count ='0;
            csr_mcycle_reset =1'b0;
            csr_mhpmcounter_3_reset =1'b0;
        end
        else begin 
            if (csr_reg_wr) begin
            case (address)
            12'h300 : csr_mstatus =  write_data ;// mstatus csr
            12'h304 : csr_mie =  write_data ;// csr mie
            12'h305 : csr_mtvec =  write_data;// csr mtvec
            12'h341 : csr_mepc =  write_data  ; // csr mepc
            12'h342 : csr_mcause =  write_data ;//csr_mcause
            12'h344 : csr_mip =  write_data ;// csr mip
            12'h306 : csr_mcounter_en = write_data; // csr_timer_enable
            12'hB00 : if(write_data == 32'b1)csr_mcycle_reset =1'b1;
            12'hb03 : if(write_data == 32'b1)csr_mhpmcounter_3_reset =1'b1;
            endcase
                end
                else begin
                    csr_mcause=csr_mcause_ff;
                    csr_mie = csr_mie_ff;
                    csr_mip=csr_mip_ff;
                    csr_mtvec=csr_mtvec_ff;
                    csr_mepc=csr_mepc_ff;
                    csr_mstatus=csr_mstatus_ff;
                    csr_mcounter_en = csr_mcounter_en_ff;
                    // csr_mcycle_count ='0;
                    // csr_mcycle_reset =1'b0;
                    // csr_mhpmcounter_3_reset =1'b0;
                end

            if (interupt_csr_en ) begin 
                    
                    csr_mcause = 32'b1;
                    //csr_mip='0;
            
            end
			
			if (interupt) begin
                    csr_mip[11] = interupt;
                     //csr_mepc = pc;
			end
			else if (~interupt) csr_mip[11] =1'b0;
        end
      
   end

    always_ff @( posedge clk ) begin : updating_the_registers
        if (reset) begin 
            csr_mip_ff<='0;
            csr_mie_ff<='0;
            csr_mstatus_ff<='0; 
            csr_mcause_ff<='0; 
            csr_mtvec_ff<='0;
            csr_mepc_ff<='0;
            csr_mcounter_en_ff <='0;
            
            end
        else begin 
            csr_mip_ff<=csr_mip;
            csr_mie_ff<=csr_mie;
            csr_mstatus_ff<=csr_mstatus; 
            csr_mcause_ff<=csr_mcause; 
            csr_mtvec_ff<=csr_mtvec;
            csr_mcounter_en_ff<=csr_mcounter_en;
            csr_mcycle_ff <= csr_mcycle_count;
            csr_mhpmcounter_3_ff<=csr_mhpmcounter_3_count;

        
            if (interupt_csr_en) csr_mepc_ff<=pc;
        end
    end
    
        always_comb begin 
            
            if(csr_mcycle_reset | reset)   csr_mcycle_count ='0;
            else begin 
                if ( csr_mcounter_en[0]) csr_mcycle_count = csr_mcycle_ff + 64'h1;
                else csr_mcycle_count =csr_mcycle_ff;
                end

            if(csr_mhpmcounter_3_reset | reset)  csr_mhpmcounter_3_count='0;
            else begin  
                if ( csr_mcounter_en[3]) csr_mhpmcounter_3_count = csr_mhpmcounter_3_ff + 64'h1;
                else csr_mhpmcounter_3_count = csr_mhpmcounter_3_ff;
                end
        end

    always_comb begin 

        interupt_csr_en = csr_mstatus_ff[3] & (csr_mip_ff[11] & csr_mie_ff[11]);
        
    end


  

endmodule