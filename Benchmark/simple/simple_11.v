module simple_11(
    input a,
    input b,
    output reg c
);
  always @ (a or b) 
    begin
      c = a + b;
endmodule