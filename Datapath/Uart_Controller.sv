module Uart_Controller (
    busy_tx,
    load_shiftreg,
    tx_mux_sel,
    clear_bit_count,
    clear_baud_count,
    assert_shift,
    CLK,
    reset,
    byte_ready,
    tx_byte,
    count_of,
    count_baud_of
);
  output logic busy_tx, load_shiftreg, tx_mux_sel, clear_bit_count, clear_baud_count, assert_shift;
  input logic CLK, reset, byte_ready, tx_byte, count_of, count_baud_of;
  localparam state_IDLE = 2'b00;
  localparam state_Start = 2'b01;
  localparam state_Data = 2'b10;
  logic [1:0] current_state, next_state;
  always_ff @(posedge CLK or posedge reset) begin
    if (reset) begin
      current_state <= state_IDLE;
    end else begin
      current_state <= next_state;
    end
  end
  always_ff @(posedge CLK) begin
    case (current_state)
      state_IDLE: begin
        if (byte_ready) next_state <= state_Start;
      end
      state_Start: begin
        if (tx_byte) next_state <= state_Data;
      end
      state_Data: begin
        if (count_baud_of && count_of) next_state <= state_IDLE;
      end
      default: next_state <= state_IDLE;
    endcase
  end
  always_ff @(posedge CLK) begin
    case (current_state)
      state_IDLE: begin
        clear_baud_count <= 1'b1;
        clear_bit_count <= 1'b1;
        tx_mux_sel <= 1'b0;
        load_shiftreg <= 1'b0;
        busy_tx <= 1'b0;
      end
      state_Start: begin
        if (tx_byte) begin
          load_shiftreg <= 1'b1;
          tx_mux_sel <= 1'b0;
        end
        clear_baud_count <= 1'b1;
        clear_bit_count <= 1'b1;
        busy_tx <= 1'b1;
      end
      state_Data: begin
        load_shiftreg <= 1'b0;
        clear_baud_count <= 1'b0;
        clear_bit_count <= 1'b0;
        busy_tx <= 1'b1;
        if (count_baud_of && !count_of) begin
          assert_shift <= 1'b1;
          tx_mux_sel   <= 1'b1;
        end else if (count_baud_of && count_of) begin
          tx_mux_sel   <= 1'b0;
          assert_shift <= 1'b0;
        end else if (!count_baud_of && count_of) begin
          tx_mux_sel   <= 1'b1;
          assert_shift <= 1'b0;
        end else if (!count_baud_of && !count_of) begin
          tx_mux_sel   <= 1'b1;
          assert_shift <= 1'b0;
        end
      end
    endcase
  end
endmodule
