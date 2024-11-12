module simple_16(
    output reg out,
    input a,
    input b,
    input c,
    input d,
    input[3:0] select
);
    always @(select or a or b or c)
        begin
            casez(select)
                4'b0001: out = a;
                4'b0010: out = b;
                4'b0100: out = c;
                4'b1000: out = d;
                default : out = d;
            endcase
        end
endmodule