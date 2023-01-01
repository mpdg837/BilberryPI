module Buzzer16(
	input clk,
	input rst,
	
	input start,
	input[23:0] in,
	
	output[7:0] sound,
	
	// DMA
	
	output startDMA,
	output[15:0] addrDMA,
	
	input[15:0] fromMemDMA,
	input rdyDMA
);

wire startSample2;
wire[15:0] addrSample2;
wire stopSample2;
wire[15:0] speedSample2;
wire loopSample2;

wire startSample1;
wire[15:0] addrSample1;
wire stopSample1;
wire[15:0] speedSample1;
wire loopSample1;

wire startSample;
wire[15:0] addrSample;
wire stopSample;
wire[15:0] speedSample;
wire loopSample;

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
wire[2:0] sampleVolume;

buzzerMan bMan(.clk(clk),
			 .rst(rst),
	
			 .in(in),
			 .start(start),
			 
			 .vol(vol),
			 .soundType(soundType),
			 .soundVol(soundVol),
			 .genType(genType),
			 .startT(startT),
						 
				.startSample(startSample),
				.addrSample(addrSample),
				.stopSample(stopSample),
				.speedSample(speedSample),
				.sampleVolume(sampleVolume),
				.loopSample(loopSample),
			 
			 	.startSample2(startSample2),
				.addrSample2(addrSample2),
				.stopSample2(stopSample2),
				.speedSample2(speedSample2),
				.sampleVolume2(sampleVolume2),
				.loopSample2(loopSample2),
			 
			 	.startSample3(startSample3),
				.addrSample3(addrSample3),
				.stopSample3(stopSample3),
				.speedSample3(speedSample3),
				.sampleVolume3(sampleVolume3),
				.loopSample3(loopSample3)
			 
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

wire[15:0] soundXXXX;
wire startXXXX; 

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
wire startDMA3;
wire[15:0] addrDMA3;
	
wire[15:0] fromMemDMA3;
wire rdyDMA3;
	
soundGenSimple gen4(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
				  
				  			 
				.startSample(startSample3),
				.addrSample(addrSample3),
				.stopSample(stopSample3),
				.speedSample(speedSample3),
				.volume(sampleVolume3),
				.loopSample(loopSample3),
					// DMA
					
					.startDMA(startDMA3),
					.addrDMA(addrDMA3),
						
					.fromMemDMA(fromMemDMA3),
					.rdyDMA(rdyDMA3),
					
					// OutGen
					.out(soundXXXX),
				  .start(startXXXX),

);

wire startDMA2;
wire[15:0] addrDMA2;
	
wire[15:0] fromMemDMA2;
wire rdyDMA2;
	
soundGenSimple gen2(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
				  
				  			 
				.startSample(startSample2),
				.addrSample(addrSample2),
				.stopSample(stopSample2),
				.speedSample(speedSample2),
				.volume(sampleVolume2),
				.loopSample(loopSample2),
					// DMA
					
					.startDMA(startDMA2),
					.addrDMA(addrDMA2),
						
					.fromMemDMA(fromMemDMA2),
					.rdyDMA(rdyDMA2),
					
					// OutGen
					.out(soundXX),
				  .start(startXX),

);



wire startDMA1;
wire[15:0] addrDMA1;
	
wire[15:0] fromMemDMA1;
wire rdyDMA1;
	
soundGenSimple gen3(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
				  
				  			 
				.startSample(startSample),
				.addrSample(addrSample),
				.stopSample(stopSample),
				.speedSample(speedSample),
				.volume(sampleVolume),
				.loopSample(loopSample),
					// DMA
					
					.startDMA(startDMA1),
					.addrDMA(addrDMA1),
						
					.fromMemDMA(fromMemDMA1),
					.rdyDMA(rdyDMA1),
					
					// OutGen
					.out(soundXXX),
				  .start(startXXX),

);


DMACollect dmaC(.clk(clk),
			  .rst(rst),
	
	// DMA In1
	.startDMA1(startDMA1),
	.addrDMA1(addrDMA1),
						
	.fromMemDMA1(fromMemDMA1),
	.rdyDMA1(rdyDMA1),

	// DMA In2
	.startDMA2(startDMA2),
	.addrDMA2(addrDMA2),
						
	.fromMemDMA2(fromMemDMA2),
	.rdyDMA2(rdyDMA2),
	
	
	// DMA In2
	.startDMA3(startDMA3),
	.addrDMA3(addrDMA3),
						
	.fromMemDMA3(fromMemDMA3),
	.rdyDMA3(rdyDMA3),
	
	// DMA Out
	.startDMA(startDMA),
	.addrDMA(addrDMA),
						
	.fromMemDMA(fromMemDMA),
	.rdyDMA(rdyDMA),
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
	
					.soundXXXX(soundXXXX),
					.startXXXX(startXXXX),	
					
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

	input[15:0] soundXXXX,
	input startXXXX,	
	
	output reg[15:0] soundO,
	output reg startO
);

reg[15:0] f_sound1;
reg[15:0] n_sound1;

reg[15:0] f_sound2;
reg[15:0] n_sound2;

reg[15:0] f_sound3;
reg[15:0] n_sound3;

reg[15:0] f_sound4;
reg[15:0] n_sound4;

always@(posedge clk or posedge rst)
	if(rst) f_sound1 <= 0;
	else f_sound1 <= n_sound1;

always@(posedge clk or posedge rst)
	if(rst) f_sound2 <= 0;
	else f_sound2 <= n_sound2;

always@(posedge clk or posedge rst)
	if(rst) f_sound3 <= 0;
	else f_sound3 <= n_sound3;

always@(posedge clk or posedge rst)
	if(rst) f_sound4 <= 0;
	else f_sound4 <= n_sound4;
	
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

always@(*)begin
	n_sound4 = f_sound4;
	
	if(startXXXX) n_sound4 = soundXXXX;
end

reg b_start;

always@(posedge clk or posedge rst)
	if(rst) b_start = 0;
	else b_start = startX | startXX | startXXX | startXXXX;

wire[15:0] sum = f_sound1 + f_sound2 + f_sound3 + f_sound4;
always@(*)begin
	
	soundO = 0;
	startO = 0;
	
	if(b_start) begin
	
		soundO = sum;
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

	
	// Sampler

	output reg startSample,
	output reg[15:0] addrSample,
	output reg stopSample,
	output reg[15:0] speedSample,
	output reg[2:0] sampleVolume,
	output reg loopSample,
	
	output reg startSample2,
	output reg[15:0] addrSample2,
	output reg stopSample2,
	output reg[15:0] speedSample2,
	output reg[2:0] sampleVolume2,
	output reg loopSample2,
	
	output reg startSample3,
	output reg[15:0] addrSample3,
	output reg stopSample3,
	output reg[15:0] speedSample3,
	output reg[2:0] sampleVolume3,
	output reg loopSample3
);


