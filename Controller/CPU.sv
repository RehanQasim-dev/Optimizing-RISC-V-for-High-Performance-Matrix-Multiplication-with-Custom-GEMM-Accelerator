module CPU (input logic [31:0] instruction, output logic [3:0] ALU_CON , output logic reg_wr , mem_read, mem_write, alu_mux_1, alu_mux_2, pc_jump_mux, output logic[1:0] wr_bck_mux, output logic [2:0] sign_extend, func3_to_mem, branch_type, output logic csr_reg_rd, csr_reg_wr,csr_return );
	logic [6:0] opcode ;
	logic [2:0]func3 ;
	logic [6:0] func7;
	
	always_comb begin 
		reg_wr=0;
		ALU_CON=0;
		sign_extend=0;
		alu_mux_1 =1'b0;
		alu_mux_2=1'b0; 
		branch_type =3'b000;
		wr_bck_mux = '0;
		mem_read='0;
		mem_write='0;
		func3_to_mem='0;
		pc_jump_mux='0;
		csr_reg_rd=1'b0;
		csr_reg_wr=1'b0;
		csr_return =1'b0;
		// m_con='0;
		// alu_mul_sel=1'b0;
		
		case (opcode)
		7'b0110011 : begin  //R-type intructions
				case (func7)
				7'b0000000 : begin 
						// alu_mul_sel=1'b0;m_con='0;
						case (func3)
						3'b000 :begin  ALU_CON = 0000 ;reg_wr=1;alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00; end // add
						3'b001 :begin  ALU_CON = 0010	; reg_wr=1;alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00; end // sll
						3'b010 :begin  ALU_CON = 0011 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end	// slt
						3'b011 :begin  ALU_CON = 0100 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end	//sltu
						3'b100 :begin  ALU_CON = 0101 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end	//xor
						3'b101 :begin  ALU_CON = 0110 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end	//srl
						3'b110 :begin  ALU_CON = 1000 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end	//or
						3'b111 :begin  ALU_CON = 1001 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end	//and
						default begin ALU_CON = 4'b???? ; reg_wr=0;alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00; end 
						endcase 
						end
				7'b0100000 : begin 
					// alu_mul_sel=1'b0;m_con='0;
						case (func3)		
						3'b000 :begin  ALU_CON = 0001 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end//sub
						3'b101 :begin  ALU_CON = 0111 ; reg_wr=1; alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00;end//sra
						default begin ALU_CON = 4'b???? ; reg_wr=0;alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00; end 
						endcase 
						end 
				7'b000_0001 : begin  // m extension
						case (func3)
						3'b000 : begin reg_wr=1;ALU_CON=4'b1011;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; wr_bck_mux = '0;pc_jump_mux='0;  end
						3'b001 : begin reg_wr=1;ALU_CON=4'b1100;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; wr_bck_mux = '0;pc_jump_mux='0;  end
						3'b010 : begin reg_wr=1;ALU_CON=4'b1101;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; wr_bck_mux = '0;pc_jump_mux='0;  end
						3'b011 : begin reg_wr=1;ALU_CON=4'b1110;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; wr_bck_mux = '0;pc_jump_mux='0;  end
						
						// 3'b100 : begin reg_wr=1;ALU_CON=0;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; branch_type =3'b000;wr_bck_mux = '0;pc_jump_mux='0;  end
						// 3'b101 : begin reg_wr=1;ALU_CON=0;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; branch_type =3'b000;wr_bck_mux = '0;pc_jump_mux='0;  end
						// 3'b110 : begin reg_wr=1;ALU_CON=0;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; branch_type =3'b000;wr_bck_mux = '0;pc_jump_mux='0;  end
						// 3'b111 : begin reg_wr=1;ALU_CON=0;sign_extend=0;alu_mux_1 =1'b0;alu_mux_2=1'b0; branch_type =3'b000;wr_bck_mux = '0;pc_jump_mux='0;  end
						endcase
				end
				endcase
				end 
		7'b0110111 : begin // LUI-instruction .. changed : see ALU
			ALU_CON=4'b1010; sign_extend =3'b101; alu_mux_1=1'b0; alu_mux_2=1'b1;reg_wr = 1'b1; wr_bck_mux =1'b00;	
			// alu_mul_sel=1'b0;	m_con='0;
			end

		7'b0010111 : begin //AUIPC instruction
			ALU_CON=4'b0000; sign_extend =3'b101; alu_mux_1=1'b1; alu_mux_2=1'b1;reg_wr = 1'b1; wr_bck_mux =1'b00;
			// alu_mul_sel=1'b0;m_con='0;	
			end
		7'b1101111 : begin //JAL-instruction
			ALU_CON = 4'b0000; pc_jump_mux=1'b1; reg_wr=1'b1; sign_extend =3'b110; alu_mux_1=1'b1;alu_mux_2=1'b1; wr_bck_mux=2'b10;
			// alu_mul_sel=1'b0;m_con='0;	
			end
		
		7'b1100111 : begin //JALR-instruction
				case(func3)
				3'b000 :  begin //JALR func 3
			ALU_CON = 4'b0000; pc_jump_mux=1'b1; reg_wr=1'b1; sign_extend =3'b010; alu_mux_1=1'b0;alu_mux_2=1'b1; wr_bck_mux=2'b10;
			// alu_mul_sel=1'b0;m_con='0;	
			end
				endcase
				end
		
		7'b1100011 : begin //B-type instructions
				// alu_mul_sel=1'b0;m_con='0;
				case (func3)
				3'b000 : begin  //BEQ-instruction
						alu_mux_1 =1'b1; alu_mux_2=1'b1; ALU_CON = 0000; sign_extend = 3'b100; branch_type =3'b001;
						end
				3'b001 :begin // BNE-instruction
					alu_mux_1 =1'b1; alu_mux_2=1'b1; ALU_CON = 0000; sign_extend = 3'b100; branch_type =3'b010;
						end
				3'b100 : begin // BLT-insturction
					alu_mux_1 =1'b1; alu_mux_2=1'b1; ALU_CON = 0000; sign_extend = 3'b100; branch_type =3'b011;
						end
				3'b101 : begin //BGE-instruction
					alu_mux_1 =1'b1; alu_mux_2=1'b1; ALU_CON = 0000; sign_extend = 3'b100; branch_type =3'b101;
						end
				3'b110 : begin // BLTU-instruction 
				alu_mux_1 =1'b1; alu_mux_2=1'b1; ALU_CON = 4'b0000; sign_extend = 3'b100; branch_type = 3'b100;
						end
					
				3'b111 : begin //BGEU-instruction
					alu_mux_1 =1'b1; alu_mux_2=1'b1; ALU_CON = 0000; sign_extend = 3'b100; branch_type =3'b110;
						end 
				endcase
				end
		
		7'b0000011 : begin //load-type-instruction
				// alu_mul_sel=1'b0;m_con='0;
				case (func3)
				3'b000 : begin // LB-instruction
					reg_wr=1'b1; sign_extend=3'b010;ALU_CON = 0000 ;wr_bck_mux=2'b01;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b1; mem_write=1'b0; func3_to_mem=func3;
						end
				3'b001 : begin //LH-instruction
					reg_wr=1'b1; sign_extend=3'b010;ALU_CON = 0000 ;wr_bck_mux=2'b01;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b1; mem_write=1'b0; func3_to_mem=func3;
						end
				3'b010 : begin //LW-intruction
					reg_wr=1'b1; sign_extend=3'b010;ALU_CON = 0000 ;wr_bck_mux=2'b01;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b1; mem_write=1'b0; func3_to_mem=func3;
						end
				3'b100 : begin //LBU-instruction
					reg_wr=1'b1; sign_extend=3'b010;ALU_CON = 0000 ;wr_bck_mux=2'b01;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b1; mem_write=1'b0; func3_to_mem=func3;
						end
				3'b101 : begin //LHU-intrcution 
					reg_wr=1'b1; sign_extend=3'b010;ALU_CON = 0000 ;wr_bck_mux=2'b01;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b1; mem_write=1'b0; func3_to_mem=func3;
						end
				endcase
				end
		7'b0100011 : begin //store-type-instuction
				// alu_mul_sel=1'b0;m_con='0;
				case (func3)
				3'b000 : begin // SB-instruction  
					reg_wr=1'b0; sign_extend=3'b011; ALU_CON = 0000 ;wr_bck_mux=2'b00;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b0; mem_write=1'b1; func3_to_mem=func3;
						end
				3'b001 : begin // SH-instruction
					reg_wr=1'b0; sign_extend=3'b011; ALU_CON = 0000 ;wr_bck_mux=2'b00;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b0; mem_write=1'b1; func3_to_mem=func3;
						end
				3'b010 : begin //SW-instruction
					reg_wr=1'b0; sign_extend=3'b011; ALU_CON = 0000 ;wr_bck_mux=2'b00;alu_mux_1=1'b0; alu_mux_2=1'b1; mem_read=1'b0; mem_write=1'b1; func3_to_mem=func3;
						end
				endcase
				end

		7'b0010011 : begin //I-type
				// alu_mul_sel=1'b0;m_con='0;
				case(func3)
				3'b000 : begin //ADDI-intruction
					ALU_CON = 0000 ;reg_wr=1;sign_extend=3'b010; wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
							end
				3'b010 : begin //SLTI-instruction
						ALU_CON = 4'b0011 ;reg_wr=1;sign_extend=3'b010;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
						end
				3'b011 : begin // SLTIU-instruction 
						ALU_CON = 4'b0100 ;reg_wr=1;sign_extend=3'b001;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
						end
				3'b100 : begin //XORI-instruction
						ALU_CON = 4'b0101 ;reg_wr=1;sign_extend=3'b010;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
						end
				3'b110 : begin //ORI-instruction
						ALU_CON = 4'b1000 ;reg_wr=1;sign_extend=3'b010;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
						end
				3'b111 : begin //ANDI-instruction 
						ALU_CON = 4'b1001 ;reg_wr=1;sign_extend=3'b010;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
						end
				3'b001 : begin //SLLI-instruction 
						if (func7 == 7'b0000000) begin 
								 ALU_CON = 4'b0010	; reg_wr=1;sign_extend=3'b001;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
										end
						end
				3'b101 : begin //SRLI-instruction 
							case (func7)
							7'b0000000 :  begin //SRLI-instruction 
								 ALU_CON = 4'b0110	; reg_wr=1;sign_extend=3'b001;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
									end 
							7'b0100000 : begin //SRAI-instruction
								 ALU_CON = 4'b0111	; reg_wr=1;sign_extend=3'b001;wr_bck_mux=2'b00; alu_mux_1=1'b0; alu_mux_2 =1'b1;
									end 
									endcase 
						end
				endcase
				

				end

		7'b1110011 : begin  // csr read write operation
					// alu_mul_sel=1'b0;m_con='0;
						case (func3)
						3'b001: begin 	ALU_CON = 0000 ;reg_wr=1;alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b11; csr_reg_rd=1'b1; csr_reg_wr=1'b1; csr_return=1'b0; sign_extend =3'b001; end // csr read write 
						3'b000: begin 	ALU_CON = 0000 ;reg_wr=0;alu_mux_1 =1'b0; alu_mux_2=1'b0;wr_bck_mux=2'b00; csr_reg_rd=1'b0; csr_reg_wr=1'b0; csr_return=1'b1; sign_extend =3'b001; end // mret
						
						endcase
		end

		




		
				default begin 
							reg_wr=0;
							ALU_CON=0;
							sign_extend=0;
							alu_mux_1 =1'b0;
							alu_mux_2=1'b0; 
							branch_type =3'b000;
							wr_bck_mux = '0;
							mem_read='0;
							mem_write='0;
							func3_to_mem='0;
							pc_jump_mux='0;
							csr_reg_rd=1'b0;
							csr_reg_wr=1'b0;
							csr_return =1'b0;
							// alu_mul_sel=1'b0;
							// m_con='0;
							end
		endcase 
		end
	
	assign opcode = instruction [6:0];
	assign func3 =instruction[14:12] ;
	assign func7 = instruction[31:25];

endmodule
					
						
		