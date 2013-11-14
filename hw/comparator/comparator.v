`timescale 1ns / 1ps
module compare2(A,B,AltB,AeqB,AgtB);
input [1:0] A,B;
output AltB,AeqB,AgtB;

assign AeqB = (A[1] ~^ B[1]) & (A[0] ~^ B[0]);
assign AltB = (~A[1] & B[1]) | ((A[1] ~^ B[1]) & (~A[0] & B[0]));
assign AgtB = (A[1] & ~B[1]) | (A[0]& ~B[1] & ~B[0]) | (A[1] & A[0] & ~B[0]); 

endmodule

module compare4(A,B,AltB,AeqB,AgtB);
input [3:0] A,B;
output AltB,AeqB,AgtB;
wire [1:0] A_lt_B, A_gt_B, A_eq_B;
wire temp1;

compare2 c0(A[1:0],B[1:0], A_lt_B[0], A_eq_B[0], A_gt_B[0]);
compare2 c1(A[3:2], B[3:2], A_lt_B[1], A_eq_B[1], A_gt_B[1]);
and a1(AeqB, A_eq_B[0], A_eq_B[1]);
and a2(temp1, A_lt_B[0], A_eq_B[1]);
or o1(AltB, A_lt_B[1], temp1);
nor no1(AgtB, AeqB, AltB);

endmodule

//Testbench files

module testbench_comp2;
reg [1:0] A,B;
wire AltB,AgtB,AeqB;
integer k;
compare2 C0(A,B,AltB,AeqB,AgtB);

initial
begin
  A = 2'b00;
  B = 2'b00;
for (k = 0; k <= 16; k = k + 1)
  begin
    {A,B} = k;
    #5 $display("A: %b, B: %b, AeqB: %b, AltB: %b, AgtB: %b", A,B,AeqB,AltB,AgtB);
  end
end
endmodule

module testbench_comp4;
reg [3:0] A,B;
wire AltB,AgtB,AeqB;
integer k;

compare4 c0(A,B,AltB,AeqB,AgtB);
initial
begin
  for(k = 0; k <= 256; k = k+1)
   begin
     {A,B} = k;
     #5 $display("A: %b, B: %b, AeqB: %b, AltB: %b, AgtB: %b", A,B,AeqB,AltB,AgtB);
   end
end
endmodule
