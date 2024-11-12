module complex_2(
    input a,
    input b,
    input sel,
    output reg out
);
    always@(a | b | sel)
        begin
            if(sel==0) 
                out=a; 
            else 
                out=b;
        end
endmodule