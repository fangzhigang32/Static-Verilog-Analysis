module complex_17(
    output reg out,
    input in1,
    input in2,
    input in3,
    input in4,
    input cntrl1,
    input cntrl2
 );
    wire cntrl3;
    always@(in1 or in2 or in3 or in4 or cntrl1 or cntrl2 or cntrl3)
        case({cntrl1,cntrl2})
            2'b00:out=in1;
            2'b01:out=in2;
            2'b10:out=in3;
            2'b11:out=in4;
            default:out=in1;
        endcase
    assign cntrl3 = out;
endmodule