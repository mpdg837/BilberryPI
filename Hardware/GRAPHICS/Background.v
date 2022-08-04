


module bcgman(
	input clk,
	input rst,
	
	input[9:0] cx,
	input[8:0] cy,
	
	input[9:0] x,
	input[8:0] y,
	
	input[7:0] fromRAM,
	
	output reg[12:0] addrRAM,
	output reg[3:0] ui,
	
	output reg[1:0] color,
	output reg[3:0] palette
	
);

reg[1:0] f_s=0;
reg[1:0] s=0;

reg[1:0] f_color = 0;
reg[1:0] f_palette = 0;

reg[1:0] f_ncolor = 0;
reg[1:0] f_npalette = 0;

reg[1:0] ncolor = 0;
reg[3:0] npalette = 0;

reg[3:0] nui = 0;
reg[3:0] f_nui = 0;
reg[3:0] f_ui;

reg[8:0] ccx;
reg[8:0] f_ccx;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_s <= 0;
		f_palette <= 0;
		f_color <= 0;

		f_ncolor <= 0;
		f_ccx <= 0;
		
		f_nui = 0;
		f_ui = 0;
	end else
	begin
		f_s <= s;
		f_palette <= palette;
		f_color <= color;

		f_ncolor <= ncolor;
		f_ccx <= ccx;
		
		f_nui = nui;
		f_ui = ui;
	end
end

always@(*)begin
	s = f_s;
	addrRAM = 0;
	
	palette = f_palette;
	color = f_color;
	
	ncolor = f_ncolor;
	
	nui = f_nui;
	ui = f_ui;
	
	ccx = f_ccx;
	
	case(f_s)
		0: begin
			addrRAM = {2'b10,cx[9:4],cy[8:4]};
			ccx = cx[9:1];
			
			if(cy[4]) nui = fromRAM[3:0];
			else nui = fromRAM[7:4]; 
			
			s=1;
		end
		
		1: begin
			 case(fromRAM[7:6])
				2'b11:
					if(f_ccx[2])
						addrRAM = {2'b01,1'b1,fromRAM[5:0],1'b1,cy[3:2],1'b1};
					else
						addrRAM = {2'b01,1'b1,fromRAM[5:0],1'b1,cy[3:2],1'b0};
				2'b10:
					if(f_ccx[2])
						addrRAM = {2'b01,1'b1,fromRAM[5:0],1'b0,cy[3:2] ,1'b1};
					else
						addrRAM = {2'b01,1'b1,fromRAM[5:0],1'b0,cy[3:2] ,1'b0};

				default:
					if(f_ccx[2])
						addrRAM = {2'b01,fromRAM[6:0],cy[3:1],1'b1};
					else
						addrRAM = {2'b01,fromRAM[6:0],cy[3:1],1'b0};
				
			 endcase
	
				
			s=2;
		end
		2: begin
			addrRAM = {3'b111,f_ccx[8:3],cy[8:5]};
			case(f_ccx[1:0])
			
				3: ncolor = fromRAM[1:0];
				2: ncolor = fromRAM[3:2];
				1: ncolor = fromRAM[5:4];
				0: ncolor = fromRAM[7:6];
				default:;
			endcase
			s=3;
		end
		3: begin
		
			addrRAM = {3'b110,f_ccx[8:3],y[8:5]};
		
			if(cy[4]) palette = fromRAM[3:0];
			else palette = fromRAM[7:4];
			
			ui = f_nui;
			color = f_ncolor;
			s=0;
		end
	endcase
end

endmodule

module paletteBcg(
	input clk,
	input rst,
	
	input[9:0] CounterX,
	input[8:0] CounterY,
	
	input[4:0] b1col1,
	input[4:0] b1col2,
	input[4:0] b1col3,
	input[4:0] b1col4,
	
	input[4:0] b2col1,
	input[4:0] b2col2,
	input[4:0] b2col3,
	input[4:0] b2col4,
	
	input[4:0] b3col1,
	input[4:0] b3col2,
	input[4:0] b3col3,
	input[4:0] b3col4,
	
	input[4:0] b4col1,
	input[4:0] b4col2,
	input[4:0] b4col3,
	input[4:0] b4col4,
	
	input[4:0] b5col1,
	input[4:0] b5col2,
	input[4:0] b5col3,
	input[4:0] b5col4,
	
	input[4:0] b6col1,
	input[4:0] b6col2,
	input[4:0] b6col3,
	input[4:0] b6col4,
	
	input[4:0] b7col1,
	input[4:0] b7col2,
	input[4:0] b7col3,
	input[4:0] b7col4,
	
	input[4:0] b8col1,
	input[4:0] b8col2,
	input[4:0] b8col3,
	input[4:0] b8col4,
	
	input[3:0] palette,
	
	input[1:0] col,
	
	output reg[4:0] pcol
	
);

always@(posedge clk)begin
	case(palette)
		0:	case(col)
				0: pcol <= b1col1;
				1: pcol <= b1col2;
				2: pcol <= b1col3;
				3: pcol <= b1col4;
			endcase
		1:	case(col)
				0: pcol <= b2col1;
				1: pcol <= b2col2;
				2: pcol <= b2col3;
				3: pcol <= b2col4;
			endcase
		2:	case(col)
				0: pcol <= b3col1;
				1: pcol <= b3col2;
				2: pcol <= b3col3;
				3: pcol <= b3col4;
			endcase
		3:	case(col)
				0: pcol <= b4col1;
				1: pcol <= b4col2;
				2: pcol <= b4col3;
				3: pcol <= b4col4;
			endcase
		4:	case(col)
				0: pcol <= b5col1;
				1: pcol <= b5col2;
				2: pcol <= b5col3;
				3: pcol <= b5col4;
			endcase
		5:	case(col)
				0: pcol <= b6col1;
				1: pcol <= b6col2;
				2: pcol <= b6col3;
				3: pcol <= b6col4;
			endcase
		6:	case(col)
				0: pcol <= b7col1;
				1: pcol <= b7col2;
				2: pcol <= b7col3;
				3: pcol <= b7col4;
			endcase
		7:	case(col)
				0: pcol <= b8col1;
				1: pcol <= b8col2;
				2: pcol <= b8col3;
				3: pcol <= b8col4;
			endcase
		default:;
		endcase
end

endmodule
