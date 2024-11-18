module simple_28(
    input wire clk,
    input wire rst,
    output wire out
);
    reg result;
    always @(posedge clk or posedge rst) begin
        if (rst)
            result <= 2'b0;
        else
            result <= ~result;
    end
    assign out = result;
endmodule
