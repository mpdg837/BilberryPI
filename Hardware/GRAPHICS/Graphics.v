

module bclk(
	input clk,
	input rst,
	
	input in,
	output reg out
);


always@(posedge clk or posedge rst)begin
	if(rst) out <= 0;
	else out <= in;
end

endmodule

module G10k(
	input clk,
	input rst,
	
	input[23:0] in,
	input start,
	
	output irq,
	output irqc,
	
	output R,
	output G,
	output B,
	
	output hsync,
	output vsync
	
);

bclk bc(.clk(clk),
		.rst(rst),
		
		.in(irq3),
		.out(irqc)
);

wire comb;
wire splash;

wire[9:0] CounterX;
wire[8:0] CounterY;


wire[23:0] nnin;
wire nnstart;

wire[23:0] nin;
wire nstart;

wire[5:0] clearx;
wire[4:0] cleary;

wire[5:0] loadx;
wire[4:0] loady;

wire irq2;

clearer clr(.clk(clk),
				.rst(rst),
	
				.in(in),
				.start(start),
	
				.nstart(nnstart),
				.nin(nnin),
	
				.clearx(clearx),
				.cleary(cleary)
				
);

wire irq3;

wire[11:0] bwaddr;
wire[7:0] inbuffer;
wire wbuffer;

wire[11:0] braddr;
wire[7:0] outbuffer;

bufferTextMem btm(.clk(clk),
						.addr(braddr),

						.w(wbuffer),
						.waddr(bwaddr),
						.save(inbuffer),
						
						.out(outbuffer)
);



textBuffer tBufeer(.clk(clk),
			  .rst(rst),
	
				.in(nnin),
				.start(nnstart),
	
				.clearx(clearx),
				.cleary(cleary),
	
				.nin(nin),
				.nstart(nstart),
				.irq(irq3),
				
				.loadx(loadx),
				.loady(loady),
				
				.waddr(bwaddr),
				.w(wbuffer),
				.inbuffer(inbuffer),
				
				.raddr(braddr),
				.outbuffer(outbuffer)
				
	
);


wire[4:0] bcgcol;
wire sel;

wire w;
wire[12:0] waddr;
wire[7:0] insa;
	
wire ws;
wire s;
wire[3:0] insaa;

BCGController bcc(.clk(clk),
						.rst(rst),
						
						.start(nstart),
						.in(nin),
	
						.waddr(waddr),
						.w(w),
					   .save1(insa),
	
						.ws(ws),
						.sel(sel),
						.save2(insaa),
						
						.clearx(loadx),
						.cleary(loady)
);

wire[6:0] deltaX;
wire[4:0] deltaY;

wire[4:0] bg1color1;
wire[4:0] bg1color2;
wire[4:0] bg1color3;
wire[4:0] bg1color4;

wire[4:0] bg2color1;
wire[4:0] bg2color2;
wire[4:0] bg2color3;
wire[4:0] bg2color4;

wire[4:0] bg3color1;
wire[4:0] bg3color2;
wire[4:0] bg3color3;
wire[4:0] bg3color4;

wire[4:0] bg4color1;
wire[4:0] bg4color2;
wire[4:0] bg4color3;
wire[4:0] bg4color4;

wire[4:0] bg5color1;
wire[4:0] bg5color2;
wire[4:0] bg5color3;
wire[4:0] bg5color4;

wire[4:0] bg6color1;
wire[4:0] bg6color2;
wire[4:0] bg6color3;
wire[4:0] bg6color4;

wire[4:0] bg7color1;
wire[4:0] bg7color2;
wire[4:0] bg7color3;
wire[4:0] bg7color4;

wire[4:0] bg8color1;
wire[4:0] bg8color2;
wire[4:0] bg8color3;
wire[4:0] bg8color4;


wire delirq;

