
module collector(
	input d1,
	input d2,
	input d3,
	input d4,
	input d5,
	input d6,
	input d7,
	input d8,
	input d9,
	input d10,
	input d11,
	input d12,
	input d13,
	input d14,
	input d15,
	input d16,
	
	input[4:0] bcgcol,
	
	input[4:0] ecol1, 
	input[4:0] ecol2, 
	input[4:0] ecol3, 
	input[4:0] ecol4, 
	input[4:0] ecol5, 
	input[4:0] ecol6,
	input[4:0] ecol7,
	input[4:0] ecol8,
	input[4:0] ecol9, 
	input[4:0] ecol10,
	input[4:0] ecol11,
	input[4:0] ecol12,
	input[4:0] ecol13, 
	input[4:0] ecol14,
	input[4:0] ecol15,
	input[4:0] ecol16,
	
	output reg[4:0] out  	
);

always@(*)begin
	if(d1) out <= ecol1;
	else if(d2) out <= ecol2;
	else if(d3) out <= ecol3;
	else if(d4) out <= ecol4;
	else if(d5) out <= ecol5;
	else if(d6) out <= ecol6;
	else if(d7) out <= ecol7;
	else if(d8) out <= ecol8;
	else if(d9) out <= ecol9;
	else if(d10) out <= ecol10;
	else if(d11) out <= ecol11;
	else if(d12) out <= ecol12;
	else if(d13) out <= ecol13;
	else if(d14) out <= ecol14;
	else if(d15) out <= ecol15;
	else if(d16) out <= ecol16;
	else out <= bcgcol;
end
endmodule


module lastBlock(
	
	input dclk,
	input clk,
	input rst,
	input splash,
	
	input xhsync,
	input xvsync,
	
	input[4:0] col,
	
	input ins,
	input[9:0] CounterX,
	input[8:0] CounterY,
	
	output R,
	output G,
	output B,
	
	output hsync,
	output vsync
);


wire xc;
wire yc;

wire xc1;
wire yc1;

wire xc2;
wire yc2;


wire xhsync1;
wire xvsync1;

wire xhsync2;
wire xvsync2;

wire xhsync3;
wire xvsync3;

wire xhsync4;
wire xvsync4;

wire ins1;
wire ins2;
wire ins3;

buffer b15(.clk(dclk),.in(CounterX[0]),.out(xc));
buffer b16(.clk(dclk),.in(xc),.out(xc1));
buffer b17(.clk(dclk),.in(xc1),.out(xc2));

buffer b18(.clk(dclk),.in(CounterY[0]),.out(yc));
buffer b19(.clk(dclk),.in(yc),.out(yc1));
buffer b20(.clk(dclk),.in(yc1),.out(yc2));
				 
buffer b1(.clk(dclk),.in(xhsync),.out(xhsync1));
buffer b2(.clk(dclk),.in(xvsync),.out(xvsync1));
buffer b10(.clk(dclk),.in(ins),.out(ins1));

buffer b3(.clk(dclk),.in(xhsync1),.out(xhsync2));
buffer b4(.clk(dclk),.in(xvsync1),.out(xvsync2));
buffer b11(.clk(dclk),.in(ins1),.out(ins2));

buffer b5(.clk(dclk),.in(xhsync2),.out(xhsync3));
buffer b6(.clk(dclk),.in(xvsync2),.out(xvsync3));
buffer b12(.clk(dclk),.in(ins2),.out(ins3));

buffer b8(.clk(dclk),.in(xhsync3),.out(xhsync4));
buffer b9(.clk(dclk),.in(xvsync3),.out(xvsync4));
buffer b13(.clk(dclk),.in(ins3),.out(ins4));

wire[4:0] col41;
wire[4:0] col42;
buffer4 b22(.clk(dclk),.in(col),.out(col41));
buffer4 b23(.clk(dclk),.in(col41),.out(col42));

wire comb;
wire comb1;
wire comb2;



combiner com(.clk(dclk),
				 .rst(rst),
				 .CounterX(CounterX),
				 .CounterY(CounterY),
	
				 .comb(comb)
	
);

buffer b7(.clk(dclk),.in(comb),.out(comb1));
buffer b14(.clk(dclk),.in(comb1),.out(comb2));

wire[5:0] color;

wire xR;
wire xG;
wire xB;

wire iscolmix;
wire[2:0] colmix;

colorDecoder cD(.clk(dclk),
					 .inCol(col42),
	
					 .decCol(color)
);

mixer mix(.clk(clk),
	
			 .CounterX(xc2),
			 .CounterY(yc2),
	
			 .color(color),
			 .comb(comb2),
			
			 .R(xR),
			 .G(xG),
			 .B(xB)
);

outputVideo oV(.clk(clk),
	
			.xR(xR),
			.xG(xG),
			.xB(xB),
			
			.ins(ins4 & splash),
			
			.xhsync(xhsync4),
			.xvsync(xvsync4),
			
			.hsync(hsync),
			.vsync(vsync),
			
			.R(R),
			.G(G),
			.B(B)
);

endmodule

module buffer(
	input clk,
	input in,
	
	output reg out

);

always@(posedge clk)begin
	out <= in;
end

endmodule

module colorDecoder(
	input clk,
	input[4:0] inCol,
	
	output [5:0] decCol

);

reg[9:0] ddd;

