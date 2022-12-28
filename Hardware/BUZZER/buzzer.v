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
			 
			 .startSample(startSample),
			 .addrSample(addrSample),
			 .speedSample(speedSample),
			 .stopSample(stopSample),
			 .loopSample(loopSample)
);

wire freq;

sampling_freq fre(.clk(clk),
						.rst(rst),
						
						.freq(freq)
);

wire[15:0] soundX;
wire startX;

wire startSample;
wire[15:0] addrSample;
wire[15:0] speedSample;
wire stopSample;

soundGen gen1(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
	
					// NoteGen
				  .genType(genType),
				  .soundType({soundVol,soundType}),
				  .startT(startT),
	
				  .soundOut(soundX),
				  .startO(startX),
				  
				  // SampleGen
				  	.startSample(startSample),
					.addrSample(addrSample),
					.speedSample(speedSample),
					.stopSample(stopSample),
					.loopSample(loopSample),

					// DMA		
					.addrDMA(addrDMA),
					.startDMA(startDMA),
						
					.inDMA(inDMA),
					.rdyDMA(rdyDMA),
						
					.toSaveDMA(toSaveDMA),
					.wDMA(wDMA)
);


wire pwm;
sigmaDelta#(.sizeBuffer(16))
		  sig1(.clk(clk),
				.rst(rst),
	
				.sound(soundX),
				.start(startX),
	
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
	output reg[15:0] speedSample,
	output reg stopSample,
	output reg loopSample
);


reg[2:0] f_vol = 7;
reg[2:0] f_genType;
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
		end
	else begin
		f_genType <= genType;
		f_vol <= vol;
		end

		
always@(*)begin
	
	vol = f_vol;
	genType = f_genType;
	
	startT = 0;
	soundType = 0;

	startSample = 0;
	addrSample = 0;
	speedSample = 0;
	stopSample = 0;
	loopSample = 0;
	
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


