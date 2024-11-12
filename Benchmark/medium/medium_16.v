module medium_16(
    output reg out,
    input a,
    input b,
    input sel
);
    always @(a || b || sel)
        begin
            if(sel) 
                out = b;
            else 
                out = a;
        end
endmodule