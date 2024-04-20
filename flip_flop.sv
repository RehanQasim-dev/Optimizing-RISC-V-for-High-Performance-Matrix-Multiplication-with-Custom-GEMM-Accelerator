module flip_flop (input clk, reset, input logic [31:0] data_in, output logic [31:0] data_out);
    always_ff @( posedge clk ) begin : blockName
        if (reset) data_out<='0;
        else data_out<=data_in;

    end
endmodule