module medium_19(
    output out,
    input sel,
    input a,
    input b
  );;
    assign out=(sel==0)?a:b;
endmodule