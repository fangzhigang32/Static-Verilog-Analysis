module simple_27(
      input wire clk, 
      input wire reset,
      output reg out
); 
   always @(posedge clk or posedge reset) 
   begin  
      if(reset)    
         out <= 0; 
      else   
         out <= 1; 
   end 
   always @(posedge clk) 
      out <= ~out; 
endmodule