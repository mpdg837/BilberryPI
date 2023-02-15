
module OneBitDAC(input clk, 
					  input RxD, 
					  
					  output PWM_out1,
					  output PWM_out2,
					  output PWM_out3,
					  output PWM_out4,
					  output PWM_out5,
					  output PWM_out6,
					  output PWM_out7,
					  output PWM_out8				  
);
	
wire rst = 0;

wire startT;

wire[7:0] soundType;
wire[2:0] genType;

siren si(.clk(clk),
			.rst(rst),
	
			.sound(soundType),
			.gen(genType),
			.start(startT)
);


wire freq;

wire[3:0] b_vol = 3'b111;

sampling_freq fre(.clk(clk),
						.rst(rst),
						
						.freq(freq)
);

wire[15:0] sound;
wire start;

soundGen gen1(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
	
				  .genType(genType),
				  .soundType(soundType),
				  .startT(startT),
	
				  .soundOut(sound),
				  .startO(start)
);


wire pwm;
sigmaDelta#(.sizeBuffer(16))
		  sig1(.clk(clk),
				.rst(rst),
	
				.sound(sound),
				.start(start),
	
				.pwm(pwm)
);


wire[7:0] ppwms = {pwm,pwm,pwm,pwm,pwm,pwm,pwm,pwm};
wire[7:0] pwms;

volumer vol(.clk(clk),
				.rst(rst),
	
				.pwm(ppwms),
				.volume(b_vol),
	
				.pwms(pwms)
	
);

assign PWM_out1 = pwms[0:0];
assign PWM_out2 = pwms[1:1];
assign PWM_out3 = pwms[2:2];
assign PWM_out4 = pwms[3:3];
assign PWM_out5 = pwms[4:4];
assign PWM_out6 = pwms[5:5];
assign PWM_out7 = pwms[6:6];
assign PWM_out8 = pwms[7:7];
endmodule



module volChannelBuffer(
	input clk,
	input rst,
	
	input[1:0] inVol,
	output reg[1:0] outVol
);

reg[1:0] inVol1;

always@(posedge clk or posedge rst)begin
	if(rst) inVol1 <= 0;
	else inVol1 <= inVol;
end

always@(posedge clk or posedge rst)begin
	if(rst) outVol <= 0;
	else outVol <= inVol1;
end

endmodule


module soundGen(
	input clk,
	input rst,
	
	input freq,
	
	// NoteGen
	input[2:0] genType,
	input[7:0] soundType,
	input startT,
	
	output[15:0] soundOut,
	output startO,
	
	// SampleGen
	
	input startSample,
	input[15:0] addrSample,
	input[15:0] speedSample,
	input stopSample,
	input loopSample,
	
	// DMA
	output[15:0] addrDMA,
	output startDMA,
	
	input[15:0] inDMA,
	input rdyDMA,
	
	output[15:0] toSaveDMA,
	output wDMA
	
);

wire ena;
wire[15:0] soundTime;

soundConverter sC(.clk(clk),
						.rst(rst),
						
						.ena(ena),
						.start(startT),
						.soundType(soundType[5:0]),
	
						.sound(soundTime)
);



wire[1:0] outVolCha;

volChannelBuffer buf1(.clk(clk),
					  .rst(rst),
	
					  .inVol(soundType[7:6]),
					  .outVol(outVolCha)
);



wire[2:0] genSel;

genTypeBuffer buf2(.clk(clk),
					  .rst(rst),
	
					  .inVol(genType),
					  .outVol(genSel)
);




wire[15:0] genSoundSin;
wire genStartSin;

generatorSin genSin(.clk(clk),
				  .rst(rst),
	
				  .freq(freq),
					
				  .f_time(soundTime),
						
				  .out(genSoundSin),
				  .start(genStartSin)
);

wire[15:0] genSoundSqu;
wire genStartSqu;

generatorSqu genSqu(.clk(clk),
						  .rst(rst),
			
						  .freq(freq),
							
						  .f_time(soundTime),
			
						  .out(genSoundSqu),
						  .start(genStartSqu)
);

