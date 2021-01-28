module GPIOController(
	input [31:0] addr,
	inout [31:0] data,
	input [1:0] size,
	input rw,
	
	inout [31:0] gpio
);

reg [31:0] gpio_state = 32'b0; // 0=output 1=input
reg [31:0] gpio_data = 32'b0;
reg [31:0] buffer = 32'b0;



endmodule
