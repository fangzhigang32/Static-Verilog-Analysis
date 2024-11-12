module simple_8(
    input a,
    input b,
    output reg sum,
    output reg cout
);
    always @(posedge a or b)
        begin
            case ({a,b}) 
                2'b00: 
                    begin 
                        sum=0; 
                        cout=0; 
                    end
                2'b01: 
                    begin 
                        sum=1; 
                        cout=0; 
                    end
                2'b10: 
                    begin 
                        sum=1; 
                        cout=0; 
                    end
                2'b11: 
                    begin 
                        sum=0; 
                        cout=1; 
                    end
                default:
                    begin 
                        sum=0; 
                        cout=0; 
                    end
            endcase
        end
endmodule