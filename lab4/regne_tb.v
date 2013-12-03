`timescale 1ns/1ns

module regne_tb;

parameter n = 8;
reg [n-1:0] R;
reg Clock, Resetn, E;
wire [n-1:0] Q;

regne register(R, Clock, Resetn, E, Q);
	defparam register.n = n;
initial
begin
	Clock = 0;
	//Load Register with Data without Enable
	#2 R = 8'b11111111;
	#2 E = 0;
	#2 $display("Register State: %b", Q);
	// => Q=xxxxxxxx
	
	//Turn on Enable without cycling the clock
	#2 E = 1;
	#2 $display("Register State: %b", Q);
	// => Q=xxxxxxxx

	//Cycle the clock, do nothing else
	#2 Clock = ~Clock;
	#2 Clock = ~Clock;
	#2 $display("Register State: %b", Q);
	// => Q=11111111

	//Turn "off" Resetn, without cycling the clock
	#2 Resetn = 0;
	#2 $display("Register State: %b", Q);
	// => Q=00000000

	//Cycle the Clock, do nothing else
	#2 Clock = ~Clock;
	#2 Clock = ~Clock;

	#2 $display("Register State: %b", Q);
	// => Q = 00000000


end

endmodule