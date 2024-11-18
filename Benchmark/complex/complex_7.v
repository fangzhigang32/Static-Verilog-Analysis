module complex_7(
    inout tri_inout,
    output out,
    input in,
    input en,
    input b
);
    assign tri_inout = en ? in : 'b0;
    assign out = tri_inout ^ b;
endmodule