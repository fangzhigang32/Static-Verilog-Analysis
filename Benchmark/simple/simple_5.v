module simple_5(
    input clk,
    input reset,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset == 1'b1)
            count <= 0;
        else 
            count <= count + 1;
    end
    assign out = count > 4;
endmodule