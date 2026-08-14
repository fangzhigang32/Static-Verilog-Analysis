module complex_24(
    input clk, 
    input [7:0] in, 
    output reg [7:0] out
);
    reg [7:0] data;
    reg [7:0] tmp;
    always @(posedge clk)
    begin
        data <= in;
        tmp <= data;
        out <= tmp;
    end
endmodule