module ClockDivider(
	output reg clk_out,
	input clk_in, rst
);

parameter FIRST_EDGE = 1;
parameter DIVISOR = 2;

reg [$clog2(DIVISOR):0] counter = 0;

always@ (clk_in)
begin
	if (rst)
	begin
		counter <= 0;
		clk_out <= FIRST_EDGE;
	end
	else if (counter == (DIVISOR-1))
	begin
		counter <= 0;
		clk_out <= ~clk_out;
	end
	else counter <= counter + 1;
end

initial clk_out <= ~FIRST_EDGE;

endmodule
