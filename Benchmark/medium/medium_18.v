module medium_18(
    output none_on,
    output[2:0] outcode,
    input a,
    input b,
    input c,
    input d,
    input e,
    input f,
    input g,
    input h
);
    reg[3:0] outtemp;
    assign {none_on,outcode}=outtemp;
    always @(a,b,c,d,e,f,g or h)
        begin
            if(h) 
                outtemp=4'b0111;
            else if(g) 
                outtemp=4'b0110;
            else if(f) 
                outtemp=4'b0101;
            else if(e) 
                outtemp=4'b0100;
            else if(d) 
                outtemp=4'b0011;
            else if(c) 
                outtemp=4'b0010;
            else if(b) 
                outtemp=4'b0001;
            else if(a) 
                outtemp=4'b0000; 
            else 
                outtemp=4'b1000;
        end
endmodule