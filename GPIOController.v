module GPIOPin(
	inout data,	// GPIO data
	input rw,	// Read=0/Write=1
	input en,	// Enable Data Access
	input sel,	// Data=0/Mode=1
	input clk,	// Clock
	inout pin
);
reg pin_mode = 0; // 0=output 1=input
reg pin_data = 0;
reg buffer;

always@ (posedge clk)
begin
	if (en && rw)
	begin
		if (sel == 0) pin_data <= data;
		else pin_mode <= data;
	end
end

always@ (posedge clk)
begin
	if (en && !rw)
	begin
		if (sel == 0) buffer <= pin;
		else buffer <= pin;
	end
end

assign pin = pin_mode ? 1'bz : pin_data;
assign data = (en && !rw) ? buffer : 1'bz;

endmodule


module GPIOController(
	input [31:0] addr,
	inout [31:0] data,
	input [1:0] size,
	input rw,
	input clk,
	
	inout [31:0] gpio
);

parameter ADDR = 32'h8000_0000;
parameter SIZE = 8;
wire enable = (addr >= ADDR) && (addr < (ADDR + SIZE)) && (addr[1:0] == 0);
wire select = ((addr - ADDR) & 4) == 4;

`ifdef ALTERA_RESERVED_QIS
`define declare_pin(I) GPIOPin ( .data(data[I]), .rw(rw), .en(enable), .sel(select), .clk(clk), .pin(gpio[I]) )
`else
`define declare_pin(I) GPIOPin pin_``I ( .data(data[I]), .rw(rw), .en(enable), .sel(select), .clk(clk), .pin(gpio[I]) )
`endif

`declare_pin(0);
`declare_pin(1);
`declare_pin(2);
`declare_pin(3);
`declare_pin(4);
`declare_pin(5);
`declare_pin(6);
`declare_pin(7);
`declare_pin(8);
`declare_pin(9);
`declare_pin(10);
`declare_pin(11);
`declare_pin(12);
`declare_pin(13);
`declare_pin(14);
`declare_pin(15);
/*`declare_pin(16);
`declare_pin(17);
`declare_pin(18);
`declare_pin(19);
`declare_pin(20);
`declare_pin(21);
`declare_pin(22);
`declare_pin(23);
`declare_pin(24);
`declare_pin(25);
`declare_pin(26);
`declare_pin(27);
`declare_pin(28);
`declare_pin(29);
`declare_pin(30);
`declare_pin(31);*/
`undef declare_pin

endmodule
