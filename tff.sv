module tff ( input logic clk, rst, output logic  out, rst_out);
    logic [2:0] d;
    logic [3:0] reset ;
    logic rst_trigger;

        always_ff @( posedge clk, posedge rst ) begin 
            if (rst) d <=0;
            else d<= d + 1'b1;
        end

        always_ff @( posedge clk , posedge rst ) begin 
              if (reset == 4'b1100) rst_trigger <=0;
               
                else   if(rst) begin rst_trigger <=1; reset <=0;end
                else  if(rst_trigger) reset <= reset + 1'b1;
        end

        assign out = d[1];
        assign rst_out = rst_trigger;
    
endmodule 