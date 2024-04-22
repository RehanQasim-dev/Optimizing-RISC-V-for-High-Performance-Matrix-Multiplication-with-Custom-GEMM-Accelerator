import Config::*;
module gemm_datapath (
    input logic clk,
    input logic rst,
    input logic if_en,
    input logic wfetch,
    input logic [SUPER_SYS_ROWS-1:0][A_BITWIDTH-1:0] if_data,
    input logic [SUPER_SYS_COLS-1:0][W_BITWIDTH-1:0] wdata,
    input store,
    overwrite,
    // From controller
    input logic [CORE_ROWS-2:0] if_mux_sel,
    input logic [CORE_COLS-2:0] w_mux_sel,
    input logic [3:0] accums_rd_en,
    output logic [3:0][127:0] accum_o_data,
    output logic [3:0] acc_empty,
    output logic [1:0] mode_FV_if,
    output logic ready_for_HI,
    output logic acc_is_done,
    output logic if_sent,
    output logic accum_start,
    input logic gt4,
    gt8,
    gt12
);

  // Internal signals
  logic [SUPER_SYS_COLS-1:0][P_BITWIDTH-1:0] of_data, of_data_setup;

  // Systolic Setup
  logic [SUPER_SYS_ROWS-1:0] if_en_setup;
  logic [SUPER_SYS_COLS-1:0] wfetch_setup;
  logic [SUPER_SYS_ROWS-1:0][A_BITWIDTH-1:0] if_data_setup;
  logic [SUPER_SYS_COLS-1:0][W_BITWIDTH-1:0] wdata_setup;

  // Instantiate systolic_setup modules
  systolic_setup #(
      .DATA_WIDTH(W_BITWIDTH),
      .PORTS(SUPER_SYS_COLS)
  ) weight_data_setup (
      .clk(clk),
      .in (wdata),
      .out(wdata_setup)
  );

  systolic_setup #(
      .DATA_WIDTH(1),
      .PORTS(SUPER_SYS_COLS)
  ) weight_valid_setup (
      .clk(clk),
      .in ({SUPER_SYS_ROWS{wfetch}}),
      .out(wfetch_setup)
  );

  systolic_setup #(
      .DATA_WIDTH(A_BITWIDTH),
      .PORTS(SUPER_SYS_ROWS)
  ) input_data_setup (
      .clk(clk),
      .in (if_data),
      .out(if_data_setup)
  );

  systolic_setup #(
      .DATA_WIDTH(1),
      .PORTS(SUPER_SYS_ROWS)
  ) input_valid_setup (
      .clk(clk),
      .in ({SUPER_SYS_ROWS{if_en}}),
      .out(if_en_setup)
  );

  // Instantiate systolic_setup_reverse modules
  generate
    genvar i;
    for (i = 0; i < SUPER_SYS_COLS; i = i + 4) begin
      systolic_setup_reverse #(
          .DATA_WIDTH(P_BITWIDTH),
          .PORTS(4)
      ) of_data_setup_inst (
          .clk(clk),
          .rst(rst),
          .in (of_data[i+3:i]),
          .out(of_data_setup[i+3:i])
      );
    end
  endgenerate
  logic [SMALL_SYS_ROWS-2:0] all_if_mux_sel;
  logic [SUPER_SYS_ROWS-2:0] all_w_mux_sel;

  // Instantiate super_sys module
  super_sys super_sys_instance (
      .clk(clk),
      .rst(rst),
      .if_en(if_en_setup),
      .wfetch(wfetch_setup),
      .if_data(if_data_setup),
      .wdata(wdata_setup),
      .bias(0),
      .if_mux_sel({all_if_mux_sel, if_mux_sel}),
      .w_mux_sel({all_w_mux_sel, w_mux_sel}),
      .of_data(of_data),
      .valid(valid),
      .accum_start(accum_start)
  );

  assign ready_for_HI = ~if_en_setup[8] && if_en_setup[9];
  // assign accum_start  = ~valid_Psum[0] && valid;
  logic [SUPER_SYS_COLS:0] valid_Psum;
  //   assign valid_Psum[0] = valid;
  //   int j;
  //   always_ff @(posedge clk) begin : blockName
  //     for (j = 1; j < SUPER_SYS_COLS + 1; j = j + 1) begin
  //       valid_Psum[j] <= valid_Psum[j-1];
  //     end
  //   end
  for (i = 0; i < SUPER_SYS_COLS; i++) begin
    if (i == 0) begin
      always_ff @(posedge clk) begin : blockName
        valid_Psum[i] <= valid;
      end
    end else begin
      always_ff @(posedge clk) begin : blockName
        valid_Psum[i] <= valid_Psum[i-1];
      end
    end
  end
  logic [SUPER_SYS_ROWS-3:0] all_store, all_overwrite;

  pipeline_gen #(
      .data_type(logic),
      .Number(7)
  ) pipeline_gen_instance (
      .clk(clk),
      .a  (gt4),
      .y  (accum1_valid)
  );
  pipeline_gen #(
      .data_type(logic),
      .Number(11)
  ) pipeline_gen_instance2 (
      .clk(clk),
      .a  (gt8),
      .y  (accum2_valid)
  );
  pipeline_gen #(
      .data_type(logic),
      .Number(15)
  ) pipeline_gen_instance3 (
      .clk(clk),
      .a  (gt12),
      .y  (accum3_valid)
  );
  accumulator accumulator_instance (
      .clk(clk),
      .rst(rst),
      .store({all_store[13], all_store[9], all_store[5], all_store[1]}),
      .overwrite({all_overwrite[13], all_overwrite[9], all_overwrite[5], all_overwrite[1]}),
      .rd_en(accums_rd_en),
      .true_valid({
        valid_Psum[15] && accum3_valid,
        valid_Psum[11] && accum2_valid,
        valid_Psum[7] && accum1_valid,
        valid_Psum[3]
      }),
      .i_data(of_data_setup),
      .o_data(accum_o_data),
      .empty(acc_empty)
  );
  assign mode_FV_if[0] = valid_Psum[15];
  assign mode_FV_if[1] = valid_Psum[7];
  logic old_valid_Psum_15;
  always_ff @(posedge clk) begin : blockName
    old_valid_Psum_15 <= valid_Psum[15];
  end
  assign acc_is_done = old_valid_Psum_15 && ~valid_Psum[15];
  assign if_sent = ~valid && valid_Psum[0];

  for (i = 0; i < SMALL_SYS_ROWS - 1; i++) begin
    if (i == 0) begin
      always_ff @(posedge clk) begin : blockName
        all_if_mux_sel[i] <= if_mux_sel;
      end
    end else begin
      always_ff @(posedge clk) begin : blockName
        all_if_mux_sel[i] <= all_if_mux_sel[i-1];
      end
    end
  end
  for (i = 0; i < SUPER_SYS_ROWS - 1; i++) begin
    if (i == 0) begin
      always_ff @(posedge clk) begin : blockName
        all_w_mux_sel[0] <= w_mux_sel;
      end
    end else begin
      always_ff @(posedge clk) begin : blockName
        all_w_mux_sel[i] <= all_w_mux_sel[i-1];
      end
    end
  end
  for (i = 0; i < SUPER_SYS_ROWS - 2; i++) begin
    if (i == 0) begin
      always_ff @(posedge clk) begin : blockName
        all_store[0] <= store;
        all_overwrite[0] <= overwrite;
      end
    end else begin
      always_ff @(posedge clk) begin : blockName
        all_store[i] <= all_store[i-1];
        all_overwrite[i] <= all_overwrite[i-1];
      end
    end
  end

endmodule
