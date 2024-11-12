module complex_16 (
    input clk,
	input a, 
	input b, 
	output reg y
);
    reg c, d;
    always @(posedge clk)begin
       c <= a & b;  
       d <= a | b;  
       y <= c ^ d;  
    end
endmodule