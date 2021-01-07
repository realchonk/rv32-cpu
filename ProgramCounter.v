module ProgramCounter(
	input [31:2] data_in,
	output [31:0] data_out,
	output [31:0] data_out2,
	
	input oe, oe2, we, inc,

	input clk, rst
);

reg [31:2] pc = 0;

always@ (posedge clk)
begin
	if (rst) pc <= 0;
	else if (we) pc <= data_in;
	else if (inc) pc <= pc + 4;
end

assign data_out = oe  ? pc | 2'b0 : 32'bz;
assign data_out2 = oe2 ? pc | 2'b0 : 32'bz;

endmodule
