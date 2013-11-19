module testbench;
reg enable;
reg [8:0] in;
wire [8:0] out;
integer i;

shift_left UUT(.in(in),.out(out),.enable(enable));

initial
begin
enable = 1;
$display("Enable: %b", enable);
	for (i = 0; i < 10; i = i + 2)
	begin
		#2 in = i;
		#2 $display("in: %b, out: %b", in, out);
	end
end


endmodule