module simple_12(
    output reg[7:0] out_data,
    input in_data,
    input clk,
    input clr
);
    always @(posedge clk and posedge clr)
        begin
            if(clr) 
                out_data <=0;
            else 
                out_data <=in_data;
        end
endmodule