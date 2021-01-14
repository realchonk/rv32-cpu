module IOController(
	input [31:0] addr,
	inout [31:0] data,
	
	input rw,
	input [1:0] size,
	input clk,
	
	input [9:0] SW,
	output reg [9:0] LEDR = 0
);

parameter IO_ADDR		= 32'h8000_0000;
parameter IO_SIZE		= 4;

wire enabled = (size != 2'b00) && (addr >= IO_ADDR) && (addr < (IO_ADDR + IO_SIZE));
reg [31:0] buffer = 0;

always@ (posedge clk)
begin
	if (enabled && rw)
		case (size)
		2'b01: LEDR[7:0] <= data[7:0];
		2'b10: LEDR[9:0] <= data[9:0];
		2'b11: LEDR[9:0] <= data[9:0];
		endcase
end

always@ (posedge clk)
begin
	if (enabled && !rw)
		case (size)
		2'b01: buffer <= SW[7:0];
		2'b10: buffer <= SW[9:0];
		2'b11: buffer <= SW[9:0];
		endcase
end

assign data = (enabled && !rw) ? buffer : 32'bz;

endmodule
