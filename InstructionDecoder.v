`include "IDConstants.vh"

module InstructionDecoder(
	input [31:0] instr_in,
	input [2:0] type,
	input [2:0] T_in,
	input [2:0] funct3,
	input [6:0] opcode,
	input [4:0] rs1, rs2, rd,
	
	input carry, zero, lt,
	
	output pc_oe, pc_we, pc_inc, pc_oe2,
	output ir_we, mar_we, mar_oe,
	output rs1_en, rs2_en, rd_we,
	output mem_rw, se_en, se_oe,
	output imm_ena, imm_enb, imm_enc,
	output funct3_ov, mdb_en, alu_oe,
	output [3:0] funct3_val,
	output [1:0] mem_size,
	output T_rst, branch_taken,
	output hlt,
	input clk
);

reg [31:0] control_word = 0;

BranchTester bt(
	.carry(carry),
	.zero(zero),
	.lt(lt),
	.funct3(funct3),
	
	.taken(branch_taken)
);


always@ (*)
begin
	case (T_in)
	3'b000: // fetch
		control_word <= `MPC_OE2 | `MMEM_SIZE(3) | `MIR_WE | `MPC_INC;
	3'b001:
	begin
		if (type == 0) control_word <= `MHLT | `MT_RST;
		else if (type == 7) control_word <= `MT_RST;
		else case (opcode[6:2])
		5'b01100: // ALU
			control_word <= `MRS1_EN | `MRS2_EN | `MALU_OE | `MRD_WE | `MT_RST;
		5'b00100: // ALUI
			control_word <= `MRS1_EN | `MIMM_ENB | `MALU_OE | `MRD_WE | `MT_RST;
		5'b01101: // LUI
			control_word <= `MIMM_ENC | `MRD_WE | `MT_RST;
		5'b01000: // STORE
			control_word <= `MIMM_ENB | `MRS1_EN | `MALU_OE | `MF3_OV | `MF3_VAL(4'b0000) | `MMAR_WE;
		5'b00000: // LOAD
			control_word <= `MIMM_ENB | `MRS1_EN | `MALU_OE | `MF3_OV | `MF3_VAL(4'b0000) | `MMAR_WE;
		5'b11011: // JAL
			if (rd == 5'b0)
				control_word <= `MIMM_ENB | `MALU_OE | `MPC_OE | `MPC_WE | `MF3_OV | `MF3_VAL(4'b0000) | `MT_RST;
			else control_word <= `MPC_OE | `MRD_WE | `MALU_OE | `MF3_OV | `MF3_VAL(4'b0000) | `MRS2_EN;
		5'b11001: // JALR
			control_word <= `MPC_OE | `MRD_WE | `MALU_OE | `MRS2_EN;
		5'b00101: // AUIPC
			control_word <= `MPC_OE | `MIMM_ENB | `MRD_WE;
		5'b11000: // BRANCH
			control_word <= `MF3_VAL(4'b1000) | `MF3_OV | `MRS1_EN | `MRS2_EN | `MALU_OE;
		endcase
	end
	3'b010:
		case (opcode[6:2])
		5'b01000: // STORE
			control_word <= `MMAR_OE | `MMEM_RW | `MRS2_EN | `MMDB_EN | `MMEM_SIZE(funct3[1:0] + 1) | `MT_RST;
		5'b00000: // LOAD
			control_word <= `MMAR_OE | `MRD_WE | `MSE_OE | (funct3[2] ? 0 : `MSE_EN) | `MMEM_SIZE(funct3[1:0] + 1) | `MT_RST;
		5'b11011: // JAL
			control_word <= `MIMM_ENB | `MALU_OE | `MPC_OE | `MPC_WE | `MF3_OV | `MF3_VAL(4'b0000) | `MT_RST;
		5'b11001: // JALR
			control_word <= `MIMM_ENB | `MRS1_EN | `MALU_OE | `MPC_WE | `MT_RST;
		5'b11000: // BRANCH
			control_word <= `MPC_WE | `MPC_OE | `MIMM_ENB | `MALU_OE | `MF3_OV | `MF3_VAL(4'b0000) | `MT_RST;
		endcase
	endcase
end

assign pc_oe		= control_word[`PPC_OE];
assign pc_we		= control_word[`PPC_WE];
assign pc_inc		= control_word[`PPC_INC];
assign pc_oe2		= control_word[`PPC_OE2];
assign ir_we		= control_word[`PIR_WE];
assign mar_we		= control_word[`PMAR_WE];
assign mar_oe		= control_word[`PMAR_OE];
assign rs1_en		= control_word[`PRS1_EN];
assign rs2_en		= control_word[`PRS2_EN];
assign rd_we		= control_word[`PRD_WE];
assign mem_rw		= control_word[`PMEM_RW];
assign se_en		= control_word[`PSE_EN];
assign imm_ena		= control_word[`PIMM_ENA];
assign imm_enb		= control_word[`PIMM_ENB];
assign imm_enc		= control_word[`PIMM_ENC];
assign funct3_ov	= control_word[`PF3_OV];
assign mdb_en		= control_word[`PMDB_EN];
assign alu_oe		= control_word[`PALU_OE];
assign se_oe		= control_word[`PSE_OE];
assign funct3_val	= control_word[`PF3_VAL];
assign mem_size	= control_word[`PMEM_SIZE];
assign hlt			= control_word[`PHLT];
assign T_rst		= control_word[`PT_RST];

endmodule
