module RiscVCore(
	output [31:0] mem_addr,		// Memory Address
	inout [31:0] mem_data,		// Memory Data
	
	output mem_rw,					// Read=0/Write=1
	output [1:0] mem_size,		// 0=disabled 1=byte(8) 2=hword(16) 3=word(32)

	output [31:0] debug_a,		// Debug Mirrors of bus a, b, c
					  debug_b,
					  debug_c,
					  
	output branch_taken,			// Branch was taken
	output instr_finish,			// Finished executing instruction
	
	output hlt,						// Halt
	input clk, rst					// Clock, Reset
);

`define T_MAX 3'd7	// Maximal number of steps for T(iming counter)

reg [2:0] T = 0;		// Timing Counter

wire [31:0] instruction;
wire [31:0] bus_a, bus_b, bus_c;
wire [31:0] immediate;

wire [2:0] instr_type;
wire [6:0] opcode;
wire [4:0] rs1, rs2, rd;
wire [3:0] alu_op, alu_op_ie, alu_op_id;

wire alu_carry, alu_zero, alu_lt;
wire rs1_en, rs2_en, rd_we;
wire pc_oe, pc_we, pc_inc, pc_oe2;
wire ir_we, mar_we, mar_oe, se_oe, se_en;
wire imm_ena, imm_enb, imm_enc;
wire funct3_ov, mdb_en, alu_oe;
wire T_rst;

// overwrite alu_op if funct3_ov is enabled
assign alu_op = funct3_ov ? alu_op_id : alu_op_ie;

InstructionExtractor ie(
	.instr(instruction),
	
	.opcode(opcode),
	.immed(immediate),
	.rd(rd),
	.rs1(rs1),
	.rs2(rs2),
	.funct3(alu_op_ie[2:0]),
	.bit30(alu_op_ie[3]),
	.type(instr_type)
);
InstructionDecoder id(
	.instr_in(instruction),
	.type(instr_type),
	.T_in(T),
	.funct3(alu_op_ie[2:0]),
	.opcode(opcode),
	.rs1(rs1),
	.rs2(rs2),
	.rd(rd),
	
	// ALU flags
	.carry(alu_carry),
	.zero(alu_zero),
	.lt(alu_lt),
	
	// Control Wires
	.pc_oe(pc_oe),
	.pc_we(pc_we),
	.pc_inc(pc_inc),
	.pc_oe2(pc_oe2),
	.ir_we(ir_we),
	.mar_we(mar_we),
	.mar_oe(mar_oe),
	.rs1_en(rs1_en),
	.rs2_en(rs2_en),
	.rd_we(rd_we),
	.mem_rw(mem_rw),
	.se_en(se_en),
	.se_oe(se_oe),
	.imm_ena(imm_ena),
	.imm_enb(imm_enb),
	.imm_enc(imm_enc),
	.funct3_ov(funct3_ov),
	.mdb_en(mdb_en),
	.alu_oe(alu_oe),
	.funct3_val(alu_op_id),
	.mem_size(mem_size),
	.hlt(hlt),
	.T_rst(T_rst),
	.branch_taken(branch_taken),
	
	.clk(clk)
);

// Arithmetic/Logic Unit
ALU alu(
	.a(bus_a),
	.b(bus_b),
	.data_out(bus_c),
	
	.op(alu_op),
	
	.carry(alu_carry),
	.zero(alu_zero),
	.lt(alu_lt),
	
	.oe(alu_oe)
);
RegisterFile rf(

	.rs1_data(bus_a),
	.rs2_data(bus_b),
	.rd_data(bus_c),
	
	.rs1(rs1),
	.rs2(rs2),
	.rd(rd),
	
	.rs1_en(rs1_en),
	.rs2_en(rs2_en),
	.rd_we(rd_we),
	
	.clk(clk),
	.rst(rst)
);
ProgramCounter pc(
	.data_in(bus_c),
	.data_out(bus_a),
	.data_out2(mem_addr),
	
	.oe(pc_oe),
	.we(pc_we),
	.inc(pc_inc),
	.oe2(pc_oe2),
	
	.clk(clk),
	.rst(rst)
);

// Instruction Register (00000013 = nop)
Register #(.DEPTH(32), .INIT_VALUE(32'h00000013)) ir(
	.data_in(mem_data),
	.data_out(instruction),
	
	.we(ir_we),
	.oe(1),
	
	.clk(clk),
	.rst(rst)
);

// Memory Address Register
Register #(.DEPTH(32)) mar(
	.data_in(bus_c),
	.data_out(mem_addr),
	
	.we(mar_we),
	.oe(mar_oe),
	
	.clk(clk),
	.rst(rst)
);

SignExtender se(
	.data_in(mem_data),
	.data_out(bus_c),
	.size(mem_size),
	
	.se(se_en),
	.oe(se_oe)
);

assign bus_a = imm_ena ? immediate : 32'bz;
assign bus_b = imm_enb ? immediate : 32'bz;
assign bus_c = imm_enc ? immediate : 32'bz;
assign mem_data = mdb_en ? bus_b : 32'bz;
assign debug_a = bus_a;
assign debug_b = bus_b;
assign debug_c = bus_c;

assign instr_finish = T_rst || T_rst2 || (T == `T_MAX);

// ((instr_type == 5) && !branch_taken && (T == 3'd3)) || 
wire T_rst2 = ((opcode == 7'b0010011) && (rd == 5'b0));
always@ (negedge clk)
begin 
	if (rst || instr_finish) T <= 0;
	else T <= T + 1'b1;
end


endmodule
