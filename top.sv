`timescale 1ns / 1ns
`include "uart_defs.svh"
module top (
    input clk,
    rst,
    output logic [7:0] an,
    output logic [6:0] a_to_g,
    input  logic uart_rxd_i,
    output  logic uart_txd_o
);
  logic is_gemm_addr_late;
  logic system_bus_en, system_bus_rdwr;
  logic [31:0]
      system_bus_rd_data,
      system_bus_wr_data,
      gemm_conf_read,
      mem_read_data,
      gemm_conf_read_ppl,
      result;
  logic [31:0] system_bus_addr;
  logic [4:0] interface_control;
  logic interface_rdwr;
  logic interface_en;
  logic [31:0] interface_addr;
  logic [15:0][7:0] interface_rd_data;
  logic [3:0][31:0] interface_wr_data;
  logic [3:0] system_bus_mask;
  logic interupt, mem_valid, is_gemm_addr, en_gemm_conf, en_Dmem;
  always_ff @(posedge clk) begin
    mem_valid <= ~system_bus_rdwr & system_bus_en;
  end
  main_csr_pipe UUT (
      clk,
      rst,
      interupt,
      an,
      a_to_g,
      system_bus_rdwr,
      system_bus_en,
      system_bus_mask,
      system_bus_addr,
      system_bus_wr_data,
      system_bus_rd_data,
      mem_valid
  );
  logic [31:0] uart_rd_data;
  logic is_uart_addr;
  assign is_gemm_addr = system_bus_addr[31:28] == 4'b1001;//0x90000000
  assign is_uart_addr= system_bus_addr[31:28] == 4'b1000; //0x80000000
  always_ff @(posedge clk) begin : blockName
    is_gemm_addr_late  <= is_gemm_addr;
    gemm_conf_read_ppl <= gemm_conf_read;
  end
  assign system_bus_rd_data = is_gemm_addr_late ? gemm_conf_read_ppl : is_uart_addr?uart_rd_data:mem_read_data;
  assign en_gemm_conf = system_bus_en && is_gemm_addr;
  assign en_Dmem = system_bus_en && (~is_gemm_addr) && (~is_uart_addr);
  memory #(
      .NUM_RAMS(16),
      .A_WID(11),
      .D_WID(8)
  ) memory_instance (
      .clk(clk),
      .system_bus_en(en_Dmem),
      .system_bus_mask(system_bus_mask),
      .system_bus_rdwr(system_bus_rdwr),
      .system_bus_rd_data(mem_read_data),
      .system_bus_wr_data(system_bus_wr_data),
      .system_bus_addr({system_bus_addr[31:2], 2'd0}),
      .interface_rdwr(interface_rdwr),
      .interface_en(interface_en),
      .interface_control(interface_control),
      .interface_addr(interface_addr),
      .interface_wr_data(interface_wr_data),
      .interface_rd_data(interface_rd_data)
  );

  gemm gemm_instance (
      .clk(clk),
      .rst(rst),
      .system_bus_en(en_gemm_conf),
      .system_bus_rdwr(system_bus_rdwr),
      .system_bus_rd_data(gemm_conf_read),
      .system_bus_wr_data(system_bus_wr_data),
      .system_bus_addr({system_bus_addr[31:2], 2'd0}),
      .interface_control(interface_control),
      .interface_rdwr(interface_rdwr),
      .interface_en(interface_en),
      .interface_addr(interface_addr),
      .interface_rd_data(interface_rd_data),
      .interface_wr_data(interface_wr_data)
  );

    logic rst_n;
    wire type_dbus2peri_s dbus2uart_i;
    wire type_peri2dbus_s uart2dbus_o;
    logic uart_sel_i;
     logic uart_irq_o;

    assign dbus2uart_i.addr = {system_bus_addr[31:2], 2'd0};
    assign dbus2uart_i.w_data = system_bus_wr_data;
    assign dbus2uart_i.sel_byte = 4'b0000;
    assign dbus2uart_i.w_en = system_bus_rdwr;
    assign dbus2uart_i.req = system_bus_en;
    
    assign uart_rd_data=uart2dbus_o.r_data;

    assign rst_n=~rst;
      uart uart_inst (
        .rst_n(rst_n),                     // Connect to reset signal
        .clk(clk),                         // Connect to clock signal
        .dbus2uart_i(dbus2uart_i),         // Connect to Dbus to UART interface
        .uart2dbus_o(uart2dbus_o),         // Connect to UART to Dbus interface
        .uart_sel_i(is_uart_addr),           // Connect to UART selection signal
        .uart_irq_o(),           // Connect to UART interrupt signal
        .uart_rxd_i(uart_rxd_i),           // Connect to UART RX signal
        .uart_txd_o(uart_txd_o)            // Connect to UART TX signal
    );

endmodule
