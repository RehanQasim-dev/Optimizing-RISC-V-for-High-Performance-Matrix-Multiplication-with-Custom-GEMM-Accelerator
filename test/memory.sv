module memory #(
    parameter NUM_RAMS = 2,
    parameter A_WID = 10,
    parameter D_WID = 32
)
(
    input clka,
    input clkb,
    input [NUM_RAMS-1:0] wea,
    input [NUM_RAMS-1:0] web,
    input [NUM_RAMS-1:0] ena,
    input [NUM_RAMS-1:0] enb,
    input [A_WID-1:0] addra [NUM_RAMS-1:0],
    input [A_WID-1:0] addrb [NUM_RAMS-1:0],
    input [D_WID-1:0] dina [NUM_RAMS-1:0],
    input [D_WID-1:0] dinb [NUM_RAMS-1:0],
    output logic [D_WID-1:0] douta [NUM_RAMS-1:0],
    output logic [D_WID-1:0] doutb [NUM_RAMS-1:0]
);

genvar i;
generate
for (i = 0; i < NUM_RAMS; i = i + 1) begin: ram_instances
    block #(
        .memory_name($sformat("memory_%0d.mem","%d",i)),  // File name for each bank's memory
        .A_WID(A_WID),
        .D_WID(D_WID)
    ) bank_inst (
        .clk(clka),
        .wea(wea[i]),
        .web(web[i]),
        .ena(ena[i]),
        .enb(enb[i]),
        .addra(addra[i]),
        .addrb(addrb[i]),
        .dina(dina[i]),
        .dinb(dinb[i]),
        .douta(douta[i]),
        .doutb(doutb[i])
    );
end
endgenerate

endmodule
