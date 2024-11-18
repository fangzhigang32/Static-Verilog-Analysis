module complex_1(
    output reg [15:0] qo,
    input [15:0] din,
    input load
  );
    reg [7:0] temp_reg;
    always @(posedge load)
        begin 
            temp_reg <= din;
            qo <= temp_reg;
        end
endmodule