always@(posedge clk)
	case(inCol)
		0:  ddd <= {2'b00,2'b00,2'b00,3'b100,1'b0};
		1:  ddd <= {2'b00,2'b00,2'b01,3'b100,1'b0};
		2:  ddd <= {2'b00,2'b00,2'b11,3'b100,1'b0};
		3:  ddd <= {2'b00,2'b01,2'b11,3'b100,1'b0};
		4:  ddd <= {2'b00,2'b01,2'b01,3'b100,1'b0};
		5:  ddd <= {2'b00,2'b01,2'b00,3'b100,1'b0};
		6:  ddd <= {2'b00,2'b11,2'b00,3'b100,1'b0};
		7:  ddd <= {2'b00,2'b11,2'b01,3'b100,1'b0};
		8:  ddd <= {2'b00,2'b11,2'b11,3'b100,1'b0};
		9:  ddd <= {2'b01,2'b11,2'b11,3'b100,1'b0};
		10: ddd <= {2'b01,2'b11,2'b01,3'b100,1'b0};
		11: ddd <= {2'b01,2'b11,2'b00,3'b100,1'b0};
		12: ddd <= {2'b01,2'b01,2'b00,3'b100,1'b0};
		13: ddd <= {2'b01,2'b01,2'b01,3'b100,1'b0};
		14: ddd <= {2'b01,2'b01,2'b11,3'b100,1'b0};
		15: ddd <= {2'b01,2'b00,2'b11,3'b100,1'b0};
		16: ddd <= {2'b01,2'b00,2'b01,3'b100,1'b0};
		17: ddd <= {2'b01,2'b00,2'b00,3'b100,1'b0};
		18: ddd <= {2'b11,2'b00,2'b00,3'b100,1'b0};
		19: ddd <= {2'b11,2'b00,2'b01,3'b100,1'b0};
		20: ddd <= {2'b11,2'b00,2'b11,3'b100,1'b0};
		21: ddd <= {2'b11,2'b01,2'b11,3'b000,1'b0};
		22: ddd <= {2'b11,2'b01,2'b01,3'b000,1'b0};
		23: ddd <= {2'b11,2'b01,2'b00,3'b000,1'b0};
		24: ddd <= {2'b11,2'b11,2'b00,3'b000,1'b0};
		25: ddd <= {2'b11,2'b11,2'b01,3'b000,1'b0};
		26: ddd <= {2'b11,2'b11,2'b11,3'b000,1'b0};
		default: ddd <= 0;
	endcase

assign decCol = ddd[9:4];

endmodule

module buffer4(
	input clk,
	input[4:0] in,
	output reg[4:0] out
);

always@(posedge clk)
	out <= in;
endmodule


module mixer(
	input clk,

	input[9:0] CounterX,
	input[8:0] CounterY,
	
	input[5:0] color,
	
	input comb,
	
	output R,
	output G,
	output B
);

wire p1 = (CounterX[0]);

wire kratka = comb ? (CounterY[0] ? p1 : ~p1): (CounterY[0] ? ~p1 : p1);

wire[2:0] fcolor = { kratka ? color[5] : color[4], kratka ? color[3] : color[2], kratka ? color[1] : color[0]};


 
wire iR =  fcolor[2];
wire iG =  fcolor[1];
wire iB =  fcolor[0];

bufferRGB iRa(.clk(clk),
	
	.iR(iR),
	.iG(iG),
	.iB(iB),
	
	.R(R),
	.G(G),
	.B(B)
);

endmodule

module buffer9(
	input clk,
	input[9:0] in,
	
	output reg[9:0] out

);

always@(posedge clk)begin
	out <= in;
end

endmodule
module bufferRGB(
	input clk,
	
	input iR,
	input iG,
	input iB,
	
	output reg R,
	output reg G,
	output reg B
);

always@(posedge clk)begin
	R <= iR;
	G <= iG;
	B <= iB;
end

endmodule

module next(
	input clk,
	
	
	input[9:0] CounterX,
	input[8:0] CounterY,

	input comb,
	output[8:0] out
);
reg[8:0] f_out;
reg[8:0] n_out;

always@(posedge clk)begin
	n_out <= f_out;
end

always@(*)begin
	f_out = n_out;
	
	if(comb) f_out = n_out + 1;
end

assign out = {CounterX[6:2],3'b0};

endmodule

module combiner(
	input clk,
	input rst,
	
	input[9:0] CounterX,
	input[8:0] CounterY,
	
	output reg comb
	
);

reg f_comb = 0;
reg f_tim;
reg n_tim;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		comb <= 0;
		f_tim <= 0;
	end
	else begin
		comb <= f_comb;
		f_tim <= n_tim;
		end
end

always@(*)begin
	f_comb = comb;
	n_tim = f_tim;
	
	if(CounterX == 0 && CounterY == 0)begin
		n_tim = f_tim+1;
		if(f_tim == 0) f_comb = ~comb;
	end
end

endmodule


module outputVideo(
	input clk,
	input cclk,
	
	input xR,
	input xG,
	input xB,
	
	input ins,
	
	input xhsync,
	input xvsync,
	
	output reg hsync,
	output reg vsync,
	
	output reg R,
	output reg G,
	output reg B
);

reg f_R;
reg f_G;
reg f_B;

always@(posedge clk)begin
	R <= f_R;
	G <= f_G;
	B <= f_B;
end

always@(posedge clk)begin
	hsync <= xhsync;
	vsync <= xvsync;
end

always@(*)begin
	f_R = 0;
	f_G = 0;
	f_B = 0;
	
	if(ins) begin
		f_R = xR;
		f_G = xG;
		f_B = xB;
	end
	
end

endmodule

module clkdiv(
	input clk,
	
	output dclk
);

reg f_dclk = 0;
reg n_dclk = 0;
always@(posedge clk)
	f_dclk <= n_dclk;
	
always@(*)
	n_dclk = ~f_dclk;
	
	
assign dclk = f_dclk;

endmodule
