module SevenSegmentController(
	input [31:0] addr,
	inout [31:0] data,
	input rw,
	input [1:0] size,	
	input clk,
	
	output reg [7:0] HEX0=0,
	output reg [7:0] HEX1=0,
	output reg [7:0] HEX2=0,
	output reg [7:0] HEX3=0
);

parameter ADDR = 32'h8000_0004;
wire enabled = (addr >= ADDR) && (addr < (ADDR + 4));
reg [31:0] buffer = 0;

always@ (posedge clk)
begin
	if (enabled && rw)
		case (size)
		2'b01:
			case (addr[1:0])
			2'b00: HEX0 <= data[7:0];
			2'b01: HEX1 <= data[7:0];
			2'b10: HEX2 <= data[7:0];
			2'b11: HEX3 <= data[7:0];
			endcase
		2'b10:
			if (addr[1])
			begin
				HEX2 <= data[7:0];
				HEX3 <= data[15:8];
			end
			else begin
				HEX0 <= data[7:0];
				HEX1 <= data[15:8];
			end
		2'b11:
		begin
			HEX0 <= data[ 7: 0];
			HEX1 <= data[15: 8];
			HEX2 <= data[23:16];
			HEX3 <= data[31:24];
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
			buffer[31:8] <= 24'b0;
			case (addr[1:0])
			2'b00: buffer[7:0] <= HEX0;
			2'b01: buffer[7:0] <= HEX1;
			2'b10: buffer[7:0] <= HEX2;
			2'b11: buffer[7:0] <= HEX3;
			endcase
		end
		2'b10:
		begin
			buffer[31:16] <= 16'b0;
			if (addr[0]) buffer[15:0] <= 16'b0;
			else if (addr[1])
			begin
				buffer[15:8] <= HEX1;
				buffer[ 7:0] <= HEX0;
			end
			else begin
				buffer[15:8] <= HEX3;
				buffer[ 7:0] <= HEX2;
			end
		end
		2'b11:
			if (addr[1:0]) buffer <= 32'b0;
			else begin
				buffer[ 7: 0] <= HEX0;
				buffer[15: 8] <= HEX0;
				buffer[23:16] <= HEX0;
				buffer[31:24] <= HEX0;
			end
		endcase
end

assign data = (enabled && !rw && (size != 2'b00)) ? buffer : 32'bz;

endmodule
