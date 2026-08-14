module complex_23(
    input clk,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] shared_var;
    always @(posedge clk) 
        shared_var <= data_in;
    always @(posedge clk) 
        data_out <= shared_var;
endmodule