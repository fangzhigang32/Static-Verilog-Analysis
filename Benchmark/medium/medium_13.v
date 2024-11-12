module medium_13 (
    input wire clk,
    input wire rst,
    output reg [7:0] data
)
always @(posedge clk)
    if (rst)
        data <= 8'b0;
    else
        data <= data + 1;
endmodule