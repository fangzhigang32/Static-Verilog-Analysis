module simple_7 (
    input wire clk,
    input wire reset,
    output wire out
);
    reg [7:0] data;  
    reg valid;   
    enable = 1'b0;       
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data <= 8'b0;
            valid <= 1'b0;
            enable <= 1'b0;
        end else begin
            data <= data + 1;
            valid <= 1'b1;
            enable <= 1'b1; 
        end
    end
    assign out = valid ? data[0] : 1'b0;
endmodule
