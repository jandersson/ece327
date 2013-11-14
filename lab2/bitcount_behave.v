`timescale 1 ns/1 ns  
module bitcount(B,count);
input  [7:0] B;
output [3:0] count;
integer      k;
reg    [3:0] count;
	
always@(B)
  begin
     count = 0;
     for (k = 0; k <= 7; k = k + 1)
        count = count+B[k];
     end
endmodule
