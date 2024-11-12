module complex_11(
    output reg[0:0] q,
    input sel,
    input clk
);
    always @(posedge clk) begin
        if(sel) 
            q <= 1;
        else 
            q <= 0;
    end
endmodule