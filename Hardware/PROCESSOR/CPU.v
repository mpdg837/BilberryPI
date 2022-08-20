


module core(
	input clk,
	input clk_tim,
	input rst,
	input work,
	
	output eirq,
	
	input irq1,
	input irq2,
	input irq3,
	
	input brk,
	
	input[15:0] in1,
	input[15:0] in2,
	
	input[15:0] fromRAM,
	
	input[4:0] exe,
	input[1:0] ereg1,
	input[1:0] ereg2,
	input[15:0] edata,
	
	output[15:0] out1,
	output[15:0] out2,
	
	
	output[14:0] addr,
	
	output[15:0] toRAM,
	output[15:0] RAMaddr,
	output w,
	
	output status,
	
	output[1:0] outsel,
	output exception,
	
	output prst
);

wire[15:0] stackaddr;

wire[1:0] stackArg;

wire[15:0] fexp;
wire[15:0] cmprarg;

wire[15:0] stackAddr1;
wire wStackAddr1;
wire readIt;

wire divbyzero;
wire overflow;
wire stackoverflow;

wire inter;

wire[1:0] bank;
wire sBank;
wire[1:0] sAddrBank;

wire oover;
wire sexa;
wire ramerr;

wire aeq;


wire rstTim;
wire saveTim;

wire[15:0] excpIn;
wire[15:0] excpIn1;

wire sstck;
wire stcke;

wire[15:0] excp;

wire[7:0] progoffset;

exceptCollector exCol(.clk(clk),
							 .rst(rst),
							 
							 .clr(rstTim),
							 
							 .inter(inter),
							 
							 .divbyzero(divbyzero),
							 .overflow(overflow),
							 .stackoverflow(stackoverflow),
							 
							 .excp(fexp)
							
);


bufexcp bxp(.clk(clk),
			  .rst(rst),
			  .in(excpIn1),
	
			  .out(excpIn)
);


wire[15:0] insIn1;
wire[15:0] insIn2;

bufferIn bI1(.clk(clk),
				
				.rst(rst),
				.in(in1),
	
				.insIn(insIn1)
	
);

bufferIn bI2(.clk(clk),
				.rst(rst),
				.in(in2),
	
				.insIn(insIn2)
	
);

wire inselin;

wire[15:0] insIn;

inselector inss(.clk(clk),
					 .rst(rst),
					 
					 .insel(inselin),
					 .insIn1(insIn1),
					 .insIn2(insIn2),
					 
					 .timeIn(excpIn),
					 .saveExcp(saveTim),
					 
					 .insIn(insIn)
);

wire[1:0] areg1;
wire[1:0] areg2;
	
wire[15:0] dataALU;

wire[3:0] mOperALU;
	
wire sALU;
	
wire[1:0] regOut;
wire outA;
wire outB;
	
wire sOUT;
	
wire sCOU;
	
wire[1:0] creg1;
wire[1:0] creg2;

wire[3:0] mOperCOU;
wire[14:0] dataAddr;
	
	
wire[15:0] muldiv;
wire sMUL;
wire[1:0] mOperMUL;

wire[1:0] mreg1;
wire[1:0] mreg2;



wire sSTA;
wire pop;
wire push;

wire[1:0] streg1;


wire[15:0] RAMdata;
wire[1:0] mOperRAM;
wire[1:0] regRAM;
wire[1:0] regRAM2;
wire sRAM;

wire hlt;

wire divbrk;
wire inbrk = divbrk | brk ;

wire mulmode;

wire cmprStart;
wire[1:0] cmprNum2;
wire[1:0] cmprNum1;

wire irst;

wire save;
wire read;
programRst prstX(.clk(clk),
					 .irst(irst),
	
					 .rst(prst)
);


controller con(.clk(clk),
					.rst(rst),
					.work(work),
					.brk(inbrk),
					
					.cmprarg(cmprarg),
					.aeq(aeq),
					.hlt(hlt),
					.exe(exe),
					.ereg1(ereg1),
					.ereg2(ereg2),
					.edata(edata),
	
					.areg1(areg1),
					.areg2(areg2),
					
					.dataALU(dataALU),
					
					.mOperALU(mOperALU),
					
					.sALU(sALU),
					
					.regOut(regOut),
					.outA(outA),
					.outB(outB),
					
					.sOUT(sOUT),
					
					.sCOU(sCOU),
					
					.creg1(creg1),
					.creg2(creg2),
					
					.mOperCOU(mOperCOU),
					.dataAddr(dataAddr),
					
					
					.sMUL(sMUL),
					.mOperMUL(mOperMUL),

					.mreg1(mreg1),
					.mreg2(mreg2),
					
					.sSTA(sSTA),
					.pop(pop),
					.push(push),

					.streg1(streg1),
					
					.RAMdata(RAMdata),
					.mOperRAM(mOperRAM),
					.regRAM(regRAM),
					.regRAM2(regRAM2),
					.sRAM(sRAM),
					
					.inselin(inselin),
					
					.rstTim(rstTim),
					.saveTim(saveTim),
					.status(status),
					
					.mulmode(mulmode),
					.prst(irst),
					
					.cmprStart(cmprStart),
					.cmprNum1(cmprNum1),
					.cmprNum2(cmprNum2),
					
					.sBank(sBank),
					.sAddrBank(sAddrBank),
					
					.save(save),
					.read(read),
					
					.stackArg(stackArg)
		

);


