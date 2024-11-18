module medium_20(
    input a,
    input b,
    output reg sum,
    output reg cout
);
    always @(a | b)
        begin
            sum = a^b;
            cout = a&b;
        end
endmodule