module SignExtender(
	input [31:0] data_in,
	output [31:0] data_out,
	
	input [1:0] size,
	
	input se, oe
);

function [31:0] sign_extend(input [31:0] data_in, input [1:0] size);
	case (size)
	2'b01:	sign_extend = (data_in[ 7] ? 32'hffffff00 : 0) | data_in[ 7:0];
	2'b10:	sign_extend = (data_in[15] ? 32'hffff0000 : 0) | data_in[15:0];
	default:	sign_extend = data_in;
	endcase
endfunction

assign data_out = oe ? (se ? sign_extend(data_in, size) : data_in) : 32'bz;

endmodule
