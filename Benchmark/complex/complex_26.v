module complex_26(
    input wire clk,
    input wire a,
    input wire b,
    output reg result
);
   always @(posedge clk)
   begin
      if (a > b)
         result <= 1;
      else
         result <= 0;
   end
   always @(posedge clk)
   begin
      if (a < b)
         result <= 1;
      else
         result <= 0;
   end
endmodule