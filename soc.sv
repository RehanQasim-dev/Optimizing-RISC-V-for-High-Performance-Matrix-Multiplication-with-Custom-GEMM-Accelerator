module soc (
    input logic clk, rst,
     output logic [7:0] an,
    output logic [6:0] a_to_g,

    output  logic uart_txd_o
);

logic rst_new, clk_25;

    tff divider_1 (clk, rst, clk_25, rst_new);
   
    top top_instance (clk_25,rst_new, an, a_to_g,1,uart_txd_o);
    
endmodule