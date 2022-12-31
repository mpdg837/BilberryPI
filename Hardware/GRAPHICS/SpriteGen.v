
module sprite(
	input clk,
	input rst,
	
	input[9:0] cccx,
	
	input[3:0] sclX,
	input[8:0] posX,
	input[31:0] colors,
	input[9:0] CounterX,
	
	input swpX,
	
	output[1:0] col
	
);

wire[8:0] relx = cccx[9:1] - posX;

reg visible;

reg[31:0] pcol = 0;

reg[8:0] cx = 0;

reg[9:0] ccx = 0;

reg[1:0] ccol;

reg[8:0] relPosX;
reg[8:0] f_relPosX;


always@(*)
	if(rst) pcol <= 0;
	else pcol <= colors;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		cx <= 0;
		ccx <= 0;
		
		relPosX <= 0;

	end else
	begin
		cx <= relx;
		ccx <= CounterX;
		
		relPosX <= f_relPosX;
	end
end

wire[3:0] negpo= ~sclX;

always@(*)begin
	f_relPosX = relPosX;
	
	
	if(cx[8:6] == 0)begin
		
		if(relPosX[8:3] == 16) begin
			f_relPosX = {5'd16,3'b0};
		end else if(cx == 0)begin
			f_relPosX = 0;
		end else
		begin
			
			f_relPosX = relPosX + (negpo);
		end
		
	end else
	begin
		
		f_relPosX = 0;
	
	end
	

end

reg[3:0] relPosXP;
reg renderSprite;

always@(*)begin
	
	renderSprite = ~(f_relPosX[8] | f_relPosX[7]);
	
	if(~swpX) relPosXP = ~f_relPosX[6:3];
	else relPosXP = f_relPosX[6:3];

end

always@(*)begin
	if(renderSprite)
		case(relPosXP)
			15: ccol <= pcol[31:30];
			14: ccol <= pcol[29:28];
			13: ccol <= pcol[27:26];
			12: ccol <= pcol[25:24];
			11: ccol <= pcol[23:22];
			10: ccol <= pcol[21:20];
			9:	 ccol <= pcol[19:18];
			8:	 ccol <= pcol[17:16];
			7:	 ccol <= pcol[15:14];
			6:  ccol <= pcol[13:12];
			5:  ccol <= pcol[11:10];
			4:  ccol <= pcol[9:8];
			3:	 ccol <= pcol[7:6];
			2:  ccol <= pcol[5:4];
			1:  ccol <= pcol[3:2];
			0:  ccol <= pcol[1:0];
			default: ccol <= 0;
		endcase
	else
		ccol <= 0;
end

always@(*)begin
	
	visible = 0;
	
	if( cx[8:6]==0 )begin
		visible = 1;
	end	
	
end

assign col = ccol & {visible,visible};


endmodule


module palette(
	input clk,
	
	input[4:0] bcol1,
	input[4:0] bcol2,
	input[4:0] bcol3,
	input[4:0] bcol4,
	
	input[1:0] scol,
	
	output reg[4:0] col,
	output reg d
);


always@(posedge clk)begin
	case(scol)
		2'd0: begin
				col <= 0;
				d <= 0;
				end
		2'd1: begin
				col <= bcol2;
				d <= 1;
				end
		2'd2: begin
				col <= bcol3;
				d <= 1;
				end
		2'd3: begin
				col <= bcol4;
				d <= 1;
				end
		default: begin
					col <= 0;
					d <= 0;
				end
	endcase
end

endmodule
