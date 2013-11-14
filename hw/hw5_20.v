`timescale 1ns/1ns

module upcounter(Q,Enable, Clock);
input Clock, Enable;
output [3:0] Q;
initial
  Q = 0;
reg [3:0] count;
assign Q = Enable ? count : 4'bzzzz;

always @(posedge Clock)
begin

  if (count == 12)
    count <= 0;
  else 
    count <= count + 1;
end
endmodule

module uptest;
reg ClockT, EnableT;
wire [3:0] QT;
integer k;

upcounter U1(QT,EnableT,ClockT);

initial
begin
EnableT = 1;
ClockT = 0;
for(k = 0; k <= 24; k = k + 1)
  begin
  #4  ClockT = !ClockT;
  #5  $display("Q = %b, Clock = %b", QT,ClockT);
  end
end



endmodule
