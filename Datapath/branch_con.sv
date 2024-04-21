module branch_con (input logic [31:0] operand_a, operand_b, input logic [2:0] BRA_con, output logic branch_tk);

        logic [32:0] compare_result; // gets result of compare
        logic  compare_not_zero;     // sets the flag of not zero
        logic compare_negative;      // sets the flag of negative
        logic compare_overflow;      // sets the flag of overflow


        assign compare_result = {1'b0, operand_a} - {1'b0 , operand_b};
        assign compare_not_zero= | compare_result[31:0];
        assign compare_negative = compare_result[31];
        assign compare_overflow = (compare_negative & ~operand_a[31] & operand_b[31])|(~compare_negative & operand_a[31] & ~operand_b[31]);

        always_comb begin : branch_taken_segment
                case (BRA_con)
                    3'b000 : branch_tk = 0;
                    3'b001 : branch_tk =~compare_not_zero; // branch equal to 
                    3'b010 : branch_tk = compare_not_zero;  // branch not equal to 
                    3'b011 : branch_tk = (compare_negative ^ compare_overflow); // branch less than 
                    3'b100 : branch_tk = compare_result[32]; // branch less than unsigned
                    3'b101 : branch_tk = ~(compare_negative ^ compare_overflow); // branch greater than 
                    3'b110 : branch_tk = ~compare_result[32]; // branch greater than unsigned
                    default: begin
                        branch_tk = 0;
                    end
                endcase
        end


endmodule
