import Config::*;
// include "types.svh"
module super_sys (
    input logic clk,
    rst,
    input [SUPER_SYS_ROWS-1:0] if_en,
    input logic [SUPER_SYS_COLS-1:0] wfetch,
    input logic [SUPER_SYS_ROWS-1:0][A_BITWIDTH-1:0] if_data,
    input logic [SUPER_SYS_COLS-1:0][W_BITWIDTH-1:0] wdata,
    input logic [SUPER_SYS_COLS-1:0][P_BITWIDTH-1:0] bias,
    ///control
    input [SMALL_SYS_ROWS-1:0] if_mux_sel,
    input logic [SUPER_SYS_ROWS-1:0] w_mux_sel,
    //outputs
    output logic [SUPER_SYS_COLS-1:0][P_BITWIDTH-1:0] of_data,
    output logic valid,
    output logic accum_start
);
  assign valid = core2_if_en[SMALL_SYS_ROWS-1];
  assign accum_start = core2_if_en[SMALL_SYS_ROWS-2] && ~core2_if_en[SMALL_SYS_ROWS-1];
  //////////////////////////////////////////
  //
  logic [SMALL_SYS_COLS-1:0][P_BITWIDTH-1:0] core0_of_data;
  logic [SMALL_SYS_ROWS-1:0] core0_wfetch_out;
  logic [SMALL_SYS_COLS-1:0][W_BITWIDTH-1:0] core0_wdata_out;
  //
  logic [SMALL_SYS_ROWS-1:0] core1_if_en;
  logic [SMALL_SYS_ROWS-1:0][A_BITWIDTH-1:0] core1_if_data;
  logic [SMALL_SYS_COLS-1:0][P_BITWIDTH-1:0] core1_of_data;
  logic [SMALL_SYS_ROWS-1:0] core1_wfetch_out;
  logic [SMALL_SYS_COLS-1:0][W_BITWIDTH-1:0] core1_wdata_out;
  //
  logic [SMALL_SYS_COLS-1:0] core2_wfetch;
  logic [SMALL_SYS_COLS-1:0][W_BITWIDTH-1:0] core2_wdata;
  logic [SMALL_SYS_COLS-1:0][P_BITWIDTH-1:0] core2_bias;
  logic [SMALL_SYS_ROWS-1:0] core2_if_en;
  logic [SMALL_SYS_ROWS-1:0][A_BITWIDTH-1:0] core2_if_data;
  //
  logic [SMALL_SYS_COLS-1:0] core3_wfetch;
  logic [SMALL_SYS_COLS-1:0][W_BITWIDTH-1:0] core3_wdata;
  logic [SMALL_SYS_ROWS-1:0] core3_if_en;
  logic [SMALL_SYS_ROWS-1:0][A_BITWIDTH-1:0] core3_if_data;
  logic [SMALL_SYS_COLS-1:0][P_BITWIDTH-1:0] core3_bias;

  ///////////////////////////////////////////

  muxes #(
      .WIDTH(1)
  ) muxes_instance1 (
      .mux_sel(if_mux_sel),
      .data2(if_en[2*SMALL_SYS_ROWS-1:SMALL_SYS_ROWS]),
      .data1(if_en[SMALL_SYS_ROWS-1:0]),
      .out(core2_if_en)
  );
  muxes #(
      .WIDTH(8)
  ) muxes_instance2 (
      .mux_sel(if_mux_sel),
      .data2(if_data[2*SMALL_SYS_ROWS-1:SMALL_SYS_ROWS]),
      .data1(if_data[SMALL_SYS_ROWS-1:0]),
      .out(core2_if_data)
  );
  muxes #(
      .WIDTH(1)
  ) muxes_instance10 (
      .mux_sel(w_mux_sel[7:0]),
      .data2(wfetch[SMALL_SYS_COLS-1:0]),
      .data1(core0_wfetch_out),
      .out(core2_wfetch)
  );
  muxes #(
      .WIDTH(8)
  ) muxes_instance11 (
      .mux_sel(w_mux_sel[7:0]),
      .data2(wdata[SMALL_SYS_COLS-1:0]),
      .data1(core0_wdata_out),
      .out(core2_wdata)
  );
  //   assign core2_wdata  = w_mux_sel[0] ? wdata[SMALL_SYS_COLS-1:0] : core0_wdata_out;
  //   assign core2_wfetch = w_mux_sel[0] ? wfetch[SMALL_SYS_COLS-1:0] : core0_wfetch_out;
  //   assign core2_bias=w_mux_sel[0]?bias[SMALL_SYS_COLS-1:0] :core0_of_data;   //technically not needed
  muxes #(
      .WIDTH(24)
  ) muxes_instance3 (
      .mux_sel(w_mux_sel[7:0]),
      .data2(bias[SMALL_SYS_COLS-1:0]),
      .data1(core0_of_data),
      .out(core2_bias)
  );

  muxes #(
      .WIDTH(24)
  ) muxes_instance4 (
      .mux_sel(w_mux_sel[15:8]),
      .data2(bias[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .data1(core1_of_data),
      .out(core3_bias)
  );
  muxes #(
      .WIDTH(1)
  ) muxes_instance5 (
      .mux_sel(w_mux_sel[15:8]),
      .data2(wfetch[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .data1(core1_wfetch_out),
      .out(core3_wfetch)
  );
  muxes #(
      .WIDTH(8)
  ) muxes_instance6 (
      .mux_sel(w_mux_sel[15:8]),
      .data2(wdata[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .data1(core1_wdata_out),
      .out(core3_wdata)
  );
  //

  //   assign core3_wdata = w_mux_sel[0] ? wdata[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS] : core1_wdata_out;
  //   assign core3_wfetch = w_mux_sel[0] ? wfetch[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS] : core1_wfetch_out;
  //   assign core3_bias = w_mux_sel[0] ? bias[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS] : core1_of_data;
  /////////////////////////////////////////
  systolic core0 (
      .clk(clk),
      .rst(rst),
      .if_en(if_en[SMALL_SYS_ROWS-1:0]),
      .wfetch(wfetch[SMALL_SYS_COLS-1:0]),
      .wfetch_halt(wfetch[SMALL_SYS_COLS-1:0]),
      .if_data(if_data[SMALL_SYS_ROWS-1:0]),
      .wdata(wdata[SMALL_SYS_COLS-1:0]),
      .bias(bias[SMALL_SYS_COLS-1:0]),
      .of_data(core0_of_data),
      .if_data_out(core1_if_data),
      .if_en_out(core1_if_en),
      .wfetch_out(core0_wfetch_out),
      .wdata_out(core0_wdata_out)
  );

  systolic core1 (
      .clk(clk),
      .rst(rst),
      .if_en(core1_if_en),
      .wfetch_halt(wfetch[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .wfetch(wfetch[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .if_data(core1_if_data),
      .wdata(wdata[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .bias(bias[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .of_data(core1_of_data),
      .if_data_out(),
      .if_en_out(),
      .wfetch_out(core1_wfetch_out),
      .wdata_out(core1_wdata_out)
  );

  systolic core2 (
      .clk(clk),
      .rst(rst),
      .if_en(core2_if_en),
      .wfetch(core2_wfetch),
      .wfetch_halt(wfetch[SMALL_SYS_COLS-1:0]),
      .if_data(core2_if_data),
      .wdata(core2_wdata),
      .bias(core2_bias),
      .of_data(of_data[SMALL_SYS_COLS-1:0]),
      .if_data_out(core3_if_data),
      .if_en_out(core3_if_en),
      .wfetch_out(),
      .wdata_out()
  );

  systolic core3 (
      .clk(clk),
      .rst(rst),
      .if_en(core3_if_en),
      .wfetch(core3_wfetch),
      .wfetch_halt(wfetch[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .if_data(core3_if_data),
      .wdata(core3_wdata),
      .bias(core3_bias),
      .of_data(of_data[2*SMALL_SYS_COLS-1:SMALL_SYS_COLS]),
      .if_data_out(),
      .if_en_out(),
      .wfetch_out(),
      .wdata_out()
  );

endmodule
