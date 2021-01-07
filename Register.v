module Register #(
	parameter DEPTH = 32,
	parameter INIT_VALUE = 0
)(
	input [DEPTH-1:0] data_in,					// Data Input
	output [DEPTH-1:0] data_out,				// Data Output
	
	input we, oe,									// Write Enable, Output Enable
	
	input clk, rst									// Clock, Reset
);

reg [DEPTH-1:0] data = INIT_VALUE;

always@ (posedge clk)
begin
	if (rst) data <= INIT_VALUE;
	else if (we) data <= data_in;
end

assign data_out = oe ? data : 32'bz;

endmodule
