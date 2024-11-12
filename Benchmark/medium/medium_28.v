module medium_28(
    output reg b,
    input clk,
    input a
  );
    always @(posedge clk)
        begin
            b=a; 
        end
endmodule