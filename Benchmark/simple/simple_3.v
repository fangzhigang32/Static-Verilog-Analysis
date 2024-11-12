module simple_3(
    input clk,
    input rst_n,
    output reg [7:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 8'b0;
        else
            data_out <= temp;
    end
endmodule
