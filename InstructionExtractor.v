module InstructionExtractor(
	input [31:0] instr,
		
	output [6:0] opcode,
	output [31:0] immed,
	output [4:0] rd, rs1, rs2,
	output [2:0] funct3,
	output       bit30,
	output [2:0] type
);

// Source: https://en.wikipedia.org/wiki/RISC-V#ISA_base_and_extensions
parameter TYPE_ILL	= 3'd0,	// illegal
			 TYPE_R		= 3'd1,	// register/register
			 TYPE_I		= 3'd2,	// immediate
			 TYPE_U		= 3'd3,	// upper immediate
			 TYPE_S		= 3'd4,	// store
			 TYPE_B		= 3'd5,	// branch
			 TYPE_J		= 3'd6,	// jump
			 TYPE_NOP	= 3'd7;	// unimplemented/ignored

function [31:0] extract_immed(input [31:0] instr, input [2:0] type);
	case (type)
	3'd2:		extract_immed = (instr[31] ? 32'hfffff000 : 0) | instr[31:20];
	3'd3: 	extract_immed = instr[31:12] << 12;
	3'd4: 	extract_immed = (instr[31] ? 32'hfffff000 : 0) | (instr[31:25] << 5) | instr[11:7];
	3'd5: 	extract_immed =((instr[31] ? 32'hfffff000 : 0) | (instr[30:25] << 5) | (instr[11:8] << 1) | (instr[7] << 11)) - 4;
	3'd6:		extract_immed =((instr[31] ? 32'hfff00000 : 0) | (instr[19:12] << 12) | (instr[20] << 11) | (instr[30:21] << 1)) - 4;
	default:	extract_immed = 32'bz;
	endcase
endfunction

function [2:0] determine_type(input [6:0] opcode);
	if (opcode[1:0] != 2'b11) determine_type = TYPE_ILL;
	else case (opcode[6:2])
	5'b11001:	determine_type = TYPE_R;	// JALR
	5'b01100:	determine_type = TYPE_R;	// ALU
		
	5'b00000:	determine_type = TYPE_I;	// LOAD
	5'b00100:	determine_type = TYPE_I;	// ALUI
		
	5'b01101:	determine_type = TYPE_U;	// LUI
	5'b00101:	determine_type = TYPE_U;	// AUIPC
		
	5'b11000:	determine_type = TYPE_B;	// BRANCH
		
	5'b01000:	determine_type = TYPE_S;	// STORE
		
	5'b11011:	determine_type = TYPE_J;	// JAL
		
	5'b00011:	determine_type = TYPE_NOP;	// FENCE
	5'b11101:	determine_type = TYPE_NOP;	// ECALL/EBREAK
		
	default:		determine_type = TYPE_ILL;
	endcase
endfunction

wire   is_shift= ((opcode & 7'b1011111) == 7'b0010011) && (funct3[1:0] == 2'b01);
assign opcode 	= 																					  instr[6:0];
assign rd		= ((type != TYPE_S) && (type != TYPE_B))								? instr[11: 7] : 5'b0;
assign funct3	= ((type != TYPE_U) && (type != TYPE_J))								? instr[14:12] : 3'b0;
assign rs1		= ((type != TYPE_U) && (type != TYPE_J))								? instr[19:15] : 5'b0;
assign rs2		= ((type == TYPE_R) || (type == TYPE_S) || (type == TYPE_B))	? instr[24:20] : 5'b0;
assign immed	=																					  extract_immed(instr, type);
assign type		=																					  determine_type(opcode);
assign bit30	= ((type == TYPE_R) || is_shift)											? instr[30] : 1'b0;

endmodule
