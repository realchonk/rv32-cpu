module BranchTester(
	input carry, zero, lt,
	input [2:0] funct3,
	
	output reg taken
);


always@ (*)
begin
	case (funct3)
	2'b000:	taken =  zero;
	2'b001:	taken = !zero;
	2'b100:	taken =  lt;
	2'b101:	taken = !lt;
	2'b110:	taken =  carry;
	2'b111:	taken = !carry;
	default:	taken =  0;
	endcase
end

endmodule
