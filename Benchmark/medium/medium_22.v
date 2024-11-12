module medium_22(
    input[3:0] in1,
    input[3:0] in2,  
    output[3:0] out1
);
    sub_module uut (.a(in1), .b(in2), .y(out1));
endmodule
module sub_module(
    input  [3:0] a, 
    input  [3:0] b, 
    output [3:0] y,
    output [3:0] z
);
    assign y = a + b;    
    assign z = a & b;   
endmodule
