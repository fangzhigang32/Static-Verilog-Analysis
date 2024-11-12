module complex_27 (
  input wire clk,
  input wire reset,
  input wire d,
  output reg q
);
  always @(posedge clk or posedge reset) 
  begin
    if (reset)
      q <= 1'b0;
    else
      q <= d;
  end
  always @(posedge clk or negedge reset) 
  begin
    if (!reset)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule