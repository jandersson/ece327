//A sequential circuit has two inputs, w1 and w2, and an output, z. Its function is to compare
//the input sequences on the two inputs. If w1 = w2 during any four consecutive clock cycles, the circuit
//produces z = 1; otherwise, z = 0. For example:
// w1 = 0_1101_1100_0110
// w2 = 1_1101_0100_0111
//  z = 0_0001_0000_1110

module hw6_10( w1, w2, the_clock, z);
input [3:0] w1, w2;
input  the_clock;
output z;
initial begin z = 1'b0;
initial begin the_clock = 1'b0;
reg [1:0] state, next_state;
parameter [1:0] BEGIN = 1'b00;
								S1		=	1'b01;
								S2		=	1'b10;
								S3		=	1'b11;
			
//combinational circuit
always @(w1 or w2 or state)
begin
	case (state)
	BEGIN	: if (w1[0] == w2[0])
						next_state = S1;
					else 
						next_state = BEGIN;
	S1		: if (w1[1] == w2[1])
						next_state = S2;
					else
						next_state = BEGIN;
	S2		: if (w1[2] == w2[2])
						next_state = S3;
					else
						next_state = BEGIN;
	S3		:
					if (w1[3] == w2[3])
						next_state = S3;
					else 
						next_state = BEGIN;
	default : z <= 1'bx; 
	endcase

assign z = (state == S3);
end

//flip flops
always @(posedge the_clock)
begin
		state <= next_state;
end

endmodule

