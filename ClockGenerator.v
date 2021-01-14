module ClockGenerator(
	input base_clk,
	input rst,
	
	output reg cpu_clk = 0,
	output reg mem_clk = 0
);

always@ (negedge base_clk)
begin
	if (rst) cpu_clk <= 0;
	else cpu_clk <= ~cpu_clk;
end
always@ (posedge base_clk)
begin
	if (rst) mem_clk <= 0;
	else mem_clk <= ~mem_clk;
end

endmodule