deltaController dca(.clk(clk),
					 .rst(rst),
					 
					 .splash(splash),
					 .in(in),
					 .start(start),
					
					 .delirq(delirq),
					 .deltaY(deltaY),
				    .deltaX(deltaX),
	
					 .bg1col1(bg1color1),
					 .bg1col2(bg1color2),
					 .bg1col3(bg1color3),
					 .bg1col4(bg1color4),
	 
					 .bg2col1(bg2color1),
					 .bg2col2(bg2color2),
					 .bg2col3(bg2color3),
					 .bg2col4(bg2color4),
	 
					 .bg3col1(bg3color1),
					 .bg3col2(bg3color2),
					 .bg3col3(bg3color3),
					 .bg3col4(bg3color4),
	 
					 .bg4col1(bg4color1),
					 .bg4col2(bg4color2),
					 .bg4col3(bg4color3),
					 .bg4col4(bg4color4),
	
					 .bg5col1(bg5color1),
					 .bg5col2(bg5color2),
					 .bg5col3(bg5color3),
					 .bg5col4(bg5color4),
	
				    .bg6col1(bg6color1),
					 .bg6col2(bg6color2),
					 .bg6col3(bg6color3),
					 .bg6col4(bg6color4),
	
					 .bg7col1(bg7color1),
					 .bg7col2(bg7color2),
					 .bg7col3(bg7color3),
					 .bg7col4(bg7color4),
	
					 .bg8col1(bg8color1),
					 .bg8col2(bg8color2),
					 .bg8col3(bg8color3),
					 .bg8col4(bg8color4)
);

wire dclk;
wire ins;


wire xhsync;
wire xvsync;


wire[31:0] fromsRAM;
wire[15:0] addrSRAM;

wire sig;

clkdiv cd(.clk(clk),
			 .dclk(dclk)
);

hvsync_generator hg(.clk(dclk),
						  .rst(rst),
						  .cclk(clk),
						  .vga_h_sync(xhsync), 
						  .vga_v_sync(xvsync), 
						  .inDisplayArea(ins), 
						  .CounterX(CounterX), 
						  .CounterY(CounterY),
						  .sig(sig)
						 );

		 
nextA n(.clk(clk),
		  .rst(rst),
			.dec((CounterX ==0) && (CounterY ==0)),
		   .out(irq)
);


// Background

wire[1:0] ccol;
wire[7:0] tex;

wire[9:0] ccx;
wire[8:0] ccy;

prze ptex(.clk(dclk),
			 
			 .cx(CounterX),
			 .cy(CounterY),
	
			 .deltax(deltaX),
			 .deltay(deltaY),
			
			 .CounterX(ccx),
			 .CounterY(ccy)
);


wire[7:0] fromVRAM;
wire[12:0] addrVRAM;

wire[3:0] palette;
wire[1:0] cols;

wire[3:0] ui;

bcgman bma(.clk(clk),
			  .rst(rst),
			  .cx(ccx),
			  .cy(ccy),
			 
				.x(CounterX),
				.y(CounterY),
				
			  .fromRAM(fromVRAM),
	
			  .addrRAM(addrVRAM),
	
			  .color(cols),
			  .palette(palette),
			  
			  .ui(ui)
	
);

VRAM vram(.clk(clk),
			 .addr(addrVRAM),
	
			.w(w),
			.waddr(waddr),
			.in(insa),
			
			.ws(ws),
			.sel(sel),
			.ins(insaa),
			
			 .out(fromVRAM)
);

localparam A_ = 2'd0;
localparam B_ = 2'd1;
localparam C_ = 2'd2;
localparam D_ = 2'd3;


paletteBcg pBc(.clk(clk),
					.rst(rst),
					
					.CounterX(ccx),
					.CounterY(ccy),
					
					.b1col1(bg1color1),
					.b1col2(bg1color2),
					.b1col3(bg1color3),
					.b1col4(bg1color4),
					
					.b2col1(bg2color1),
					.b2col2(bg2color2),
					.b2col3(bg2color3),
					.b2col4(bg2color4),
					
					.b3col1(bg3color1),
					.b3col2(bg3color2),
					.b3col3(bg3color3),
					.b3col4(bg3color4),
					
					.b4col1(bg4color1),
					.b4col2(bg4color2),
					.b4col3(bg4color3),
					.b4col4(bg4color4),
					
					.b5col1(bg5color1),
					.b5col2(bg5color2),
					.b5col3(bg5color3),
					.b5col4(bg5color4),
					
					.b6col1(bg6color1),
					.b6col2(bg6color2),
					.b6col3(bg6color3),
					.b6col4(bg6color4),
					
					.b7col1(bg7color1),
					.b7col2(bg7color2),
					.b7col3(bg7color3),
					.b7col4(bg7color4),
					
					.b8col1(bg8color1),
					.b8col2(bg8color2),
					.b8col3(bg8color3),
					.b8col4(bg8color4),
					
					
					.palette(palette),
					
					.col(cols),
	
					.pcol(bcgcol)
	
);

