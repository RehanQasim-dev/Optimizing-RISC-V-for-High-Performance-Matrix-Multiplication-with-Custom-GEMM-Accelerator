module alternate_delayer (input clk, output wire clock);
    
    wire clock_1,clock_2,clock_3,clock_4,clock_5,clock_6,clock_7,clock_8,clock_9,clock_10,clock_11,clock_12,clock_13,clock_14,clock_15,clock_16,clock_17,clock_18,clock_19,clock_20,clock_21;
    flip_flop_display Devider_1(clk,clock_1);
    flip_flop_display Devider_2(clock_1,clock_2);
    flip_flop_display Devider_3(clock_2,clock_3);
    flip_flop_display Devider_4(clock_3,clock_4);
    flip_flop_display Devider_5(clock_4,clock_5);
    flip_flop_display Devider_6(clock_5,clock_6);
    flip_flop_display Devider_7(clock_6,clock_7);
    flip_flop_display Devider_8(clock_7,clock_8);
    flip_flop_display Devider_9(clock_8,clock_9);
    flip_flop_display Devider_10(clock_9,clock_10);
    flip_flop_display Devider_11(clock_10,clock_11);
    flip_flop_display Devider_12(clock_11,clock_12);
    flip_flop_display Devider_13(clock_12,clock_13);
    flip_flop_display Devider_14(clock_13,clock_14);
    flip_flop_display Devider_15(clock_14,clock_15);
    flip_flop_display Devider_16(clock_15,clock_16);
    flip_flop_display Devider_17(clock_16,clock_17);
    flip_flop_display Devider_18(clock_17,clock);
    
  


endmodule 