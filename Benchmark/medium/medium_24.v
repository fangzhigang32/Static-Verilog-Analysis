module medium_24(
    input even_bit,
    output odd_bit,
    input input_bus
  );
    assign odd_bit = ^input_bus;
    assign even_bit = ~input_bus;
endmodule