module simple_9(
    output reg out,
    input in0,
    input in1,
    input in2,
    input in3,
    input[1:0] sel
);
    always (in0 or in1 or in2 or in3 or sel)
        begin
            if(sel==2'b00) 
                out=in0;
            else if(sel==2'b01) 
                out=in1;
            else if(sel==2'b10) 
                out=in2;
            else 
                out=in3;
        end
endmodule