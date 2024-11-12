module medium_6(
    input clk,
    input reset,
    input data, 
    output reg internal_data
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            internal_data <= 8'b0;
        end else begin
            internal_data <= data;
        end
    end
endmodule
