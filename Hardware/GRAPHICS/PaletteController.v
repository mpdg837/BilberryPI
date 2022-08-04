module deltaController(
	input clk,
	input rst,
	
	input[23:0] in,
	input start,
	
	output reg delirq,
	
	output splash,
	
	output reg[4:0] deltaY,
	output reg[6:0] deltaX,
	
	output reg[4:0] bg1col1,
	output reg[4:0] bg1col2,
	output reg[4:0] bg1col3,
	output reg[4:0] bg1col4,
	
	output reg[4:0] bg2col1,
	output reg[4:0] bg2col2,
	output reg[4:0] bg2col3,
	output reg[4:0] bg2col4,
	
	output reg[4:0] bg3col1,
	output reg[4:0] bg3col2,
	output reg[4:0] bg3col3,
	output reg[4:0] bg3col4,
	
	output reg[4:0] bg4col1,
	output reg[4:0] bg4col2,
	output reg[4:0] bg4col3,
	output reg[4:0] bg4col4,
	
	output reg[4:0] bg5col1,
	output reg[4:0] bg5col2,
	output reg[4:0] bg5col3,
	output reg[4:0] bg5col4,
	
	output reg[4:0] bg6col1,
	output reg[4:0] bg6col2,
	output reg[4:0] bg6col3,
	output reg[4:0] bg6col4,
	
	output reg[4:0] bg7col1,
	output reg[4:0] bg7col2,
	output reg[4:0] bg7col3,
	output reg[4:0] bg7col4,
	
	output reg[4:0] bg8col1,
	output reg[4:0] bg8col2,
	output reg[4:0] bg8col3,
	output reg[4:0] bg8col4
	
);
reg n_splash =0;
reg f_splash = 0;

reg[4:0] f_deltaY;
reg[6:0] f_deltaX;

reg[4:0] f_bg1col1;
reg[4:0] f_bg1col2;
reg[4:0] f_bg1col3;
reg[4:0] f_bg1col4;

reg[4:0] f_bg2col1;
reg[4:0] f_bg2col2;
reg[4:0] f_bg2col3;
reg[4:0] f_bg2col4;

reg[4:0] f_bg3col1;
reg[4:0] f_bg3col2;
reg[4:0] f_bg3col3;
reg[4:0] f_bg3col4;

reg[4:0] f_bg4col1;
reg[4:0] f_bg4col2;
reg[4:0] f_bg4col3;
reg[4:0] f_bg4col4;

reg[4:0] f_bg5col1;
reg[4:0] f_bg5col2;
reg[4:0] f_bg5col3;
reg[4:0] f_bg5col4;

reg[4:0] f_bg6col1;
reg[4:0] f_bg6col2;
reg[4:0] f_bg6col3;
reg[4:0] f_bg6col4;

reg[4:0] f_bg7col1;
reg[4:0] f_bg7col2;
reg[4:0] f_bg7col3;
reg[4:0] f_bg7col4;

reg[4:0] f_bg8col1;
reg[4:0] f_bg8col2;
reg[4:0] f_bg8col3;
reg[4:0] f_bg8col4;


reg[3:0] f_typePalette = 0;

reg[3:0] typePalette = 0;
always@(posedge clk or posedge rst)begin
	if(rst)begin
	
		f_splash <= 0;
		f_deltaX <= 0;
		f_deltaY <= 0;
		
		f_typePalette <= 0;
		
		f_bg1col1 <= 0;
		f_bg1col2 <= 0;
		f_bg1col3 <= 0;
		f_bg1col4 <= 0;
		
		f_bg2col1 <= 0;
		f_bg2col2 <= 0;
		f_bg2col3 <= 0;
		f_bg2col4 <= 0;
		
		f_bg3col1 <= 0;
		f_bg3col2 <= 0;
		f_bg3col3 <= 0;
		f_bg3col4 <= 0;
		
		f_bg4col1 <= 0;
		f_bg4col2 <= 0;
		f_bg4col3 <= 0;
		f_bg4col4 <= 0;
		
		f_bg5col1 <= 0;
		f_bg5col2 <= 0;
		f_bg5col3 <= 0;
		f_bg5col4 <= 0;
		
		f_bg6col1 <= 0;
		f_bg6col2 <= 0;
		f_bg6col3 <= 0;
		f_bg6col4 <= 0;
		
		f_bg7col1 <= 0;
		f_bg7col2 <= 0;
		f_bg7col3 <= 0;
		f_bg7col4 <= 0;
		
		f_bg8col1 <= 0;
		f_bg8col2 <= 0;
		f_bg8col3 <= 0;
		f_bg8col4 <= 0;
	end else
	begin
	
		f_splash <= n_splash;
		
		f_deltaX <= deltaX;
		f_deltaY <= deltaY;
		
		f_typePalette <= typePalette;
		
		f_bg1col1 <= bg1col1;
		f_bg1col2 <= bg1col2;
		f_bg1col3 <= bg1col3;
		f_bg1col4 <= bg1col4;
		
		f_bg2col1 <= bg2col1;
		f_bg2col2 <= bg2col2;
		f_bg2col3 <= bg2col3;
		f_bg2col4 <= bg2col4;
		
		f_bg3col1 <= bg3col1;
		f_bg3col2 <= bg3col2;
		f_bg3col3 <= bg3col3;
		f_bg3col4 <= bg3col4;
		
		f_bg4col1 <= bg4col1;
		f_bg4col2 <= bg4col2;
		f_bg4col3 <= bg4col3;
		f_bg4col4 <= bg4col4;
		
		f_bg5col1 <= bg5col1;
		f_bg5col2 <= bg5col2;
		f_bg5col3 <= bg5col3;
		f_bg5col4 <= bg5col4;
		
		f_bg6col1 <= bg6col1;
		f_bg6col2 <= bg6col2;
		f_bg6col3 <= bg6col3;
		f_bg6col4 <= bg6col4;
		
		f_bg7col1 <= bg7col1;
		f_bg7col2 <= bg7col2;
		f_bg7col3 <= bg7col3;
		f_bg7col4 <= bg7col4;
		
		f_bg8col1 <= bg8col1;
		f_bg8col2 <= bg8col2;
		f_bg8col3 <= bg8col3;
		f_bg8col4 <= bg8col4;
	end

	
