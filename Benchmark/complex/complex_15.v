module complex_15(
    output reg out,
    input in0,
    input in1,
    input in2,
    input in3,
    input[1:0] sel
);
    always @(sel or in0 or in1 or in2 or in3)
        begin
            case(sel)
                2'b00: out=in0;
                2'b01: out=in1;
                2'b10: out=in2;
                2'b11: out=in3;
            endcase
        end
endmodule