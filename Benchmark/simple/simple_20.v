module simple_20 (
    input wire clk,
    input wire reset,
    output reg[7:0] data_out,
    reg [7:0] internal_data
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            data_out <= 8'd0;
        end else begin
            data_out <= internal_data; 
        end
    end
endmodule
