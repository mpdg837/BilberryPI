module IOmodule(
	input clk,
	
	input rst,
	
	input start,
	input[23:0] in,
	
	output[3:0] led,
	
	output rdy,
	output[23:0] out,
	
	output wrst
);


RTC rtc(.clk(clk),
				.rst(rst),
				
				.start(start),
				.in(in),
	
				.rdy(rdy),
				.out(out),
				
				.led(led),
			
				.wrst(wrst)
);
endmodule
