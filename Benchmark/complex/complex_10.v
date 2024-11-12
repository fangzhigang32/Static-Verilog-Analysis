module complex_10(
    input d,
    input clk,
    input set,
    input reset,
    output reg q,
    output reg qn
);
    always @(negedge clk)
        begin
            if (reset) 
                begin 
                    q <= 0; 
                    qn <= 1;
                end
            else if (set) 
                begin
                    q <= 1; 
                    qn <= 0;
                end
            else 
                begin
                    q <= d; 
                    qn <= ~d;
                end
        end
endmodule