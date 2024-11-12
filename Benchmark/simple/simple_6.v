module simple_6(
    input wire clk,
    input wire reset,
    output reg [3:0] data
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data <= 4'b0000;
        end else begin
            data <= data + 1;
        end
        endif
    end
endmodule