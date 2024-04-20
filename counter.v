module counter (input clk, input reset, output reg [2:0]sel_2);
    

//here write is acting as a reset
    always@(posedge clk)
        begin 
             if (reset) sel_2<=1'b0;
            else sel_2<=sel_2+3'b001;
        

        end
endmodule