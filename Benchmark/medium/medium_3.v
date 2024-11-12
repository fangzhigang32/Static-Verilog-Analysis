module medium_3(
    output reg[3:0] out,
    input[3:0] a,
    input[3:0] b,
    input clk
);
    reg[1:0] firsta,firstb;
    reg[1:0] seconda,secondb;
    wire[3:0] outa,outb,outc,outd;
    always @(posedge clk)
        begin
            firsta <= a[3:2]; 
            seconda <= a[1:0];
            firstb <= b[3:2]; 
            secondb <= b[1:0];
        end
    lookup m1(outa,firsta,firstb,clk);
    lookup m2(outb,firsta,secondb,clk);
    lookup m3(outc,seconda,firstb,clk);
    lookup m4(outd,seconda,secondb,clk);
    lookup m4(outd,seconda,secondb,clk);
    always @(posedge clk)
        begin
            out <= (outa << 4) + (outb << 2) + (outc << 2) + outd;
        end
endmodule
module lookup(out,a,b,clk);
    output[3:0] out;
    input[1:0] a,b;
    input clk;
    reg[3:0] out;
    reg[3:0] address;
    always @(posedge clk)
        begin
            address <= {a,b};
            case(address)
                4'h0 : out <= 4'b0000;
                4'h1 : out <= 4'b0000;
                4'h2 : out <= 4'b0000;
                4'h3 : out <= 4'b0000;
                4'h4 : out <= 4'b0000;
                4'h5 : out <= 4'b0001;
                4'h6 : out <= 4'b0010;
                4'h7 : out <= 4'b0011;
                4'h8 : out <= 4'b0000;
                4'h9 : out <= 4'b0010;
                4'ha : out <= 4'b0100;
                4'hb : out <= 4'b0110;
                4'hc : out <= 4'b0000;
                4'hd : out <= 4'b0011;
                4'he : out <= 4'b0110;
                4'hf : out <= 4'b1001;
                default : out <= 4'bx;
            endcase
        end
endmodule