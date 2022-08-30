module sprites(
	input clk,
	input dclk,
	input rst,
	input splash,
	
	input[3:0] uiin,
	
	input[4:0] bgcol2,
	input[4:0] bgcol3,
	input[4:0] bgcol4,
	
	input[8:0] ccy,
	input[9:0] ccx,
		
	input[31:0] fromRAM,
	output[15:0] addr,

	input[4:0] bcgcol,
	
	input xhsync,
	input xvsync,
	
	input ins,
	input sig,
	
	input[9:0] CounterX,
	input[8:0] CounterY,
	
	output comb,
	
	output R,
	output G,
	output B,
	
	output hsync,
	output vsync

	
);

wire[8:0] posX1;
wire[31:0] colors1;

wire[4:0] b1col1;
wire[4:0] b1col2;
wire[4:0] b1col3;
wire[4:0] b1col4;


wire[8:0] posX2;
wire[31:0] colors2;

wire[4:0] b2col1;
wire[4:0] b2col2;
wire[4:0] b2col3;
wire[4:0] b2col4;



wire[8:0] posX3;
wire[31:0] colors3;

wire[4:0] b3col1;
wire[4:0] b3col2;
wire[4:0] b3col3;
wire[4:0] b3col4;



wire[8:0] posX4;
wire[31:0] colors4;

wire[4:0] b4col1;
wire[4:0] b4col2;
wire[4:0] b4col3;
wire[4:0] b4col4;



wire[8:0] posX5;
wire[31:0] colors5;

wire[4:0] b5col1;
wire[4:0] b5col2;
wire[4:0] b5col3;
wire[4:0] b5col4;



wire[8:0] posX6;
wire[31:0] colors6;

wire[4:0] b6col1;
wire[4:0] b6col2;
wire[4:0] b6col3;
wire[4:0] b6col4;



wire[8:0] posX7;
wire[31:0] colors7;

wire[4:0] b7col1;
wire[4:0] b7col2;
wire[4:0] b7col3;
wire[4:0] b7col4;



wire[8:0] posX8;
wire[31:0] colors8;

wire[4:0] b8col1;
wire[4:0] b8col2;
wire[4:0] b8col3;
wire[4:0] b8col4;



wire[3:0] sclX1;
wire[3:0] sclX2;
wire[3:0] sclX3;
wire[3:0] sclX4;
wire[3:0] sclX5;
wire[3:0] sclX6;
wire[3:0] sclX7;
wire[3:0] sclX8;

wire swpX1;
wire swpX2;
wire swpX3;
wire swpX4;
wire swpX5;
wire swpX6;
wire swpX7;
wire swpX8;


wire[8:0] posX;
wire[31:0] colors;

wire[4:0] bcol1;
wire[4:0] bcol2;
wire[4:0] bcol3;
wire[4:0] bcol4;
wire[3:0] sclX;
wire swpX;

wire clr;
wire shift;


manager man(.clk(clk),
				.rst(rst),
				
				.shift(shift),
				.clr(clr),
				
				.uiin(uiin),
				
				.ccy(ccy),
				
				.CounterX(CounterX),
				.CounterY(CounterY),
				
				.fromRAM(fromRAM),
				.addr(addr),
	
				.posX1(posX),
				
				.colors1(colors),
				
				.b1col1(bcol1),
				.b1col2(bcol2),
				.b1col3(bcol3),
				.b1col4(bcol4),
				
				.sclX1(sclX),
				.swpX1(swpX)
				
				
);

wire[1:0] uicol;

uiconv uiC(.clk(clk),

			  .rst(rst),
			  .dclk(dclk),
			
			  .cx(CounterX),
			  .cy(CounterY),
	
			  .fromRAM(fromRAM),
	
			  .uicol(uicol)
);


