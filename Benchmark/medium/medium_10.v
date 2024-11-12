module medium_10(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] internal_reg;
    always @(posedge clk or reset) begin
        if (reset) begin
            internal_reg <= 8'd0;
        end else begin
            internal_reg <= data_in;
        end
    end
    always @(posedge clk) begin
        data_out <= internal_reg;
    end
endmodule
