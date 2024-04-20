module main_pipe (input logic clk, reset);
	logic 	[31:0]  pc_to_flip, pc_to_inst_mem,pc_to_flip_mux, pc_from_alu,pc_for_jump, pc_for_jump_flip_2;
	logic 	[31:0] inst_out,rs1_alu_a,rs2_alu_b,write_back_data_to_reg_file;
	logic 	[3:0] alu_con;
	logic 	reg_wr,BR_taken, reg_wr_flip,  mem_read_flip, mem_write_flip, pc_jump_mux_flip, BR_taken_flip;
	logic [4:0] rs1 ;
	logic [4:0] rs2 ;
	logic [4:0] rd ;
	logic [31:0] alu_result,pc_to_alu_mux, alu_result_flip,rs2_alu_b_flip;
	logic [31:0] alu_A, alu_B,imm_to_alu_mux_2, load_data, inst_out_flip,inst_out_flip_2;
	logic mem_read, mem_write, alu_mux_1, alu_mux_2, pc_jump_mux;
	logic[1:0] wr_bck_mux,wr_bck_mux_flip;
	logic [2:0]  sign_extend, func3_to_mem, branch_type,func3_to_mem_flip;
	logic sel_for_branch;
	logic [31:0] forward_data_to_alu_1, data_out_to_alu_mux_1,forward_data_to_alu_2, data_out_to_alu_mux_2,inst_out_to_flip_muxed;
	logic forward_sel_1,forward_sel_2, flush_sel, stall_sel;
	logic [31:0] stall_instruction_for_pc, flush_opcode,pc_to_inst_mem_through_stall_n_flush,pc_to_alu_mux_muxed,inst_out_to_rd_flip_muxed;
	logic [31:0] alu_result_flip_muxed,inst_out_to_rd_flip_muxed_stalled,alu_result_flip_muxed_stalled,data_out_to_alu_mux_2_muxed_stalled,data_out_to_alu_mux_2_muxed,inst_out_to_flip_muxed_stalled;


	assign stall_instruction_for_pc = pc_to_inst_mem;
	assign flush_opcode = 32'h00000013;
	assign sel_for_branch =(pc_jump_mux | BR_taken);
	assign pc_from_alu = alu_result;
	assign forward_data_to_alu_1 = alu_result_flip;
	assign forward_data_to_alu_2 = alu_result_flip;
	assign inst_out_to_flip_muxed_stalled = inst_out_flip;
	assign alu_result_flip_muxed_stalled = alu_result_flip;
	assign data_out_to_alu_mux_2_muxed_stalled = rs2_alu_b_flip;
	assign inst_out_to_rd_flip_muxed_stalled = inst_out_flip_2;

	mux_2x1 PC_MUX (pc_to_flip_mux,pc_from_alu, sel_for_branch, pc_to_flip);
	mux_2x1 ALU_MUX_1(data_out_to_alu_mux_1,pc_to_alu_mux, alu_mux_1, alu_A);
	mux_2x1 ALU_MUX_2(data_out_to_alu_mux_2, imm_to_alu_mux_2, alu_mux_2 , alu_B);
	mux_4x1 WRITE_BACK_MUX (alu_result_flip, load_data, pc_for_jump_flip_2, 32'b0, wr_bck_mux_flip, write_back_data_to_reg_file);

	// forward for alu muxes
	mux_2x1 forward_mux_to_alu_mux_1 (rs1_alu_a, forward_data_to_alu_1,forward_sel_1, data_out_to_alu_mux_1);
	mux_2x1 forward_mux_to_alu_mux_2 (rs1_alu_a, forward_data_to_alu_2,forward_sel_2, data_out_to_alu_mux_2);


	// stall for instructions flips 1 
	mux_4x1 stall_and_flush_to_inst_flip (inst_out, flush_opcode, inst_out_to_flip_muxed_stalled, inst_out_to_flip_muxed_stalled, {stall_sel,flush_sel}, inst_out_to_flip_muxed);
	// stall for pc for alu and jump return
	mux_2x1 stall_for_pc_flip_to_alu_mux_and_jump_return(pc_to_inst_mem,  pc_to_inst_mem_through_stall_n_flush,  stall_sel, pc_to_inst_mem_through_stall_n_flush);
	mux_2x1 stall_for_pc_flip_2_to_write_back(pc_to_alu_mux, pc_to_alu_mux_muxed, stall_sel, pc_to_alu_mux_muxed);
	// stall for alu and write_data_to_memory, instruction flip 2 
	mux_2x1 stall_for_rd_flip (inst_out_flip, inst_out_to_rd_flip_muxed_stalled , stall_sel, inst_out_to_rd_flip_muxed);
	mux_2x1 stall_for_alu_flip(alu_result, alu_result_flip_muxed_stalled, stall_sel, alu_result_flip_muxed);
	mux_2x1 stall_for_data_memory (data_out_to_alu_mux_2, data_out_to_alu_mux_2_muxed_stalled, stall_sel, data_out_to_alu_mux_2_muxed);


	adder JUMP_ADDER (pc_for_jump,pc_for_jump_flip_2);
	adder PC_ADDER (pc_to_inst_mem,pc_to_flip_mux);
	
	flip_flop instruction_flip (clk, reset, inst_out_to_flip_muxed,inst_out_flip); // fetch stage
	flip_flop rd_flip (clk, reset, inst_out_to_rd_flip_muxed, inst_out_flip_2); // writeback stage /decode and execute stage
	flip_flop pc_to_alu_mux_flip(clk, reset, pc_to_inst_mem_through_stall_n_flush, pc_to_alu_mux); // fetch stages
	flip_flop alu_flip (clk, reset, alu_result_flip_muxed, alu_result_flip); //decode and execute stage
	flip_flop store_data_flip(clk, reset, data_out_to_alu_mux_2_muxed, rs2_alu_b_flip);//decode and execute stage
	flip_flop pc_for_jump_flip(clk, reset, pc_to_alu_mux_muxed, pc_for_jump); //decode and execute stage


	PC_flip flip_flop_pc (clk, reset,pc_to_flip, pc_to_inst_mem);//fetch stage
	inst_mem instruction_memory (pc_to_inst_mem,  inst_out); // fetch stage

	// decode and execute stage
	extend IMMEDIATE_CREATE (sign_extend, inst_out_flip,imm_to_alu_mux_2);
	branch_con COMPARATOR (data_out_to_alu_mux_1,data_out_to_alu_mux_2,branch_type,BR_taken);
	reg_file register_file(clk, reset, reg_wr_flip,rd,rs1,rs2,write_back_data_to_reg_file,rs1_alu_a,rs2_alu_b);
	ALU calculator (alu_A,alu_B,alu_con, alu_result);

	// memeory and write back stage
	main_mem LOAD_STORE (clk, alu_result_flip, rs2_alu_b_flip,mem_write_flip,mem_read_flip, func3_to_mem_flip, load_data );
	CPU control_unit (inst_out_flip , alu_con, reg_wr,mem_read, mem_write, alu_mux_1, alu_mux_2, pc_jump_mux, wr_bck_mux, sign_extend, func3_to_mem, branch_type ); //CPU (input logic [31:0] instruction, output logic [3:0] ALU_CON , output logic reg_wr , mem_read, mem_write, alu_mux_1, alu_mux_2, pc_jump_mux, output logic[1:0] wr_bck_mux, output logic [2:0] sign_extend, func3_to_mem, branch_type );

    assign rs2 = inst_out_flip [24:20];
	assign rs1 = inst_out_flip [19:15];
	assign rd = inst_out_flip_2 [11:7];
/*	// control stage
	flip_flop reg_flie_write_flip(clk, reset, reg_wr, reg_wr_flip);
	flip_flop mem_data_write_flip(clk, reset, mem_write, mem_write_flip);
	flip_flop mem_data_read_flip (clk, reset, mem_read, mem_read_flip);
	flip_flop wr_bck_mux_control_flip (clk, reset, wr_bck_mux, wr_bck_mux_flip);*/

//	csr_unit csr_and_intrupts (clk, reset,);
	flip_CU control_unit_flip(clk, reset, reg_wr, mem_write, mem_read,pc_jump_mux,BR_taken,wr_bck_mux,func3_to_mem,reg_wr_flip,mem_write_flip,mem_read_flip,pc_jump_mux_flip,BR_taken_flip,wr_bck_mux_flip,func3_to_mem_flip);
	hazard_unit hazard_detection_unit(reg_wr_flip,mem_read_flip,sel_for_branch,inst_out_flip, inst_out_flip_2,forward_sel_1, forward_sel_2, flush_sel, stall_sel);
endmodule
