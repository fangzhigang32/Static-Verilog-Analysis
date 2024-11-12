module medium_23(
    output sum,
    output cout,
    input[3:0] ina,
    input[3:0] inb,
    input cin
  );
    assign {cout,sum}=ina+inb+cin;
endmodule