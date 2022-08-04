
module mandisk(
	input clk,
	input rst,
	
	input[23:0] ini,
	input starti,
	
	output inti,
	output reg[23:0] outi,
	output reg rdyi,
	
	output reg startstream,
	
	output reg startinit,
	input readyinit,
	
	output[5:0] cmdx,
	output[31:0] argx,
	output startx,
	output init,
	output start40x,
	output readit,
	output reg closex,
	
	input[7:0] out,
	input rdy
);

localparam NOP = 8'd0;
localparam INIT = 8'd1;
localparam BLOCK = 8'd2;
localparam OREAD = 8'd3;
localparam OWRITE = 8'd4;
localparam READ = 8'd5;
localparam WRITEBYTE = 8'd6;
localparam READBYTE = 8'd7;
localparam CLOSE = 8'd8;

reg rdyx = 0;
reg f_rdyx = 0;

reg rdyix = 0;
reg f_rdyix = 0;

reg[23:0] f_outi = 0;
reg[15:0] f_block;
reg[15:0] n_block;

reg f_rrdyx = 0;
reg f_rrrdyx = 0;

reg rrdyx = 0;
reg rrrdyx = 0;

reg[1:0] f_open = 0;
reg[1:0] n_open = 0;

reg[5:0] cmdxx;
reg[31:0] argxx;
reg startxx;
reg initx;
reg start40xx;
reg readitx;

reg[5:0] cmdxxx;
reg[31:0] argxxx;
reg startxxx;
reg initxx;
reg start40xxx;
reg readitxx;

always@(posedge clk or posedge rst)
	if(rst) begin
		f_open = 0;
	end else
	begin
		f_open = n_open;
	end
	
always@(posedge clk or posedge rst)
	if(rst) begin
		f_rdyix <= 0;
		f_rdyx <= 0;
		f_outi <= 0;
		f_block <= 0;
		f_rrdyx <= 0;
		f_rrrdyx <= 0;
		end
	else begin
		f_rdyix <= rdyix; 
		f_rrdyx <= rrdyx;
		f_rrrdyx <= rrrdyx;
		f_block <= n_block;
		f_outi <= outi;
		f_rdyx <= rdyx;
		end

always@(*)begin
	rdyx = f_rdyx;
	n_block = f_block;
	rdyix  = f_rdyix;
	
	rrdyx = 0;
	rrrdyx = 0;
	
	startinit = 0;
	startstream = 0;
	
	cmdxx = 0;
	argxx = 0;
	startxx = 0;
	initx = 0;
	start40xx = 0;
	readitx = 0;
	closex = 0;
	
	if(rdy && f_rdyx) rdyx = 0;
	if(readyinit && f_rdyix) rdyix = 0;
	
	if(starti)
		case(ini[23:16])
			NOP:;
			INIT:begin
				cmdxx = 0; // INIT
				argxx = 0;
				startinit = 1;
				
				startxx = 0;
				initx = 0;
				start40xx = 0;
				readitx = 0;
				
				rdyix = 1;
			end
			BLOCK: begin
				n_block = ini[15:0];
			end
			OREAD: begin
				cmdxx = 17; // OSTREAM
				argxx = f_block;
				
				initx = 0;
				startxx = 0;
				
				readitx = 0;
				start40xx = 1;
				rdyx = 1;
			end
			READ: begin
				cmdxx = 7'hFF; // READ
				argxx = 32'hFFFFFFFF;
				
				initx = 0;
				startxx = 1;
				
				readitx = 1;
				start40xx = 0;
				rdyx = 1;
			end
			READBYTE: begin
				cmdxx = 0; // READBYTE
				argxx = 0;
				
				startstream = 1;
				
				initx = 0;
				startxx = 0;
				readitx = 0;
				start40xx = 0;
				
				rrdyx = 1;
			end
			OWRITE: begin
				cmdxx = 24; // OWRITE
				argxx = ini[15:0];
				
				initx = 0;
				startxx = 0;
				
				readitx = 0;
				start40xx = 1;
				
				rrrdyx = 1;
			end
			WRITEBYTE:begin // WRITEBYTE
				cmdxx = 0;
				argxx = {8'b0,ini[7:0]};
				
				initx = 0;
				startxx = 1;
				
				readitx = 0;
				start40xx =1;
				
				rdyx = 1;
			end
			CLOSE: begin
				cmdxx = 0; // CLOSE
				argxx = 0;
				
				initx = 0;
				startxx = 0;
				
				closex = 1;
				
				readitx = 0;
				start40xx =0;
				
				rdyx = 1;
			end
		endcase
end

reg inti1;
reg inti2;
reg inti3;

always@(*) begin
	
	inti1 = 0;
	
	if(rdy && f_rdyx) inti1 = 1;
	
	if(readyinit && f_rdyix) inti1 = 1;
end

always@(*) begin
	
	outi = f_outi;
	inti2 = 0;
	
	if(f_rrdyx) begin
		inti2 = 1;
		outi = {16'b0,out};
	end
end

always@(*)begin
	inti3 = 0;
	n_open = f_open;
	
	cmdxxx = 0;
	argxxx = 0;
	startxxx = 0;
	initxx = 0;
	start40xxx = 0;
	readitxx = 0;
	
	case(f_open)
		0: if(rrrdyx) n_open = 1;
		1: if(rdy) n_open = 2;
		2: begin
			n_open = 3;
			
			cmdxxx = 0;
			argxxx = 8'hFE;
			startxxx = 1;
			initxx = 0;
			start40xxx = 1;
			readitxx = 0;
			
		end
		3: if(rdy) begin
			n_open = 0;
			inti3 = 1;
			end
	endcase
	
end

assign cmdx = cmdxx | cmdxxx;
assign argx = argxx | argxxx;
assign startx = startxx | startxxx;
assign init = initx | initxx;
assign start40x = start40xx | start40xxx;
assign readit = readitx | readitxx;

assign inti = inti1 | inti2 | inti3;
endmodule
