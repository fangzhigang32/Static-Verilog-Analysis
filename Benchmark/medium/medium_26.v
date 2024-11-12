module medium_26(
    output reg[7:0] out,
    input [7:0] data,
    input load,
    input clk,
    input reset
);
    always @(posedge clk)
        begin
            if (!reset) 
                out <= 8'h00;
            elif (load) 
                out <= data;
            else 
                out <= out + 1;
        end
endmodule
