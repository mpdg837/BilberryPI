module CPU(
	input clk,
	input clk_tim,
	input rst,
	
	input saverdy,
	input readrdy,
	
	output readstart,
	
	input irq1,
	input irq2,
	input irq3,
	input irq4,
	input irq5,
	input irq6,
	input irq7,
	
	input[15:0] in1,
	input[15:0] in2,

	
	output status,
	
	// Memory
	
	
	output[15:0] out1,
	output[15:0] out2,

	output workx,
	
	output prst,
	
	
	input[31:0] toCPU,
		
	output[14:0] addrCPU,
	output[31:0] fromCPU,
	output wCPU,
	
	output oover,
	
	output[1:0] outsel,
	
	// DMA
	output canRead
);

wire inbrk;
wire brk;

wire[15:0] RAMaddr;
wire[15:0] toRAM;

wire w;
wire[15:0] fromRAM;

wire work;
	
wire[14:0] addr;
	
wire[24:0] dataProg;
	
wire cbrk;

wire prsts;

wire eirq;
wire irqx1;
wire irqx2;
wire irqx3;

wire[2:0] irq;
wire exception;

reg pexp;

always@(posedge clk)
	pexp <= 0;
	
irqcollector iCola(.clk(clk),
						 .rst(rst),
	
						.irq1(irq1),
						.irq2(irq2),
						.irq3(irq3),
						.irq4(irq4),
						.irq5(irq5),
						.irq6(irq6),
						.irq7(irq7),
						
						.irq(irq)
	
);

interCont iCo(.clk(clk),
				  .rst(rst),
	
				  .eirq(eirq),
				  .irq(irq),
	
					.irq1(irqx1),
					.irq2(irqx2),
					.irq3(irqx3)
);

core QDP(.clk(clk),
		   .clk_tim(clk_tim),
			.rst(rst),
			
			.iinbrk(inbrk),
			.eirq(eirq),
			
			.irq1(irqx1),
			.irq2(irqx2),
			.irq3(irqx3),
			
			.brk(brk),
			
			
			.in1(in1),
			.in2(in2),
			
			.exception(exception),
			.fromRAM(fromRAM),
			
			.exe(dataProg[24:20]),
			.ereg1(dataProg[19:18]),
			.ereg2(dataProg[17:16]),
			.edata(dataProg[15:0]),
			
			.out1(out1),
			.out2(out2),

			
			.addr(addr),
			
			.toRAM(toRAM),
			.RAMaddr(RAMaddr),
			.w(w),
			.status(status),
			
			.work(work),
			
			.outsel(outsel)
			
			
);

	
memCont mCa(
	.clk(clk),
	.rst(rst),
	.brk(brk),
	.inbrk(inbrk),
	
	// Memory
	.toCPU(toCPU),
	
	.addr(addrCPU),
	.fromCPU(fromCPU),
	.wRAM(wCPU),
	
	// RAM
	
	.RAMaddr({RAMaddr}),
	.toRAM(toRAM),
	.w(w),
	
	.fromRAM(fromRAM),
	
	
	// Program
	
	.addrPro(addr),
	.dataProg(dataProg),
	
	// CPU
	
	
	.readrdy(readrdy),
	.saverdy(saverdy),
	.readstart(readstart),
			
	.work(work),
	
	// DMA
	.canRead(canRead),

);

assign workx = work;
assign prst = prsts;
endmodule

module toRAMCollect(
	input[31:0] toCPURAM8,
	
	input[31:0] toCPUROM,
	input selector,
	
	output[31:0] toCPU
);

assign toCPU = selector ? toCPURAM8 : toCPUROM;
endmodule


module toMem(
	input clk,
	input rst,
	
	input[31:0] toMemory,
	input[14:0] addrMemory,
	input wCPU,
	
	input startRead,
	input w,
	
	output reg[31:0] toRAM8,
	output reg wRAM8,
	output reg[14:0] addrRAM8,
	output reg startReadRAM,
	
	output reg[14:0] addrROM,
	output reg startReadROM,
	
	output reg selector
);

reg[1:0] status;

reg f_selector;

always@(posedge clk or posedge rst)begin
	if(rst) selector <= 0;
	else selector <= f_selector;
end

always@(*)begin
	status = 0;
	f_selector = selector;
	
	status = addrMemory[12] | addrMemory[11];
	
	if(startRead || w) f_selector = status;

	end
	

always@(*)begin
	startReadRAM <= startRead & status;
	startReadROM <= startRead & (~status);
end

always@(*)begin

	if(status == 0) addrROM <= addrMemory[10:0];
	else addrROM <= 0;
	
end
	

always@(*)begin
	if(status == 1) begin
	
		case(addrMemory[12:11])
			2'b10: addrRAM8 = {1'b1,addrMemory[10:0]};
			default: addrRAM8 = {1'b0,addrMemory[10:0]};
		endcase
		
		wRAM8 = wCPU;
		toRAM8 = toMemory;	
	end else
	begin
		addrRAM8 = 0;

		wRAM8 = 0;
		toRAM8 = 0;
	end
end

endmodule
