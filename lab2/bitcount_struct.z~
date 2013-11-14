`timescale 1ns/1ns
module halfadd (A,B,carryout,sum);
input  A, B;
output carryout, sum;
  assign carryout = A&B;
  xor(sum, A, B);
endmodule

module fulladd(A, B, carryoutFA, carryin, sum);
input A, B, carryin;
output sum, carryoutFA;
   assign sum = A^B^carryin;
   assign carryoutFA = (A&B)|(A&carryin)|(B&carryin);
endmodule

module mainmod(halfadd_input, sum, out_sum);
   input [7:0] halfadd_input;
   output [2:0] sum;
   
   wire [2:0] fulladd2_cout;
   output [3:0] out_sum;
   wire [3:0] halfadd_cout, halfadd_sum, fulladd_cout, fulladd_sum;
// change this to a for loop when done
   halfadd HA0  (halfadd_input[0], halfadd_input[1], halfadd_cout[0], halfadd_sum[0]);

   halfadd HA1  (halfadd_input[2], halfadd_input[3], halfadd_cout[1], halfadd_sum[1]);

   halfadd HA2  (halfadd_input[4], halfadd_input[5], halfadd_cout[2], halfadd_sum[2]);

   halfadd HA3  (halfadd_input[6], halfadd_input[7], halfadd_cout[3], halfadd_sum[3]);

   fulladd FA0  (halfadd_sum[0],   halfadd_sum[1],   fulladd_cout[0], 1'b0, fulladd_sum[0]);
   fulladd FA1  (halfadd_cout[0],  halfadd_cout[1],  fulladd_cout[1], fulladd_cout[0], fulladd_sum[1]);
   fulladd FA2  (halfadd_sum[2],   halfadd_sum[3],   fulladd_cout[2], 1'b0, fulladd_sum[2]);
   fulladd FA3  (halfadd_cout[2],  halfadd_cout[3],  fulladd_cout[3], fulladd_cout[2], fulladd_sum[3]);

   fulladd F3B0 (fulladd_sum[0],   fulladd_sum[2], fulladd2_cout[0], 1'b0, sum[0]);
   fulladd F3B1 (fulladd_sum[1],   fulladd_sum[3], fulladd2_cout[1], fulladd2_cout[0], sum[1]);
   fulladd F3B2 (fulladd_cout[1],  fulladd_cout[3],fulladd2_cout[2], fulladd2_cout[1], sum[2]);

   assign out_sum = {fulladd2_cout[2],sum};   

endmodule

