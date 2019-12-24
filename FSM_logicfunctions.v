//Verilog program which implements a finite state machine (FSM) that recognizes the sequence of 0000 or 1111 (overlapping sequences are
//allowed). The input is w and the output is z. When w=0 or w=1 for 4 consecutive clock pulses, the value of z=1 otherwise the value of 
//z=0. This particular FSM program is done by implementing logic functions (derived from state tables) instead of using cases.
//SW0 toggle swithc on the DE1-SoC board acts as an active-low synchronous reset input and the SW1 toggle acts as the w input. KEY0 
//acts as the clock input. The LEDRs 0-8 represent the output of the state flipflops and LEDR9 represents the state of the z output.


module FSM(SW,KEY,LEDR);
	//initialization of inputs, outputs, and variables
	input [1:0] SW;
	input [0:0] KEY;
	output [9:0]LEDR;
	
	wire clock, w, resetn;
	wire z;
	wire [8:0] Y; 
	wire [8:0] y;
	
	//assigning variables 
	assign clock=KEY[0];
	assign w=SW[1];
	assign resent=SW[0];
	
	//implementing logic function that was determined by state tables
	assign Y[0]=(~w)&(y[0]); 
	assign Y[1]=(~w)&(y[0]|y[5]|y[6]|y[7]|y[8]);
	assign Y[2]=(~w)&(y[1]);
	assign Y[3]=(~w)&(y[2]);
	assign Y[4]=(~w)&(y[3]|y[4]);
	assign Y[5]=(w)&(y[0]|y[2]|y[3]|y[4]|y[1]);
	assign Y[6]=(w)&(y[5]);
	assign Y[7]=(w)&(y[6]);
	assign Y[8]=(w)&(y[7]|y[8]);
	
	//initializing the D flip flops used for the states of the FSM
	d_ff U0 (Y[0], clock, y[0], resetn);
	d_ff U1 (Y[1], clock, y[1], resetn);
	d_ff U2 (Y[2], clock, y[2], resetn);
	d_ff U3 (Y[3], clock, y[3], resetn);
	d_ff U4 (Y[4], clock, y[4], resetn);
	d_ff U5 (Y[5], clock, y[5], resetn);
	d_ff U6 (Y[6], clock, y[6], resetn);
	d_ff U7 (Y[7], clock, y[7], resetn);
	d_ff U8 (Y[8], clock, y[8], resetn);
	
	assign z=(y[4])&(y[8]);
	
	//assigning outputs (state of flip flops & output z) onto LEDRs
	assign LEDR[9]=z;
	assign LEDR[8:0]=Y[8:0];
endmodule
	
//D flip flop module with active-low synchronous reset
module d_ff(D, clock, Q, resetn);
	input D, clock, resetn;
	output reg Q;
	always @(posedge clock)
	begin
		//check if it is a reset case
		if (resetn==1'b0)
		begin
			Q<=1'b0;
		end
		//otherwise, the data is passed onto the D flip flop
		else
		begin
			Q<=D;
			//Qb<=~D;
		end
	end
endmodule
