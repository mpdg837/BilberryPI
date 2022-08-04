
module bussystem(
	input clk,
	input rst,
	
	input[1:0] outsel,
	
	output[31:0] toCPU,
		
	input[14:0] addrCPU,
	input[31:0] fromCPU,
	input wCPU,
	
	// RAM
	
	output[31:0] tomRAM8,
	output wmRAM8,
	output[14:0] addrmRAM8,
		
	input[31:0] toCPURAM8,
	
	
	// ROM
	
	output[11:0] addrmROM,
	input[31:0] toCPUROM,

	
	input[31:0] in1,
	input[31:0] in2,
	input[31:0] in3,
	input[31:0] in4,


	output[31:0] inToPro,

	input[31:0] fromPro,
	output[31:0] out1,
	output[31:0] out2,
	output[31:0] out3,
	output[31:0] out4,
	
	// ReadyStatus
	
	
	input readstart,
	
	output saverdy,		
	output readrdy,
	
	input readRdyRAM,
	input readRdyROM,
	
	output startReadROM,
	output startReadRAM,
	
	input saveRdyRAM
	
	
	
);

wire selector;

toMem tM(
	.clk(clk),
	.rst(rst),
	
	.toMemory(fromCPU),
	.addrMemory(addrCPU),
	.wCPU(wCPU),
	
	.toRAM8(tomRAM8),
	.wRAM8(wmRAM8),
	.addrRAM8(addrmRAM8),
	
	.startRead(readstart),
	.addrROM(addrmROM),
	
	.startReadROM(startReadROM),
	.startReadRAM(startReadRAM),
	
	.selector(selector),
	.w(w)
	
);


toRAMCollect trC(

	.toCPURAM8(toCPURAM8),
	.toCPUROM(toCPUROM),
	
	.selector(selector),
	
	.toCPU(toCPU)
);

inbuffer intopro(.clk(clk),
					  .rst(rst),
						
					  .outsel(outsel),
					  
					  .in1(in1),
					  .in2(in2),
					  .in3(in3),
					  .in4(in4),

					  .out(inToPro)
);

outbuffer outfrompro(.clk(clk),
						  .rst(rst),
	
						  .in(fromPro),
						  .out1(out1),
						  .out2(out2),
						  .out3(out3),
						  .out4(out4)
);


	
assign saverdy = saveRdyRAM;
assign readrdy = selector ? readRdyRAM : readRdyROM;


	
endmodule


module outbuffer(
	input clk,
	input rst,
	
	input[31:0] in,
	output reg[31:0] out1,
	output reg[31:0] out2,
	output reg[31:0] out3,
	output reg[31:0] out4
);

reg[31:0] r_out1;
reg[31:0] r_out2;
reg[31:0] r_out3;
reg[31:0] r_out4;

always@(posedge clk or posedge rst)begin
	if(rst) out1 <= 0;
	else out1 <= r_out1;
end

always@(posedge clk or posedge rst)begin
	if(rst) out2 <= 0;
	else out2 <= r_out2;
end

always@(posedge clk or posedge rst)begin
	if(rst) out3 <= 0;
	else out3 <= r_out3;
end

always@(posedge clk or posedge rst)begin
	if(rst) out4 <= 0;
	else out4 <= r_out4;
end

always@(*)begin
	r_out1 = 0;
	r_out2 = 0;
	r_out3 = 0;
	r_out4 = 0;
	
	case(in[31:30]) 
		0: r_out4 = in;
		1: r_out1 = in;
		2: r_out2 = in;
		3: r_out3 = in;
	endcase
end

endmodule


module inbuffer(
	input clk,
	input rst,
	
	input[1:0] outsel,
	
	input[31:0] in1,
	input[31:0] in2,
	input[31:0] in3,
	input[31:0] in4,
	
	output reg[31:0] out
);

reg[31:0] r_out = 0;

always@(posedge clk or posedge rst)begin
	if(rst) out <= 0;
	else out <= r_out;
end


always@(*)begin
	r_out = out;
	
	case(outsel)
		1: r_out = in1;
		2: r_out = in2;
		3: r_out = in3;
		0: r_out = in4;
	endcase
	
	
	
end

endmodule

