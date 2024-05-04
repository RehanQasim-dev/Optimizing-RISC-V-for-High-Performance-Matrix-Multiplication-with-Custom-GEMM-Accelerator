module block #(
    parameter memory_name=" ",
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
    $readmemh(memory_name, mem);
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

