module complex_30(
    output reg [6:0] c,
    output [6:0] y,
    input clk
);
    reg[6:0] c_buf;
    reg[6:0] buffer;
    reg temp;
    reg s0,s1,s2;
    reg e;
    integer i;
    always @(posedge clk)
        begin
            s0=0; s1=0; s2=0; 
            temp=0;
            buffer=y; 
            for (i=6;i>=0;i=i-1) 
                begin
                    e=s0&(~s1)&temp;
                    temp=s2;
                    s2=s1;
                    s1=s0^temp;
                    s0=y[i]^temp^e;
                end
            for (i=6;i>=0;i=i-1) 
                begin
                    e=s0&(~s1)&temp;
                    temp=s2;
                    s2=s1;
                    s1=s0^temp;
                    s0=temp^e;
                    c_buf[i]=buffer[i]^e;
                    if (e==1) 
                        begin
                            s0=0; s1=0; s2=0;
                        end
                end
        end
    always @(posedge clk)
        begin
            c<=c_buf;
        end
endmodule