module m_unit (input logic clk ,input logic [31:0] operand_a, operand_b, input logic [3:0] mul_con,input logic branch_output, output logic [31:0] out_result, output logic out_done, m_busy);

    logic [31:0] to_mul_a, to_mul_b, to_div_a, to_div_b, div_quotient, div_remainder;
//     logic [63:0] mul_output;
    logic div_start, div_busy, bit_sign, mul_done, mul_start, mul_busy;
    logic  valid_a, valid_b, div_overflow, div_valid, div_zero_flag,div_start_flip, div_done;
    logic [1:0] bit_case;
    logic [31:0] number_signed, remainder_signed;
    assign bit_case = {{operand_a[31]},{operand_b[31]}};

    assign bit_sign = operand_a[31] ^ operand_b[31]; 
    assign valid_a = |operand_a;
    assign valid_b = |operand_b;

    always_comb begin // output mux
    out_done=1'b0;

    case (mul_con)
        // 4'b0000 : begin out_done=mul_done|div_valid; m_busy=mul_busy|div_busy; end	//no need of m_unit
        // 4'b0001 : begin    //mul lower signed multiplcation
	// 					if (mul_done)begin     if (bit_sign) out_result = ~mul_output[31:0] + 1'b1;
        //                                         else out_result = mul_output[31:0]; 
        //                  out_done=mul_done;  m_busy=mul_busy;  end
        //                         else begin out_done= mul_done; m_busy=1'b1;  end end
        // 4'b0010 : begin    //mulh upper signed x signed multipliction
	// 					if (mul_done)begin  begin 
        //                 if (bit_sign & (mul_output[63:32] !=32'd0)) out_result = ~mul_output[63:32] + 1'b1;
        //                         else if (bit_sign & (mul_output[63:32] ==32'd0 )) out_result = 32'hffff_ffff;
        //                         else out_result = mul_output[63:32];
        //                  end out_done= mul_done; m_busy=mul_busy;end 
        //                         else out_done= mul_done; m_busy=1'b1; end         
        // 4'b0011 : begin   //mulhu, unsigned multiplication upper bits  
	// 						if (mul_done)begin   out_result = mul_output[63:32];  out_done= mul_done; m_busy=mul_busy;end  
        //                         else begin      out_done= mul_done; m_busy=1'b1;         end                end
        // 4'b0100 : begin     // mulhsu multiplction signed and unsigned, output signed (rs1 treated as signed)
        //                 if (mul_done) begin 
        //                 begin if (operand_a[31]) out_result = ~mul_output[63:32] +1'b1;
        //                         else out_result = mul_output[63:0]; end
        //                  out_done= mul_done; m_busy=mul_busy; 
        //                 end     
        //                 else begin 
        //                         out_done= mul_done; m_busy=1'b1;
        //                 end   end
        4'b1000 : begin     // div, signed division
                if (valid_a & valid_b) begin  //no zero
                    if (div_overflow)  begin out_result = 32'h8000_0000; out_done = 1'b1; end
                    else begin 
                        if (div_valid) begin //stops the value of the output to change before the divider stops calculating
                                if (bit_sign) begin     out_result = number_signed; out_done =div_valid;     end
                                else begin  out_result = div_quotient; out_done = div_valid;    end out_done = div_valid; m_busy=div_busy;end
                        else begin out_done =1'b0; m_busy=div_busy; end  
                    end   end
                else if (valid_a & ~valid_b) begin // zero in denominator
                        out_result = 32'h8000_0000; out_done = 1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & valid_b) begin // zero in numerator
                    out_result =1'b0; out_done =1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & ~valid_b) begin  //both zeros
                        out_result='x; out_done=1'b1;m_busy=1'b0; 
                end
           end 
        4'b1001 : begin    //divu unsigned divide
                if (valid_a & valid_b) begin  
                       if (div_valid) begin  out_result = div_quotient; out_done = div_valid; m_busy=div_busy; end
                       else begin out_done=1'b0;m_busy=1'b1; end
                    end   
                else if (valid_a & ~valid_b) begin 
                        out_result = 32'hffff_ffff; out_done = 1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & valid_b) begin
                    out_result =1'b0; out_done =1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & ~valid_b) begin 
                        out_result='x; out_done=1'b1;m_busy=1'b0; 
                end
        end    
        4'b1010 : begin    // rem remainder signed 
                if (valid_a & valid_b) begin  
                        if (div_valid) begin 
                        case (bit_case) 
                        2'b00 : begin out_result = div_remainder; out_done = div_valid;  end 
                        2'b01 : begin out_result = div_remainder; out_done = div_valid;  end 
                        2'b10 : begin out_result = remainder_signed; out_done = div_valid;  end 
                        2'b11 : begin out_result = remainder_signed; out_done = div_valid;  end 
                    
                        endcase
                        m_busy=div_busy;
                        end
                        else begin out_done=1'b0;m_busy=div_busy; end
                        
                    end   
                else if (valid_a & ~valid_b) begin 
                        out_result = operand_a; out_done = 1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & valid_b) begin
                    out_result =1'b0; out_done =1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & ~valid_b) begin 
                        out_result='x; out_done=1'b1;m_busy=1'b0; 
                end   
                end
        4'b1011 : begin      // remu remainder unsigned
                if (valid_a & valid_b) begin  
                        if (div_valid) begin out_result = div_remainder; out_done = div_valid;   m_busy=div_busy;    end
                        else   begin  out_done=1'b0;m_busy=div_busy; end
                         
                        
                    end   
                else if (valid_a & ~valid_b) begin 
                        out_result = operand_a; out_done = 1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & valid_b) begin
                    out_result =1'b0; out_done =1'b1;m_busy=1'b0; 
                end
                else if (~valid_a & ~valid_b) begin 
                        out_result='x; out_done=1'b1;m_busy=1'b0; 
                end    
                  end   
      
        
            default: begin
                 out_done='0;m_busy=1'b0; 
            end
    endcase

        
    end

        always_comb begin  // overflow catcher
        if (operand_a == 32'h8000_0000 & operand_b == 32'hffff_ffff) div_overflow=1'b1;
                else div_overflow=1'b0;
        end

        always_comb begin // bit sign handler
        
        if (bit_sign)begin 
         if (mul_con[3]) begin number_signed = ~div_quotient + 1'b1; remainder_signed = ~div_remainder + 1'b1;  ;end // divide case
        end

        end

        always_comb begin  // input selctor and module started
        div_start=1'b0;
        
                case (mul_con)
                // 4'b0000 : begin div_start=1'b0; mul_start=1'b0; end
                // 4'b0001 : begin  begin if (operand_a[31])  to_mul_a = ~operand_a + 1'b1;
                //                 else to_mul_a = operand_a;
                //         end  
                        
                //         begin 
                //                 if (operand_b[31]) to_mul_b = ~operand_b + 1'b1;
                //                 else to_mul_b = operand_b;
                //         end div_start=1'b0;mul_start=1'b1; end
                // 4'b0010 : begin  
                //         begin if (operand_a[31])  to_mul_a = ~operand_a + 1'b1;
                //                 else to_mul_a = operand_a;
                //         end  
                        
                //         begin 
                //                 if (operand_b[31]) to_mul_b = ~operand_b + 1'b1;
                //                 else to_mul_b = operand_b;
                //         end div_start=1'b0;mul_start=1'b1;
                //         end
                // 4'b0011 : begin to_mul_a = operand_a; to_mul_b= operand_b;div_start=1'b0; mul_start=1'b1;end 
                // 4'b0100 : begin 
                //                 begin if (operand_a[31])  to_mul_a = ~operand_a + 1'b1;
                //                 else to_mul_a = operand_a;
                //                 end
                //                 to_mul_b = operand_b; div_start=1'b0;mul_start=1'b1;
                //         end 
                4'b1001 : begin to_div_a= operand_a; to_div_b=operand_b; 
                                div_start=1'b1; mul_start=1'b0;
                               
                                        end
                4'b1011 : begin to_div_a= operand_a; to_div_b=operand_b;                 
                                 div_start=1'b1;mul_start=1'b0;
                               
                                 end
                4'b1000 : begin 
                        begin if (operand_a[31])  to_div_a = ~operand_a + 1'b1;
                                else to_div_a = operand_a;
                        end  
                        
                        begin 
                                if (operand_b[31]) to_div_b = ~operand_b + 1'b1;
                                else to_div_b = operand_b;
                        end     
                        
                       div_start=1'b1;mul_start=1'b0;
                      
                
                        end 
                4'b1010 : begin 
                        begin if (operand_a[31])  to_div_a = ~operand_a + 1'b1;
                                else to_div_a = operand_a;
                        end  
                        
                        begin 
                                if (operand_b[31]) to_div_b = ~operand_b + 1'b1;
                                else to_div_b = operand_b;
                        end     div_start=1'b1; mul_start=1'b0;
                        end 

                default begin 
                        to_div_a='0;
                        to_div_b='0;
                        to_mul_a='0;
                        to_mul_b='0;
                        div_start=1'b0;        
                        mul_start=1'b0;    end 


                endcase 
                
        end

        always_ff@ (posedge clk , posedge div_busy ) begin // after changing the modules we only need to start the two modules and not give it a pulse, so this is ignored
               if(div_busy) div_start_flip<=1'b0;
               else if (div_start ) div_start_flip<=1'b1;
                else if (div_start & div_busy )div_start_flip<=1'b0;
                else if (~ div_start) div_start_flip<=1'b0;
        end


       // mul_int multiplcation_unit(to_mul_a, to_mul_b, mul_output, mul_done);
        // mul_try multiplcation_unit(clk, mul_start, branch_output,to_mul_a, to_mul_b, mul_busy, mul_done, mul_output);
        div_try #(.WIDTH(32)) division_unit (clk, div_start, div_busy, div_valid,div_zero_flag,to_div_a,to_div_b,div_quotient, div_remainder, div_done);
endmodule

// module: M_UNIT made by 2019ee25unioni
// module: MUL_TRY	made by 2019ee25unioni
// module: DIV_TRY taken from https://github.com/projf/projf-explore/tree/2022/lib/maths , modified and renamed   Div_try(original name div_int.sv )