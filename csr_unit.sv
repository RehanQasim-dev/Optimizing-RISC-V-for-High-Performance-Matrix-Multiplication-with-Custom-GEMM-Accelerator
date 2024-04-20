module csr_unit (input logic clk, reset, input logic [31:0] pc, input logic [31:0] write_data, input logic [31:0] csr_address, input logic csr_reg_wr, csr_reg_rd,csr_return, interupt, output logic [31:0] data_out_to_reg, pc_for_inst_mem, output logic interupt_sel );

    logic [31:0] csr_mip,csr_mie, csr_mstatus, csr_mcause, csr_mtvec, csr_mepc;
    logic  [11:0] address;
    logic csr_mcause_en, csr_mepc_en, csr_mie_en, csr_mip_en, csr_mtvec_en, csr_mstatus_en;
    logic [31:0] pc_for_inst_mem_intrupt_return;
    logic [31:0] pc_for_intrupt_handle;
    logic interupt_csr_en;

    assign address  = csr_address[11:0];
    assign pc_for_inst_mem_intrupt_return = csr_mepc;
    assign interupt_sel = interupt_csr_en | csr_return;
    
    
    always_comb begin 
         csr_mip_en=1'b0;
       
        if (csr_reg_rd) begin
            data_out_to_reg = '0; 
            case (address) 
            
            12'h300 : data_out_to_reg = csr_mstatus; // mstatus csr
            12'h304 : data_out_to_reg = csr_mie; // csr mie
            12'h305 : data_out_to_reg = csr_mtvec; // csr mtvec
            12'h341 : data_out_to_reg = csr_mepc;    // csr mepc
            12'h342 : data_out_to_reg = csr_mcause; //csr_mcause
            12'h344 : data_out_to_reg = csr_mip; // csr mip
            default data_out_to_reg = '0;
            endcase
        end
        if (interupt )  csr_mip_en = 1'b1; 
        if (csr_reg_wr) begin
                csr_mstatus_en = 1'b0; // mstatus csr
                csr_mie_en = 1'b0; // csr mie
                csr_mtvec_en = 1'b0; // csr mtvec
                csr_mepc_en = 1'b0; // csr mepc
                csr_mcause_en = 1'b0; //csr_mcause
                //csr_mip_en = 1'b0; 
            case(address)
                12'h300 : csr_mstatus_en = 1'b1; // mstatus csr
                12'h304 : csr_mie_en = 1'b1; // csr mie
                12'h305 : csr_mtvec_en = 1'b1; // csr mtvec
                12'h341 : csr_mepc_en = 1'b1; // csr mepc
                //12'h342 : csr_mcause_en = 1'b1; //csr_mcause
                //12'h344 : if (interupt ) begin csr_mip_en = 1'b1; end // csr mip
            endcase
        end
    

    end

    always_ff @( posedge clk, posedge reset ) begin 
        if (reset) begin 
         //   csr_mcause <='0;
          //  csr_mepc <= '0;
            csr_mie <= '0;
            csr_mip <= '0;
            csr_mstatus <='0;
            csr_mtvec <='0; 
                   
        end
                    
        if (csr_mie_en) csr_mie <= write_data;
        if (csr_mtvec_en) csr_mtvec <= write_data;
        //if (csr_mepc_en) csr_mepc <= write_data;
        if (csr_mstatus_en) csr_mstatus <= write_data;
        //if (csr_mcause_en ) csr_mcause <= write_data;
                    if (csr_mip_en ) csr_mip[11] <=  interupt;                   //write_data;
    end

    assign interupt_csr_en = csr_mstatus[3] & (csr_mip[11] & csr_mie[11]) ;

    always_comb begin 
    
        if (reset)  begin 
             csr_mepc ='0;
            csr_mcause ='0;
            
        end
        else if (interupt_csr_en)  begin 
            csr_mepc = pc;
            csr_mcause = 32'b1;
           
        end
    
     if (interupt_csr_en & ~csr_return) begin
            if (csr_mtvec [1:0] == 2'b00) pc_for_inst_mem = {2'b00 +{csr_mtvec} };
            else if (csr_mtvec [1:0] == 2'b01) pc_for_inst_mem = csr_mtvec  + (csr_mcause << 2);
            
     end

     else if (csr_return) begin
            pc_for_inst_mem = pc_for_inst_mem_intrupt_return;
     end 
    end

  

endmodule