module InstructionROM(
	input [31:0] addr,
	output [31:0] data,
	input rw,
	input [1:0] size,
	
	input clk
);

parameter ROM_START = 32'h0000_0000;
parameter ROM_SIZE = 4*16;
localparam ADDR_WIDTH = $clog2(ROM_SIZE);

wire enabled = (addr >= ROM_START) && (addr < (ROM_START + ROM_SIZE));
wire [ADDR_WIDTH-1:0] real_addr = addr - ROM_START;
wire [31:0] rom [(ROM_SIZE>>2)-1:0];
reg [31:0] buffer;
reg initialized;

always@ (posedge clk)
begin
	if (enabled && !rw)
		case (size)
		2'b00: buffer <= 32'b0;
		2'b01:
		begin
			buffer[31:8] <= 24'b0;
			case (real_addr[1:0])
			2'b00: buffer[7:0] <= rom[real_addr >> 2][ 7: 0];
			2'b01: buffer[7:0] <= rom[real_addr >> 2][15: 8];
			2'b10: buffer[7:0] <= rom[real_addr >> 2][23:16];
			2'b11: buffer[7:0] <= rom[real_addr >> 2][31:24];
			endcase
		end
		2'b10:
		begin
			buffer[31:16] <= 16'b0;
			if (real_addr[0]) buffer[15:0] <= 16'b0;
			else if (real_addr[1]) buffer[15:0] <= rom[real_addr >> 2][15:0];
			else buffer[15:0] <= rom[real_addr >> 2][31:16];
		end
		2'b11:
		begin
			if (real_addr[1:0]) buffer <= 32'b0;
			else buffer <= rom[real_addr >> 2];
		end
		endcase
end

assign data = (enabled && !rw && (size != 2'b00)) ? buffer : 32'bz;

/*00*/ assign rom[32'h00] = 32'h800000b7;	// li x1, 0x8000_0000
/*04*/ assign rom[32'h01] = 32'h00000113;	// li x2, 0
/*08*/ assign rom[32'h02] = 32'h3ff00193;	// li x3, 1023
/*0c*/ assign rom[32'h03] = 32'h00110113;	// loop: addi x2, x2, 1
/*10*/ assign rom[32'h04] = 32'h0020a023; // sw x2, 0(x1)
/*14*/ assign rom[32'h05] = 32'h0020a223;	// sw x2, 4(x1)
/*18*/ assign rom[32'h06] = 32'hfe311ae3;	// bne x2, x3, loop
/*1c*/ assign rom[32'h07] = 32'h00000013;	// 
/*20*/ assign rom[32'h08] = 32'h00000013;	// 
/*24*/ assign rom[32'h09] = 32'h00000013;	// 
/*28*/ assign rom[32'h0a] = 32'h00000013;	// 
/*2c*/ assign rom[32'h0b] = 32'h00000013;	// 
/*30*/ assign rom[32'h0c] = 32'h00000013;	// 
/*34*/ assign rom[32'h0d] = 32'h00000013;	//	
/*38*/ assign rom[32'h0e] = 32'h00000013;	// 
/*3c*/ assign rom[32'h0f] = 32'h00100073; // ebreak/hlt

endmodule
