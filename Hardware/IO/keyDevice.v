module keyDevice(
	input clk,
	input rst,
	
	input tclk,
	
	input krst,
	
	input in1,
	input in2,
	input in3,
	input in4,
	
	output irq,
	
	output[31:0] out
	
);

wire pin1;
wire pin2;
wire pin3;
wire pin4;
wire pin5;

keyrst k1(.mode(0),
			.in(in1),
			.rst(rst),
			.clk(tclk),
			.rspress(pin1)
);

keyrst k2(.mode(0),
			.in(in2),
			.clk(tclk),
			.rst(rst),
			.rspress(pin2)
);

keyrst k3(.mode(0),
			.in(in3),
			.clk(tclk),
			.rst(rst),
			.rspress(pin3)
);

keyrst k4(.mode(0),
			.in(in4),
			.clk(tclk),
			.rst(rst),
			.rspress(pin4)
);


wire[7:0] timer;

keyMan kM(.clk(clk),
			 .rst(rst),
			 
			 .irq(irq),
			 
			 .in({1'b0,~pin4,~pin3,~pin2,~pin1}),
	
			 .out(out),
			 .tim(timer)
);

endmodule

module timerInDevice(
	input clk,
	input rst,
	
	output[7:0] out
);

reg[11:0] n_out;
reg[11:0] f_out;
always@(posedge clk or posedge rst) begin
	if(rst) f_out <= 0;
	else f_out <= n_out;
end

always@(*)begin
	if(f_out == 255) n_out = 255;
	else n_out = f_out + 1;
end

assign out = f_out[11:4];
endmodule

module keyMan(
	input clk,
	
	input rst,
	
	input[4:0] in,
	input[7:0] tim,
	
	output reg irq,
	
	output reg[31:0] out
);

reg iirq;

reg[4:0] f_key;
reg[4:0] n_key;

reg[21:0] f_tim;
reg[21:0] n_tim;

reg[31:0] f_out;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_out <= 0;
		f_key <= 0;
		f_tim <= 0;
	end else
	begin
		f_out <= out;
		f_key <= n_key;
		f_tim <= n_tim;
	end
end

	
always@(*)begin
	
	out = f_out;
	n_key = f_key;
	n_tim = f_tim;
	
	iirq =0;
	
	if(f_tim != 0) begin
		n_tim = f_tim - 1;
	end
	
	if(in == 0 && f_tim == 0) begin
		n_key = 0;
	end
	
	if(in != 0) begin
	
		if(f_key == in) n_tim = {4'd15,18'b0};
		
		if(f_key != in && f_tim == 0) begin
			n_key = in;
			n_tim = {4'd15,18'b0};
			iirq = 1;
			out = {8'd1,8'd0,8'd0,3'b0,in};
		end
			
		
	end
	
end

always@(posedge clk or posedge rst)
	if(rst) irq <= 0;
	else irq <= iirq;
	
endmodule

module keyrstmodule(
	input clk,
	input in,
	input tclk,
	
	output rst
);

keyrst k1(.mode(0),
			.in(in),
			.clk(tclk),
			.rspress(irst)
);

assign rst = ~irst;

endmodule



