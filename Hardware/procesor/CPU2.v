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

module interCont(
	input clk,
	input rst,
	
	input eirq,
	input[2:0] irq,
	
	output reg irq1,
	output reg irq2,
	output reg irq3
);

reg started;
reg f_started;

reg[2:0] f_irqm1;
reg[2:0] f_irqm2;
reg[2:0] f_irqm3;
reg[2:0] f_irqm4;
reg[2:0] f_irqm5;
reg[2:0] f_irqm6;
reg[2:0] f_irqm7;
reg[2:0] f_irqm8;
reg[2:0] f_irqm9;
reg[2:0] f_irqm10;
reg[2:0] f_irqm11;
reg[2:0] f_irqm12;
reg[2:0] f_irqm13;
reg[2:0] f_irqm14;
reg[2:0] f_irqm15;
reg[2:0] f_irqm16;

reg[2:0] n_irqm1;
reg[2:0] n_irqm2;
reg[2:0] n_irqm3;
reg[2:0] n_irqm4;
reg[2:0] n_irqm5;
reg[2:0] n_irqm6;
reg[2:0] n_irqm7;
reg[2:0] n_irqm8;
reg[2:0] n_irqm9;
reg[2:0] n_irqm10;
reg[2:0] n_irqm11;
reg[2:0] n_irqm12;
reg[2:0] n_irqm13;
reg[2:0] n_irqm14;
reg[2:0] n_irqm15;
reg[2:0] n_irqm16;


always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_irqm1 <= 0;
		f_irqm2 <= 0;
		f_irqm3 <= 0;
		f_irqm4 <= 0;
		f_irqm5 <= 0;
		f_irqm6 <= 0;
		f_irqm7 <= 0;
		f_irqm8 <= 0;
		f_irqm9 <= 0;
		f_irqm10 <= 0;
		f_irqm11 <= 0;
		f_irqm12 <= 0;
		f_irqm13 <= 0;
		f_irqm14 <= 0;
		f_irqm15 <= 0;
		f_irqm16 <= 0;
		
		f_started <= 0;
	end else
	begin
		f_irqm1 <= n_irqm1;
		f_irqm2 <= n_irqm2;
		f_irqm3 <= n_irqm3;
		f_irqm4 <= n_irqm4;
		f_irqm5 <= n_irqm5;
		f_irqm6 <= n_irqm6;
		f_irqm7 <= n_irqm7;
		f_irqm8 <= n_irqm8;
		f_irqm9 <= n_irqm9;
		f_irqm10 <= n_irqm10;
		f_irqm11 <= n_irqm11;
		f_irqm12 <= n_irqm12;
		f_irqm13 <= n_irqm13;
		f_irqm14 <= n_irqm14;
		f_irqm15 <= n_irqm15;
		f_irqm16 <= n_irqm16;
		
		f_started <= started;
	end
end

always@(*)begin
	n_irqm1 = f_irqm1;
	n_irqm2 = f_irqm2;
	n_irqm3 = f_irqm3;
	n_irqm4 = f_irqm4;
	n_irqm5 = f_irqm5;
	n_irqm6 = f_irqm6;
	n_irqm7 = f_irqm7;
	n_irqm8 = f_irqm8;
	n_irqm9 = f_irqm9;
	n_irqm10 = f_irqm10;
	n_irqm11 = f_irqm11;
	n_irqm12 = f_irqm12;
	n_irqm13 = f_irqm13;
	n_irqm14 = f_irqm14;
	n_irqm15 = f_irqm15;
	n_irqm16 = f_irqm16;
	
	started = f_started;
	
	irq1 = 0;
	irq2 = 0;
	irq3 = 0;
	
	if(irq != 0)begin
		if(f_irqm1 == 0) n_irqm1 = irq;
		else if(f_irqm2 == 0) n_irqm2 = irq;
		else if(f_irqm3 == 0) n_irqm3 = irq;
		else if(f_irqm4 == 0) n_irqm4 = irq;
		else if(f_irqm5 == 0) n_irqm5 = irq;
		else if(f_irqm6 == 0) n_irqm6 = irq;
		else if(f_irqm7 == 0) n_irqm7 = irq;
		else if(f_irqm8 == 0) n_irqm8 = irq;
		else if(f_irqm9 == 0) n_irqm9 = irq;
		else if(f_irqm10 == 0) n_irqm10 = irq;
		else if(f_irqm11 == 0) n_irqm11 = irq;
		else if(f_irqm12 == 0) n_irqm12 = irq;
		else if(f_irqm13 == 0) n_irqm13 = irq;
		else if(f_irqm14 == 0) n_irqm14 = irq;
		else if(f_irqm15 == 0) n_irqm15 = irq;
		else n_irqm16 = irq;
	end 
	
	if(eirq | (~f_started))begin
	
		
		
		if(f_irqm1 == 0)begin
			if(irq==0) started = 0;
			else started = 1;
		
			irq1 = irq[0];
			irq2 = irq[1];
			irq3 = irq[2];
			
		end else
		begin
			if(f_irqm1==0) started = 0;
			else started = 1;
		
			irq1 = f_irqm1[0];
			irq2 = f_irqm1[1];
			irq3 = f_irqm1[2];
		end
		
		
		
		n_irqm1 = f_irqm2;
		n_irqm2 = f_irqm3;
		n_irqm3 = f_irqm4;
		n_irqm4 = f_irqm5;
		n_irqm5 = f_irqm6;
		n_irqm6 = f_irqm7;
		n_irqm7 = f_irqm8;
		n_irqm8 = f_irqm9;
		n_irqm9 = f_irqm10;
		n_irqm10 = f_irqm11;
		n_irqm11 = f_irqm12;
		n_irqm12 = f_irqm13;
		n_irqm13 = f_irqm14;
		n_irqm14 = f_irqm15;
		n_irqm15 = f_irqm16;

		
		n_irqm16 = 0;
	end
	
	
