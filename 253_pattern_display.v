//Using a two-bit 3-1 multiplexer to create a 7-segment decoder, the numbers 2, 3, 5 will be diplayed onto the DE1-SoC board.
//00 means that 2, 5, 3 will be displayed on HEX2, HEX1, and HEX0 respectively, 01 means that 5, 3, 2 will be displayed on 
//HEX2, HEX1, and HEX0 respectively, and 10 means that 3, 2, 5 will be displayed on HEX2, HEX1, and HEX0 respectively. The 2 bit
//multiplexer will be controlled by SW9-8. This should produce a rotation like pattern.

module pattern_display(SW, LEDR, HEX0);
	//initializing inputs, outputs, variables
	input [9:0] SW; 
	output [9:0] LEDR; 
	output [6:0] HEX0; 
	wire [1:0] M0;

	//calling muliplexer to determine which case to display
	mux_2bit_3to1 U0 (SW[9:8], SW[5:4], SW[3:2], SW[1:0], M0);
	//displaying the first digit on HEX0
	char_7seg H0 (M0, HEX0);
	mux_2bit_3to1 U1 (SW[9:8], SW[1:0], SW[5:4], SW[3:2], M1);
	//displaying the second digit on HEX1
	char_7seg H1 (M1, HEX0);
	mux_2bit_3to1 U2 (SW[9:8], SW[3:2], SW[1:0], SW[5:4], M2);
	//displaying the last digit on HEX2
	char_7seg H2 (M2, HEX0);
endmodule

//multiplexer module which determines which case of the pattern to display
module mux_2bit_3to1 (S, U, V, W, M);
	input [1:0] S, U, V, W;
	output [1:0] M;
	assign M[0] = (~S[1] & ~S[0] & U[0])|(S[1] & ~S[0]&V[0]) | (S[0] & ~S[1] & W[0]);
	assign M[1] = (~S[1] & ~S[0] & U[1])|(S[1] & ~S[0]&V[1]) | (S[0] & ~S[1] & W[1]);
endmodule

//7 segment decoder: depending on what the multiplexer inputs into the decoder, the display should show the appropriate number associated
module char_7seg (C, Display);
	input [1:0] C; 
	output [6:0] Display;
	//assignment of diplay bits begin--based on logic functions of each bit of the HEX display
	assign Display[0]=C[1]&C[0];
	assign Display[1]=C[0];
	assign Display[2]=~(C[1]^C[0]);
	assign Display[3]=C[1]&C[0];
	assign Display[4]=C[1]|C[0];
	assign Display[5]=(~C[0])|C[1];
	assign Display[6]=C[1]&C[0];
endmodule