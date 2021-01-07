module MemoryController(
	input [31:0] addr,
	inout [31:0] data,
	
	input rw,
	input [1:0] size,
	
	input clk
);

reg [7:0] ram [255:0][3:0];
reg [31:0] buffer = 0;

always@ (posedge clk)
begin
	if (addr < 1024 && !rw)
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
	if (addr < 1024 && rw)
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

assign data = (size && !rw) ? buffer : 32'bz;

integer i;
initial begin
	for (i=0; i<256; i = i + 1)
	begin
		ram[i][0] <= 8'b00;
		ram[i][1] <= 8'b00;
		ram[i][2] <= 8'b00;
		ram[i][3] <= 8'b00;
	end
	// 00a00193
	ram[0][3] <= 8'h00;
	ram[0][2] <= 8'ha0;
	ram[0][1] <= 8'h01;
	ram[0][0] <= 8'h93;
	// 00310863
	ram[1][3] <= 8'h00;
	ram[1][2] <= 8'h31;
	ram[1][1] <= 8'h08;
	ram[1][0] <= 8'h63;
	// 02008093
	ram[2][3] <= 8'h02;
	ram[2][2] <= 8'h00;
	ram[2][1] <= 8'h80;
	ram[2][0] <= 8'h93;
	// 00110113
	ram[3][3] <= 8'h00;
	ram[3][2] <= 8'h11;
	ram[3][1] <= 8'h01;
	ram[3][0] <= 8'h13;
	// ff5ff06f
	ram[4][3] <= 8'hff;
	ram[4][2] <= 8'h5f;
	ram[4][1] <= 8'hf0;
	ram[4][0] <= 8'h6f;
end

endmodule

