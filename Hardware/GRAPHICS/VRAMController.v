module BCGController(
	input clk,
	input rst,
	
	input start,
	input[23:0] in,
	
	input[5:0] clearx,
	input[4:0] cleary,
	
	output reg[12:0] waddr,
	output reg w,
	output reg[7:0] save1,
	
	output reg ws,
	output reg sel,
	output reg[3:0] save2
);

reg[7:0] ntex;
reg[7:0] f_ntex;

reg[2:0] yline;
reg[2:0] f_yline;

reg[8:0] x;
reg[7:0] y;

reg[8:0] f_x;
reg[7:0] f_y;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_ntex <= 0;
		f_yline <= 0;
		
		f_x <= 0;
		f_y <= 0;
	end else
	begin
		f_ntex <= ntex;
		f_yline <= yline;
		
		f_x <= x;
		f_y <= y;
	end
end

always@(*)begin

	ntex = f_ntex;
	yline = f_yline;
	
	x = f_x;
	y = f_y;
	
	waddr = 0;
	w = 0;
	save1 = 0;
	
	ws = 0;
	sel = 0;
	save2 = 0;
	
	if(start)
		case(in[23:16])
			8'd6: ntex = in[7:0]; // GET TEXTURE.NUMBER
			8'd7: yline = in[2:0]; // GET TEXTURE(NUMBER).YLINE
			8'd8: begin // SET TEXTURE(NUMBER).YLINE(YNUMBER).PIXELSCOL1
					w = 1;
					waddr = {2'b01,f_ntex[6:0],f_yline,1'b0};
					save1 = in [15:8];
			end
			
			10: begin
					x = in[8:3];
			end
			11: begin
					y = in[7:3];
			end
			
			8'd9: begin // SET TEXTURE(NUMBER).YLINE(YNUMBER).PIXELSCOL2
					w = 1;
					waddr = {2'b01,f_ntex[6:0],f_yline,1'b1};
					save1 = in [7:0];
			end
			
			8'd13: begin // SET BCG.BLOCK(X,Y).PALETTE
					 ws = 1;
					 sel = ~f_y[3];
					 waddr = {3'b111,f_x[8:3],f_y[7:4]};
					 save2 = in[3:0];
			end
			8'd14: begin // SET UI.BLOCK(X,Y).TEXTURE
					 ws = 1;
					 sel = ~f_y[3];
					 waddr = {3'b110,f_x[8:3],f_y[7:4]};
					 save2 = in[3:0];
			end
			8'd244: begin // LOAD BUFFER PALETTE
					 ws = 1;
					 sel = ~cleary[0];
					 waddr = {3'b111,clearx[5:0],cleary[4:1]};
					 save2 = in[3:0];
			end
			8'd252: begin // LOAD BUFFER
					 w = 1;
					 waddr = {2'b10,clearx,cleary};
					 save1 = in[7:0];
			end
			8'd250: begin // CLM
					 w = 1;
					 waddr = {in[12:0]};
					 save1 = 0;
			end
			
		endcase
end


endmodule
