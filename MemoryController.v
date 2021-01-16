module MemoryController(
	input [31:0] addr,
	inout [31:0] data,
	
	input rw,
	input [1:0] size,
	
	input clk
);

InstructionROM #(
	.ROM_START(32'h0000_0000)
) rom (
	.addr(addr),
	.data(data),
	.rw(rw),
	.size(size),
	.clk(clk)
);

RAM #(
	.RAM_START(32'h1000_0000),
	.RAM_SIZE(16)
) ram (
	.addr(addr),
	.data(data),
	.rw(rw),
	.size(size),
	.clk(clk)
);

endmodule
