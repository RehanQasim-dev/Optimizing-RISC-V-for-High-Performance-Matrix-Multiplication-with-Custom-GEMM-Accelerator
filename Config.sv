package Config;
  parameter int SCRATCHPAD_DEPTH = 2 ** 7;

  parameter int BIAS = 0;
  parameter A_BITWIDTH = 8;
  parameter W_BITWIDTH = 8;
  parameter P_BITWIDTH = 24;
  //systolic array configuration
  parameter SMALL_SYS_ROWS = 8;
  parameter SMALL_SYS_COLS = 8;
  parameter CORE_ROWS = 2;
  parameter CORE_COLS = 2;
  parameter int SUPER_SYS_ROWS = CORE_ROWS * SMALL_SYS_ROWS;
  parameter int SUPER_SYS_COLS = SMALL_SYS_COLS * CORE_COLS;
  typedef struct packed {
    logic en, rdwr;
    logic [3:0] mask;
    logic [3:0][7:0] rd_data;
    logic [3:0][7:0] wr_data;
    logic [31:0] addr;
  } dbus_interface;
endpackage : Config
