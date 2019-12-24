//Verilog program which implements a combinational circuit that performs binary-to-decimal number conversion and binary-coded-decimal 
//(BCD) additon
//The inputs are 2 decimal digits X and Y which each represent a 4-bit number. X and Y, along with a carry-in (cin) bit will be added
//and the result will be a 5-bit binary number which will be displayed on a 7-segment display as a two-digit BCD onto HEX0 and HEX1. 
//The input values will be displayed on HEX4 and HEX5. Switches SW7-4 will determine input X and SW3-0 will determine input Y. SW8 will
//be used for the carry-in bit.

module BCD_adder_display(SW, HEX0, HEX1, HEX4, HEX5, LEDR);
	//initializing inputs, outputs, and variables
	input [8:0] SW;
	output [6:0] HEX0, HEX1, HEX4, HEX5;
	output [8:0] LEDR;
	
	//initializing variables (A_out=output of cct A, B_out=output of cct B, mux_out=output of multiplexer, etc)
	wire [3:0] O;
	wire z, or_1;
	wire [3:0] A_out, B_out, mux_out;
	wire [3:0] s; //sum of the two inputs X and Y
	wire co; //carry out bit
	
	adder4bit V0(SW, LEDR, s, co); //obtaining sum of inputs and placing it into s and co
	comparator V1(s[3:0],z); //checking if the sum is greater than 9 for appropriate display on HEX1
	circuit_a V2(s[2:0],A_out); //getting appropriate data for display of HEX0 (is it from 0-5 or 6-9?)
	circuit_b V9(s[1:0],B_out);
	mux_4bit_2to1 V3(s[3:0],A_out,z,mux_out);
	mux_4bit_2to1 V4(mux_out,B_out,co,O);
	
	//displaying the output values (sum)
	hexDisp V5(O,HEX0); 
	assign or_1=z|co;
	hexDisp V6(or_1,HEX1);
	
	//displaying input values
	hexDisp V7 (SW[3:0], HEX4);
	hexDisp V8 (SW[7:4], HEX5);
endmodule	

//comparator (>9). This module verifies if the sum is greater than 9, which would require HEX1 to display a 1 instead 
//of a 0
module comparator(V,z);
	input [3:0] V;
	output z;
	
	assign z=(V[3]&V[2])|(V[3]&V[1]);
endmodule

//circuit a: displays 0, 1, 2, 3, 4, 5 onto HEX0 (least significant digit)
module circuit_a(V,A);
	input [2:0] V;
	output [3:0] A;
	
	assign A[3]=1'b0;
	assign A[2]=V[2]&V[1];
	assign A[1]=~V[1];
	assign A[0]=V[0];
endmodule

//circuit b: displays 6, 7, 8, 9 onto HEX0 (least significant digit)
module circuit_b(V,B);
	input [1:0] V;
	output [3:0] B;
	
	assign B[0]= V[0];
	assign B[1]= ~V[1];
	assign B[2]= ~V[1];
	assign B[3]= V[1];
endmodule


//4 bit 2 to 1 multiplexer
module mux_4bit_2to1(V,A,z,M);
	input [3:0] V,A;
	input z;
	output [3:0] M;
	assign M[0] = (~z&V[0])|(z&A[0]);
	assign M[1] = (~z&V[1])|(z&A[1]);
	assign M[2] = (~z&V[2])|(z&A[2]);
	assign M[3] = (~z&V[3])|(z&A[3]);
endmodule


//Adder (4 bits) to obtain the sum of the two inputs
module adder4bit(SW0,LEDR0,s,co);
	input [8:0] SW0;
	output [8:0] LEDR0;
	output [3:0] s;
	output co;
	wire [3:0] ci;
	wire [3:0] a,b;
	
	assign a=SW0[7:4];
	assign b=SW0[3:0];
	assign ci[0]=SW0[8];
	assign LEDR0[3:0]=s[3:0];
	assign LEDR0[4]=co;
	
	full_adder V0 (a[0],b[0], ci[0], s[0], ci[1]);
	full_adder V1 (a[1],b[1], ci[1], s[1], ci[2]);
	full_adder V2 (a[2],b[2], ci[2], s[2], ci[3]);
	full_adder V3 (a[3],b[3], ci[3], s[3], co);
endmodule

//Full adder (1 bit) to module, acts as a helper function of the adder module to obtain the sum of two inputs	
module full_adder(a,b,ci,s,co);
	input a,b,ci;
	output s,co;
	
	assign s=a^b^ci;
	assign co=(a&b)|(a&ci)|(b&ci);
endmodule	

//module which displays the decimal number (0-9) onto the HEX display
module hexDisp (in, out);
	input [3:0] in;
	output [6:0] out;
	wire c0,c1,c2,c3;
	
	assign c0=in[0];
	assign c1=in[1];
	assign c2=in[2];
	assign c3=in[3];
	
	assign out[0]=(~c3&~c2&~c1&c0)|(~c1&~c0&c2)|(c3&c2)|(c1&c3);
	assign out[1]=(~c1&c0&c2)|(c1&~c0&c2)|(c3&c2)|(c1&c3);
	assign out[2]=(c1&~c0&~c2)|(c3&c2)|(c1&c3);
	assign out[3]=(~c1&c0&~c2)|(~c1&~c0&c2)|(c3&c2)|(c1&c3)|(c1&c2&c0);
	assign out[4]=(c1|c0|c2)&(~c1|c0|c3);
	assign out[5]=(~c3&~c2&c0)|(c1&c3)|(~c3&~c2&c1)|(c1&c0)|(c3&c2);
	assign out[6]=(~c3&~c2&~c1)|(c1&c0&c2)|(c3&c2)|(c1&c3);
endmodule
