
`timescale 1ns/1ns
module excess3_tb;
reg [3:0] the_input;
wire [3:0] the_output;
reg clk;
initial clk = 0;
integer k;
 
excess3 DUT (  
		.stream_in(the_input),
	       	.the_clock(clk),
		.e3_out(the_output)
	    );

//always 
//	#2 clk <= ~clk;
initial
begin 
the_input = 4'b0000;
clk = 1'b0;

	for (k = 0; k < 15; k = k + 1)
	begin
				
		the_input = k;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 $display("Input: %d, Output: %d", the_input, the_output); 
		
	end
end
initial
	#200 $finish;
endmodule

