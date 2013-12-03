`timescale 1ns/1ns

module divider_tb;
parameter n = 8, logn = 8;
reg Clock, Resetn, s, LA, EB;
reg [n-1:0] DataA, DataB;
wire [n-1:0] R, Q;
wire Done;

divider divide(.Clock(Clock),
               .Resetn(Resetn),
               .s(s),
               .LA(LA),
               .EB(EB),
               .DataA(DataA),
               .DataB(DataB),
               .R(R),
               .Q(Q),
               .Done(Done));



endmodule