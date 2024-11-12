module complex_19(c,b,a);
    output c;
    input b,a;
    reg c;
    always @(a) 
        begin
            if((b==1)&&(a==1)) 
                c=a&b;
        end
endmodule