module complex_3(
	input wire clk1, 
	input wire clk2, 
	input wire d, 
	output reg q
);
  always @(posedge clk1)
    q <= d;
  always @(posedge clk2)
    q <= ~d;
endmodule