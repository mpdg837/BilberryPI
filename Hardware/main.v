
module main(
	input clk,
	
	input krst,
	
	// DISK CONTROLLER
	
	input mosi_sd,
	output cs_sd,
	output miso_sd,
	output sck_sd,
	
	
	// KEYS
	
	input kin1,
	input kin2,
	input kin3,
	input kin4,

	// KEYBOARD
	
	input ps2clk,
	input ps2data,

	// VIDEO
	output R,
	output G,
	output B,
	
	output hsync,
	output vsync,
	
	// SOUND
	output[7:0] sound,
	
	// LEDS 
	
	output[3:0] led
	
	
	
);

wire iclk = clk;

sm_altpll altpll(clk1, clk1);

wire inclk;


inputclock inclo(.clk(iclk),
					  .rst(irst),
					  .dclk(inclk)
);

wire kkrst;

keyrstmodule krsta(.clk(iclk),
				 .in(krst),
	
				 .tclk(inclk),
				 
				 .rst(kkrst)
);

wire wrst;

wire irq1;
wire irq2;
wire irq3;
wire irq4;
wire irq5;
wire irq6;
wire irq7;

wire saverdy;
wire readrdy;



wire readstart;

wire[1:0] outsel;

wire[31:0] oout1;
wire[31:0] oout2;
wire[31:0] oout3;
wire[31:0] oout4;

wire[31:0] iin1;
wire[31:0] iin2;
wire[31:0] iin3;
wire[31:0] iin4;

wire irst = kkrst;

wire clkm;




wire[31:0] toCPU;

wire[15:0] in1 ;
wire[15:0] in2 ;


wire[14:0] addrCPU;
wire[31:0] fromCPU;
wire wCPU;


wire[15:0] out1;
wire[15:0] out2;


wire[31:0] fromPro;
wire[31:0] inToPro;

wire[31:0] tomRAM8;
wire wmRAM8;
wire[14:0] addrmRAM8;
	
wire[31:0] toCPURAM8;


wire[11:0] addrmROM;
wire[31:0] toCPUROM;

wire mrdy;
wire[23:0] mout;
wire[23:0] min;

wire mstart;



div_input dI50(.clk(iclk),.rst(irst),.clkm(clkm));

keyDevice kD(.clk(iclk),
				 .tclk(inclk),
				 
				 .rst(irst),
				 .krst(krst),
				 
				 .irq(irq1),
				
				 .in1(kin1),
				 .in2(kin2),
				 .in3(kin3),
				 .in4(kin4),
				 
				 .out(iin2)
	
);

keyboard keybo(.clk(iclk),
					.rst(irst),
					
					.irq(irq2),
	
					.ps2clk(ps2clk),
					.ps2data(ps2data), 
					.out(iin3)

);


CPU cpu1(.clk(iclk),
			.rst(irst | wrst),
			
			
			.irq1(irq1),
			.irq2(irq2),
			.irq3(irq3),
			.irq4(irq4),
			.irq5(irq5),
			.irq6(irq6),
			.irq7(clkm),
			
			.in1(in1),
			.in2(in2),

	
			.status(status),
	
			// Memory
	
	
			.out1(out1),
			.out2(out2),
			
			.workx(work),
			
			.prst(prst),
			
			// Mem
			.toCPU(toCPU),
		
			.addrCPU(addrCPU),
			.fromCPU(fromCPU),
			.wCPU(wCPU),
			
			.saverdy(saverdy),
			
			.readrdy(readrdy),
			.readstart(readstart),
			
			.outsel(outsel)
	
);

connector cnn(.clk(iclk),
				  .rst(irst),
	
				  .out1(out1),
				  .out2(out2),
	
				  .out(fromPro)
);

wire readRdyRAM;
wire saveRdyRAM;
wire startReadRAM;

wire readRdyROM = 1;
wire startReadROM;


