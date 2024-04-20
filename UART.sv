module UART (
    output logic Tx,
    tx_busy,
    input logic byte_ready,
    tx_byte,
    CLK,
    reset,
    input logic [7:0] IN_Data, 
    output logic  uart_done

);
  logic
      serial_out,
      assert_shift,
      load_data,
      count_of,
      clear_bit_count,
      count_baud_of,
      tx_mux_sel,
      clear_baud_count;
  Shift_Reg SR (
      .serial_out(serial_out),
      .IN_Data(IN_Data),
      .assert_shift(assert_shift),
      .load_data(load_data),
      .reset(reset)
  );
  Uart_Mux_2x1 mux2x1 (
      .out(Tx),
      .IN1(1'b1),
      .IN2(serial_out),
      .sel(tx_mux_sel)
  );
  Bit_Counter bit_count (
      .count_of(count_of),
      .clear_count(clear_bit_count),
      .tx_clk(count_baud_of),
      .reset(reset),
      .uart_done(uart_done)
  );
  Baud_rate_Generator BRG (
      .count_baud_of(count_baud_of),
      .CLK(CLK),
      .clear_baud_count(clear_baud_count)
  );
  Uart_Controller UC (
      .busy_tx(tx_busy),
      .load_shiftreg(load_data),
      .tx_mux_sel(tx_mux_sel),
      .clear_bit_count(clear_bit_count),
      .clear_baud_count(clear_baud_count),
      .assert_shift(assert_shift),
      .CLK(CLK),
      .reset(reset),
      .byte_ready(byte_ready),
      .tx_byte(tx_byte),
      .count_of(count_of),
      .count_baud_of(count_baud_of)
  );
endmodule
