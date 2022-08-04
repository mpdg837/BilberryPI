
module buffspi(
	input clk,
	input rst,
	
	input[7:0] in,
	output reg[7:0] b_in,
	
	input start,
	output reg b_start
);

always@(posedge clk or posedge rst)begin
	if(rst)begin
		b_in <= 0;
		b_start <= 0;
	end
	else begin
		b_in <= in;
		b_start <= start;
	end
end


endmodule

module spi(
	input clk,
	input rst,
	
	input csz,
	
	input[7:0] in,
	input start,
	output reg ready,
	
	output reg[7:0] out,
	
	input mosi,
	
	output reg cs,
	output reg miso,
	output reg sck
	
);

wire[7:0] b_in;
wire b_start;

buffspi bs(
	.clk(clk),
	.rst(rst),
	
	.in(in),
	.b_in(b_in),
	
	.start(start),
	.b_start(b_start)
);

reg f_sck = 0;
reg f_miso = 0;

reg[7:0] f_mem = 0;
reg[7:0] mem = 0;

reg[4:0] f_tim = 0;
reg[4:0] tim = 0;

reg[7:0] f_out = 0;
	always@(posedge clk or posedge rst)
	begin
		if(rst)begin
			f_sck <= 0;
			f_miso <= 0;
			f_tim <= 0;
			f_mem <= 0;
			f_out <= 0;
		
		end else
		begin
			f_sck <= sck;
			f_miso <= miso;
			f_tim <= tim;
			f_mem <= mem;
			f_out <= out;
		end
	end

	always@(*)begin
		
		sck = f_sck;
		if(csz) cs = 1;
		else cs = 0;
		miso = f_miso;
		tim = f_tim;
		mem = f_mem;
		out = f_out;
		
		ready = 0;
		
		if(b_start)begin
			mem = b_in;
			out = 0;
			sck = 0;
			tim = 8;
			miso = b_in[7];
		end else
		if(f_tim != 0) begin
		
			sck = ~f_sck;
			
			if(sck && ~f_sck)begin
				out = {f_out[6:0],mosi};
			end
			
			if(f_sck)begin
			
				if(f_tim >=2) begin
					tim = f_tim - 1;
					miso = f_mem[f_tim - 2];
					
				end else if(f_tim == 1)
				begin
					ready = 1;
					miso = 1;
					tim = 0;
				end
			end
			
		end else begin
			sck = 0;
			miso = 1;
		end

	end

endmodule


module dclk(
	input clk,
	input rst,
	
	output reg dclk = 0
);

localparam tima = 6;

reg f_dclk = 0;

reg[tima:0] f_tim = 0;
reg[tima:0] n_tim = 0;
 
always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_tim <= 0;
		dclk <= 0;
	end
	else begin
		f_tim <= n_tim;
		dclk <= f_dclk;
	end
end
	
always@(*)begin
	n_tim = f_tim + 1;
	f_dclk = dclk;
	
	if(f_tim == 0)begin
		f_dclk = ~dclk;
	end
		
end


endmodule