bussystem bussystem(
	.clk(iclk),
	.rst(irst),
	
	.toCPU(toCPU),
		
	.addrCPU(addrCPU),
	.fromCPU(fromCPU),
	.wCPU(wCPU),
	
	.tomRAM8(tomRAM8),
	.wmRAM8(wmRAM8),
	.addrmRAM8(addrmRAM8),
		
	.toCPURAM8(toCPURAM8),


	.addrmROM(addrmROM),
	.toCPUROM(toCPUROM),
	
	.outsel(outsel),
	
	.in1(iin1),
	.in2(iin2),
	.in3(iin3),
	.in4(iin4),
	
	.inToPro(inToPro),

	.fromPro(fromPro),
	.out1(oout1),
	.out2(oout2),
	.out3(oout3),
	.out4(oout4),
			
	.saverdy(saverdy),
			
	.readrdy(readrdy),
	.readstart(readstart),
	
	
	.readRdyRAM(readRdyRAM),
	.readRdyROM(readRdyROM),
	
	.startReadROM(startReadROM),
	.startReadRAM(startReadRAM),
	
	.saveRdyRAM(saveRdyRAM)
);

wire[14:0] xaddr;
wire[31:0] xdin;

wire xwe;

wire[31:0] xout;
BRAMI32 bram8(
	.addr(addrmRAM8),
	.din(tomRAM8),
	
	.clk(iclk),
	.rst(irst),
	
	.we(wmRAM8),
	.out(toCPURAM8),
	
	.startReadRAM(startReadRAM),
	
	.readRdyRAM(readRdyRAM),
	.saveRdyRAM(saveRdyRAM)
	
);

KERNAL kernal(
	.clk(iclk),
	.addr(addrmROM),
	.out(toCPUROM)
);

coprocesor cop(.clk(iclk),
					.rst(irst),

					.devaddrin(2'b01),
					.devaddrout(2'b01),
					
					.in(oout1),
					.out(iin1),

					.mrdy(mrdy),
					.mout(mout),
	
					.min(min),
					.mstart(mstart),
					
					.irq(irq3)
	
);

IOmodule rtc(.clk(iclk),
				.rst(irst),
				
				.wrst(wrst),
				
				.start(mstart),
				.in(min),
	
				.rdy(mrdy),
				.out(mout),
				
				.led(led)
);


wire[23:0] outG;
wire stG;
connectorGraphics cGA(.clk(iclk),
							 .rst(irst),
							 
							 .in(oout2),
							 .devaddr(2'd2),
	
							 .out(outG),
							 .start(stG)
);

G10k graphics(.clk(iclk),
				  .rst(irst),
					
				  .in(outG),
				  .start(stG),
					
				  .irq(irq4),
				  .irqc(irq5),
				  
				  .R(R),
				  .G(G),
				  .B(B),
						
				  .hsync(hsync),
				  .vsync(vsync)
	
);

wire[23:0] outB;
wire stB;

connectorGraphics cGB(.clk(iclk),
							 .rst(irst),
							 
							 .in(oout3),
							 .devaddr(2'd3),
	
							 .out(outB),
							 .start(stB)
);


Buzzer16 bz16(.clk(iclk),
				  .rst(irst),
	
				  .start(stB),
				  .in(outB),
	
				  .sound(sound)
);

wire[23:0] outC;
wire stC;



wire[23:0] mout2;
wire mrdy2;

wire[23:0] min2;
wire mstart2;

coprocesor cop2(.clk(iclk),
					.rst(irst),

					.devaddrin(2'd0),
					.devaddrout(2'd0),
					
					.in(oout4),
					.out(iin4),

					.mrdy(mrdy2),
					.mout(mout2),
	
					.min(min2),
					.mstart(mstart2),
					
					.irq(irq6)
	
);

diskcontroller dk(
	.clk(iclk),
	.rst(irst),
	
	.inix(min2),
	.starti(mstart2),
	
	.inti(mrdy2),
	.outi(mout2),
	
	.mosi(mosi_sd),
	
	.cs(cs_sd),
	.miso(miso_sd),
	.sck(sck_sd)
);


assign in1 = {inToPro[15:0]};
assign in2 = {inToPro[31:16]};

endmodule

module inputclock(
	input clk,
	input rst,
	output reg dclk
);

always@(posedge clk)
	dclk <= ~dclk;
endmodule

