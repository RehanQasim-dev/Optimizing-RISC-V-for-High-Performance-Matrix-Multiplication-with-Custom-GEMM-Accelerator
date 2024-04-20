
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2022 07:25:23 PM
// Design Name: 
// Module Name: pin_selector
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


module pin_selector(
    
    input [2:0]sel,
  
    output reg [7:0]pins
    );

  
  
    always @ ( sel,pins)
       
           
                begin 
                    case (sel)
                        3'b000 : pins <=8'b1111_1110;
                       
                        3'b001 : pins <=8'b1111_1101;
                  
                        3'b010 : pins <=8'b1111_1011;
                       
                        3'b011 : pins <=8'b1111_0111;
                    
                        3'b100 : pins <=8'b1110_1111;
                        
                        3'b101 : pins <=8'b1101_1111;
                      
                        3'b110 : pins <=8'b1011_1111;
                     
                        3'b111 : pins <=8'b0111_1111;
                 
                     endcase
          
             
            

            end
            
            
            
            
          
  
                    


endmodule
