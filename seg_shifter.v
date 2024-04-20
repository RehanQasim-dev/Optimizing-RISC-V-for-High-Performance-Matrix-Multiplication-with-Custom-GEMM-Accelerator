
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2022 05:58:02 AM
// Design Name: 
// Module Name: seg_shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg_shifter(input write , input [2:0] sel_2, sel, output reg  [2:0]data

    );

    initial begin 
        data='b0;
    end    
    always@(*)
        begin 
            if (write)
                data<=sel_2;
            else 
                data<=sel_2; 
    
        end
endmodule
