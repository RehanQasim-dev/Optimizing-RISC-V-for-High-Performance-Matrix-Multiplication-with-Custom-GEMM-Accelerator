module Shift_Reg (
    serial_out,
    IN_Data,
    assert_shift,
    load_data, 
    reset
);
  output logic serial_out;
  input logic [7:0] IN_Data;
  input logic assert_shift;
  input logic load_data, reset;
  logic [8:0] data = 9'b00000000;

  always_comb begin
    if(reset) begin
      serial_out = 1'b1;
    end
    else begin
      if (load_data) begin
        data = {IN_Data, 1'b0};
      end
      if (assert_shift) begin
        serial_out = data[0];
        data = {1'b0, data[8:1]};
      end
    end
  end
endmodule
