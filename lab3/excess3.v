`timescale 1ns/1ns
module excess3(stream_in, the_clock, e3_out);
input [3:0] stream_in; 
input the_clock;
output [3:0] e3_out;
parameter [2:0] 
		START     = 3'b000,
		CARRY1    = 3'b001,
		CARRY2    = 3'b010,
		CARRY3    = 3'b011,
		NO_CARRY1 = 3'b100,
		NO_CARRY2 = 3'b101,
		NO_CARRY3 = 3'b110; 
reg [2:0] state, next_state;
initial state = 3'b000;
reg [3:0] e3_out;
always @(state or stream_in)
begin
	case(state)
  START :
					
		      if (stream_in[0] == 0)
				 		begin
						next_state <= NO_CARRY1;
						e3_out[0] <= 1'b1;
		     		end
					else if(stream_in[0] == 1) 
		     		begin
						next_state <= CARRY1;
						e3_out[0] <= 1'b0;
		    		end
				 
				
		
	CARRY1:
				
		   		if (stream_in[1] == 0)
   	      	begin
						next_state <= CARRY2;
						e3_out[1] <= 1'b0;
		     		end
		     	else if (stream_in[1] == 1)
		     		begin
						next_state <= CARRY2;
						e3_out[1] <= 1'b1;
		    		end 
				
	CARRY2		: 
						if (stream_in[2] == 0)
		     			begin
							next_state <= NO_CARRY2;
    					e3_out[2] <= 1'b1;
		     			end
		     		else
          		begin 
							next_state <= CARRY3;
          		e3_out[2] <= 1'b0;
          		end
	CARRY3		: begin
							next_state <= START;
							e3_out[3] <= 1'b1;
							end
  NO_CARRY1	: 
				 		if (stream_in[1] == 1)
		     			begin
							next_state <= CARRY2;
							e3_out[1] <= 1'b0;
		     			end
         		else
		     			begin
              next_state <= NO_CARRY2;
							e3_out[1] <= 1'b1;
		     			end		    		
	NO_CARRY2 : 
		     		if (stream_in[2] == 0)
							begin
							next_state <= NO_CARRY3;
							e3_out[2] <= 1'b0;
	            end
		     		else if (stream_in[2] == 1)
							e3_out[2] <= 1'b1;
							next_state <= NO_CARRY3;
 	NO_CARRY3 :
		  if (stream_in[3] == 0)
				begin
				e3_out[3] <= 1'b0;
		    next_state <= START;   
				end
		  else
				begin 
				e3_out[3] <= 1'b1;
				next_state <= START;
				end
		    
	default   :
				  next_state <= 3'bxxx;
	endcase
end

always @(posedge the_clock)
	state <= next_state;
endmodule

