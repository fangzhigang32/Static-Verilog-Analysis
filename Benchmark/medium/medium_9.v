module medium_9(
    output out,
    input A, 
    input B,
    input opt
    );
    calculate calculate_1 (.out(out),.A(A),.B(B),.opt(opt),.tmp());
endmodule
module calculate(
    output out,
    input A,
    input B,
    input opt,
    output tmp
    );
    assign {tmp,out} = opt ? (A + B) : (A - B);
endmodule