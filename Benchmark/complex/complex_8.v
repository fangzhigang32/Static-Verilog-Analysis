module complex_8 (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] sum
);
    reg [7:0] temp;
    always @(posedge clk) begin
        temp <= a + b;
    end
    always @(temp) begin
        sum = temp;
    end
endmodule
