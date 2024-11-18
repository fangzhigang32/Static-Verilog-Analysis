module simple_26 (
    input wire reset,
    output reg data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0;
        end else begin
            data_out <= ~data_out;
        end
    end
endmodule
