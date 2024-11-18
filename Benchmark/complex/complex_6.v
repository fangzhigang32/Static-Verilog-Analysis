module complex_6 (
    input [7:0] data,
    input [7:0] address,
    input we,
    input tmp,
    input inclock,
    input outclock,
    output reg [7:0] q
);
    reg [7:0] ram [255:0];
    always @(posedge inclock) begin
        if (we)
            ram[address] <= data;
    end
    always @(posedge outclock) begin
        q <= ram[address];
    end
endmodule
