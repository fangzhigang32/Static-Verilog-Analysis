module simple_24(
   input a, 
   input b, 
   input clk,
   output reg out
);
   always @(posedge clk) begin
     out <= a & (~b);
     out <= a | b;
   end
endmodule