module complex_20( 
    input wire [7:0] A, 
    input wire [7:0] B, 
    input wire [7:0] C, 
    input wire [7:0] D,
    output wire [7:0] F
  );
    assign F = ~((A[0] & B[0]) | (C[0] & D[0])); 
endmodule
