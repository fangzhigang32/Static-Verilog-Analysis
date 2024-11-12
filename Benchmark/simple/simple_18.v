module simple_18(
  input wire clk,
  input wire reset,
  output reg out
  );
always @(posedge clk or posedge reset)
  begin
    if (reset = 1'b1) begin
      out = 0;
    end
    else begin
      out = out + 1; 
    end
  end
endmodule