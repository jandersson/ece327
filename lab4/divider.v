`timescale 1ns/1ns

// Jonas Andersson
//TODO:
//	IMPLEMENT: []reglne module
//	TEST: []downcount module
//				


module divider (Clock, Resetn, s, LA, EB, DataA, DataB, R, Q, Done);
parameter n = 8, logn = 3;
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

//regne RegB (DataB, Clock, Resetn, EB, B);
//	defparam RegB.n = n;
//shiftlne ShiftR (DataR, LR, ER, R0, Clock, R);
//	defparam ShiftR.n = n;
//muxdff FF_R0 (1'b0, A[n-1], ER0, Clock, R);
//shiftlne ShiftA(DataA, LA, EA, Cout, Clock, A);
//	defparam ShiftA.n = n;
//assign Q = A;
//downcount Counter(Clock, EC, LC, Count);
//	defparam Counter.n = logn;
//assign z = (Count == 0);
//assign Sum = {1'b0, R[n-2:0], R0} + {1'b0, ~B} + 1;
//assign Cout = Sum[n];

//define the n 2-to-1 multiplexers
//assign DataR = Rsel ? Sum : 0;
endmodule
	
module muxdff(D0, D1, Sel, Clock, Q);
//figure 5.47
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
//Figure 5.54
parameter n = 8;
input [n-1:0] R;
input Clock, L, E;
output [n-1:0] Q;
reg [n-1:0] Q;

always @(posedge Clock)
	if (L)
		Q <= R;
	else if (E)
		Q <= Q - 1;

endmodule

module shiftn(R, L, w, Clock, Q);
// page 298
// R: Data from input stream
// L: Load_Enable
// w: bit to insert after shifting
// Q: shifted input, its the output

	parameter n = 8;
	input [n-1:0] R;
	input L, w, Clock;
	output [n-1:0] Q;
	reg [n-1:0] Q;
	integer k;
	initial begin Q = 0; end

	always @(posedge Clock)
		if(L == 1)
			Q <= R;
		else 
		begin
			for (k = 0; k < n - 1; k = k + 1)
				Q[k+1] <= Q[k];
			Q[0] <= w;	
		end
endmodule
