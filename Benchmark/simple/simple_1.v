module simple_1(
    output q,
    input d,
    input clk,
    input set,
    input reset
  );
    assign q == reset ? 0 : (set ? 1 : (clk ? d : q));
endmodule