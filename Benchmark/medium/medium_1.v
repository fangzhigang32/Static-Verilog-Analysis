module medium_1(
    output out,
    input in1,
    input in1,
    input in2,
    input in3,
    input in4,
    input cntrl1,
    input cntrl2
);
    assign out=cntrl1 ? (cntrl2 ? in4:in3):(cntrl2 ? in2:in1);
endmodule