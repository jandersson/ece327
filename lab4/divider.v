`timescale 1ns/1ns

// Jonas Andersson
//TODO:
//	IMPLEMENT: [x]regne module
//             [x]shiftlne module
//			   [x]Connect divider module to sub modules
//	TEST: [x]downcount module
//		  [x]muxdff module 
//		  [x]regne module
//        [x]shiftlne module
//		  []divider module					


module divider (Clock, Resetn, s, LA, EB, DataA, DataB, R, Q, Done);
// Clock: A Clock
// Resetn: Reset to 0 when equal to 0
// s: Go signal
// LA: Load Data into Register A
// EB: This is never used anywhere...
// DataA:
// DataB:
// R:
// Q:
// Done: Asserted when divider is finished
parameter n = 8, logn = 8;
input Clock, Resetn, s, LA, EB;
input [n-1:0] DataA, DataB;
output [n-1:0] R, Q;
output Done;
reg Done;
wire Cout, z, R0;
wire [n-1:0] DataR;
wire [n:0] Sum;
reg [1:0] y, Y;
wire [n-1:0] A, B;
wire [logn-1:0] Count;
reg EA, Rsel, LR, ER, ER0, LC, EC;
integer k;

//control circuit

parameter	S1 = 2'b00,
			S2A = 2'b01,
			S2B = 2'b10,
			S3 = 2'b11;
always @(s or y or z)
begin: State_table
	case(y)
		S1:		if (s == 0) 
					Y = S1;
				else
					if (Cout == 1)
						Y = S2A;
					else 
						Y = S2B;
		S2A:	if (z == 0)
					if (Cout == 1)
						Y = S2A;
					else 
						Y = S2B;
				else
				  	Y = S3;
		S2B:	if (z == 0)
					if (Cout == 1)
						Y = S2A;
					else 
						Y = S2B;
				else
				  	Y = S3;
		S3:		if(s == 1)
					Y = S3;
				else
					Y = S1;
		default: Y = 2'bxx;
	endcase
end

always @(posedge Clock or negedge Resetn)
begin: State_flipflops
	if (Resetn == 0)
		y <= S1;
	else
		y <= Y;
end	

always @(y or s or Cout or z)
begin: FSM_outputs
	//defaults
	case (y)
		S1: 
		begin
			Rsel = 0; LC = 1; LR = 1; ER0 = 0;
		end
		S2B:
		begin
			EA = 1; ER0 = 1; ER = 1;
			if (z == 0)
				EC = 1;
			else 
				EC = 0;
		end
		S2A:
		begin
			Rsel = 1; LR = 1; EA = 1; ER0 = 1;
			if (z == 0)
				EC = 1;
			else 
				EC = 0;
		end
		S3:
			Done = 1;
	endcase
end

//datapath circuit

regne RegB (.R(DataB),
            .Clock(Clock),
            .Resetn(Resetn), 
            .E(EB),
            .Q(B));
	defparam RegB.n = n;
shiftlne ShiftR (.R(DataR),
                 .L(LR),
                 .E(ER),
                 .w(R0), 
                 .Clock(Clock),
                 .Q(R));
	defparam ShiftR.n = n;
muxdff FF_R0 (.D0(1'b0),
              .D1(A[n-1]),
              .Sel(ER0),
              .Clock(Clock),
              .Q(R0));
shiftlne ShiftA(.R(DataA),
                .L(LA),
                .E(EA),
                .w(Cout),
                .Clock(Clock),
                .Q(A));
	defparam ShiftA.n = n;
assign Q = A;
downcount Counter(.Clock(Clock),
                  .E(EC), 
                  .L(LC),
                  .Q(Count),
                  .R(B));
	defparam Counter.n = logn;
assign z = (Count == 0);
assign Sum = {1'b0, R[n-2:0], R0} + {1'b0, ~B} + 1;
assign Cout = Sum[n];

//define the n 2-to-1 multiplexers
assign DataR = Rsel ? Sum : 0;
endmodule
	
module muxdff(D0, D1, Sel, Clock, Q);
// figure 5.47
// This is basically a 2-1 multiplexer
// D0: Data stream 0
// D1: Data stream 1
// Sel: Select bit
//		When Select is 0, D0 is connected to Q
//		When Select is 1, D1 is connected to Q

	input D0, D1, Sel, Clock;
	output Q;
	reg Q;

	always @(posedge Clock)
		if (!Sel)
			Q <= D0;
		else
			Q <= D1;
endmodule

module downcount (R, Clock, E, L, Q);
// Figure 5.54
// A counter that begins counting down when enabled
// L: Load Counter (if this is on, the counter will never count, only load)
// E: Enable Counter (L needs to be 0 also)
// R: Data from input stream, the counter will load this value
// Q: Counter state, the output
parameter n = 8;
input [n-1:0] R;
input Clock, L, E;
output [n-1:0] Q;
reg [n-1:0] Q;

always @(posedge Clock)
	if (L == 1)
		Q <= R;
	else if (E == 1)
		Q <= Q - 1;

endmodule

module shiftlne(R, L, w, Clock, Q, E);
// Figure 5.51 on page 298
// modified to shift left instead of right
// R: Data from input stream
// L: Load_Enable
// w: bit to insert after shifting
// Q: shifted input, its the output
// TODO: []add enable switch


	parameter n = 8;
	input [n-1:0] R;
	input L, w, Clock, E;
	output [n-1:0] Q;
	reg [n-1:0] Q;
	integer k;
	initial begin Q = 0; end

	always @(posedge Clock)
		

		if(L == 1)
			Q <= R;
		else if (E == 1)
		begin
			for (k = 0; k < n - 1; k = k + 1)
				Q[k+1] <= Q[k];
			Q[0] <= w;	
		end
endmodule

module regne (R, Clock, Resetn, E, Q);
// Figure 5.58 on page 302
// An n-bit register with an enable input

parameter n = 8;
input [n-1:0] R;
input Clock, Resetn, E;
output [n-1:0] Q;
reg [n-1:0] Q;

always @(posedge Clock or negedge Resetn)
	if (Resetn == 0)
		Q <= 0;
	else if (E == 1)
		Q <= R;
endmodule
