module inst_mem (
    input  logic [31:0] pc,
    output logic [31:0] inst_out
);
  logic [31:0] inst_ruction[2047:0];
  logic [31:0] address;
  assign address = pc;
  initial begin
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/ICACHE.mem", inst_ruction);
  end

  assign inst_out = inst_ruction[address[31:2]];

endmodule

