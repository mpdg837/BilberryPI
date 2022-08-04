
module initizer(
	input clk,
	input rst,
	
	input startinit,
	
	output reg[5:0] cmdx,
	output reg[31:0] argx,
	output reg startx,
	output reg init,
	output reg start40x,
	output reg readit,
	
	output reg ready,
	
	input[7:0] out,
	input rdy
);


reg[3:0] tim = 0;
reg[3:0] f_tim = 0;

reg[9:0] f_tchar;
reg[9:0] n_tchar;

reg f_start;
reg n_start;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_tim <= 0;
		f_tchar <= 0;
		f_start <= 0;
		end
	else begin
		f_tim <= tim;
		f_tchar <= n_tchar;
		f_start <= n_start;
		end
end

always@(*)begin
	tim = f_tim;
	n_tchar = f_tchar;
	n_start = f_start;
	
	ready = 0; 
	
	cmdx = 0;
	argx = 0;
				
	startx = 0;
	init = 0;
	start40x = 0;
	readit = 0;
				
	if(startinit) begin
		n_start = 1;
		tim = 0;
	end
	
	if(f_start)
		case(f_tim)
			0:begin
				cmdx = 0;
				argx = 0;
				
				startx = 0;
				init = 1;
				tim = 1;
				start40x = 0;
				readit = 0;
				n_tchar = 0;
			end
			1:begin
				cmdx = 0;
				argx = 0;
				
				startx = 0;
				init = 0;
				if(rdy) tim = 2;
				else tim = 1;
				start40x = 0;
				readit = 0;
			end
			
			2: begin
				cmdx = 0;
				argx = 0;
				init = 0;
				
				startx = 1;
				tim = 3;
				start40x = 0;
				readit = 0;
			end
			
			3:begin
				cmdx = 0;
				argx = 0;
				
				init = 0;
				startx = 0;
				if(rdy) tim = 4;
				else tim = 3;
				start40x = 0;
				readit = 0;
			end
			4: begin
				cmdx = 8;
				argx = 32'h1AA;
				
				init = 0;
				startx = 0;
				tim = 5;
				start40x = 1;
				readit = 0;
			end
			5: begin
				cmdx = 0;
				argx = 0;
				
				init = 0;
				startx = 0;
				
				if(rdy) tim = 6;
				else tim = 5;
				
				start40x = 0;
				readit = 0;
			end
			
			6: begin
				cmdx = 55;
				argx = 32'h0;
				
				init = 0;
				startx = 1;
				tim = 7;
				
				start40x = 0;
				readit = 0;
			end
			7: begin
				cmdx = 0;
				argx = 0;
				
				init = 0;
				startx = 0;
				
				if(rdy) tim = 8;
				else tim = 7;
				
				start40x = 0;
				readit = 0;
			end
			8: begin
				cmdx = 41;
				argx = 32'h40000000;
				
				init = 0;
				startx = 1;
				tim = 9;
				start40x = 0;
				readit = 0;
			end
			9: begin
				cmdx = 0;
				argx = 0;
				
				init = 0;
				startx = 0;
				
				if(rdy) begin
					tim = 6;
					if(out == 0) tim = 10;
					end
				else tim = 9;
				readit = 0;
				start40x = 0;
			end
			10: begin
				cmdx = 58;
				argx = 0;
				
				init = 0;
				startx = 0;
				tim = 11;
				
				readit = 0;
				start40x = 1;
			end
			11: begin
				cmdx = 0;
				argx = 0;
				
				init = 0;
				startx = 0;
				if(rdy) tim = 12;
				else tim = 11;
				
				readit = 0;
				start40x = 0;
				
			end
			12: begin
				n_start = 0;
				cmdx = 0;
				argx = 0;
				
				init = 0;
				startx = 0;
				tim = 0;
				
				readit = 0;
				start40x = 0;
				ready = 1;
			end
		endcase
	
end


endmodule
