module complex_22 (
    input clk,
    input reset,
    output reg y
);
    reg [7:0] counter = 8'b0;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
        end else begin
            y <= counter[0];
            counter <= counter + 1;
        end
    end
endmodule
