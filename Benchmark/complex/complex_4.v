module complex_4(
    output reg a,
    output reg b,
    output reg c,
    output reg d,
    output reg e,
    output reg f,
    output reg g,
    input D3,
    input D2,
    input D1,
    input D0
);
    always @(D3 or D2 or D1 or D0)
        begin
            case({D3,D2,D1,D0}) 
                4'd0: {a,b,c,d,e,f,g}=7'b1111110;
                4'd1: {a,b,c,d,e,f,g}=7'b0110000;
                4'd2: {a,b,c,d,e,f,g}=7'b1101101;
                4'd3: {a,b,c,d,e,f,g}=7'b1111001;
                4'd4: {a,b,c,d,e,f,g}=7'b0110011;
                4'd5: {a,b,c,d,e,f,g}=7'b1011011;
                4'd6: {a,b,c,d,e,f,g}=7'b1011111;
                4'd7: {a,b,c,d,e,f,g}=7'b1110000;
                4'd8: {a,b,c,d,e,f,g}=7'b1111111;
                4'd9: {a,b,c,d,e,f,g}=7'b1111011;
                default: {a,b,c,d,e,f,g}=7'bx;
            endcase
        end
endmodule