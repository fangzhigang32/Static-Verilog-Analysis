module medium_15(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [7:0] c,
    input wire [1:0] select,
    output reg [7:0] z 
);
	always @(*) begin
		if(select == 2'b00) begin
			z = a;
		end else if(select == 2'b01) begin
			z = b;
		end else if(select == 2'b10) begin
			z = c;
		end else begin
			z = 8'bZZ;
		end
	end
endmodule