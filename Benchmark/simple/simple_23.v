module simple_23(
    input clk,
    input a,
    input b,
    output reg out
);
    always @(posedge clk)
        begin
            out <= a & b;
            out <= a | b; 
        end
endmodule