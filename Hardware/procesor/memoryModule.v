
module DMA(
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
	
	input saveRdyRAM,
	
	// DMA
	input canRead,
	
	input startDMA,
	input[15:0] addrDMA,
	
	output[15:0] fromMemDMA,
	output rdyDMA
	
);


wire[31:0] toCPU1;
wire[14:0] addrCPU1;
wire[31:0] fromCPU1;
wire wCPU1;
	
toDevice tD(.clk(clk),
				.rst(rst),
				
				.canRead(canRead),
				
				.toCPU(toCPU),
				.addrCPU(addrCPU),
				.fromCPU(fromCPU),
				.wCPU(wCPU),
	
				.toCPU1(toCPU1),
				.addrCPU1(addrCPU1),
				.fromCPU1(fromCPU1),
				.wCPU1(wCPU1),
				
				.startDMA(startDMA),
				.addrDMA(addrDMA),
				
				.fromMemDMA(fromMemDMA),
				.rdyDMA(rdyDMA),
				
				.toCPURAM(toCPURAM8),
				.toCPUROM(toCPUROM),
				.sel(selector)
);

wire selector;

toMem tM(
	.clk(clk),
	.rst(rst),
	
	.toMemory(fromCPU1),
	.addrMemory(addrCPU1),
	.wCPU(wCPU1),
	
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
	
	.toCPU(toCPU1)
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

module toDevice(
	input clk,
	input rst,
	
	input canRead,
	
	// MemPipe
	input sel,
	input[31:0] toCPURAM,
	input[31:0] toCPUROM,
	
	output reg[31:0] toCPU,
	input [14:0] addrCPU,
	input [31:0] fromCPU,
	input wCPU,
	
	input[31:0] toCPU1,
	output reg[14:0] addrCPU1,
	output reg[31:0] fromCPU1,
	output reg wCPU1,
	
	// DMA
	
	input startDMA,
	input[15:0] addrDMA,
	
	output reg[15:0] fromMemDMA,
	output reg rdyDMA
);

reg[1:0] f_status = 0;
reg[1:0] n_status = 0;

reg[15:0] f_memAddr;
reg[15:0] n_memAddr;

reg[15:0] f_mem;
reg[15:0] n_mem;

always@(posedge clk or posedge rst)begin
	if(rst) f_mem <= 0;
	else f_mem <= n_mem;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_status <= 0;
	else f_status <= n_status;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_memAddr <= 0;
	else f_memAddr <= n_memAddr;
end

always@(*)begin
	
	n_mem = f_mem;
	n_memAddr = f_memAddr;
	n_status = f_status;

	
	
	fromMemDMA = 0;
	rdyDMA = 0;
	
	case(f_status)
		0: begin
		
			if(startDMA) begin
				n_memAddr = addrDMA[15:0];
				n_status = 1;
			end
					
			toCPU <= toCPU1;
			addrCPU1 <= addrCPU;
			fromCPU1 <= fromCPU;
			wCPU1 <= wCPU;
			
			end
		1: if(canRead)begin
		
				addrCPU1 <= f_memAddr[15:1];
				wCPU1 <= 0;
				fromCPU1 <= 0;
				toCPU <= 0;
				
				n_status = 2;
			end else
			begin
				toCPU <= toCPU1;
				addrCPU1 <= addrCPU;
				fromCPU1 <= fromCPU;
				wCPU1 <= wCPU;
			end
		2: begin
				toCPU <= toCPU1;
				addrCPU1 <= addrCPU;
				fromCPU1 <= fromCPU;
				wCPU1 <= wCPU;
				
				case(f_memAddr[0])
					0: n_mem = toCPURAM[15:0];
					1: n_mem = toCPURAM[31:16];
				endcase
				
					
				n_status = 3;
			end
		3: begin
				toCPU <= toCPU1;
				addrCPU1 <= addrCPU;
				fromCPU1 <= fromCPU;
				wCPU1 <= wCPU;
			
				fromMemDMA =  f_mem;
				rdyDMA = 1;
				
				n_status = 0;
			end
		default:begin
			toCPU <= toCPU1;
			addrCPU1 <= addrCPU;
			fromCPU1 <= fromCPU;
			wCPU1 <= wCPU;
		end
		
	endcase

	
end


endmodule
