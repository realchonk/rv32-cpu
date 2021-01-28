module PerformanceCounter(
	input [31:0] addr,
	output [31:0] data,
	input [1:0] size,
	input rw,
	
	input inc,
	input clk
);

parameter ADDR = 32'h8000_0000;

assign enabled = (addr >= ADDR) && (addr < (ADDR + 4));

wire [1:0] lower  = addr[1:0];
reg [31:0] counter = 32'b0;
reg [31:0] buffer = 32'b0;

always@ (posedge clk, posedge inc)
begin
	if (inc) counter = counter + 1'b1;
	else if (!rw && enabled)
	begin
		case (size)
		2'b00: buffer = 32'b0;
		2'b01: buffer = 32'b0 | ((counter >> (lower * 8)) & 8'hff);
		2'b10: buffer = 32'b0 | ((counter >> (lower[1] * 16)) & 16'hffff);
		2'b11: buffer = counter;
		endcase
		counter = 32'b0;
	end
end

assign data = enabled && (size != 2'b00) ? buffer : 32'bz;

endmodule