reg[1:0] n_selSample;
reg[1:0] f_selSample;

reg f_loopSample;
reg[2:0] f_sampleVolume;
reg[15:0] f_speedSample;

reg f_loopSample2;
reg[2:0] f_sampleVolume2;
reg[15:0] f_speedSample2;

reg f_loopSample3;
reg[2:0] f_sampleVolume3;
reg[15:0] f_speedSample3;

reg[2:0] f_vol = 7;
reg[2:0] f_genType;

localparam NOP = 8'd0;
localparam NOTE = 8'd1;
localparam STOP = 8'd2;
localparam VOL = 8'd3;

localparam SAMPLE = 8'd4;
localparam SPEED = 8'd5;
localparam STOPSAMPLE = 8'd6;
localparam LOOP = 8'd9;

localparam SOUNDVOL = 8'd7;
localparam SELECT = 8'd8;


always@(posedge clk or posedge rst)
	if(rst) f_selSample <= 0;
	else f_selSample <= n_selSample;
	
always@(posedge clk or posedge rst)
	if(rst) begin
		f_loopSample <= 0;
		f_loopSample2 <= 0;
		f_loopSample3 <= 0;
		end
	else begin
		f_loopSample <= loopSample;
		f_loopSample2 <= loopSample2;
		f_loopSample3 <= loopSample3;
		end
		
always@(posedge clk or posedge rst)
	if(rst) begin
		f_sampleVolume <= 0;
		f_sampleVolume2 <= 0;
		f_sampleVolume3 <= 0;
		end
	else begin
		f_sampleVolume <= sampleVolume;
		f_sampleVolume2 <= sampleVolume2;
		f_sampleVolume3 <= sampleVolume3;
		end
		
always@(posedge clk or posedge rst)
	if(rst) begin
		f_speedSample <= 0;
		f_speedSample2 <= 0;
		f_speedSample3 <= 0;
		end
	else begin
		f_speedSample <= speedSample;
		f_speedSample2 <= speedSample2;
		f_speedSample3 <= speedSample3;
		end
		
always@(posedge clk or posedge rst)
	if(rst) begin
		f_vol <= 7;
		f_genType <= 0;
		end
	else begin
		f_genType <= genType;
		f_vol <= vol;
		end

		
always@(*)begin
	
	n_selSample = f_selSample;
	
	vol = f_vol;
	genType = f_genType;
	startT = 0;
	soundType = 0;
	
	loopSample = f_loopSample;
	speedSample = f_speedSample;
	sampleVolume = f_sampleVolume;
	
	loopSample2 = f_loopSample2;
	speedSample2 = f_speedSample2;
	sampleVolume2 = f_sampleVolume2;
	
	loopSample3 = f_loopSample3;
	speedSample3 = f_speedSample3;
	sampleVolume3 = f_sampleVolume3;
	
	startSample = 0;
	addrSample = 0;
	stopSample = 0;

	startSample2 = 0;
	addrSample2 = 0;
	stopSample2 = 0;

	startSample3 = 0;
	addrSample3 = 0;
	stopSample3 = 0;
	
	if(start)
		case(in[23:16])
			NOP:;
			NOTE: begin
			
					soundType = in[5:0];
					soundVol = in[7:6];
					genType = in[10:8];
					startT = 1;
				
				end
			STOP: begin
			
					soundType = 0;
					startT = 0;
					genType = 0;

				
				end
			VOL: vol = in[2:0];
			
			SAMPLE: 
				case(f_selSample)
					0: begin
						startSample = 1;
						addrSample = in[15:0];
					end
					1: begin
						startSample2 = 1;
						addrSample2 = in[15:0];
					end
					2: begin
						startSample3 = 1;
						addrSample3 = in[15:0];
					end
					default:;
				endcase
			STOPSAMPLE: 
				case(f_selSample)
					0: stopSample = 1;
					1: stopSample2 = 1;
					2: stopSample3 = 1;
					default:;
				endcase
			SPEED: 
				case(f_selSample)
					0: speedSample = in[15:0];
					1: speedSample2 = in[15:0];
					2: speedSample3 = in[15:0];
					default:;
				endcase
			SOUNDVOL:
				case(f_selSample)
					0: sampleVolume = in[2:0];
					1: sampleVolume2 = in[2:0];
					2: sampleVolume3 = in[2:0];
					default:;
				endcase
			LOOP: 
				case(f_selSample)
					0: loopSample = in[0];
					1: loopSample2 = in[0];
					2: loopSample3 = in[0];
					default:;
				endcase
			SELECT: n_selSample = in[1:0];
			default:;
		endcase
end

endmodule


