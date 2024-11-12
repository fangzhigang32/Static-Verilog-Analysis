module medium_11(
    output out,
    input A, 
    input B,
    input opt
  );
    calculate calculate_1 (out,.A(A),.B(B),.opt(opt));
endmodule
module calculate(out,A,B,opt);
    output out;
    input A,B;
    input opt;
    assign out = opt ? (A + B) : (A - B);
endmodule