end

always@(*)begin
	deltaX = f_deltaX;
	deltaY = f_deltaY;
	
	n_splash = f_splash;
	
	typePalette = f_typePalette;
	
	bg1col1 = f_bg1col1;
	bg1col2 = f_bg1col2;
	bg1col3 = f_bg1col3;
	bg1col4 = f_bg1col4;
	
	bg2col1 = f_bg2col1;
	bg2col2 = f_bg2col2;
	bg2col3 = f_bg2col3;
	bg2col4 = f_bg2col4;
	
	bg3col1 = f_bg3col1;
	bg3col2 = f_bg3col2;
	bg3col3 = f_bg3col3;
	bg3col4 = f_bg3col4;
	
	bg4col1 = f_bg4col1;
	bg4col2 = f_bg4col2;
	bg4col3 = f_bg4col3;
	bg4col4 = f_bg4col4;
	
	bg5col1 = f_bg5col1;
	bg5col2 = f_bg5col2;
	bg5col3 = f_bg5col3;
	bg5col4 = f_bg5col4;
	
	bg6col1 = f_bg6col1;
	bg6col2 = f_bg6col2;
	bg6col3 = f_bg6col3;
	bg6col4 = f_bg6col4;
	
	bg7col1 = f_bg7col1;
	bg7col2 = f_bg7col2;
	bg7col3 = f_bg7col3;
	bg7col4 = f_bg7col4;
	
	bg8col1 = f_bg8col1;
	bg8col2 = f_bg8col2;
	bg8col3 = f_bg8col3;
	bg8col4 = f_bg8col4;
	
	delirq = 0;
	
	if(start)
		case(in[23:16])
			8'd64: n_splash = in[0];
			8'd36: delirq = 1;
			8'd1: deltaX = in[6:0]; // SET DELTA X
			8'd2: deltaY = in[4:0]; // SET DELTA Y
			8'd3: typePalette = in[3:0]; // GET PALETTE.NUMBER
			8'd4: case(f_typePalette) // SET PALETTE(NUMBER).COLORS1
						0: begin
							bg1col1 = in[4:0];
							bg1col2 = in[9:5];
						end
						1: begin
							bg2col1 = in[4:0];
							bg2col2 = in[9:5];
						end
						2: begin
							bg3col1 = in[4:0];
							bg3col2 = in[9:5];
						end
						3: begin
							bg4col1 = in[4:0];
							bg4col2 = in[9:5];
						end
						4: begin
							bg5col1 = in[4:0];
							bg5col2 = in[9:5];
						end
						5: begin
							bg6col1 = in[4:0];
							bg6col2 = in[9:5];
						end
						6: begin
							bg7col1 = in[4:0];
							bg7col2 = in[9:5];
						end
						7: begin
							bg8col1 = in[4:0];
							bg8col2 = in[9:5];
						end
						default:;
					endcase
				8'd5: case(f_typePalette) // SET PALETTE(NUMBER).COLORS2
						0: begin
							bg1col3 = in[4:0];
							bg1col4 = in[9:5];
						end
						1: begin
							bg2col3 = in[4:0];
							bg2col4 = in[9:5];
						end
						2: begin
							bg3col3 = in[4:0];
							bg3col4 = in[9:5];
						end
						3: begin
							bg4col3 = in[4:0];
							bg4col4 = in[9:5];
						end
						4: begin
							bg5col3 = in[4:0];
							bg5col4 = in[9:5];
						end
						5: begin
							bg6col3 = in[4:0];
							bg6col4 = in[9:5];
						end
						6: begin
							bg7col3 = in[4:0];
							bg7col4 = in[9:5];
						end
						7: begin
							bg8col3 = in[4:0];
							bg8col4 = in[9:5];
						end
						default:;
					endcase
			default:;
		endcase
	
end

assign splash = ~n_splash;

endmodule
