module complex_14(
    input [3:0] a, 
    input b,
    output [7:0] out
);
    sub_module uut (.in1(a), .in2(b), .out(out));
endmodule
module sub_module (
    input  [3:0] in1,
    input  [1:0] in2, 
    output [7:0] out 
    );
    assign out = in1 + in2;
endmodule
