module Buzzer16(
	input clk,
	input rst,
	
	input start,
	input[23:0] in,
	
	output[7:0] sound,
	
	// DMA
	output[15:0] addrDMA,
	output startDMA,
	
	input[15:0] inDMA,
	input rdyDMA,
	
	output [15:0] toSaveDMA,
	output wDMA
);

wire startT;

wire[5:0] soundType;
wire[1:0] soundVol;
wire[2:0] genType;

wire startT1;

wire[5:0] soundType1;
wire[1:0] soundVol1;
wire[2:0] genType1;

wire startT2;

wire[5:0] soundType2;
wire[1:0] soundVol2;
wire[2:0] genType2;

wire[2:0] vol;

wire loopSample;

buzzerMan bMan(.clk(clk),
			 .rst(rst),
	
			 .in(in),
			 .start(start),
			 
			 .vol(vol),
			 .soundType(soundType),
			 .soundVol(soundVol),
			 .genType(genType),
			 .startT(startT),
			 
			 .soundType1(soundType1),
			 .soundVol1(soundVol1),
			 .genType1(genType1),
			 .startT1(startT1),
			 
			 .soundType2(soundType2),
			 .soundVol2(soundVol2),
			 .genType2(genType2),
			 .startT2(startT2)
			 
			 
);

wire freq;

sampling_freq fre(.clk(clk),
						.rst(rst),
						
						.freq(freq)
);

wire[15:0] soundX;
wire startX;

wire[15:0] soundXX;
wire startXX; 

wire[15:0] soundXXX;
wire startXXX; 

soundGen gen1(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
	
					// NoteGen
				  .genType(genType),
				  .soundType({soundVol,soundType}),
				  .startT(startT),

				  
				  .soundOut(soundX),
				  .startO(startX),

);

soundGen gen2(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
	
					// NoteGen
				  .genType(genType1),
				  .soundType({soundVol1,soundType1}),
				  .startT(startT1),
	
				  .soundOut(soundXX),
				  .startO(startXX),

);

soundGenSimple gen3(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
	
					// NoteGen
				  .genType(genType2),
				  .soundType({soundVol2,soundType2}),
				  .startT(startT2),
	
				  .soundOut(soundXXX),
				  .startO(startXXX),

);

wire[15:0] soundO;
wire startO;

soundSuming sum(.clk(clk),
					 .rst(rst),	
	
					.soundX(soundX),
					.startX(startX),

					.soundXX(soundXX),
					.startXX(startXX),	
					
					.soundXXX(soundXXX),
					.startXXX(startXXX),	
					
					.soundO(soundO),
					.startO(startO)	
);

wire pwm;
sigmaDelta#(.sizeBuffer(16))
		  sig1(.clk(clk),
				.rst(rst),
	
				.sound(soundO),
				.start(startO),
	
				.pwm(pwm)
);


wire[7:0] ppwms = {pwm,pwm,pwm,pwm,pwm,pwm,pwm,pwm};
wire[7:0] pwms;

volumer volume(.clk(clk),
				.rst(rst),
	
				.pwm(ppwms),
				.volume(vol),
	
				.pwms(sound)

);

endmodule

module soundSuming(
	input clk,
	input rst,	
	
	input[15:0] soundX,
	input startX,

	input[15:0] soundXX,
	input startXX,	
	
	input[15:0] soundXXX,
	input startXXX,	
	
	output reg[15:0] soundO,
	output reg startO
);

reg[15:0] f_sound1;
reg[15:0] n_sound1;

reg[15:0] f_sound2;
reg[15:0] n_sound2;

reg[15:0] f_sound3;
reg[15:0] n_sound3;

always@(posedge clk or posedge rst)
	if(rst) f_sound1 <= 0;
	else f_sound1 = n_sound1;

always@(posedge clk or posedge rst)
	if(rst) f_sound2 <= 0;
	else f_sound2 = n_sound2;

always@(posedge clk or posedge rst)
	if(rst) f_sound3 <= 0;
	else f_sound3 = n_sound3;

always@(*)begin
	n_sound1 = f_sound1;
	
	if(startX) n_sound1 = soundX;
