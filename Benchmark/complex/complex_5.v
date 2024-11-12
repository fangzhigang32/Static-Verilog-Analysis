module complex_5(
	input wire clk,
	input wire rst_n,
	input wire [3:0] cell,
	output wire valid_out,
	output wire dout
	);
	reg [3:0] data;
	reg [1:0] cnt;
	reg valid;
	assign dout = data[3];
	assign valid_out = valid;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			begin
				data<= 4'd0;
				cnt <= 2'd0;
				valid <= 1'd0;
			end
		else  
			begin		
				if (cnt == 2'd3) 
					begin
						data <= cell;
						cnt <= 2'd0;
						valid <= 1;
					end
				else 
					begin
						cnt <= cnt + 2'd1;
						valid <= 0;
						data  <= {data[2:0],data[3]};
					end
			end
	end
endmodule