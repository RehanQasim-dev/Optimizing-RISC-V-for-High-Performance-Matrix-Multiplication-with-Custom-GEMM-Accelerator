module extend (input logic [2:0] ALU_ex_con, input logic [31:0] instruction, output logic [31:0] immediate_to_alu);

    logic [11:0] imm_I ;
    logic [12:0] imm_B;
    logic [11:0] imm_S;
    logic [20:0] imm_U;
    logic [20:0] imm_J;

    assign imm_I = {  instruction[31:20]  };
    assign imm_S = {{instruction[31:25]},{instruction[11:7]}};
    assign imm_U = {instruction[31:12]};
    
    // this is the code for assigning the bits for B type 
    assign imm_B = {{instruction[31]},{instruction[7]},{instruction[30:25]},{instruction[11:8]},1'b0};
   /* assign imm_B[11] = instruction[7]; // 1 bit
    assign imm_B[4:1] = instruction[11:8]; // 4 bits
    assign imm_B [10:5] = instruction [30:25]; // 6 bits 
    assign imm_B [12] = instruction[31]; // 1 bit
    assign imm_B [0]=0;*/
    
    assign imm_J = {{instruction[31]},{instruction [19:12]},{instruction[20]}, {instruction[30:21]},1'b0};
    /*assign imm_J[19:12]= instruction [19:12]; //8 bits 
    assign imm_J [11] = instruction[20]; // 1 bit
    assign imm_J [10:1] = instruction[30:21]; // 10 bits
    assign imm_J [20]= instruction[31];*/ // 1 bit



        always_comb begin : sign_extend
            case (ALU_ex_con)
                3'b000 : immediate_to_alu = '0;
                3'b001 : immediate_to_alu = {20'b0 , imm_I}; // no sign extend, only zero: I type 
                3'b010 : immediate_to_alu = {{20{imm_I[11]}}, imm_I}; // sign extend , I type 
                3'b011 : immediate_to_alu = {{20{imm_S[11]}}, imm_S}; //sign extend , S type 
                3'b100 : immediate_to_alu = {{19{imm_B[12]}},imm_B}; // sign extend : B type
                3'b101 : immediate_to_alu = {imm_U, {12{1'b0}}}; // sign extend : U type
                3'b110 : immediate_to_alu = { { 12{imm_J[20]}} , imm_J }; //sign extend : J Type
                default: begin
                    immediate_to_alu ='0;
                end
            endcase
        end

endmodule