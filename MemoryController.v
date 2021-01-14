module MemoryController(
	input [31:0] addr,
	inout [31:0] data,
	
	input rw,
	input [1:0] size,
	
	input clk
);

parameter MEM_ADDR = 32'h0000_0000;
parameter MEM_SIZE = 1024;

wire enabled = (size != 2'b00) && (addr >= MEM_ADDR) && (addr < (MEM_ADDR + MEM_SIZE));
reg [7:0] ram [(MEM_SIZE>>2)-1:0][3:0];
reg [31:0] buffer = 0;

always@ (posedge clk)
begin
	if (enabled && !rw)
		case (size)
		2'b01: buffer <= ram[addr[9:2]][addr[1:0]];
		2'b10: buffer <= ram[addr[9:2]][addr[1:0]] | (ram[addr[9:2]][addr[1:0] + 1] << 8);
		2'b11:
		begin
			buffer[ 7: 0] <= ram[addr[9:2]][addr[1:0] + 0];
			buffer[15: 8] <= ram[addr[9:2]][addr[1:0] + 1];
			buffer[23:16] <= ram[addr[9:2]][addr[1:0] + 2];
			buffer[31:24] <= ram[addr[9:2]][addr[1:0] + 3];
		end
		endcase
	else buffer <= 0;
end

always@ (posedge clk)
begin
	if (enabled && rw)
		case (size)
		2'b01:
			ram[addr[9:2]][addr[1:0]] <= data[7:0];
		2'b10:
		begin
			ram[addr[9:2]][addr[1:0] + 0] <= data[ 7: 0];
			ram[addr[9:2]][addr[1:0] + 1] <= data[15: 8];
		end
		2'b11:
		begin
			ram[addr[9:2]][addr[1:0] + 0] <= data[ 7: 0];
			ram[addr[9:2]][addr[1:0] + 1] <= data[15: 8];
			ram[addr[9:2]][addr[1:0] + 2] <= data[23:16];
			ram[addr[9:2]][addr[1:0] + 3] <= data[31:24];
		end
		endcase
end

assign data = (enabled && !rw) ? buffer : 32'bz;

integer i;
initial begin
	for (i=0; i< (MEM_SIZE>>2); i = i + 1)
	begin
		ram[i][0] <= 8'b00;
		ram[i][1] <= 8'b00;
		ram[i][2] <= 8'b00;
		ram[i][3] <= 8'b00;
	end
	// 800000b7: lui x1, 0x80000000
	ram[0][3] <= 8'h80;
	ram[0][2] <= 8'h00;
	ram[0][1] <= 8'h00;
	ram[0][0] <= 8'hb7;
	// 0000a103: lw x2, 0(x1)
	ram[1][3] <= 8'h00;
	ram[1][2] <= 8'h00;
	ram[1][1] <= 8'ha1;
	ram[1][0] <= 8'h03;
	// 01010113: adi x2, x2, 16
	ram[2][3] <= 8'h01;
	ram[2][2] <= 8'h01;
	ram[2][1] <= 8'h01;
	ram[2][0] <= 8'h13;
	// 0020a023: sw x2, 0(x1)
	ram[3][3] <= 8'h00;
	ram[3][2] <= 8'h20;
	ram[3][1] <= 8'ha0;
	ram[3][0] <= 8'h23;
	// 00100073: ebreak
	ram[4][3] <= 8'h00;
	ram[4][2] <= 8'h10;
	ram[4][1] <= 8'h00;
	ram[4][0] <= 8'h73;
	// 00000013
	ram[5][3] <= 8'h00;
	ram[5][2] <= 8'h00;
	ram[5][1] <= 8'h00;
	ram[5][0] <= 8'h13;
end

endmodule

