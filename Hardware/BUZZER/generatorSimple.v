

module soundGenSimple(
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


wire[15:0] soundTime;

soundConverter sC(.clk(clk),
						.rst(rst),
	
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

wire[15:0] genSoundSam;
wire genStartSam;

wire[15:0] genSound;
wire genStart;

genSel gs(.gen(genSel),
		
		.genSin(genSoundSin),
		.genStartSin(genStartSin),
		
		.genSqu(genSoundSqu),
		.genStartSqu(genStartSqu),
		
		.genTri(genSoundTri),
		.genStartTri(genStartTri),
		
		.genSaw(genSoundSaw),
		.genStartSaw(genStartSaw),

		.genNoi(genSoundNoi),
		.genStartNoi(genStartNoi),

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


