module main_display (input [31:0]num,input clock, input reset, output [6:0]seg, output [7:0]pin);
	
	wire [3:0]a;
	wire [3:0]b;
	wire [3:0]c;
	wire  [3:0]d;
	wire  [3:0]e;
	wire  [3:0]f;
	wire  [3:0]g;
	wire  [3:0]h;
	wire write;
	assign a=num[3:0];
    assign b=num[7:4];
    assign c=num[11:8];
    assign d=num[15:12];
    assign e=num[19:16];
    assign f=num[23:20];
    assign g=num[27:24];
    assign h=num[31:28];
	
	
	assign write =1'b1;
	
	wire [2:0] sel_2;
    wire clk;
    
   //  alternate_delayer clock_delayer(clock,clk);
    //clock_count clock_delayer_2(clock, clk);
    wire [3:0]w;
	wire [6:0]seg_1;

  
    //flip_flop_main flop (clk,write,reset,num,a,b,c,d,e,f,g,h);
                 
		counter COUNT(clock,reset, sel_2);
      // seg_shifter MUX_2(write,sel_2,3'b000,sel_2);
       mux_display MUX (a,b,c,d,e,f,g,h,sel_2,w);
   
	   seven SEVEN_1(w,seg_1);
	 
	   pin_selector PIN (sel_2,pin);
		
	assign seg=seg_1;
	
	
endmodule