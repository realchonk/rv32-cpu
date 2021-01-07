`timescale 1ps/1ps
module testing();

reg base_clk = 1;
wire hlt;
always #1 if(!hlt) base_clk = ~base_clk;

reg cpu_clk = 0;
reg mem_clk = 0;

always@ (negedge base_clk) cpu_clk <= ~cpu_clk;
always@ (posedge base_clk) mem_clk <= ~mem_clk;

wire [31:0] mem_addr, mem_data;
wire mem_rw;
wire [1:0] mem_size;

wire [31:0] a, b, c;

RiscVCore cpu(
	.mem_addr(mem_addr),
	.mem_data(mem_data),
	
	.mem_rw(mem_rw),
	.mem_size(mem_size),
	
	.debug_a(a),
	.debug_b(b),
	.debug_c(c),
	
	.hlt(hlt),
	.clk(cpu_clk),
	.rst(0)
);

MemoryController memctrl(
	.addr(mem_addr),
	.data(mem_data),
	.rw(mem_rw),
	.size(mem_size),
	.clk(mem_clk)
);

endmodule
