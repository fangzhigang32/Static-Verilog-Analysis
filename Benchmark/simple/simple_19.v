module simple_19(
    input clk,
    input reset,
    output reg [3:0] count
);
    always @(posedge clk or negedge reset)
        if (!reset) begin
            count <= 0;
        end
        else begin
            count = count + 1;
        end
endmodule