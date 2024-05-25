module bank #(
    parameter bank_no,
    parameter A_WID = 10,
    parameter D_WID = 8
)
(
    input clk,
    input wea,
    input web,
    input ena,
    input enb,
    input [A_WID-1:0] addra,
    input [A_WID-1:0] addrb,
    input [D_WID-1:0] dina,
    input [D_WID-1:0] dinb,
    output logic [D_WID-1:0] douta,
    output logic [D_WID-1:0] doutb
);

reg [D_WID-1:0] mem [2**A_WID-1:0];

initial begin
if (bank_no == 0)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory0.mem", mem);
else if (bank_no == 1)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory1.mem", mem);
else if (bank_no == 2)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory2.mem", mem);
else if (bank_no == 3)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory3.mem", mem);
else if (bank_no == 4)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory4.mem", mem);
else if (bank_no == 5)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory5.mem", mem);
else if (bank_no == 6)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory6.mem", mem);
else if (bank_no == 7)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory7.mem", mem);
else if (bank_no == 8)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory8.mem", mem);
else if (bank_no == 9)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory9.mem", mem);
else if (bank_no == 10)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory10.mem", mem);
else if (bank_no == 11)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory11.mem", mem);
else if (bank_no == 12)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory12.mem", mem);
else if (bank_no == 13)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory13.mem", mem);
else if (bank_no == 14)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory14.mem", mem);
else if (bank_no == 15)
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory15.mem", mem);
else  
    $readmemh("/home/abdul_waheed/Music/rv32_for_fyp/Script/build/memory16.mem", mem);

    
end

// PORT_A
always @ (posedge clk) begin
    if (ena) begin
        if (wea) begin
            mem[addra] <= dina;
        end
        douta <= mem[addra];
    end
end

// PORT_B
always @ (posedge clk) begin
    if (enb) begin
        if (web) begin
            mem[addrb] <= dinb;
        end
        doutb <= mem[addrb];
    end
end

endmodule

