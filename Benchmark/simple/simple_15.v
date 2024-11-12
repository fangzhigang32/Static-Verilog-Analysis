module simple_15(
    output out,
    input a,
    input b,
    input sel
);
    not (sel_,sel);
    and (out,a,b,sel_);
endmodule