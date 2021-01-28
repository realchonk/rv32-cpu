module RAM(
	input [31:0] addr,
	inout [31:0] data,
	input rw,
	input [1:0] size,
	
	input clk
);

parameter RAM_START = 32'h0000_0000;
parameter RAM_SIZE  = 32'd256;
localparam ADDR_WIDTH = $clog2(RAM_SIZE);

wire enabled = (addr >= RAM_START) && (addr < (RAM_START + RAM_SIZE));

wire [ADDR_WIDTH-1:0] real_addr = addr - RAM_START;
wire [1:0] lwa = real_addr[1:0];

reg [7:0] ram [(RAM_SIZE>>2)-1:0][3:0];
reg [31:0] buffer = 0;

always@ (posedge clk)
begin
	if (enabled && rw)
		case (size)
		2'b01:
			ram[real_addr >> 2][lwa] <= data[7:0];
		2'b10:
		begin
			ram[real_addr >> 2][lwa + 2'd0] <= data[ 7: 0];
			ram[real_addr >> 2][lwa + 2'd1] <= data[15: 8];
		end
		2'b11:
		begin
			ram[real_addr >> 2][lwa + 2'd0] <= data[ 7: 0];
			ram[real_addr >> 2][lwa + 2'd1] <= data[15: 8];
			ram[real_addr >> 2][lwa + 2'd2] <= data[23:16];
			ram[real_addr >> 2][lwa + 2'd3] <= data[31:24];
		end
		endcase
end

always@ (posedge clk)
begin
	if (enabled && !rw)
		case (size)
		2'b00: buffer <= 32'b0;
		2'b01:
		begin
			buffer[7:0] <= ram[real_addr >> 2][lwa];
			buffer[31:8] <= 24'b0;
		end
		2'b10:
		begin
			buffer[ 7: 0] <= ram[real_addr >> 2][lwa + 2'd0];
			buffer[15: 8] <= ram[real_addr >> 2][lwa + 2'd1];
			buffer[31:16] <= 16'b0;
		end
		2'b11:
		begin
			buffer[ 7: 0] <= ram[real_addr >> 2][lwa + 2'd0];
			buffer[15: 8] <= ram[real_addr >> 2][lwa + 2'd1];
			buffer[23:16] <= ram[real_addr >> 2][lwa + 2'd2];
			buffer[31:24] <= ram[real_addr >> 2][lwa + 2'd3];
		end
		endcase
end

assign data = (enabled && !rw && (size != 2'b00)) ? buffer : 32'bz;

endmodule
