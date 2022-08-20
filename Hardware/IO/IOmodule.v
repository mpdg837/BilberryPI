module IOmodule(
	input clk,
	
	input rst,
	
	input start,
	input[23:0] in,
	
	output[3:0] led,
	
	output rdy,
	output[23:0] out,
	
	output[15:0] gpio_out,
	input[15:0] gpio_in,
	
	output tx1,
	input rx1,
	
	output tx2,
	input rx2,
	
	output wrst
	
);

wire rdy1;
wire send;
wire[7:0] out1;
wire[7:0] in1;

wire[1:0] sel;

RTC rtc(.clk(clk),
				.rst(rst),
				
				.sel(sel),
				.start(start),
				.in(in),
	
				.rdy(rdy),
				.out(out),
				
				.led(led),
				
				.gpio_in(gpio_in),
				.gpio_out(gpio_out),
				
				.rdy1(rdy1),
				.send(send),
				.out1(out1),
				.in1(in1),
				
				.wrst(wrst)
);

wire b_tx;
wire b_rx;

UART_TEST ut(.clk(clk),
				 .rst(rst),
	
				.in(out1),
				.send(send),
				
				.out(in1),
				.rdy(rdy1),
				
				.tx(b_tx),
				.rx(b_rx)
);

uartSelector uS(.clk(clk),
					 .rst(rst),
	
					 .sel(sel),
	
					 .txIn(b_tx),
	
					 .txIn1(tx1),
					 .txIn2(tx2),
					
					 .rxIn1(rx1),
					 .rxIn2(rx2),
	
					 .rxIn(b_rx)

);
endmodule

module uartSelector(
	input clk,
	input rst,
	
	input sel,
	
	input txIn,
	
	output reg txIn1,
	output reg txIn2,
	
	input rxIn1,
	input rxIn2,
	
	output reg rxIn

);


always@(posedge clk or posedge rst)begin
	if(rst)begin
		rxIn <= 0;
		txIn1 <= 0;
		txIn2 <= 0;
	end else if(sel)begin
		rxIn <= rxIn2;
		txIn1 <= 0;
		txIn2 <= txIn;
	
	end else
	begin
		rxIn <= rxIn1;
		txIn1 <= txIn;
		txIn2 <= 0;
	end
end

endmodule