end

always@(*)begin
	n_sound2 = f_sound2;
	
	if(startXX) n_sound2 = soundXX;
end

always@(*)begin
	n_sound3 = f_sound3;
	
	if(startXXX) n_sound3 = soundXXX;
end

reg b_start;

always@(posedge clk or posedge rst)
	if(rst) b_start = 0;
	else b_start = startX | startXX | startXXX;

always@(*)begin
	
	soundO = 0;
	startO = 0;
	
	if(b_start) begin
		soundO = f_sound1 + f_sound2 + f_sound3;
		startO = 1;
	
	end
	
end

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
	
	output reg[2:0] vol = 7,
	
	// NoteGen
	
	output reg startT,
	output reg[5:0] soundType,
	output reg[1:0] soundVol,
	output reg[2:0] genType,

	output reg startT1,
	output reg[5:0] soundType1,
	output reg[1:0] soundVol1,
	output reg[2:0] genType1,

	output reg startT2,
	output reg[5:0] soundType2,
	output reg[1:0] soundVol2,
	output reg[2:0] genType2,

	
	// Sampler
	output reg startSample,
	output reg[15:0] addrSample,
	output reg[15:0] speedSample,
	output reg stopSample,
	output reg loopSample
);


reg[2:0] f_vol = 7;

reg[2:0] f_genType;
reg[2:0] f_genType1;
reg[2:0] f_genType2;

reg[2:0] f_playSample;

localparam NOP = 8'd0;
localparam NOTE = 8'd1;
localparam STOP = 8'd2;
localparam VOL = 8'd3;

localparam SAMPLE = 8'd4;
localparam SPEED = 8'd5;
localparam STOPSAMPLE = 8'd6;
localparam LOOP = 8'd9;

localparam SOUND = 8'd7;
localparam SOUNDVOL = 8'd8;

always@(posedge clk or posedge rst)
	if(rst) begin
		f_vol <= 7;
		f_genType <= 0;
		f_genType1 <= 0;
		f_genType2 <= 0;
		end
	else begin
		f_genType <= genType;
		f_genType1 <= genType1;
		f_genType2 <= genType2;
		f_vol <= vol;
		end

		
always@(*)begin
	
	vol = f_vol;
	genType = f_genType;
	genType1 = f_genType1;
	genType2 = f_genType2;
	
	startT = 0;
	startT1 = 0;
	startT2 = 0;
	
	soundType = 0;
	soundType1 = 0;
	soundType2 = 0;

	startSample = 0;
	addrSample = 0;
	speedSample = 0;
	stopSample = 0;
	loopSample = 0;
	
	if(start)
		case(in[23:16])
			NOP:;
			NOTE: begin
			
				case(in[12:11])
					0:begin
						soundType = in[5:0];
						soundVol = in[7:6];
						genType = in[10:8];
							startT = 1;
					end
					1:begin
						soundType1 = in[5:0];
						soundVol1 = in[7:6];
						genType1 = in[10:8];
							startT1 = 1;
					end
					2:begin
						soundType2 = in[5:0];
						soundVol2 = in[7:6];
						genType2 = in[10:8];
							startT2 = 1;
					end
					default:;
				endcase
				
			
				
				end
			STOP: begin
				case(in[1:0])
					0:begin
						soundType = 0;
						startT = 0;
						genType = 0;
					end
					1:begin
						soundType1 = 0;
						startT1 = 0;
						genType1 = 0;
					end
					2:begin
						soundType2 = 0;
						startT2 = 0;
						genType2 = 0;
					end
					default:;
				endcase
				
				end
			VOL: vol = in[2:0];
			
			SAMPLE: begin
				startSample = 1;
				addrSample = in[15:0];
				speedSample = {8'd1,8'd0};
				
				genType = 5;
			end
			STOPSAMPLE: begin
				stopSample = 1;
				
				genType = 0;
			end
			SPEED: begin
				startSample = 1;
				speedSample = in[15:0];
			end
			LOOP: begin
				loopSample = 1;
			end
			
			default:;
		endcase
end

endmodule


