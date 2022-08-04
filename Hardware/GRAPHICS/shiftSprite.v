module shift(
	input clk,
	input rst,
	
	input clr,
	input shift,
	
	input[8:0] i_posX,
	input[3:0] i_sclX,
	input i_swpX,
	
	input[4:0] i_bcolor1,
	input[4:0] i_bcolor2,
	input[4:0] i_bcolor3,
	input[4:0] i_bcolor4,
	
	input[31:0] i_colors,
	
	output reg[8:0] posX,
	output reg[3:0] sclX,
	output reg swpX,
	
	output reg[4:0] bcolor1,
	output reg[4:0] bcolor2,
	output reg[4:0] bcolor3,
	output reg[4:0] bcolor4,
	
	output reg[31:0] colors
	
	
);


reg[8:0] f_posX;
reg[3:0] f_sclX;
reg f_swpX;
	
reg[4:0] f_bcolor1;
reg[4:0] f_bcolor2;
reg[4:0] f_bcolor3;
reg[4:0] f_bcolor4;
	
reg[31:0] f_colors;
	
always@(posedge clk or posedge rst)begin
	if(rst) begin
		posX <= 0;
		sclX <= 0;
		swpX <= 0;

	end else
	begin
		posX <= f_posX;
		sclX <= f_sclX;
		swpX <= f_swpX;
	end
end

always@(posedge clk) begin
	if(rst)begin
		bcolor1 <= 0;
		bcolor2 <= 0;
		bcolor3 <= 0;
		bcolor4 <= 0;
	end else
	begin
		bcolor1 <= f_bcolor1;
		bcolor2 <= f_bcolor2;
		bcolor3 <= f_bcolor3;
		bcolor4 <= f_bcolor4;
	end
end

always@(posedge clk) begin
	colors <= f_colors;
end

always@(*)begin
	
	f_colors = colors;
	
	if(clr) begin

		f_colors = 0;
	end
	
	if(shift)begin
	
		f_colors = i_colors;
	end
end


always@(*)begin
	f_posX = posX;
	f_sclX = sclX;
	f_swpX = swpX;
	
	if(clr) begin
		f_posX = 0;
		f_sclX = 0;
		f_swpX = 0;
		
	end
	
	if(shift)begin
		f_posX = i_posX;
		f_sclX = i_sclX;
		f_swpX = i_swpX;
	end
end


always@(*)begin

	
	f_bcolor1 = bcolor1;
	f_bcolor2 = bcolor2;
	f_bcolor3 = bcolor3;
	f_bcolor4 = bcolor4;
	
	
	if(clr) begin

		
		f_bcolor1 = 0;
		f_bcolor2 = 0;
		f_bcolor3 = 0;
		f_bcolor4 = 0;
		
	end
	
	if(shift)begin
		
		f_bcolor1 = i_bcolor1;
		f_bcolor2 = i_bcolor2;
		f_bcolor3 = i_bcolor3;
		f_bcolor4 = i_bcolor4;
		
	end
end


endmodule
