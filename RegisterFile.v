module RegisterFile(
	output [31:0] rs1_data, rs2_data,
	input [31:0] rd_data,
	
	input [4:0] rs1, rs2, rd,
	
	input rs1_en, rs2_en, rd_we,
	
	input clk, rst
);

integer i;
reg [31:0] regs [30:0];

always@ (posedge clk)
begin
	if (rst)
	begin
		for (i = 0; i < 31; i = i + 1)
			regs[i] <= 0;
		i <= 'bx;
	end
	else if (rd_we && (rd != 5'b0))
		regs[rd - 1] <= rd_data;
end

assign rs1_data = rs1_en ? (rs1 != 5'b0 ? regs[rs1 - 1] : 32'b0) : 32'bz;
assign rs2_data = rs2_en ? (rs2 != 5'b0 ? regs[rs2 - 1] : 32'b0) : 32'bz;

initial begin
	for (i = 0; i < 31; i = i + 1)
		regs[i] <= 0;
	i <= 'bx;
end

endmodule
