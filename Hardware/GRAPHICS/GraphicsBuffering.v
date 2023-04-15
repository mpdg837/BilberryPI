
module textBuffer(
	input clk,
	input rst,
	
	input[23:0] in,
	input start,
	
	input[5:0] clearx,
	input[4:0] cleary,
	
	output reg[23:0] nin,
	output reg nstart,
	output reg irq,
	
	output reg[5:0] loadx,
	output reg[4:0] loady,
	
	
	output reg[11:0] waddr,
	output reg w,
	output reg[7:0] inbuffer,
	
	output reg[11:0] raddr,
	input[7:0] outbuffer
);

reg f_comb;
reg comb;

reg[23:0] n_nin;
reg n_nstart;

reg f_block;
reg n_block;

reg[5:0] f_c_x;
reg[4:0] f_c_y;

reg[5:0] n_c_x;
reg[4:0] n_c_y;

reg[5:0] n_mem_x;
reg[4:0] n_mem_y;

reg[5:0] f_mem_x;
reg[4:0] f_mem_y;

always@(posedge clk or posedge rst)begin
	if(rst) f_comb <= 0;
	else f_comb <= comb;
end


always@(posedge clk or posedge rst)begin
	if(rst) f_block <= 0;
	else f_block <= n_block;
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_c_x <= 0;
		f_c_y <= 0;
		end
	else begin
		f_c_x <= n_c_x;
		f_c_y <= n_c_y;
		end
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_mem_x <= 0;
		f_mem_y <= 0;
		end
	else begin
		f_mem_x <= n_mem_x;
		f_mem_y <= n_mem_y;
		end
end

always@(*)begin
	n_block = f_block;
	comb = f_comb;
	
	nin = 0;
	nstart = 0;
	
	n_c_x = f_c_x;
	n_c_y = f_c_y;
		
	n_mem_x = f_mem_x;
	n_mem_y = f_mem_y;
	
	loadx = 0;
	loady = 0;
	
	waddr =0;
	w = 0;
	inbuffer = 0;
	
	raddr = 0;
	
	irq = 0;
	
	if(start && (~f_block))
		case(in[23:16])
			253: begin
				n_block = 1;
				
				comb = ~f_comb;
				
				n_c_x = 0;
				n_c_y = 0;
				
				end
			10: begin
				n_mem_x = in[8:3];
				nin = in;
				nstart = start;
			end
			11: begin
				n_mem_y = in[7:3];
				nin = in;
				nstart = start;
			end
			12: begin
			
				if(f_comb)begin
					waddr = {1'b0,f_mem_x,f_mem_y}; // TEXTURE
					w = 1;
					inbuffer = in[7:0];
				end

			end
			13: begin
			
				if(~f_comb)begin
					waddr = {1'b0,f_mem_x,f_mem_y}; // PALETTE
					w = 1;
					inbuffer = in[7:0];
				end

			end
		
			254: begin
			
				waddr = {1'b0,clearx,cleary};
				w = 1;
				inbuffer = 0;
				
			end
			
			
			default: begin
				nin = in;
				nstart = start;
			end
		endcase
	
	if(f_block)begin
		
		if(f_c_x == 42) begin
			
			n_c_x = 0;
			n_c_y = f_c_y + 1;
			
		end else n_c_x = f_c_x + 1;
		
		if(f_c_y == 31) begin
			n_block = 0;
			irq = 1;
		end
			
		raddr = {1'b0,n_c_x,n_c_y};
		
		
		if(~f_comb) nin = {8'd252,8'd0,outbuffer};
		else nin = {8'd244,8'd0,outbuffer};
		nstart = 1;
			
			waddr = {1'b0,f_c_x,f_c_y}; 
			
			w = 1;
			inbuffer = 0;
					
					
			loadx = f_c_x;
			loady = f_c_y;
	end
	
end

endmodule

module clearer(
	input clk,
	input rst,
	
	input comb,
	
	input[23:0] in,
	input start,
	
	output reg nstart,
	output reg[23:0] nin,
	
	
	output reg[5:0] clearx,
	output reg[4:0] cleary,
	
	output reg irq
);



always@(posedge clk or posedge rst)begin
	
	irq <= 0;
	
	
	clearx <= 0;
	cleary <= 0;
	
	if(rst) begin
		nstart <= 0;
		nin <= 0;

	end else
	begin
		nstart <= start;
		nin <= in;
	end
		
end


endmodule

module bufferTextMem(
	input clk,
	input[11:0] addr,

	input w,
	input[11:0] waddr,
	input[7:0] save,
	
	output reg[7:0] out
);

reg[7:0] memory[4095:0];

always@(posedge clk)begin
	if(w) memory[waddr] <= save;
	
	out <= memory[addr];
end
	

endmodule



