`timescale 1ns/1ns

module shiftlne_tb;
// test the shiftlne module
// As it stands this will shift the bits by one place.

// Turn Load on, cycle the clock, then turn load off, cycle the clock.
// It appears only one cycle is required to shift all the bits one place.
parameter n = 8;
reg [n-1:0] R;
reg E, L, w, Clock;
wire [n-1:0] Q;
integer i;

shiftlne shifter(.R(R),
               .L(L),
               .w(w),
               .Clock(Clock),
               .Q(Q),
               .E(E));
	defparam shifter.n = n;
initial
begin
Clock = 0;
L = 1;
w = 1;
E = 0;
// Will only load R into Q until E is turned on.
// When E is turned on, Shifting is allowed to happen, but only when L is turned off
// If L and E are both on, then R will load into Q, but no shifting will occur
    for (i = 0; i < 256; i = i + 1)
    begin
    	#2 R = i;
      #2 E = 1;
    	#2 L = 1;
    	#2 Clock = ~Clock;
    	#2 Clock = ~Clock;
    	#2 L = 0;
    	#2 Clock = ~Clock;
    	#2 Clock = ~Clock;    	
		$display("R: %b, Q: %b",R, Q);		
    end
end
endmodule
