//Verilog Project 3
//Aim: Synthesize a circuit that finds the average of n numbers.

//The number n is loaded into a counter C. The successive inputs are loaded into a
//single register D. A signal LD is asserted every time D is loaded. Every time a
//successfull load is done, the sum is updated in register S.
//At the end of n loads, the contents of the sum are divided by n. The quotient is
//placed into a register A. The remainder is to be ignored.

module shift_left(enable, in, out);
// module that shifts the input left when the enable input is 1
parameter n = 8;
input enable;
input [n:0] in;
output [n:0] out;
integer i;
always @(shift)
begin
	for (i = 0; i < n; i = i+1)
	begin
		out[i+1] <= in[i]
	end
end
endmodule

module divider_restore();

endmodule

module divider_nonrestore(quotient, remainder, numerator, denominator);
parameter n = 8;
input [n:0] numerator;
input [n+1:0] denominator;
output [n+1:0] remainder;
output [n:0] quotient;

always @(remainder)
begin
	if (remainder < 0)
	begin
		
		remainder = remainder + denominator;
	end
	else
	begin
		//shift rem||a
		remainder = remainder - denominator;
	end
end

endmodule

module divider_textbook();

endmodule

