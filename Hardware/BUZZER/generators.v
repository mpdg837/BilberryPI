
module generatorSin(
	input clk,
	input rst,
	
	input freq,
	input[15:0] f_time,
	
	output reg[15:0] out,
	output reg start
);


reg[7:0] memory[255:0];

reg[15:0] f_tim;
reg[15:0] n_tim;

reg[15:0] f_out;
reg[15:0] b_out;

reg b_start;

reg signed[15:0] b_val;
reg signed[15:0] b_pow;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= b_out;
	
always@(*)begin
	b_out = f_out;
	n_tim = f_tim;
	b_start = 0;
	
	b_val = 0;
	b_pow = 0;
	
	if(freq)begin
		n_tim = f_tim + f_time;
		
		if(f_tim[15])begin
			b_pow = (f_tim[15:8] - 191);
			b_val = (b_pow * b_pow) >> 5;
		end else begin
			b_pow = (f_tim[15:8] - 63);
			b_val = 255 - ((b_pow * b_pow) >> 5);
		end
		
		b_out = {b_val,8'b0};
		b_start = 1;
	end
	
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		out <= 0;
		start <= 0;
	end
	else begin
		out <= b_out;
		start <= b_start;
	end
end

endmodule





module generatorNoi(
	input clk,
	input rst,
	
	input freq,
	input[15:0] f_time,
	
	output reg[15:0] out,
	output reg start
);

reg[15:0] f_tim;
reg[15:0] n_tim;

reg[15:0] f_out;

reg[31:0] f_rand = 32'b10101010101010101010101010101010;
reg[31:0] n_rand = 32'b10101010101010101010101010101010;

reg f_r;

reg n_l_tim;
reg f_l_tim;

always@(posedge clk or posedge rst)
	if(rst) f_l_tim <= 0;
	else f_l_tim <= n_l_tim;

always@(posedge clk or posedge rst)
	if(rst) f_rand <= 32'b10101010101010101010101010101010;
	else f_rand <= n_rand;

always@(*)begin
	n_l_tim = f_l_tim;
	n_rand = f_rand;
	f_r = 0;
	
	if( f_tim[15] && (~f_l_tim)) begin
	
		f_r =f_rand[14] ^ f_rand[12] ^ f_rand[10] ^ f_rand[0];
		n_rand = {n_rand[30:0],f_r};
		
	end
	
	n_l_tim = f_tim[15];
end

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;
	
always@(*)begin
	out = f_out;
	n_tim = f_tim;
	start = 0;
	
	if(freq)begin
		n_tim = f_tim + f_time;
		out = {f_rand[15:0]};
		start = 1;
	end
	
end

endmodule





module generatorSqu(
	input clk,
	input rst,
	
	input freq,
	input[15:0] f_time,
	
	output reg[15:0] out,
	output reg start
);

reg[15:0] f_tim;
reg[15:0] n_tim;

reg[15:0] f_out;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;
	
always@(*)begin
	out = f_out;
	n_tim = f_tim;
	start = 0;
	
	if(freq)begin
		n_tim = f_tim + f_time;
		out = {f_tim[15],15'b0};
		start = 1;
	end
	
end

endmodule


module generatorTria(
	input clk,
	input rst,
	
	input freq,
	input[15:0] f_time,
	
	output reg[15:0] out,
	output reg start
);

reg[15:0] f_tim;
reg[15:0] n_tim;

reg[15:0] f_out;

reg[7:0] f_count;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;
	
always@(*)begin
	out = f_out;
	n_tim = f_tim;
	start = 0;
	
	f_count = 0;
	
	if(freq)begin
		n_tim = f_tim + f_time;
		
		if(f_tim[15])begin
			f_count = 7'd255 - (f_tim[15:8]);
			out = {f_count[6:0],9'b0};
		end else begin
			out = {f_tim[14:8],9'b0};
		end
		
		start = 1;
	end
	
end

endmodule

module generatorSaw(
	input clk,
	input rst,
	
	input freq,
	input[15:0] f_time,
	
	output reg[15:0] out,
	output reg start
);

reg[15:0] f_tim;
reg[15:0] n_tim;

reg[15:0] f_out;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;
	
always@(*)begin
	out = f_out;
	n_tim = f_tim;
	start = 0;
	
	if(freq)begin
		n_tim = f_tim + f_time;
		
		out = {f_tim[15:8],8'b0};
		start = 1;
	end
	
end

endmodule
