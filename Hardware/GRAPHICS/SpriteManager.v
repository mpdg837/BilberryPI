
module manager(
	
	
	input clk,
	input rst,
	
	input[9:0] CounterX,
	input[8:0] CounterY,
	
	input[8:0] ccy,
	
	input[31:0] fromRAM,
	
	input[3:0] uiin,
	
	output reg shift,
	output reg clr,
	
	output reg[8:0] addr,
	
	output reg[8:0] posX1,
	
	output reg[4:0] b1col1,
	output reg[4:0] b1col2,
	output reg[4:0] b1col3,
	output reg[4:0] b1col4,
	
	output reg[31:0] colors1,
	
	output reg[3:0] sclX1,
	
	output reg swpX1
	
);

reg[8:0] f_posX1;

reg[4:0] f_n;
reg[4:0] n;

reg[1:0] f_a;
reg[1:0] a;


reg[4:0] f_b1col1;
reg[4:0] f_b1col2;
reg[4:0] f_b1col3;
reg[4:0] f_b1col4;

reg[3:0] f_sclX1;


reg f_swpX1;

reg f_mswpY;
reg mswpY;

reg[7:0] mrelY;
reg[7:0] f_mrelY;


reg[3:0] sclY;
reg[3:0] f_sclY;

wire[7:0] relY = {ccy[8:1] - fromRAM[22:15]};

always@(posedge clk or posedge rst)begin
	if(rst) begin
		posX1 <= 0;
		
		
		sclY = 0;
		
		n <= 0;
		a <= 0;
		
		b1col1 <= 0;
		b1col2 <= 0;
		b1col3 <= 0;
		b1col4 <= 0;
		
		sclX1 <= 0;

		swpX1 <= 0;

		mswpY <= 0;
		mrelY <= 0;

	end else
	begin
		posX1 <= f_posX1;
		
		
		sclY = f_sclY;
		
		n <= f_n;
		a <= f_a;
		
		b1col1 <= f_b1col1;
		b1col2 <= f_b1col2;
		b1col3 <= f_b1col3;
		b1col4 <= f_b1col4;
		
		sclX1 <= f_sclX1;

		swpX1 <= f_swpX1;

		mswpY <= f_mswpY;
		mrelY <= f_mrelY;
	end
	
end

reg[15:0] frR;


always@(*)begin
	
	f_sclY = sclY;
	
	f_mrelY = mrelY;
	f_mswpY = mswpY;
	
	f_posX1 = posX1;
	
	colors1 = 0;
	
	f_n = n;
	f_a = a;
	
	f_b1col1 = b1col1;
	f_b1col2 = b1col2;
	f_b1col3 = b1col3;
	f_b1col4 = b1col4;
	
	f_sclX1 = sclX1;
	
	f_swpX1 = swpX1;
	
	addr = 0;
	clr = 0;
	shift = 0;
	
	if(CounterX[9:2] == 179)begin
		clr = 1;
		
		f_posX1 = 0;
		
		f_b1col1 = 0;
		f_b1col2 = 0;
		f_b1col3 = 0;
		f_b1col4 = 0;
		
		f_sclX1 = 0;
		
		f_swpX1 = 0;
	end
		
	if(CounterX[9:6] == 0) begin
	
		case(a)
			0: begin
				
				addr = {n, 1'd0};
				f_a = 1;
			end
			1: begin
				if((relY[7:4] == 0) && (fromRAM[31:28] != 0)) begin
				
					addr = {n, 1'd1};
						
					f_mswpY = fromRAM[5];
					f_mrelY = relY;
					f_sclY = fromRAM[10:7];
					f_posX1 = fromRAM[31:23];
					f_sclX1 = fromRAM[14:11];
					f_swpX1 = fromRAM[6];
					
					
					
					
					f_a = 2;
				end else
				begin
				
					f_mswpY =0; 
					f_mrelY = 0;
					f_a = 0;
					
					if(n<31) f_n = n + 1;
					else f_n = 0;
					
				end
			end
			2: begin
				if(mswpY)begin
					
					if(sclY[3]) addr = {fromRAM[30:26], ~mrelY[3:0]};
					else if(sclY[2]) addr = {fromRAM[30:26], ~mrelY[2:0],1'b0};
					else if(sclY[1]) addr = {fromRAM[30:26], ~mrelY[1:0],2'b0};
					else addr = {fromRAM[30:26], ~mrelY[0],3'b0};
					
				
				end else
				begin
				
					if(sclY[3]) addr = {fromRAM[30:26], mrelY[3:0]};
					else if(sclY[2]) addr = {fromRAM[30:26], mrelY[2:0],1'b0};
					else if(sclY[1])addr = {fromRAM[30:26], mrelY[1:0],2'b0};
					else addr = {fromRAM[30:26], mrelY[0],3'b0};
					
				end
				
				f_b1col1 = fromRAM[25:21]; 
				f_b1col2 = fromRAM[20:16]; 
				f_b1col3 = fromRAM[15:11]; 
				f_b1col4 = fromRAM[10:6]; 
				
				f_a = 3;
			end
			3: begin
				
					
					if(sclY[3]) colors1 = fromRAM;
					else if(sclY[2]) begin
						
						if(~mrelY[3]) colors1 = fromRAM;
						else colors1 = 0;
						
					end else if(sclY[1]) begin
						
						if(mrelY[3:2] == 2'b0) colors1 = fromRAM;
						else colors1 = 0;
						
					end else
					begin
						
						if(mrelY[3:1] == 2'b0) colors1 = fromRAM;
						else colors1 = 0;
						
					end
					
			
				
				
				
				f_a = 0;
				
				if(n<31) f_n = n + 1;
				else f_n = 0;
				
				f_sclY =0;
				f_mswpY =0; 
				shift = 1;
				
				f_mrelY = 0;
			end
			
				
		endcase
		
		
		
		
	end else
	begin
	
		addr = {1'b1,uiin,ccy[3:2]};
	
		
		f_mswpY =0; 
		
		f_n = 0;
		f_a = 0;
	end
	
end

endmodule

module uiconv(
	input clk,
	input dclk,
	input rst,
	
	input[9:0] cx,
	input[8:0] cy,
	
	input[31:0] fromRAM,
	
	output reg[1:0] uicol

);

reg[1:0] tim;
reg[1:0] f_tim;

reg[1:0] f_uicol;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_tim <= 0;
		f_uicol <= 0;
	end else
	begin
		f_tim <= tim;
		f_uicol <= uicol;
	end
end


always@(*)begin
	tim = f_tim +1;
	uicol = f_uicol;

	
	if(cx[9:6] != 0) begin
	
		if(tim == 1) begin
			if(~cy[1])begin
				case(cx[3:1])
					
					2: uicol = fromRAM[31:30];
					3: uicol = fromRAM[29:28];
					4: uicol = fromRAM[27:26];
					5: uicol = fromRAM[25:24];
					6: uicol = fromRAM[23:22];
					7: uicol = fromRAM[21:20];
					0: uicol = fromRAM[19:18];
					1: uicol = fromRAM[17:16];
					default: uicol =0;
				endcase
			end else
			begin
				case(cx[3:1])
					
					2: uicol = fromRAM[15:14];
					3: uicol = fromRAM[13:12];
					4: uicol = fromRAM[11:10];
					5: uicol = fromRAM[9:8];
					6: uicol = fromRAM[7:6];
					7: uicol = fromRAM[5:4];
					0: uicol = fromRAM[3:2];
					1: uicol = fromRAM[1:0];
					default: uicol =0;
				endcase
			end
		end 
	end else
	begin
		uicol = 0;
	end
end

endmodule

