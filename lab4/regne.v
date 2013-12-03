`timescale 1ns/1ns

module regne;

parameter n = 8;
reg [n-1:0] R:
reg Clock, Resetn, E;
wire [n-1:0] Q;

regne register(R, Clock, Resetn, E, Q);
	defparam register.n = n;
initial
begin
	Clock = 0;
	#2 $display("Register State:")

end

endmodule