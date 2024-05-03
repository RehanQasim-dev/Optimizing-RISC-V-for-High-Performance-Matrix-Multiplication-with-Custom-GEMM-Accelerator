// Module: Load_Ex_controller
// Description: Controller module for managing load and execute operations in hardware.
module Load_Ex_controller (
    input  logic        rst,                      // Reset signal
    clk,  // Clock signal
    done_store,  // Signal indicating completion of store operation
    store,  // Store operation signal
    conf_empty,  // Configuration empty signal
    ready_for_HI,  // Signal indicating readiness for high importance tasks
    input  logic [ 1:0] mode,                     // Operating mode
    input  logic [31:0] current_addr,             // Current address
    tile_B_addr,  // Tile B address
    tile_A_addr,  // Tile A address
    tile_B_stride,  // Stride for Tile B
    tile_A_stride,  // Stride for Tile A
    input  logic [ 4:0] msize,                    // Size parameter n
    ksize,  // Size parameter k
    nsize,
    output logic        can_store,                // Signal to indicate if storing is possible
    // Interface signals
    interface_rdwr,  // Interface read/write signal
    interface_en,  // Interface enable signal
    output logic [ 4:0] interface_control,        // Interface control signal
    output logic        conf_buff_read_buffered,  // Configuration buffer read signal
    // Address generate block signals
    output logic [31:0] next_addr,                // Next address to generate
    output logic        gen_addr,                 // Generate address signal
    output logic        prefetch_done_buffered,
    output logic        prefetch_start,
    output logic        use_store_addr,
    if_en_buffered,
    wfetch_buffered,
    input  logic        gen_addr_store,
    interface_en_store,
    input  logic [ 4:0] interface_control_store,
    input  logic [31:0] next_row_addr_store,
    input  logic        interface_rdwr_store,
    output logic        we_accum_ctrl

);
  // logic use_store_addr;
  logic [2:0] ns, cs;  // Next state and current state

  assign use_store_addr = cs == STORE;
  logic conf_buff_read, prefetch_done;  // Configuration buffer read signal
  logic if_en, wfetch;
  assign conf_buff_read_buffered = conf_buff_read;
  always_ff @(posedge clk) begin : blockName
    prefetch_done_buffered <= prefetch_done;
    if_en_buffered <= if_en;
    wfetch_buffered <= wfetch;
    // conf_buff_read_buffered <= conf_buff_read;
  end
  // State definitions for the finite state machine
  localparam IDLE = 3'b000;
  localparam PREFETCH = 3'b001;
  localparam COMPUTE = 3'b010;
  localparam STORE = 3'b011;
  localparam CHECK_NEXT = 3'b100;

  // Mode definitions
  localparam FW = 0;
  localparam VW = 1;
  localparam HW = 2;
  localparam IW = 3;

  // Internal signals
  logic clr_size_counter, en_size_counter, do_read_B, do_read_A;

  logic [31:0] count;

  always_ff @(posedge clk) begin
    if (clr_size_counter) count <= 0;
    else if (en_size_counter) count <= count + 1;
  end
  assign do_read_B = ksize != (count + 1);
  assign do_read_A = msize != (count + 1);
  logic test_gen;
  assign test_gen = gen_addr;
  // Combinational logic block
  always_comb begin
    // Default assignments
    gen_addr = 0;
    clr_size_counter = 0;
    en_size_counter = 0;
    interface_en = 0;
    interface_control = 'x;
    next_addr = 'x;
    interface_rdwr = 0;  // Read operation
    conf_buff_read = 0;
    prefetch_done = 0;
    if_en = 0;
    wfetch = 0;
    can_store = 0;
    prefetch_start = 0;
    we_accum_ctrl = 0;
    ns = IDLE;

    // State machine logic
    case (cs)
      IDLE:
      if (conf_empty) begin
        ns = IDLE;
      end else begin
        next_addr = tile_B_addr;
        gen_addr = 1;
        en_size_counter = 1;
        clr_size_counter = 1;
        prefetch_start = 1;
        ns = PREFETCH;
      end

      PREFETCH:
      if (do_read_B) begin
        interface_en = 1;
        interface_control = nsize;
        next_addr = current_addr - tile_B_stride;
        gen_addr = 1;
        en_size_counter = 1;
        wfetch = 1;
        ns = PREFETCH;
      end else begin
        //these are being used combinationally for the last B vector
        interface_en = 1;
        interface_control = nsize;
        // address of first row of A is to be generated next
        next_addr = tile_A_addr;
        gen_addr = 1;
        en_size_counter = 1;
        clr_size_counter = 1;
        prefetch_done = 1;
        wfetch = 1;
        we_accum_ctrl = 1;
        ns = COMPUTE;
      end

      COMPUTE:
      if (do_read_A) begin
        interface_en = 1;
        interface_control = ksize;
        next_addr = current_addr + tile_A_stride;
        gen_addr = 1;
        en_size_counter = 1;
        if_en = 1;
        ns = COMPUTE;
      end else if (~do_read_A && ~store) begin
        interface_en = 1;
        interface_control = ksize;
        if_en = 1;
        conf_buff_read = 1;
        ns = CHECK_NEXT;
      end else begin
        can_store = 1;
        interface_en = 1;
        interface_control = ksize;

        if_en = 1;

        //for first store
        gen_addr = gen_addr_store;
        next_addr = next_row_addr_store;
        ns = STORE;
      end

      STORE:
      if (done_store) begin
        conf_buff_read = 1;
        interface_en = interface_en_store;
        interface_control = interface_control_store;
        interface_rdwr = interface_rdwr_store;
        can_store = 1;
        ns = IDLE;
        // end else if (done_store & ~conf_empty) begin
        //   interface_en = interface_en_store;
        //   interface_control = interface_control_store;
        //   interface_rdwr = interface_rdwr_store;
        //   can_store = 1;
        //   next_addr = tile_B_addr;
        //   gen_addr = 1;
        //   en_size_counter = 1;
        //   clr_size_counter = 1;
        //   prefetch_start = 1;
        //   ns = PREFETCH;
      end else begin
        interface_en = interface_en_store;
        interface_control = interface_control_store;
        interface_rdwr = interface_rdwr_store;
        gen_addr = gen_addr_store;
        next_addr = next_row_addr_store;
        ns = STORE;
        can_store = 1;
      end

      CHECK_NEXT:
      if (~ready_for_HI && (mode == HW || mode == IW) && ~conf_empty) begin
        ns = CHECK_NEXT;
      end else if (ready_for_HI && (mode == HW || mode == IW) && ~conf_empty) begin

        interface_en = 0;
        interface_control = nsize;
        next_addr = tile_B_addr;
        gen_addr = 1;
        en_size_counter = 'x;
        clr_size_counter = 1;
        prefetch_start = 1;
        ns = PREFETCH;
      end else if ((mode == FW || mode == VW) && ~conf_empty) begin

        interface_control = ksize;
        next_addr = tile_B_addr;
        gen_addr = 1;
        en_size_counter = 1;
        clr_size_counter = 1;
        prefetch_start = 1;
        ns = PREFETCH;
      end else begin
        ns = IDLE;
      end
    endcase
  end

  // Sequential logic block
  always_ff @(posedge clk) begin
    if (rst) cs <= IDLE;  // Reset current state to IDLE
    else cs <= ns;  // Transition to next state
  end

endmodule

