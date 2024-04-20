module flip_flop_display ( input clk,  output reg out);
    reg d=1'b0;
  
    
    always @(posedge clk)
        begin 
             
           out<=d;
         
           

        end
        always @(negedge clk)
            begin
            d<=~out;
            end 
endmodule 