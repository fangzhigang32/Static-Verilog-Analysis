module medium_2(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
always @(posedge clk or posedge reset) begin
    if (reset)
        data_out <= 7'b0;
    else
        data_out <= data_in;
end
endmodule