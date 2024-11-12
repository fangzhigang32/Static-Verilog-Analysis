module medium_30 (
    input clk,
    input rst,       
    input enable,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst)            
            count <= 4'b0000;
        else if (enable)
            count <= count + 1;
    end
endmodule