// Sprites

wire[4:0] addrSpriteProp;
wire sel1;

wire wSpriteProp1;
wire[4:0] addrSpritePropSave1;
wire[31:0] prop1;
	
wire wSpriteProp2;
wire [4:0] addrSpritePropSave2;
wire [31:0] prop2;
	
wire wOut1;
wire[8:0] addrOut1;
wire[15:0] out1;
	
wire wOut2;
wire[8:0] addrOut2;
wire[15:0] out2;

wire wx;
wire[8:0] waddrx;
wire[31:0] savex;

wire block;

SpriteController sco(.clk(clk),
							.rst(rst),
							
							.start(start),
							.in(in),
							
							.wx(wx),
							.waddrx(waddrx),
							.savex(savex)

);


						 
spriteRAM sRAM(.clk(clk),
					.addr(addrSRAM),
					
					
					.waddr(waddrx),
					.w(wx),
					.save(savex),
					
					.out(fromsRAM)
					
);


sprites sprT(.clk(clk),
		  .dclk(dclk),
		  .rst(rst),
		  
		  .uiin(ui),
		  
		  .bgcol2(bg8color2),
		  .bgcol3(bg8color3),
		  .bgcol4(bg8color4),
		  
		  .ccx(ccx),
		  .ccy(ccy),
		  
		  .fromRAM(fromsRAM),
		  .addr(addrSRAM),
		  
		  .bcgcol(bcgcol),
			
		  .xhsync(xhsync),
		  .xvsync(xvsync),
					
		  .splash(splash),
		  .ins(ins),
		  .sig(sig),
			
		  .CounterX(CounterX),
		  .CounterY(CounterY),
	
	
		  .hsync(hsync),
		  .vsync(vsync),
	
		  .R(R),
		  .G(G),
		  .B(B),
		  
		  .comb(comb)
	
);

endmodule

module nextA(
	input clk,
	input rst,
	input dec,
	output reg out
);

reg f_out;
reg n_out;



always@(posedge clk or posedge rst)begin
	if(rst) f_out <= 0;
	else f_out <= n_out;
end

always@(*)begin
	n_out = f_out;
	out = 0;
	
	if(f_out != dec ) begin
		n_out = dec;
		out = dec;
		
	end
	
	
end


endmodule


module prze(
	input clk,
	input[9:0] cx,
	input[8:0] cy,
	
	input[6:0] deltax,
	input[4:0] deltay,
	
	output reg[9:0] CounterX,
	output reg[8:0] CounterY
);

always@(posedge clk)begin
	CounterX <= cx + {deltax,1'b0}-48;
	CounterY <= cy + {deltay,1'b0};
end

endmodule


module hvsync_generator(clk, rst, cclk, vga_h_sync, vga_v_sync, inDisplayArea, CounterX, CounterY, sig);

input clk;
input rst;
input cclk;

output vga_h_sync, vga_v_sync;
output inDisplayArea;
output [9:0] CounterX;
output [8:0] CounterY;
output reg sig;

//////////////////////////////////////////////////
reg [9:0] CounterX;
reg [8:0] CounterY;
wire CounterXmaxed = (CounterX==10'h2FF);

always @(posedge clk or posedge rst)
	if(rst) CounterX <= 0;
	else if(CounterXmaxed) CounterX <= 0;
else
	CounterX <= CounterX + 1;

always @(posedge clk or posedge rst)
	if(rst) CounterY <= 0;
	else if(CounterXmaxed) CounterY <= CounterY + 1;

reg	vga_HS, vga_VS;

always @(posedge clk or posedge rst)
begin
	if(rst) begin
		vga_HS <= 0; // change this value to move the display horizontally
		vga_VS <= 0; // change this value to move the display vertically
		end
	else begin
		vga_HS <= (CounterX[9:4]==6'h2D); // change this value to move the display horizontally
		vga_VS <= (CounterY==500); // change this value to move the display vertically
		end
end

reg inDisplayArea;
always @(posedge clk or posedge rst)
	inDisplayArea <= (CounterX > 100) && (CounterX<700) && (CounterY>20) && (CounterY<500);


always @(posedge cclk)
	sig <= CounterX[0];
	
assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;

endmodule


