module BranchTester(
	input carry, zero, lt,
	input [2:0] funct3,
	
	input check,
	output reg taken=0
);


always@ (posedge check)
begin
	case (funct3)
	3'b000:	taken =  zero;
	3'b001:	taken = !zero;
	3'b100:	taken =  lt;
	3'b101:	taken = !lt;
	3'b110:	taken =  carry;
	3'b111:	taken = !carry;
	default:	taken =  0;
	endcase
end

endmodule
