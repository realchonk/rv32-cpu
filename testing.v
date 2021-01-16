`timescale 1ps/1ps
module testing();

reg pre_clk = 1;
wire base_clk;
wire hlt;
always #1 if(!hlt) pre_clk = ~pre_clk;

ClockDivider clk_div (
	.clk_in(pre_clk),
	.clk_out(base_clk)
);

defparam clk_div.FIRST_EDGE = 0;
defparam clk_div.DIVISOR = 2;

wire cpu_clk, mem_clk;

ClockGenerator cgen(
	.base_clk(base_clk),
	.rst(0),
	
	.cpu_clk(cpu_clk),
	.mem_clk(mem_clk)
);

wire [31:0] mem_addr, mem_data;
wire mem_rw;
wire [1:0] mem_size;

wire [31:0] a, b, c;

wire [9:0] SW, LEDR;

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

MemoryController mem(
	.addr(mem_addr),
	.data(mem_data),
	.rw(mem_rw),
	.size(mem_size),
	.clk(mem_clk)
);

IOController ioctrl(
	.addr(mem_addr),
	.data(mem_data),
	.rw(mem_rw),
	.size(mem_size),
	.clk(mem_clk),
	
	.SW(SW),
	.LEDR(LEDR)
);
assign SW = 32;

endmodule
