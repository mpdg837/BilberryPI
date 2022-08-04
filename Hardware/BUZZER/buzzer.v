module Buzzer16(
	input clk,
	input rst,
	
	input start,
	input[23:0] in,
	
	output sound
);

wire[5:0] ssound;
wire[1:0] vol;


wire[2:0] nsound;

wire finish;

buzzerMan bMan(.clk(clk),
			 .rst(rst),
	
			 .in(in),
			 .start(start),
			 
			 .vol(vol),
			 .sig(ssound)
);


wire[1:0] tt;
wire snd1;
wire ff;

generator gen1(
	.clk(clk),
	.rst(rst),
	.tt(tt),
	.sound(ssound),
	.snd(snd1),
	
	.finish(finish)
);


wire snd = snd1;


volumer volx(
	.clk(clk),
	.rst(rst),
	.vol(vol),
	
	.tt(tt),
	.ff(ff)
);

wire insnd;

bufferconnector bc(
	.clk(clk),
	
	.snd(snd),
	
	.ff(ff),
	
	.sound(insnd)
);

singleBuffer sB(
	.clk(clk),
	.insnd(insnd),
	.snd(sound)
);
endmodule

module singleBuffer(
	input clk,
	input insnd,
	output reg snd
);

always@(posedge clk)
	snd <= insnd;
	
endmodule


module buzzerMan(
	input clk,
	input rst,
	
	input[23:0] in,
	input start,

	output reg[2:0] nsound,
	output reg startnoise,	
	
	output[1:0] vol,
	output reg[5:0] sig
);
reg[1:0] vvol = 3;
reg[5:0] f_sig;
reg[1:0] f_vol=3;

reg[19:0] f_tim;
reg[19:0] n_tim;

reg f_p;
reg n_p;

localparam NOP = 8'd0;
localparam SET = 8'd1;
localparam STOP = 8'd2;
localparam VOL = 8'd3;
localparam NOISE = 8'd4;
localparam PEAK = 8'd5;
localparam PEAKL = 8'd6;

always@(posedge clk or posedge rst)
	if(rst) begin
		f_sig <= 0;
		f_vol <= 3;
		f_tim <= 0;
		end
	else begin
		f_tim <= n_tim;
		f_sig <= sig;
		f_vol <= vvol;
		end

always@(*)begin
	n_tim = f_tim;
	
	if(f_tim != 0) n_tim = f_tim + 1;
	
	if(in[23:16] == PEAK) n_tim = 1;
end
		
always@(*)begin
	sig = f_sig;
	vvol = f_vol;
	
	nsound = 0;
	startnoise = 0;
	
	if(f_tim ==18'hFFFFFFFF) sig = 0;
	
	case(in[23:16])
		NOP:;
		SET: begin
			sig = in[5:0];
			nsound = 0;
			startnoise = 1;
			end
		STOP: begin
			sig = 0;
			nsound = 0;
			startnoise = 1;
			end
		VOL: vvol = in[1:0];
		NOISE: begin
			sig = 0;
			nsound = in[2:0];
			startnoise = 1;
		end
		PEAK: begin
			sig = in[5:0];
			nsound = 0;
			startnoise = 1;
		end
		default:;
	endcase
end

assign vol = f_vol;
endmodule


module bufferconnector(
	input clk,
	input snd,
	
	input ff,
	
	output reg sound
);

always@(posedge clk)begin
	sound <= snd | ff;
end

endmodule

module volumer(
	input clk,
	input rst,
	input[1:0] vol,
	
	input[1:0] tt,
	
	output reg ff
);

reg f_ff;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_ff <= 0;
		end
	else begin
		f_ff <= ff;
		end
end

always@(*)begin
	ff = f_ff;
	
	case(vol)
		0: ff = 1;
		1: ff = tt[0];
		2: ff = tt[0] & tt[1];
		3: ff = 0;
	endcase
end

endmodule

module generator(
	input clk,
	input rst,
	
	input[5:0] sound,
	
	output[1:0] tt,
	output snd,
	
	output reg finish
);


reg n_snd;
reg f_snd;

reg[17:0] tim;
reg[17:0] f_tim;

reg[5:0] ssound;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_tim <= 0;
		f_snd <= 0;
		end
	else begin
		f_tim <= tim;
		f_snd <= n_snd;
		end
end

always@(posedge clk)
	if(sound == 0 || sound == 63) ssound <= 0;
	else ssound <= sound;


always@(*) begin
	tim = f_tim + 1;
	n_snd = f_snd;
	finish = 0;
	
	if(sound == 0) n_snd = 1;
	else begin
		if(f_tim[17:11] == {ssound})begin
			tim = 0;
			finish = 1;
		end
		else
		if(f_tim[17:15] == 0 && f_tim[14:8] <= (sound))begin
			n_snd = 0;
		end else
		begin
			n_snd = 1;
		end
	end 
	
	
end

assign tt = f_tim[1:0];
assign snd = f_snd;
endmodule