end

endmodule



module irqcollector(
	input clk,
	input rst,
	
	input irq1,
	input irq2,
	input irq3,
	input irq4,
	input irq5,
	input irq6,
	input irq7,
	
	output reg[2:0] irq
	
);

reg s_r0;
reg s_r1;
reg s_r2;
reg s_r3;
reg s_r4;
reg s_r5;
reg s_r6;
reg s_r7;

reg f_r0;
reg f_r1;
reg f_r2;
reg f_r3;
reg f_r4;
reg f_r5;
reg f_r6;
reg f_r7;

reg[2:0] f_t;
reg[2:0] n_t;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_r0 <= 0;
		f_r1 <= 0;
		f_r2 <= 0;
		f_r3 <= 0;
		f_r4 <= 0;
		f_r5 <= 0;
		f_r6 <= 0;
		f_r7 <= 0;
		
		f_t <= 0;
	end else
	begin
		f_r0 <= s_r0;
		f_r1 <= s_r1;
		f_r2 <= s_r2;
		f_r3 <= s_r3;
		f_r4 <= s_r4;
		f_r5 <= s_r5;
		f_r6 <= s_r6;
		f_r7 <= s_r7;
		
		f_t <= n_t;
	end
		
end

always@(*) n_t = f_t + 1;

always@(*)begin
		s_r0 = f_r0;
		s_r1 = f_r1;
		s_r2 = f_r2;
		s_r3 = f_r3;
		s_r4 = f_r4;
		s_r5 = f_r5;
		s_r6 = f_r6;
		s_r7 = f_r7;
	
		if(irq1) s_r1 = 1;
		if(irq2) s_r2 = 1;
		if(irq3) s_r3 = 1;
		if(irq4) s_r4 = 1;
		if(irq5) s_r5 = 1;
		if(irq6) s_r6 = 1;
		if(irq7) s_r7 = 1;
			
		case(f_t)
			1: s_r1 = 0;
			2: s_r2 = 0;
			3: s_r3 = 0;
			4: s_r4 = 0;
			5: s_r5 = 0;
			6: s_r6 = 0;
			7: s_r7 = 0;
			default:;
		endcase
end

always@(*)begin

		irq = 0;
		
		case(f_t)
			0: irq = 0;
			1: if(irq1)begin
					irq = 3'd1;
				end else
				begin
					if(f_r1) irq = 3'd1;
				end
			2: if(irq2)begin
					irq = 3'd2;
				end else
				begin
					if(f_r2) irq = 3'd2;
				end
			3: if(irq3)begin
					irq = 3'd3;
				end else
				begin
					if(f_r3) irq = 3'd3;
				end
			4: if(irq4)begin
					irq = 3'd4;
				end else
				begin
					if(f_r4) irq = 3'd4;
				end
			5: if(irq5)begin
					irq = 3'd5;
				end else
				begin
					if(f_r5) irq = 3'd5;
				end
			6: if(irq6)begin
					irq = 3'd6;
				end else
				begin
					if(f_r6) irq = 3'd6;
				end
			7: if(irq7)begin
					irq = 3'd7;
				end else
				begin
					if(f_r7) irq = 3'd7;
				end
			default:;
		endcase
end


endmodule

