module AlignedRAM(
	input [31:0] addr,
	inout [31:0] data,
	input [1:0] size,
	input rw, clk
);

parameter ADDR=32'h2000_0000;
parameter SIZE=256;
localparam REAL_SIZE = SIZE / 4;

reg [31:0] mem [REAL_SIZE-1:0];
reg [31:0] buffer;
wire enabled = (addr >= ADDR) && (addr < (ADDR + SIZE));
wire [31:0] internal_addr = (addr - ADDR) >> 2;

always@ (posedge clk)
begin
	if (enabled && rw)
	begin
		case (size)
		//2'b01: mem[internal_addr][(addr[1:0] * 8 + 7):(addr[1:0] * 8)] <= data[7:0];
		//2'b10: mem[internal_addr][(addr[1] ? 31 : 15):(addr[1] ? 16 : 0)] <= data[15:0];
		2'b11: mem[internal_addr] <= data;
		endcase
	end
end

always@ (posedge clk)
begin
	if (enabled && !rw)
	begin
		buffer = mem[internal_addr];
		case (size)
		2'b01: buffer = (buffer >> (addr[1:0] * 8)) & 32'hff;
		2'b10: buffer = (buffer >> (addr[1] ? 16 : 0)) & 32'hffff;
		endcase
	end
end

assign data = (enabled && !rw) ? buffer : 32'bz;

endmodule