shift sh1(.clk(clk),

			.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX),
	.i_sclX(sclX),
	.i_swpX(swpX),
	
	.i_bcolor1(bcol1),
	.i_bcolor2(bcol2),
	.i_bcolor3(bcol3),
	.i_bcolor4(bcol4),
	
	.i_colors(colors),
	
	.posX(posX1),
	.sclX(sclX1),
	.swpX(swpX1),
	
	.bcolor1(b1col1),
	.bcolor2(b1col2),
	.bcolor3(b1col3),
	.bcolor4(b1col4),
	
	.colors(colors1)
	
	
);

shift sh2(.clk(clk),

	.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX1),
	.i_sclX(sclX1),
	.i_swpX(swpX1),
	
	.i_bcolor1(b1col1),
	.i_bcolor2(b1col2),
	.i_bcolor3(b1col3),
	.i_bcolor4(b1col4),
	
	.i_colors(colors1),
	
	.posX(posX2),
	.sclX(sclX2),
	.swpX(swpX2),
	
	.bcolor1(b2col1),
	.bcolor2(b2col2),
	.bcolor3(b2col3),
	.bcolor4(b2col4),

	.colors(colors2)
	
	
);

shift sh3(.clk(clk),

	.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX2),
	.i_sclX(sclX2),
	.i_swpX(swpX2),
	
	.i_bcolor1(b2col1),
	.i_bcolor2(b2col2),
	.i_bcolor3(b2col3),
	.i_bcolor4(b2col4),
	
	.i_colors(colors2),
	
	.posX(posX3),
	.sclX(sclX3),
	.swpX(swpX3),
	
	.bcolor1(b3col1),
	.bcolor2(b3col2),
	.bcolor3(b3col3),
	.bcolor4(b3col4),
	
	.colors(colors3)
	
	
);

shift sh4(.clk(clk),

	.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX3),
	.i_sclX(sclX3),
	.i_swpX(swpX3),
	
	.i_bcolor1(b3col1),
	.i_bcolor2(b3col2),
	.i_bcolor3(b3col3),
	.i_bcolor4(b3col4),
	
	.i_colors(colors3),
	
	.posX(posX4),
	.sclX(sclX4),
	.swpX(swpX4),
	
	.bcolor1(b4col1),
	.bcolor2(b4col2),
	.bcolor3(b4col3),
	.bcolor4(b4col4),
	
	.colors(colors4)
	
	
);

shift sh5(.clk(clk),

	.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX4),
	.i_sclX(sclX4),
	.i_swpX(swpX4),
	
	.i_bcolor1(b4col1),
	.i_bcolor2(b4col2),
	.i_bcolor3(b4col3),
	.i_bcolor4(b4col4),
	
	.i_colors(colors4),
	
	.posX(posX5),
	.sclX(sclX5),
	.swpX(swpX5),

	.bcolor1(b5col1),
	.bcolor2(b5col2),
	.bcolor3(b5col3),
	.bcolor4(b5col4),
	
	.colors(colors5)
	
	
);

shift sh6(.clk(clk),

	.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX5),
	.i_sclX(sclX5),
	.i_swpX(swpX5),
	
	.i_bcolor1(b5col1),
	.i_bcolor2(b5col2),
	.i_bcolor3(b5col3),
	.i_bcolor4(b5col4),

	.i_colors(colors5),
	
	.posX(posX6),
	.sclX(sclX6),
	.swpX(swpX6),
	
	.bcolor1(b6col1),
	.bcolor2(b6col2),
	.bcolor3(b6col3),
	.bcolor4(b6col4),
	
	.colors(colors6)
	
	
);


shift sh7(.clk(clk),

	.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX6),
	.i_sclX(sclX6),
	.i_swpX(swpX6),
	
	.i_bcolor1(b6col1),
	.i_bcolor2(b6col2),
	.i_bcolor3(b6col3),
	.i_bcolor4(b6col4),
	
	.i_colors(colors6),
	
	.posX(posX7),
	.sclX(sclX7),
	.swpX(swpX7),
	
	.bcolor1(b7col1),
	.bcolor2(b7col2),
	.bcolor3(b7col3),
	.bcolor4(b7col4),
	
	.colors(colors7)
	
	
);


