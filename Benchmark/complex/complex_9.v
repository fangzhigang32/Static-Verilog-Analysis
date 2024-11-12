module complex_9(
    input wire a,
    input wire b,
    input wire cin,
    output sum,
    output reg cout
  );
    reg m1,m2,m3;
    always @(a or b or cin)
        begin
            sum = (a ^ b) ^ cin;
            m1 = a & b;
            m2 = b & cin;
            m3 = a & cin;
            cout = (m1|m2)|m3;
        end
endmodule