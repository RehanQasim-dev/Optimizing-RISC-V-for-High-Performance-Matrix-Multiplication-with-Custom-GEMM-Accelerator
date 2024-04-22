//`include "datapath.sv"
//`include "controller.sv"

import Config::*;
module gemm (
    input clk,
    input rst,
    system_bus_en,
    system_bus_rdwr,
    output logic [31:0]system_bus_rd_data,
    input logic [31:0] system_bus_wr_data,
    [31:0]system_bus_addr,
    output logic [4:0] interface_control,
    output logic interface_rdwr,
    output logic interface_en,
    output logic [31:0] interface_addr,
    input logic [127:0] interface_rd_data,
    output logic [3:0][31:0] interface_wr_data
);
logic gt4_buffered,gt8_buffered,gt12_buffered;

// Declare signals to connect to Main_controller
    logic [3:0] buffer_empty;
    logic [4:0] msize, nsize, ksize;
    logic [31:0] tile_A_addr, tile_B_addr, tile_A_stride, tile_B_stride, tile_C_addr;
    logic conf_empty, ready_for_HI,  read_all_buffers, store;
    logic [1:0] mode;
    logic [3:0] rd_result;
    logic prefetch_done;
    logic if_mux_sel;
    logic w_mux_sel;
    logic overwrite;
    logic [1:0] mode_FV_if;
    logic store_buffered,overwrite_buffered;
    logic if_en,wfetch;
    logic if_mux_sel_buffered;
    logic [1:0]buffer_sel;
    logic gen_addr_store,
    interface_en_store;
    logic [4:0] interface_control_store;
    logic [31:0] next_addr_store;
    logic interface_rdwr_store;
    logic w_mux_sel_buffered;

  logic [3:0][127:0]accum_o_data;
    gemm_datapath datapath_instance (
    .clk(clk),
    .rst(rst),
    .if_en(if_en),
    .wfetch(wfetch),
    .if_data(interface_rd_data),
    .wdata(interface_rd_data),
    .store(store_buffered),
    .overwrite(overwrite_buffered),
    .if_mux_sel(if_mux_sel_buffered),
    .w_mux_sel(w_mux_sel_buffered),
    .accums_rd_en(rd_result),
    .accum_o_data(accum_o_data),
    .acc_empty(buffer_empty),
    .mode_FV_if(mode_FV_if),
    .ready_for_HI(ready_for_HI),
    .accum_start(accum_start),
    // .acc_is_done(acc_is_done),
    // .if_sent(if_sent)
    .gt4(gt4_buffered),
    .gt8(gt8_buffered),
    .gt12(gt12_buffered)
    );
    always_comb begin : blockName
      case(buffer_sel)
        0:interface_wr_data=accum_o_data[0];
        1:interface_wr_data=accum_o_data[1];
        2:interface_wr_data=accum_o_data[2];
        3:interface_wr_data=accum_o_data[3];
      endcase
    end
  gemm_decoder decoder_instance (
    .clk(clk),              
    .ksize(ksize),          
    .nsize(nsize),          
    .mode(mode),            
    .if_mux_sel(if_mux_sel),
    .w_mux_sel(w_mux_sel)  
);
  logic gt4, gt8, gt12;  // Greater than 4, 8, 12 signals

buffer_accum_ctrl #(
  .DEPTH(4),
  .DWIDTH(5)
) buffer_instance(
  .rst(rst),
  .clk(clk),
  .wr_en(prefetch_done),
  .rd_en(accum_start),
  .din({store,overwrite,gt4,gt8,gt12}),
  .dout({store_buffered,overwrite_buffered,gt4_buffered,gt8_buffered,gt12_buffered}),
  .empty(),
  .full()
);
// always_ff @( posedge clk ) begin
//     if(accum_start) begin 
//     store_buffered<=store;
//     overwrite_buffered<=overwrite;
//     gt4_buffered<=gt4;
//     gt8_buffered<=gt8;
//     gt12_buffered<=gt12;
//     end
// end


always_ff @( posedge clk ) begin
    if(prefetch_done) begin 
    if_mux_sel_buffered<=if_mux_sel;
    end
