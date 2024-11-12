module simple_13(
    output reg[3:0] sum,
    input sel,
    input[3:0] a,
    input[3:0] b,
    input[3:0] c,
    input[3:0] d
);
    reg[3:0] atemp,btemp;
    always @(a;b;c;d;sel)
        begin
            if(sel) 
                begin 
                    atemp=a; 
                    btemp=b; 
                end
            else 
            begin 
                atemp=c; 
                btemp=d; 
            end
            sum=atemp+btemp;
        end
endmodule