module ALU(
	input [31:0] a, b,
	output [31:0] data_out,
	input [3:0] op,
	output carry, zero, lt,
	
	input oe
);

function [32:0] calculate(input [31:0] a, b, input [3:0] op);
	case (op)
	4'b0000: calculate = a + b;
	4'b1000: calculate = a - b;
	4'b0001: calculate = a << b;
	4'b0010: calculate = $signed(a) < $signed(b);
	4'b0011: calculate = a < b;
	4'b0100: calculate = a ^ b;
	4'b0101: calculate = a >> b;
	4'b1101:	calculate = $signed(a) >>> b;
	4'b0110: calculate = a | b;
	4'b0111: calculate = a ^ b;
	default:	calculate = 33'bx;
	endcase
endfunction
wire [32:0] result = calculate(a, b, op);
assign carry = result[32];
assign zero = (result[31:0] == 32'b0);
assign lt = $signed(a) < $signed(b);

assign data_out = oe ? result[31:0] : 32'bz;

endmodule