end
always_ff @( posedge clk ) begin
    if(prefetch_start) begin 
    w_mux_sel_buffered<=w_mux_sel;
    end
end


//////////////////////////////////////////////////////////////////////////
// Controller
  assign gt4  = nsize > 4;
  assign gt8  = nsize > 8;
  assign gt12 = nsize > 12;
  // Internal signals for Load_Ex_controller
  logic        done_store;  // Signal indicating completion of store operation
  logic [31:0] current_addr;  // Current address
  logic        can_store;  // Signal to indicate if storing is possible
  logic [31:0] next_addr,next_row_addr_store;  // Next address to generate
  logic        gen_addr;  // Generate address signal

  // Instantiate Load_Ex_controller
  Load_Ex_controller my_controller (
      .rst(rst),
      .clk(clk),
      .done_store(done_store),
      .store(store),
      .conf_empty(conf_empty),
      .ready_for_HI(ready_for_HI),
      .mode(mode),
      .current_addr(current_addr),
      .tile_B_addr(tile_B_addr),
      .tile_A_addr(tile_A_addr),
      .tile_B_stride(tile_B_stride),
      .tile_A_stride(tile_A_stride),
      .msize(msize),
      .nsize(nsize),
      .ksize(ksize),
      .can_store(can_store),
      .interface_rdwr(interface_rdwr),
      .interface_en(interface_en),
      .interface_control(interface_control),
      .conf_buff_read_buffered(read_all_buffers),
      .next_addr(next_addr),
      .gen_addr(gen_addr),
      .prefetch_done_buffered(prefetch_done),
      .if_en_buffered(if_en),
      .wfetch_buffered(wfetch),
      .interface_en_store(interface_en_store),
      .interface_control_store(interface_control_store),
      .next_row_addr_store(next_row_addr_store),
      .interface_rdwr_store(interface_rdwr_store),
      .gen_addr_store(gen_addr_store),
      .prefetch_start(prefetch_start),
      .use_store_addr(use_store_addr),
      .we_accum_ctrl(we_accum_ctrl)
  );

  logic [31:0] current_store_addr;  // Current address

  // Instantiate store_controller

  store_controller my_store_controller (
      .clk(clk),
      .rst(rst),
      .can_do_store(can_store),
      .buffer_empty(buffer_empty),
      .msize(msize),
      .nsize(nsize),
      .gt4(gt4),
      .gt8(gt8),
      .gt12(gt12),
      .tile_C_addr(tile_C_addr),
      .tile_B_stride(tile_B_stride),
      .current_row_addr(current_addr),
      .rd_result(rd_result),
      .gen_addr(gen_addr_store),
      .interface_en(interface_en_store),
      .interface_control(interface_control_store),
      .next_row_addr(next_row_addr_store),
      .current_addr(current_store_addr),
      .interface_rdwr(interface_rdwr_store),
      .done_store(done_store),
      .buffer_sel(buffer_sel)
  );


  ///////////////////////////// Address generate block//////////////////
  assign interface_addr = use_store_addr ? current_store_addr : current_addr;
  //assign interface_addr=current_addr;
  always_ff @(posedge clk) begin
    if (rst) current_addr <= 0;
    else if (gen_addr) current_addr <= next_addr;
  end
  memory_mapped memory_mapped_instance(
    .clk(clk),
    .rst(rst),
    .read_all_buffers(read_all_buffers),
    .system_bus_en(system_bus_en),
    .system_bus_rdwr(system_bus_rdwr),
    .system_bus_wr_data(system_bus_wr_data),
    .system_bus_addr(system_bus_addr),
    .system_bus_rd_data(system_bus_rd_data),
    .tile_A_addr(tile_A_addr),
    .tile_B_addr(tile_B_addr),
    .tile_C_addr(tile_C_addr),
    .tile_A_stride(tile_A_stride),
    .tile_B_stride(tile_B_stride),
    .ksize(ksize),
    .msize(msize),
    .nsize(nsize),
    .store(store),
    .overwrite(overwrite),
    .conf_empty(conf_empty)
  );
endmodule
