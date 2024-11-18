module simple_2(
    output q,
    input d,
    input clk
  );
    assign q = clk ？ d : q;
endmodule