module complex_21(
    output reg[7:0] qout,
    output reg [7:0] qout_internal,
    input [7:0] data,
    input clk
  );
    always @(clk or data)
        begin
            if (clk) qout_internal = data; 
        end
endmodule