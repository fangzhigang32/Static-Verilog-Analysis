module complex_28 (
  input clk, 
  input reset,
  input [7:0] a, 
  input [15:0] b,
  output reg[15:0] p,
  output reg rdy
);
  reg [15:0] multiplier;
  reg [15:0] multiplicand;
  reg [4:0] ctr;
  always @(posedge clk or posedge reset) 
    begin
        if (reset) 
          begin
            rdy <= 0;
            p <= 0;
            ctr <= 0;
            multiplier <= {{8{a[7]}}, a[7:0]};
            multiplicand <= {{8{b[7]}}, b[7:0]};
          end 
        else 
          begin 
            if(ctr < 16) 
                begin
                  multiplicand <= multiplicand << 1;
                  if (multiplier[ctr] == 1)
                    begin
                        p <= p + multiplicand;
                    end
                  ctr <= ctr + 1;
                end
            else 
                begin
                  rdy <= 1;
                end
          end
    end
endmodule