shift sh8(.clk(clk),


	.rst(rst),	
	.clr(clr),
	.shift(shift),
	
	.i_posX(posX7),
	.i_sclX(sclX7),
	.i_swpX(swpX7),
	
	.i_bcolor1(b7col1),
	.i_bcolor2(b7col2),
	.i_bcolor3(b7col3),
	.i_bcolor4(b7col4),
	
	.i_colors(colors7),
	
	.posX(posX8),
	.sclX(sclX8),
	.swpX(swpX8),
	
	.bcolor1(b8col1),
	.bcolor2(b8col2),
	.bcolor3(b8col3),
	.bcolor4(b8col4),
	
	.colors(colors8)
	
	
);

wire d1;
wire d2;
wire d3;
wire d4;
wire d5;
wire d6;
wire d7;
wire d8;

wire[1:0] col1;

sprite sprt1(.clk(dclk),

	.rst(rst),
	.cccx(ccx),
	.sclX(sclX1),
	.swpX(swpX1),
	.colors(colors1),
	.posX(posX1),
	
	.CounterX(CounterX),
	
	.col(col1)
);

wire[4:0] ecol1;

palette palt1(.clk(dclk),
	
				 .scol(col1),
	
				 .col(ecol1),
				
				 .bcol1(b1col1),
				 .bcol2(b1col2),
				 .bcol3(b1col3),
				 .bcol4(b1col4),
				
					.d(d1)
);

wire[1:0] col2;

sprite sprt2(.clk(dclk),

	.rst(rst),
	.cccx(ccx),
	.sclX(sclX2),
	.swpX(swpX2),
	
	.colors(colors2),
	.posX(posX2),
	
	.CounterX(CounterX),
	
	.col(col2)
);

wire[4:0] ecol2;

palette palt2(.clk(dclk),
	
				 .scol(col2),
	
				 .col(ecol2),
				
				 .bcol1(b2col1),
				 .bcol2(b2col2),
				 .bcol3(b2col3),
				 .bcol4(b2col4),
				
					.d(d2)
);

wire[1:0] col3;

sprite sprt3(.clk(dclk),

	.rst(rst),	
	.cccx(ccx),
	.sclX(sclX3),
	.swpX(swpX3),
	
	.colors(colors3),
	.posX(posX3),
	
	.CounterX(CounterX),
	
	.col(col3)
);

wire[4:0] ecol3;

palette palt3(.clk(dclk),
	
				 .scol(col3),
	
				 .col(ecol3),
				
				 .bcol1(b3col1),
				 .bcol2(b3col2),
				 .bcol3(b3col3),
				 .bcol4(b3col4),
				
					.d(d3)
);

wire[1:0] col4;

sprite sprt4(.clk(dclk),

	.rst(rst),
	.cccx(ccx),
	.sclX(sclX4),
	.swpX(swpX4),
	
	.colors(colors4),
	.posX(posX4),
	
	.CounterX(CounterX),
	
	.col(col4)
);

wire[4:0] ecol4;

palette palt4(.clk(dclk),
	
				 .scol(col4),
	
				 .col(ecol4),
				
				 .bcol1(b4col1),
				 .bcol2(b4col2),
				 .bcol3(b4col3),
				 .bcol4(b4col4),
				
					.d(d4)
);

wire[1:0] col5;

sprite sprt5(.clk(dclk),

	.rst(rst),
	.cccx(ccx),
	.sclX(sclX5),
	.swpX(swpX5),
	
	.colors(colors5),
	.posX(posX5),
	
	.CounterX(CounterX),
	
	.col(col5)
);

wire[4:0] ecol5;

