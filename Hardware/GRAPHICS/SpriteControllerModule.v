module SpriteController(
	input clk,
	input rst,
	
	input start,
	input[23:0] in,
	
	output reg wx,
	output reg[8:0] waddrx,
	output reg[31:0] savex,

	output reg rdy
);

reg[3:0] uinnum;
reg[3:0] f_uinnum;

reg[2:0] yline;
reg[2:0] f_yline;

reg[15:0] uitexline;
reg[15:0] f_uitexline;

reg[4:0] spritetexnum;
reg[4:0] f_spritetexnum;

reg[3:0] ysline;
reg[3:0] f_ysline;

reg[15:0] spritetexline;
reg[15:0] f_spritetexline;

reg[31:0] line1;
reg[31:0] line2;

reg[31:0] f_line1;
reg[31:0] f_line2;

reg[1:0] f_readme;
reg[1:0] readme;

reg[4:0] numsp;
reg[4:0] f_numsp;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_uinnum <= 0;
		f_yline <= 0;
		f_uitexline <= 0;
		
		f_spritetexnum <= 0;
		f_spritetexline <= 0;
		f_ysline <= ysline;
		
		f_line1 <= 0;
		f_line2 <= 0;
		
		f_numsp <= 0;
		
		f_readme <= 0;
		f_numsp <= 0;

	end else
	begin
		f_uinnum <= uinnum;
		f_yline <= yline;
		f_uitexline <= uitexline;
		
		f_spritetexnum <= spritetexnum;
		f_spritetexline <= spritetexline;
		f_ysline <= ysline;
		
		f_line1 <= line1;
		f_line2 <= line2;
		
		f_numsp <= numsp;
		
		f_readme <= readme;
		f_numsp <= numsp;
	end
end

