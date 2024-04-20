module main (input logic clk, reset);
	logic 	[31:0]  pc_to_flip, pc_to_inst_mem,pc_to_flip_mux, pc_from_alu,pc_for_jump;
	logic 	[31:0] inst_out,rs1_alu_a,rs2_alu_b,write_back_data_to_reg_file;
	logic 	[3:0] alu_con;
	logic 	reg_wr,BR_taken;
	logic [4:0] rs1 ;
	logic [4:0] rs2 ;
	logic [4:0] rd ;
	logic [31:0] alu_result;
	logic [31:0] alu_A, alu_B,imm_to_alu_mux_2, load_data;
	logic mem_read, mem_write, alu_mux_1, alu_mux_2, pc_jump_mux;
	logic[1:0] wr_bck_mux;
	logic [2:0]  sign_extend, func3_to_mem, branch_type ;
	logic sel_for_branch;
	assign sel_for_branch =(pc_jump_mux | BR_taken);
	assign pc_from_alu = alu_result;
	mux_2x1 PC_MUX (pc_to_flip_mux,pc_from_alu, sel_for_branch, pc_to_flip);
	mux_2x1 ALU_MUX_1(rs1_alu_a,pc_to_inst_mem, alu_mux_1, alu_A);
	mux_2x1 ALU_MUX_2(rs2_alu_b, imm_to_alu_mux_2, alu_mux_2 , alu_B);
	mux_4x1 WRITE_BACK_MUX (alu_result, load_data, pc_for_jump, 32'b0, wr_bck_mux, write_back_data_to_reg_file);

	adder JUMP_ADDER (pc_to_inst_mem,pc_for_jump);
	adder PC_ADDER (pc_to_inst_mem,pc_to_flip_mux);

	PC_flip flip_flop_pc (clk, reset,pc_to_flip, pc_to_inst_mem);
	inst_mem instruction_memory (pc_to_inst_mem,  inst_out);
	extend IMMEDIATE_CREATE (sign_extend, inst_out,imm_to_alu_mux_2);
	branch_con COMPARATOR (rs1_alu_a,rs2_alu_b,branch_type,BR_taken);
	main_mem LOAD_STORE (clk, alu_result, rs2_alu_b,mem_write,mem_read, func3_to_mem, load_data );
	CPU control_unit (inst_out , alu_con, reg_wr,mem_read, mem_write, alu_mux_1, alu_mux_2, pc_jump_mux, wr_bck_mux, sign_extend, func3_to_mem, branch_type ); //CPU (input logic [31:0] instruction, output logic [3:0] ALU_CON , output logic reg_wr , mem_read, mem_write, alu_mux_1, alu_mux_2, pc_jump_mux, output logic[1:0] wr_bck_mux, output logic [2:0] sign_extend, func3_to_mem, branch_type );
	reg_file register_file(clk, reset, reg_wr,rd,rs1,rs2,write_back_data_to_reg_file,rs1_alu_a,rs2_alu_b);
	ALU calculator (alu_A,alu_B,alu_con, alu_result);

    assign rs2 = inst_out [24:20];
	assign rs1 = inst_out [19:15];
	assign rd = inst_out [11:7];

endmodule
