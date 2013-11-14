module dec2to4(W, En, Y);
input [1:0] W;
input En;
output reg [0:3] Y;
integer k;

always @(W,En)
  for (k = 0; k <= 3; k = k + 1)
    if (W == k)
      Y[k] = En;

endmodule

module dec2to4_tb;
reg [1:0] W;
wire [0:3] Y;
integer j;

initial
begin
for (j = 0; j <= 3; j = j + 1)
  W = j;
end

endmodule
