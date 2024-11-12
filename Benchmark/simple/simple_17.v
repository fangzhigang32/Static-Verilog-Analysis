module simple_17(
    output [7:0] common_bus
);
    reg [7:0] bus_driver1, bus_driver2;
    assign common_bus = bus_driver1;
    assign common_bus = bus_driver2;
    initial begin
        bus_driver1 = 8'hA5;  
        bus_driver2 = 8'h5A; 
    end
endmodule