always@(*)begin

	numsp = f_numsp;
	
	uinnum = f_uinnum;
	yline = f_yline;
	uitexline = f_uitexline;
	
	spritetexnum = f_spritetexnum;
	ysline = f_ysline;
	
	line1 = f_line1;
	line2 = f_line2;
	
	readme = f_readme;
	
	spritetexline = f_spritetexline;
	
	wx = 0;
	savex  =0;
	waddrx = 0;
	
	rdy = 0;
	
	case(in[23:16])
		8'd15: uinnum = in[3:0]; // GET UI.TEXTURE.NUMBER;
		8'd16: yline = in[2:0]; // GET UI.TEXTURE(NUMBER).YLINE
		8'd17: if(f_yline[0]) begin // SET UI.TEXTURE(NUMBER).YLINE(YNUMBER).PIXELS
						wx = 1;
						waddrx = {1'b1,f_uinnum,f_yline[2:1]};
						savex = {f_uitexline,in[15:0]};
				 end
				 else begin
						uitexline = in[15:0];
				 end	
		8'd18: if(in[4:3] != 0) spritetexnum = in[4:0]; // GET SPRITE.TEXTURE.NUMBER
		8'd19: ysline = in[3:0]; // GET SPRITE.TEXTUTE(NUMBER).YLINE
		8'd20: spritetexline = in[15:0]; // SET SPRITE.TEXTUTE(NUMBER).YLINE(YNUMBER).PIXELS1
		8'd21: begin // SET SPRITE.TEXTUTE(NUMBER).YLINE(YNUMBER).PIXELS2
						wx = 1;
						waddrx = {f_spritetexnum,f_ysline};
						savex = {f_spritetexline,in[15:0]};
				 end
		8'd22: begin //GET SPRITE.SPRITE.NUMBER
					 numsp = in[4:0];
					 line1 = 0;
					 line2 = 0;
				 end
		8'd23: begin // SET SPEITE.SPRITE(NUMBER).POSX;
						wx = 1;
						waddrx = {f_numsp,1'b0}; 
						savex = {in[8:0],f_line1[22:0]};
						line1 = {in[8:0],f_line1[22:0]};
				 end
		8'd24: begin // SET SPEITE.SPRITE(NUMBER).POSY;
						wx = 1;
						waddrx = {f_numsp,1'b0}; 
						savex = {f_line1[31:23],in[7:0],f_line1[14:0]};
						line1 = {f_line1[31:23],in[7:0],f_line1[14:0]};
				 end
		8'd25: begin // SET SPEITE.SPRITE(NUMBER).SCLX;
						wx = 1;
						waddrx = {f_numsp,1'b0}; 
						savex = {f_line1[31:15],in[3:0],f_line1[10:0]};
						line1 = {f_line1[31:15],in[3:0],f_line1[10:0]};
				 end
		8'd26: begin // SET SPEITE.SPRITE(NUMBER).SCLY;
						wx = 1;
						waddrx = {f_numsp,1'b0}; 
						savex = {f_line1[31:11],in[3:0],f_line1[6:0]};
						line1 = {f_line1[31:11],in[3:0],f_line1[6:0]};
				 end
		8'd27: begin // SET SPEITE.SPRITE(NUMBER).SWPX;
						wx = 1;
						waddrx = {f_numsp,1'b0}; 
						savex = {f_line1[31:7],in[0],f_line1[5:0]};
						line1 = {f_line1[31:7],in[0],f_line1[5:0]};
				 end
		8'd28: begin // SET SPEITE.SPRITE(NUMBER).SWPY;
						wx = 1;
						waddrx = {f_numsp,1'b0}; 
						savex = {f_line1[31:6],in[0],f_line1[4:0]};
						line1 = {f_line1[31:6],in[0],f_line1[4:0]};
				 end
		8'd29: begin // CLEAR SPEITE.SPRITE(NUMBER).PORP1;
						wx = 1;
						waddrx = {f_numsp,1'b0}; 
						savex = 0;
						line1 = 0;
				 end
		8'd30: begin // SET SPEITE.SPRITE(NUMBER).TEX;
						wx = 1;
						waddrx = {f_numsp,1'b1}; 
						savex = {1'b0,in[4:0],f_line2[25:0]};
						line2 = {1'b0,in[4:0],f_line2[25:0]};
				 end
		8'd31: begin // SET SPEITE.SPRITE(NUMBER).COL1;
						wx = 1;
						waddrx = {f_numsp,1'b1}; 
						savex = {f_line2[31:26],in[4:0],f_line2[20:0]};
						line2 = {f_line2[31:26],in[4:0],f_line2[20:0]};
				 end
		8'd32: begin // SET SPEITE.SPRITE(NUMBER).COL2;
						wx = 1;
						waddrx = {f_numsp,1'b1}; 
						savex = {f_line2[31:21],in[4:0],f_line2[15:0]};
						line2 = {f_line2[31:21],in[4:0],f_line2[15:0]};
				 end
		8'd33: begin // SET SPEITE.SPRITE(NUMBER).COL3;
						wx = 1;
						waddrx = {f_numsp,1'b1}; 
						savex = {f_line2[31:16],in[4:0],f_line2[10:0]};
						line2 = {f_line2[31:16],in[4:0],f_line2[10:0]};
				 end
		8'd34: begin // SET SPEITE.SPRITE(NUMBER).COL4;
						wx = 1;
						waddrx = {f_numsp,1'b1}; 
						savex = {f_line2[31:11],in[4:0],f_line2[5:0]};
						line2 = {f_line2[31:11],in[4:0],f_line2[5:0]};
				 end
		8'd35: begin // CLEAR SPEITE.SPRITE(NUMBER).PORP2;
						wx = 1;
						waddrx = {f_numsp,1'b1}; 
						savex = 0;
						line1 = 0;
				 end
		8'd249: begin // CLM
					 wx = 1;
						waddrx = {in[8:0]}; 
						savex = 0;
						line1 = 0;
			end
		default:;
	endcase

end

endmodule
