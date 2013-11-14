`timescale 1ns/1ns
module halfadd_tb;
reg [7:0] halfadd_input;
wire [3:0] out_sum;
integer k;

mainmod BC (
             .halfadd_input(halfadd_input),
             .out_sum(out_sum)
           );

initial
begin
  halfadd_input = 8'b0000_0000;
  for (k = 0; k <= 256; k = k+1)
    begin
      halfadd_input = k;
      #5 $display("Input: %b, Bitcount: %d", halfadd_input, out_sum);
    end
end

endmodule
