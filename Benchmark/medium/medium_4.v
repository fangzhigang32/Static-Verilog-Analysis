module medium_4(
    input clk,         
    input rst_n,       
    input start,      
    input [15:0] ain,  
    input [15:0] bin,  
    output [31:0] yout,
    output done      
);
reg [15:0] areg;    
reg [15:0] breg;   
reg [31:0] yout_r;  
reg done_r;
reg [4:0] i;       
always @(posedge clk or negedge rst_n)
    if (!rst_n) i <= 5'd0;
    else if (start && i < 5'd17) i <= i + 1'b1; 
    else if (!start) i <= 5'd0;
always @(posedge clk or negedge rst_n)
    if (!rst_n) done_r <= 1'b0;
    else if (i == 5'd16) done_r <= 1'b1; 
    else if (i == 5'd17) done_r <= 1'b0; 
assign done = done_r;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
        areg <= 16'h0000;
        breg <= 16'h0000;
        yout_r <= 32'h00000000000000000000000000000000;
    end
    else if (start) begin
        if (i == 5'd0) begin 
            areg <= ain;
            breg <= bin;
        end
        else if (i > 5'd0 && i < 5'd17) begin
            if (areg[i-1]) 
            yout_r <= yout_r + ({16'h0000, breg} << (i-1));
        end
    end
end
assign yout = yout_r;
endmodule