// 3-D Ram Inference Example (True Dual port)
// File:rams_tdp_3d.sv
module memory #(
    parameter NUM_RAMS = 16,
    A_WID = 4,
    D_WID = 8
) (
    input logic clk,
    //portA
    system_bus_en,
    system_bus_rdwr,
    input logic [3:0]system_bus_mask,
    output logic [3:0][D_WID-1:0]system_bus_rd_data,
    input logic [3:0][D_WID-1:0] system_bus_wr_data,
    [31:0] system_bus_addr,
    //portB
    input logic interface_rdwr,
    input logic interface_en,
    input logic [4:0] interface_control,
    input logic [31:0] interface_addr,
    input logic [NUM_RAMS-1:0][D_WID-1:0] interface_wr_data,
    output logic [NUM_RAMS-1:0][D_WID-1:0] interface_rd_data
);


  logic [15:0] mask,mask_ppl;  // 16-bit output mask
  //portA
  logic [D_WID-1:0] bank_dina[NUM_RAMS-1:0];
  logic [D_WID-1:0] bank_douta[NUM_RAMS-1:0];
  logic [A_WID-1:0] bank_addra[NUM_RAMS-1:0];
  logic [15:0]bank_ena;
  logic [15:0] bank_wea;
  //PortB
  logic [D_WID-1:0] bank_doutb[NUM_RAMS-1:0];
  logic [A_WID-1:0] bank_addrb[NUM_RAMS-1:0];
  logic [D_WID-1:0] bank_dinb[NUM_RAMS-1:0],bank_dinb_ [NUM_RAMS-1:0];
  logic [15:0]bank_enb,bank_enb_;
  logic [15:0] bank_web,bank_web_;

  logic [3:0] interface_addr_ppl,system_bus_addr_ppl;
    always_ff @(posedge clk) begin
     system_bus_addr_ppl<= system_bus_addr[3:0];
    interface_addr_ppl<= interface_addr[3:0];
    mask_ppl<=mask;
  end
genvar i;
    for (i = 0; i < NUM_RAMS; i++) begin
           assign bank_wea[i] = interface_rdwr && mask[(16+i-interface_addr[3:0])%16];
           assign bank_ena[i] = interface_en;
           assign bank_dina[i]  = interface_wr_data[(16+i-interface_addr[3:0])%16];
           assign bank_addra[i] = {4'b0,interface_addr[31:4]} + (i < interface_addr[3:0]);
    end
    for (i = 0; i < NUM_RAMS; i++) begin
          assign interface_rd_data[i] = mask_ppl[i]?bank_douta[(i+interface_addr_ppl)%16]:8'd0;
    end

    ////////////

  for (i = 0; i<16 ;i++ ) begin
  if (i<4)begin
      assign bank_dinb_[i]=system_bus_wr_data[i];
      assign bank_enb_[i]=system_bus_en;
      assign bank_web_[i]=system_bus_rdwr && system_bus_mask[i] ;
      end
  else begin
      assign bank_dinb_[i]=interface_wr_data[i];
      assign bank_enb_[i]=1'b0;
      assign bank_web_[i]=1'b0;
  end
  end
    for (i = 0; i < NUM_RAMS; i++) begin
           assign bank_web[i] = bank_web_[(16+i-system_bus_addr[3:0])%16];
           assign bank_enb[i] = bank_enb_[(16+i-system_bus_addr[3:0])%16];
           assign bank_dinb[i]  = bank_dinb_[(16+i-system_bus_addr[3:0])%16];
          assign bank_addrb[i] = {4'b0,system_bus_addr[31:4]} + (i < system_bus_addr[3:0]);
    end
    for (i = 0; i < 4; i++) begin
          assign system_bus_rd_data[i] = bank_doutb[(i+system_bus_addr_ppl)%16];
    end
    always_comb begin
    mask = 0;  // Initialize all bits to 0
    for (int i = 1; i <= 16; i++) begin
      // Set the bit to 1 if it's position is greater than the input value
      if (i <= interface_control) begin
        mask[i-1] = 1'b1;
      end
    end
  end
  reg [D_WID-1:0] meam[NUM_RAMS-1:0][2**A_WID-1:0];

  // logic [D_WID-1:0] mem[2**A_WID-1:0][NUM_RAMS-1:0];
  initial begin
  // Open the file for reading
  integer file;
  logic [7:0] mem_value;
  file = $fopen("DCACHE.data", "r");
  
  // Check if file opened successfully
  if (file == 0) begin
      $display("Error opening file");
      $finish;
  end
  $fscanf(file, "%h", mem_value);
  meam[0][0]  = mem_value;
  $display("%h",mem_value);
  // Loop through each line in the file
//  for (int i = 0; i < 1;i++) begin
//      for (int j = 0; NUM_RAMS; j++) begin
//          // Read the line from the file
//          $fscanf(file, "%h", mem_value);
//          //isplay("%h",mem_value);
//          // Assign the value to the memory array
//          meam[j][i] = mem_value;
//      end
//  end
  
  // Close the file
  $fclose(file);
//    $readmemb("DCACHE.data",meam);
//meam[0][0]=8'd1;
//meam[1][0]=8'd2;
//meam[2][0]=8'd3;
//meam[3][0]=8'd4;
//meam[4][0]=8'd5;
//meam[5][0]=8'd6;
//meam[6][0]=8'd7;
//meam[7][0]=8'd8;
//meam[8][0]=8'd9;
//meam[9][0]=8'd7;
//meam[10][0]=8'd11;
//meam[11][0]=8'd12;



  end
  // PORT_A
  generate
    for (i = 0; i < NUM_RAMS; i = i + 1) begin : port_a_ops
      always @(posedge clk) begin
        if (bank_ena[i]) begin
          if (bank_wea[i]) begin
            meam[i] [bank_addra[i]]<= bank_dina[i];
            // mem [bank_addra[i]][i] <= bank_dina[i];
          end
          bank_douta[i] <= meam[i][bank_addra[i]];
          // bank_douta[i] <= mem[bank_addra[i]][i];
        end
      end
    end
  endgenerate

  
  // //PORT_B
   generate
    for (i = 0; i < NUM_RAMS; i = i + 1) begin: port_b_ops
      always @(posedge clk) begin
        if (bank_enb[i]) begin
          if (bank_web[i]) begin
            meam[i][bank_addrb[i]] <= bank_dinb[i];
            // mem[bank_addrb[i]][i] <= bank_dinb[i];
          end
          bank_doutb[i] <= meam[i][bank_addrb[i]];
          // bank_doutb[i] <= mem[bank_addrb[i]][i];
        end
      end
    end
  endgenerate

endmodule
