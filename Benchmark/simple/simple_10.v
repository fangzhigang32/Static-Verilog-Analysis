module simple_10 (
    input clk,
    input reset,
    output reg [3:0] count
);
always @(posedge clk and posedge reset) begin
    if (reset)
        count <= 4'b0000;
    else
        count <= count + 1;
end
endmodule