//Verilog program which implements a finite state machine (FSM) that recognizes the sequence of 0000 or 1111 (overlapping sequences are
//allowed). The input is w and the output is z. When w=0 or w=1 for 4 consecutive clock pulses, the value of z=1 otherwise the value of
//z=0. This particular program is done by implementing cases. 
//SW0 toggle swithc on the DE1-SoC board acts as an active-low synchronous reset input and the SW1 toggle acts as the w input. KEY0 
//acts as the clock input. The LEDRs 0-8 represent the output of the state flipflops and LEDR9 represents the state of the z output. 

module lab6part2(SW, KEY, LEDR);	
	//initialization of inputs, outputs, and variables
	input [1:0] SW;
	input [0:0] KEY;
	output [9:0]LEDR;
	
	wire clock, w, resetn;
	wire z;
	reg [3:0] Y; 
	reg [3:0] y;
	
	assign clock=KEY[0];
	assign w=SW[1];
	assign resetn=SW[0];
	
	//initializing each possible state of the FSM
	parameter [3:0] A=4'b0000, B=4'b0001, C=4'b0010, D=4'b0011, E=4'b0100, F=4'b0101, G=4'b0110, H=4'b0111, I=4'b1000;

	//Implementation of the state table
	always@(w, y)
	begin
		case (y)
			A: if (!w) Y=B;
				else Y=F;
			B: if (!w) Y=C;
				else Y=F;
			C: if (!w) Y=D;
				else Y=F;
			D: if (!w) Y=E;
				else Y=F;
			E: if (!w) Y=E;
				else Y=F;
			F: if (!w) Y=B;
				else Y=G;
			G: if (!w) Y=B;
				else Y=H;
			H: if (!w) Y=B;
				else Y=I;
			I: if (!w) Y=B;
				else Y=I;
			default: Y=4'bxxxx; 
		endcase
	end
	
	always @(posedge clock)
	begin
		//checking if it is the reset case (active-low synchronous reset)	
		if (!(resetn))
			y<=A;
		//otherwise the data is passed on/change of state occurs
		else
			y<=Y;
	end

	//assigning outputs to LEDRs
	assign z=(y[3])|((y[2])&(~y[1])&(~y[0]));
	assign LEDR[9]=z;
	assign LEDR[3:0]=Y[3:0];
endmodule
