module simple_25(
    input clk,
    input clr,
    input start,
    input step2,
    input step3,
    output reg[2:0] out
);
    reg[1:0] state,next_state;
    parameter state0=2'b00,state1=2'b01,
    state2=2'b11,state3=2'b10;
    always @(posedge clk or posedge clr or state) 
        begin
            if (clr) 
                state <= state0;
            else 
                state <= next_state;
        end
    always @(state or start or step2 or step3) 
        begin 
            case (state)
                state0: 
                    begin
                        if (start) 
                            next_state = state1;
                        else 
                            next_state = state0;
                    end
                state1: 
                    begin
                        next_state = state2;
                    end
                state2: 
                    begin
                        if (step2) 
                            next_state = state3;
                        else 
                            next_state = state0;
                    end
                state3: 
                begin
                    if (step3) 
                        next_state = state0;
                    else 
                        next_state = state3;
                end
                default: next_state = state0; 
            endcase
        end
    always @(state) 
        begin
            case(state)
                state0: out=3'b001;
                state1: out=3'b010;
                state2: out=3'b100;
                state3: out=3'b111;
                default:out=3'b001; 
            endcase
        end
endmodule