palette palt5(.clk(dclk),
	
				 .scol(col5),
	
				 .col(ecol5),
				
				 .bcol1(b5col1),
				 .bcol2(b5col2),
				 .bcol3(b5col3),
				 .bcol4(b5col4),
				
					.d(d5)
);
	

wire[1:0] col6;

sprite sprt6(.clk(dclk),

	.rst(rst),
	.cccx(ccx),
	.sclX(sclX6),
	.swpX(swpX6),
	
	.colors(colors6),
	.posX(posX6),
	
	.CounterX(CounterX),
	
	.col(col6)
);

wire[4:0] ecol6;

palette palt6(.clk(dclk),
	
				 .scol(col6),
	
				 .col(ecol6),
				
				 .bcol1(b6col1),
				 .bcol2(b6col2),
				 .bcol3(b6col3),
				 .bcol4(b6col4),
				
					.d(d6)
);

wire[1:0] col7;

sprite sprt7(.clk(dclk),

	.cccx(ccx),
	.sclX(sclX7),
	.swpX(swpX7),
	
	.colors(colors7),
	.posX(posX7),
	
	.CounterX(CounterX),
	
	.col(col7)
);

wire[4:0] ecol7;

palette palt7(.clk(dclk),
	
				 .scol(col7),
	
				 .col(ecol7),
				
				 .bcol1(b7col1),
				 .bcol2(b7col2),
				 .bcol3(b7col3),
				 .bcol4(b7col4),
				
					.d(d7)
);

wire[1:0] col8;

sprite sprt8(.clk(dclk),

	.rst(rst),
	.cccx(ccx),
	.sclX(sclX8),
	.swpX(swpX8),
	
	.colors(colors8),
	.posX(posX8),
	
	.CounterX(CounterX),
	
	.col(col8)
);

wire[4:0] ecol8;

palette palt8(.clk(dclk),
	
				 .scol(col8),
	
				 .col(ecol8),
				
				 .bcol1(b8col1),
				 .bcol2(b8col2),
				 .bcol3(b8col3),
				 .bcol4(b8col4),
				
					.d(d8)
);

wire[4:0] endcol;

collector cola(.d1(d1),
					.d2(d2),
					.d3(d3),
					.d4(d4),
					.d5(d5),
					.d6(d6),
					.d7(d7),
					.d8(d8 & 0),
					
					.bcgcol(bcgcol),
					
					.ecol1(ecol1), 
					.ecol2(ecol2), 
					.ecol3(ecol3), 
					.ecol4(ecol4), 
					.ecol5(ecol5), 
					.ecol6(ecol6),
					.ecol7(ecol7),
					.ecol8(ecol8 & 0),

					.out(endcol)  	
);

wire[4:0] oocol;

ui u(.clk(dclk),
	
		.uiin(uicol),
		
		.bgcol2(bgcol2),
		.bgcol3(bgcol3),
		.bgcol4(bgcol4),
		
	  .in(endcol),
	
	  .out(oocol)
);


lastBlock lB(.dclk(dclk),
				 .splash(splash),
				 .clk(clk),
				 .rst(rst),
				 
				 .xhsync(xhsync),
				 .xvsync(xvsync),
	
				 .col(oocol),
				 .ins(ins),
				 .CounterX(CounterX),
				 .CounterY(CounterY),
	
				 .hsync(hsync),
				 .vsync(vsync),
	
				 .R(R),
				 .G(G),
				 .B(B),
				 
				
);

endmodule

module ui(
	input clk,
	
	input[9:0] CounterX,
	input[8:0] CounterY,
	
	input[4:0] in,
	
	input[1:0] uiin,
	
	input[4:0] bgcol2,
	input[4:0] bgcol3,
	input[4:0] bgcol4,
	
	output reg[4:0] out
);

always@(posedge clk)begin

	case(uiin)
		1: out <= bgcol2;
		2: out <= bgcol3;
		3: out <= bgcol4;
		default: out <= in;
	endcase

end


endmodule

