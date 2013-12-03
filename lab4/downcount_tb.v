`timescale 1ns/1ns

module downcount_tb;
// L: Load Counter (if this is on, the counter will never count, only load)
// E: Enable Counter (L needs to be 0 also)
// R: Data from input stream, the counter will load this value
// Q: Counter state, the output

// This testbench will instantiate the downcounter module, load the counter with the value of parameter n
// then it will cycle the clock to realize the loading, set enable to 1, load to 0, and start counting.
// Count = Count - 1 on each rising edge of clock.
parameter n = 8;
reg [n-1:0] R;
reg Clock, L, E;
wire [n-1:0] Q;
integer i;
downcount counter(.R(R), .Clock(Clock), .E(E), .L(L), .Q(Q));
	defparam counter.n = n;

initial begin
	Clock = 0;
	L = 1;
	R = n;
	#2 Clock = ~Clock;
	#2 Clock = ~Clock;
	for (i = 0; i < n; i = i + 1)
	begin
		E = 1;
		L = 0;
		#2 Clock = ~Clock;
		#2 Clock = ~Clock;
		$display("i: %d, Q: %d", i, Q);
	end
end

endmodule