wire[15:0] genSoundTri;
wire genStartTri;

generatorTria genTria(.clk(clk),
						  .rst(rst),
			
						  .freq(freq),
							
						  .f_time(soundTime),
			
						  .out(genSoundTri),
						  .start(genStartTri)
);

wire[15:0] genSoundSaw;
wire genStartSaw;

generatorSaw genSaw(.clk(clk),
						  .rst(rst),
			
						  .freq(freq),
							
						  .f_time(soundTime),
			
						  .out(genSoundSaw),
						  .start(genStartSaw)
);


wire[15:0] genSoundNoi;
wire genStartNoi;

generatorNoi genNoi(.clk(clk),
						  .rst(rst),
			
						  .freq(freq),
							
						  .f_time(soundTime),
			
						  .out(genSoundNoi),
						  .start(genStartNoi)
);


wire[15:0] genSoundSam;
wire genStartSam;

wire[15:0] genSound;
wire genStart;

genSel gs(.gen(genSel),
			 .ena(ena),
			 
		.genSin(genSoundSin),
		.genStartSin(genStartSin),
		
		.genSqu(genSoundSqu),
		.genStartSqu(genStartSqu),
		
		.genTri(genSoundTri),
		.genStartTri(genStartTri),
		
		.genSaw(genSoundSaw),
		.genStartSaw(genStartSaw),

		.genNoi(genSoundNoi & 0),
		.genStartNoi(genStartNoi & 0),

		.genSam(genSoundSam),
		.genStartSam(genStartSam),
		
		.genO(genSound),
		.genStartO(genStart)
	
);



chanelVolume chAV(.clk(clk),
						.rst(rst),
	
						.volume(outVolCha),
						.soundIn(genSound),
						.start(genStart),
						
						.soundOut(soundOut),
						.startO(startO)
);




endmodule







module genTypeBuffer(
	input clk,
	input rst,
	
	input[2:0] inVol,
	output reg[2:0] outVol
);

reg[2:0] inVol1;

always@(posedge clk or posedge rst)begin
	if(rst) inVol1 <= 0;
	else inVol1 <= inVol;
end

always@(posedge clk or posedge rst)begin
	if(rst) outVol <= 0;
	else outVol <= inVol1;
end

endmodule




module chanelVolume(
	input clk,
	input rst,
	
	input[1:0] volume,
	input[15:0] soundIn,
	input start,
	
	output reg[15:0] soundOut,
	output reg startO
);

