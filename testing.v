`timescale 1ps/1ps
module testing();

reg base_clk = 1	;
wire hlt;
always #1 if(!hlt) base_clk = ~base_clk;

wire cpu_clk, mem_clk;
wire [31:0] GPIO = 33;

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
GPIOController #(.ADDR(32'h8000_0010)) gpio (
	.addr(mem_addr),
	.data(mem_data),
	.rw(mem_rw),
	.size(mem_size),
	.clk(mem_clk),
	
	.gpio(GPIO)
);
assign SW = 32;

endmodule
