module Memory_test (
    input logic clk,
    rst,
    input logic interface_rdwr,
    input logic interface_en,
    input logic [31:0] interface_addr,
    output logic [127:0] interface_rd_data,
    input logic [127:0] interface_wr_data,
    input logic [4:0] interface_control
);

  logic [7:0] mem[2000];
  initial begin
    $readmemh("memory.mem", mem);
  end

  logic [16:1] mask;  // 16-bit output mask
  // Generate the mask
  always_comb begin
    mask = 0;  // Initialize all bits to 0
    for (int i = 1; i <= 16; i++) begin
      // Set the bit to 1 if it's position is greater than the input value
      if (i <= interface_control) begin
        mask[i] = 1'b1;
      end
    end
  end
  genvar i;
  for (i = 0; i < 16; i++) begin
    assign interface_rd_data[i*8+7:i*8] = mask[i+1] ? mem[interface_addr+i] : 8'b0;
  end
  logic [7:0] hello, hello1, hello2, hello3;
  assign hello  = mem[interface_addr];
  assign hello1 = mem[interface_addr+1];

  assign hello2 = mem[interface_addr+2];
  assign hello3 = mem[interface_addr+3];


  genvar j;
  for (j = 0; j < 16; j++) begin
    always_ff @(posedge clk) begin
      if (interface_en && interface_rdwr) begin
        mem[interface_addr+j] <= mask[j+1] ? interface_wr_data[j*8+7:j*8] : 8'b0;
      end
    end
  end
endmodule
