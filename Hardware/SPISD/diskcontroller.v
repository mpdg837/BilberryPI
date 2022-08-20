

module diskcontroller(
	input clk,
	input rst,
	
	
	input[23:0] inix,
	input starti,
	
	output inti,
	output [23:0] outi,
	output rdyi,
	
	
	input mosi,
	
	output dclkx,
	
	output cs,
	output miso,
	output sck,
	
	output sck1,
	output mosi1,
	output cs1,
	output miso1
);

wire irst = rst;


wire ddclk;



wire[7:0] out;

wire[6:0] timx;
wire rdyread;

wire[7:0] in;
wire start;
wire ready;



wire[5:0] cmd1;
wire[31:0] arg1;
wire[6:0] crc1;
wire start1;
wire start401;


wire startinit;
wire readyinit;


wire[5:0] cmdx;
wire[31:0] argx;

wire startx;
wire start40x;

wire init;
wire readit;



wire[5:0] cmdxx;
wire[31:0] argxx;

wire startxx;
wire start40xx;

wire initxx;
wire readitxx;

wire[7:0] outstream;

wire closex;

mandisk pro(.clk(clk),
			.rst(irst),

			.ini(inix),
			.starti(starti),
		
			.inti(inti),
			.outi(outi),
			.rdyi(rdyi),
	
			.startinit(startinit),
			.readyinit(readyinit),
			
			.cmdx(cmdx),
			.argx(argx),
			.startx(startx),
			.init(init),
			.start40x(start40x),
			.readit(readit),
			.closex(closex),
			
			.startstream(gets),
			.out(outputstream),
			
			.rdy(rdy)
);


initizer ini(.clk(clk),
			.rst(irst),
			
			.startinit(startinit),
			
			.cmdx(cmdxx),
			.argx(argxx),
			.startx(startxx),
			.init(initxx),
			.start40x(start40xx),
			.readit(readitxx),
			
			.ready(readyinit),
			
			.out(out),
			.rdy(rdy)
);


wire rdy;
wire csz;

dclkb dclka(
	.clk(clk),
	.rst(rst),
	.dclk(ddclk)
);

wire gets;
wire[7:0] outputstream;

wire[39:0] incrc;
wire startcrc;

wire[6:0] crc7;
wire rdycrc;

crc7spi c7s(
	.rst(irst),
	.clk(ddclk),
	
	.in(incrc), 
	.start(startcrc),
	
	.out(crc7),
	.rdy(rdycrc)
	
);

wire readit1;

wire[5:0] cmd11;
wire[31:0] arg11;
wire sta11;
wire sta4011;
wire readit11;
wire init11;

insideconnector ica(
	.clk(clk),
	.rst(rst),
	
	.cmd1(cmdx),
	.arg1(argx),
	.sta1(startx),
	.sta401(start40x),
	.readit1(readit),
	.init1(init),
	
	.cmd2(cmdxx),
	.arg2(argxx),
	.sta2(startxx),
	.sta402(start40xx),
	.readit2(readitxx),
	.init2(initxx),
	
	.cmd(cmd11),
	.arg(arg11),
	.sta(sta11),
	.sta40(sta4011),
	.readit(readit11),
	.init(init11),
);


prepare prp(
	.clk(clk),
	.dclk(ddclk),
	.rst(irst),
	
	// wejscie
	.start(sta11),
	.start40(sta4011),
	.cmd(cmd11),
	.arg(arg11),
	.readit(readit11),
	
	// crcmodule
	.startcrc(startcrc),
	.incrc(incrc),
	
	.rdystart(rdycrc),
	.crccode(crc7),
	
	// do menedzera
	
	.cmd1(cmd1),
	.arg1(arg1),
	.crc1(crc1),
	
	.startx(start1),
	.start40x(start401),
	.readitx(readit1)
);

managerx man(
	.dclk(ddclk),
	.clk(clk),
	.rst(irst),
	
	.cmd(cmd1),
	.arg(arg1),
	.crc(crc1),
	
	.init(init11),
	.readit(readit1),
	
	.sta40(start401),
	.sta(start1),
	.rdy(rdy),
	
	.csz(csz),
	
	.closex(closex),
	
	.in(in),
	.start(start),
	.ready(ready),
	
	.into(out),
	
	.rdyread(rdyread)
);

receiver rec(.clk(clk),
			.rst(irst),
			.dclk(ddclk),
	
			.reset(start401 | start1),
		
			.readed(ready),
			.in(out),
	
			.gets(gets),
			.out(outputstream)
);

spi spix(
	.clk(ddclk),
	.rst(irst),
	
	.in(in),
	.start(start),
	.ready(ready),
	
	.out(out),
	.csz(csz),
	
	.cs(cs),
	.miso(miso),
	.sck(sck),
	
	.mosi(mosi)
	
);

assign dclkx = ddclk;

assign sck1 = sck;
assign mosi1 = mosi;
assign miso1 = miso;
assign cs1 = cs;
endmodule


module insideconnector(
	input clk,
	input rst,
	
	input [5:0] cmd1,
	input [31:0] arg1,
	input [6:0] crc1,
	input sta1,
	input sta401,
	input readit1,
	input init1,
	
	input [5:0] cmd2,
	input [31:0] arg2,
	input [6:0] crc2,
	input sta2,
	input sta402,
	input readit2,
	input init2,
	
	output reg [5:0] cmd,
	output reg [31:0] arg,
	output reg [6:0] crc,
	output reg sta,
	output reg sta40,
	output reg readit,
	output reg init
);

always@(posedge clk or posedge rst)begin
	if(rst)begin
		cmd <= 0;
		arg <= 0;
		crc <= 0;
		sta <= 0;
		sta40 <= 0;
		readit <= 0;
		init <= 0;
	end else
	begin
		cmd <= cmd1 | cmd2;
		arg <= arg1 | arg2;
		crc <= crc1 | crc2;
		sta <= sta1 | sta2;
		sta40 <= sta401 | sta402;
		readit <= readit1 | readit2;
		init <= init1 | init2;
	end
end

endmodule