wire[15:0] sreg1;
wire[15:0] sreg2;
wire[15:0] sreg3;
wire[15:0] sreg4;

wire lt;
wire gt;
wire eq;

comparer cmp(.clk(clk),
				 .rst(rst),
				 
				 .arg(cmprarg),
				 .start(cmprStart),
				 .num1(cmprNum1),
				 .num2(cmprNum2),
	
				 .sreg1(sreg1),
				 .sreg2(sreg2),
				 .sreg3(sreg3),
				 .sreg4(sreg4),
				 
				 .inter(inter),
				 
				 .lt(lt),
				 .gt(gt),
				 .eq(eq)
	
);



muldivB mdB(.clk(clk),
				.rst(rst),
				
				.gaddr(prst),
				.addr(stackaddr),
				.inter(inter),
				.divbrk(divbrk),
				.s(sMUL),
				.mOper(mOperMUL),
	
				.mreg1(mreg1),
				.mreg2(mreg2),
	
				.s_sreg1(sreg1),
				.s_sreg2(sreg2),
				.s_sreg3(sreg3),
				.s_sreg4(sreg4),
	
				.muldiv(muldiv),
				
				.mode(mulmode),
				.divbyzero(divbyzero)
				
				
);

wire[15:0] fstack;

stack sta(.clk(clk),
		.clr(rstTim),
		
		.rst(rst),
		
		.arg(stackArg),
		
		.s(sSTA),
		
		.pop(pop),
		.push(push),
		
		.readIt(readIt),
		
		.wstackAddr(wStackAddr1),
		.stackAddr(stackAddr1),
		
		.stackoverflow(stackoverflow)
	
	
);


alu al(.clk(clk),
		 .rst(rst),
	
		.fromRAM(fromRAM),
		.in(insIn),
		.reg1(areg1),
		.reg2(areg2),
		
		.data(dataALU),
		
		.fexp(fexp),
		.sexp(saveTim),
		
		.mOper(mOperALU),
		
		.ssreg1(sreg1),
		.ssreg2(sreg2),
		.ssreg3(sreg3),
		.ssreg4(sreg4),
		
		.muldiv(muldiv),
		
		.s(sALU),
		.overflow(overflow),
		
		.bank(bank),
		
		.readIt(readIt)
);

outputX ouX(.clk(clk),
			   .rst(rst),
				
				.reg1(regOut),
		
			  .sreg1(sreg1),
			  .sreg2(sreg2),
			  .sreg3(sreg3),
			  .sreg4(sreg4),
		
			  .outA(outA),
			  .outB(outB),
		
			  .s(sOUT),
		
			  .out1(out1),
			  .out2(out2),
			  
			  .inter(inter)
);

counter cou(.s(sCOU),
				
				.prst(prst),
				.inter(inter),
				.offset(progoffset),
				
				.clk(clk),
			   .rst(rst),
				
				.irq1(irq1),
				.irq2(irq2),
				.irq3(irq3),
				
				.hlt(hlt),
			
				.aeq(aeq),
				.sreg1(sreg1),
				.sreg2(sreg2),
				.sreg3(sreg3),
				.sreg4(sreg4),
	
				.reg1(creg1),
				.reg2(creg2),
				.mOper(mOperCOU),
				.data(dataAddr),
	
				.addr(addr),
				
				.lt(lt),
				.gt(gt),
				.eq(eq),
				
				.exp(0),
				.eirq(eirq),
				
				.cmpStart(cmprStart),
				
				.save(save),
				.read(read),
				
				.stackaddr(stackaddr)
);


RAMController Rco(.clk(clk),
						.rst(rst),
						
						.progoffset(progoffset),
						.inter(inter),
						.edata(RAMdata),
						.mOper(mOperRAM),
	
						.ereg1(regRAM),
						.ereg2(regRAM2),
						
						.sreg1(sreg1),
						.sreg2(sreg2),
						.sreg3(sreg3),
						.sreg4(sreg4),
	
						.s(sRAM),
	
						.toRAM(toRAM),
						.RAMaddr(RAMaddr),
						.w(w),
						
						.wStackAddr(wStackAddr1),
						.stackAddr(stackAddr1)
);

bankManager bMa(.clk(clk),
					 .rst(rst),
	
					 .sAddrBank(sAddrBank),
					 .sBank(sBank),
	
					 .bank(bank),
					 .inter(inter)
);

assign outsel = bank;
endmodule

module bufferInA(
	input clk,
	input in,
	output reg out
);

always@(posedge clk)
	out <= in;
	
endmodule
module bankManager(
	input clk,
	input rst,
	
	input inter,
	
	input[1:0] sAddrBank,
	input sBank,
	
	output reg[1:0] bank
);

reg[1:0] nbank;
reg[1:0] ibank;

reg[1:0] f_ibank;
reg[1:0] f_nbank;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		nbank <= 0;
		ibank <= 0;
	end
	else begin
		nbank <= f_nbank;
		ibank <= f_ibank;
	end
end

always@(*)begin
	f_nbank = nbank;
	f_ibank = ibank;
	
	if(inter)begin
		if(sBank) f_ibank = sAddrBank;
	end else
	begin
		if(sBank) f_nbank = sAddrBank;
	end

end

always@(*)begin
	if(inter) bank <= ibank;
	else bank <= nbank;
end

endmodule

module programRst(
	input clk,
	input irst,
	
	output reg rst
);

always@(posedge clk) 
	rst <= irst;
endmodule
