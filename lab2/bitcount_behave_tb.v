`timescale 1 ns/1 ns
module bitcount_tb;

reg [7:0] TB;
wire [3:0] tcount;
integer b;

bitcount UUT (
              .B     (TB),
	      .count (tcount)
             );

initial 
begin
TB = 7'b0000000;
  for (b = 0; b <= 256; b = b + 1)
  begin
    TB = b;
   #5 $display("Test B = %b, Count = %d",TB,tcount);  
  end
end
endmodule

 
