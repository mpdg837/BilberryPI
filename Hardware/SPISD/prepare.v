
module bufferin100k(
	input dclk,
	input clk,
	input rst,
	
	input start,
	input start40,
	input[5:0] cmd,
	input[31:0] arg,
	input readit,
	
	output reg n_start,
	output reg n_start40,
	output reg[5:0] n_cmd,
	output reg[31:0] n_arg,
	output reg n_readit
);


always@(*)begin
	begin
		n_start <= start;
		n_start40 <= start40;
		n_cmd <= cmd;
		n_arg <= arg;
		n_readit <= readit;
	end	
end


endmodule

module prepare(
	input clk,
	input dclk,
	input rst,
	
	// wejscie
	input start,
	input start40,
	input[5:0] cmd,
	input[31:0] arg,
	input readit,
	
	// crcmodule
	output reg startcrc,
	output reg [39:0] incrc,
	
	input rdystart,
	input[6:0] crccode,
	
	// do menedzera
	
	output reg[5:0] cmd1,
	output reg[31:0] arg1,
	output reg[6:0] crc1,
	
	output reg readitx,
	output reg startx,
	output reg start40x
);

wire startb;
wire start40b;
wire[5:0] cmdb;
wire[31:0] argb;
wire readitb;
	
bufferin100k bit(
	.dclk(dclk),
	.clk(clk),
	.rst(rst),
	
	.start(start),
	.start40(start40),
	.cmd(cmd),
	.arg(arg),
	.readit(readit),
	
	.n_start(startb),
	.n_start40(start40b),
	.n_cmd(cmdb),
	.n_arg(argb),
	.n_readit(readitb)
);


reg[5:0] f_cmd1 = 0;
reg[31:0] f_arg1 =0;
reg[6:0] f_crc1 = 0;

reg f_k = 0;
reg n_k = 0;

reg f_s = 0;
reg n_s = 0;

reg f_c = 0;
reg n_c = 0;

always@(posedge dclk or posedge rst)begin
	if(rst)begin
		f_cmd1 <= 0;
		f_arg1 <= 0;	
		f_s <= 0;
		f_c <= 0;
		f_k <= 0;
	end else
	begin
		f_cmd1 <= cmd1;
		f_arg1 <= arg1;
		f_s <= n_s;
		f_c <= n_c;
		f_k <= n_k;
		
	end
end

always@(*)begin
	n_s = f_s;
	n_c = f_c;
	n_k = f_k;
	
	cmd1 = f_cmd1;
	arg1 = f_arg1;
	crc1 = 0;
	startx = 0;
	start40x = 0;
	
	incrc = 0;
	startcrc = 0;
	readitx = 0;
	
	
	if(startb || start40b)begin
		cmd1 = cmdb;
		arg1 = argb;
		n_s = start40b;
		n_c = readitb;
		
		n_k = start40b && startb;
		
		incrc = {2'b01,cmdb,argb};
		startcrc = 1;
	end
	
	if(rdystart)begin
		crc1 = crccode;
		readitx = f_c;
		
		if(f_s) start40x = 1;
		else startx = 1;
		
		if(f_k) begin
			start40x = 1;
			startx = 1;
		end
		
	end
	
end

endmodule


