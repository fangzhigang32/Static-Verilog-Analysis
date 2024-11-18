module complex_18(
    output[3:0] data,
    input clk
);
    sub_module uut (.data(data),.clk(clk));
endmodule
module sub_module(
    output reg[3:0] data,
    input clk
);
    always @(posedge clk) begin
        data <= data + 1;
    end
endmodule