wire[15:0] s0 = {4'b0,soundIn[15:4]};
wire[15:0] s1 = {2'b0,soundIn[15:2]};
wire[15:0] s2 = {3'b0,soundIn[15:3]};
wire[15:0] s3 = {1'b0,soundIn[15:1]};

reg[15:0] soundOutx;
reg startOx;
	
always@(posedge clk or posedge rst)begin
	if(rst) begin
		soundOutx <= 0;
		startOx <= 0;
	end
	else begin
		case(volume)
			0: soundOutx <= s0;
			1: soundOutx <= s1;
			2: soundOutx <= s2;
			3: soundOutx <= s3;
		endcase
		
		startOx <= start;
	end
end

always@(posedge clk or posedge rst)
	if(rst)begin
		soundOut <= 0;
		startO <= 0;
	end
	else begin
		soundOut <= soundOutx;
		startO <= startOx;
	end

endmodule


module genSel(
	input[2:0] gen,
	input ena,
	
	input[15:0] genSin,
	input genStartSin,
	
	input[15:0] genSqu,
	input genStartSqu,
	
	input[15:0] genTri,
	input genStartTri,
	
	input[15:0] genSaw,
	input genStartSaw,

	input[15:0] genNoi,
	input genStartNoi,

	input[15:0] genSam,
	input genStartSam,
	
	output reg[15:0] genO,
	output reg genStartO
	
);

localparam SINUS = 0;
localparam SQUARE = 1;
localparam TRIANGLE = 2;
localparam SAWTOOTH = 3;
localparam NOISE = 4;
localparam SAMPLE = 5;

always@(*)begin

	genO = 0;
	if(ena)
		case(gen)
			SINUS: genO = genSin;
			SQUARE: genO = genSqu;
			TRIANGLE: genO = genTri;
			SAWTOOTH: genO = genSaw;
			NOISE: genO = genNoi;
			SAMPLE: genO = genSam;
			default:;
		endcase
	
	if(ena)
		genStartO = genStartSin | genStartSqu | genStartTri | genStartSaw |genStartNoi |genStartSam; 
end

endmodule

module soundConverter(
	input clk,
	input rst,
	
	input start,
	input[5:0] soundType,
	
	output reg ena,
	output reg[15:0] sound
);

reg[15:0] n_sound = 0;

always@(posedge clk or posedge rst)begin
	if(rst) sound <= 0;
	else sound <= n_sound;
end

always@(*)begin
	n_sound = sound;
	ena = (sound != 0);
	
	if(start) 
		case(soundType[5:3])
			0: n_sound = 0;
			1: n_sound = {7'd1,soundType[2:0],6'd0};
			2: n_sound = {6'd1,soundType[2:0],7'd0};
			3: n_sound = {5'd1,soundType[2:0],8'd0};
			4: n_sound = {4'd1,soundType[2:0],9'd0};
			5: n_sound = {3'd1,soundType[2:0],10'd0};
			6: n_sound = {2'd1,soundType[2:0],11'd0};
			7: n_sound = {1'd1,soundType[2:0],12'd0};
		endcase
	
	
end

endmodule

module sampling_freq(
	input clk,
	input rst,
	
	output reg freq
);

reg[12:0] f_tim;
reg[12:0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
always@(*)begin
	n_tim = f_tim + 1;
	freq = 0;
	
	if(f_tim == 4608)begin
		n_tim = 0;
		freq = 1;
	end
	
end

endmodule



module volumer(
	input clk,
	input rst,
	
	input[7:0] pwm,
	input[2:0] volume,
	
	output reg[7:0] pwms
	
);

reg[7:0] f_mask;
reg[7:0] n_mask;

reg[7:0] b_pwms;

always@(posedge clk or posedge rst)begin
	if(rst) f_mask <= 0;
	else f_mask <= n_mask;
end

always@(*)begin
	n_mask = f_mask;
	
	case(volume)
		0: n_mask <= 8'b00000001;
		1: n_mask <= 8'b00000011;
		2: n_mask <= 8'b00000111;
		3: n_mask <= 8'b00001111;
		4: n_mask <= 8'b00011111;
		5: n_mask <= 8'b00111111;
		6: n_mask <= 8'b01111111;
		7: n_mask <= 8'b11111111;
		default:;
	endcase
end

always@(*)begin
	b_pwms <= f_mask & pwm;
end

always@(posedge clk or posedge rst)
	if(rst) pwms <= 0;
	else pwms <= b_pwms;

endmodule


module sigmaDelta#(
	parameter sizeBuffer = 16,
	parameter sizeData = 16
)(
	input clk,
	input rst,
	
	input[sizeData:0] sound,
	input start,
	
	output reg pwm
);



reg [sizeBuffer - 1:0] f_sound;
reg [sizeBuffer - 1:0] n_sound;

reg [sizeBuffer:0] n_PWM_accumulator;
reg [sizeBuffer:0] f_PWM_accumulator;


always @(posedge clk or posedge rst) 
	if(rst) f_PWM_accumulator <= 0;
	else f_PWM_accumulator <= n_PWM_accumulator;

always @(posedge clk or posedge rst) 
	if(rst) f_sound <= 0;
	else f_sound <= n_sound;

	
always@(*)begin
	n_sound = f_sound;
	
	if(start) n_sound = sound[sizeBuffer-1: sizeBuffer - sizeData];
	 
end
always@(*)begin
	
	n_PWM_accumulator <= f_PWM_accumulator[sizeBuffer - 1:0] + f_sound;
	pwm = f_PWM_accumulator[sizeBuffer]; 
end


	
endmodule

	