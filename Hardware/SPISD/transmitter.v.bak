module initbuffer(
	input clk,
	input dclk,
	input rst,
	
	input init,
	output reg n_init
);

reg f_init = 0;
reg f_dclk = 0;
reg n_dclk = 0;

reg[1:0] f_start = 0;
reg[1:0] n_start = 0;

reg b_init;

reg nn_init;

always@(posedge clk or posedge rst)
	if(rst) b_init <= 0;
	else b_init <= init;
	
always@(posedge clk or posedge rst)
	if(rst)begin
		f_init <= 0;
		f_dclk <= 0;
		f_start <= 0;
	end
	else begin
		f_dclk <= n_dclk;
		f_init <= nn_init;
		f_start <= n_start;
	end

always@(*)begin
	nn_init = f_init; 
	n_dclk = dclk;
	n_start = f_start;
	
	case(f_start)
		0: if(b_init)begin
				n_start = 1;
				nn_init = 1;
			end
		1: if(~f_dclk & dclk) n_start = 2;
		2: if(f_dclk & ~dclk) begin
				n_start = 0;
				nn_init = 0;
				end
		default:;
	endcase
end

always@(posedge dclk or posedge rst)
	if(rst) n_init <= 0;
	else n_init <= nn_init;
	
endmodule

module rdyspibuffer(
	input clk,
	input dclk,
	input rst,
	input in,
	
	output reg out
);

reg f_in = 0;
reg n_in = 0;

reg nout = 0;
reg nin = 0;

always@(posedge dclk or posedge rst)begin
	if(rst) nin <= 0;
	else nin <= in;
end

always@(posedge clk or posedge rst)
	if(rst) begin
		f_in <= 0;
	end
	else begin
		f_in <= n_in;
	end

always@(*)begin
	nout = 0;
	n_in = nin;
	
	if(~f_in && nin) nout = 1;
end

always@(posedge clk or posedge rst)
	if(rst) out <= 0;
	else out <= nout;

endmodule

module managerx(
	input clk,
	input dclk,
	input rst,
	
	input [5:0] cmd,
	input [31:0] arg,
	input [6:0] crc,
	input sta,
	input sta40,
	input readit,
	input init,
	input closex,
	
	output rdy,
	output rdyread,
	
	output[7:0] in,
	output start,
	output csz,
	
	input[7:0] into,
	input ready
);

wire rdy_in;

wire rdyread_in;

rdyspibuffer rsbr(
	.clk(clk),
	.dclk(dclk),
	.rst(rst),
	.in(rdyread_in),
	
	.out(rdyread)
);

rdyspibuffer rsb(
	.clk(clk),
	.dclk(dclk),
	.rst(rst),
	.in(rdy_in),
	
	.out(rdy)
);

wire n_init;

initbuffer ibuf(
	.clk(clk),
	.dclk(dclk),
	.rst(rst),
	
	.init(init),
	.n_init(n_init)
);

wire n_close;

initbuffer iclo(
	.clk(clk),
	.dclk(dclk),
	.rst(rst),
	
	.init(closex),
	.n_init(n_close)
);

wire[4:0] p_tim;
wire[2:0] p_ttim;

wire[5:0] f_cmd;
wire[31:0] f_arg;
wire[6:0] f_crc;

wire start3;
wire[7:0] in3;
wire rdy3;

wire f_c;
wire f_answ40;

wire[3:0] f_timinit;
	
wire start2;
wire[7:0] in2;
wire rdy2;

wire start4;
wire[7:0] in4;
wire rdy4;

close clo(
	.clk(dclk),
	.rst(rst),
	
	.closex(n_close),
	
	.ready(ready),
	
	.out(into),
	
	.start4(start4),
	.in4(in4),
	
	.rdy4(rdy4)
);
	
starteri si(
	.clk(dclk),
	.rst(rst),
	
	.n_init(n_init),
	.ready(ready),
	
	.csz(csz),
	.f_timinit(f_timinit),
	
	.start2(start2),
	.in2(in2),
	.rdy2(rdy2)

);

saverx sa(
	.clk(dclk),
	.rst(rst),
	
	.arg(arg),
	.sta(sta),
	.sta40(sta40),
	.ready(ready),
	
	.start3(start3),
	.in3(in3),
	.rdy3(rdy3)

);






starter ssa(
	.clk(dclk),
	.rst(rst),
	
	.cmd(cmd),
	.arg(arg),
	.crc(crc),
	.sta(sta),
	.sta40(sta40),
	.readit(readit),
	
	.n_init(n_init),
	.f_startsave(f_startsave),
	
	.p_tim(p_tim),
	.p_ttim(p_ttim),

	.f_cmd(f_cmd),
	.f_arg(f_arg),
	.f_crc(f_crc),

	.f_answ40(f_answ40),
	.f_c(f_c),
	
	.f_timinit(f_timinit)
);

wire start1;
wire[7:0] in1;
wire rdy1;

sender sen(
	.clk(dclk),
	.rst(rst),

	.f_cmd(f_cmd),
	.f_arg(f_arg),
	.f_crc(f_crc),
	.f_c(f_c),
	.f_answ40(f_answ40),
	
	.ready(ready),
	.into(into),
	
	.p_tim(p_tim),
	.p_ttim(p_ttim),
	
	.rdyread_in(rdyread_in),
	
	.start1(start1),
	.in1(in1),
	.rdy1(rdy1)

);

assign rdy_in = rdy1 | rdy2 | rdy3 | rdy4;
assign in = in1 | in2 | in3 | in4;
assign start = start1 | start2 | start3 | start4;

endmodule

module starteri(
	input clk,
	input rst,
	
	input n_init,
	
	input ready,
	
	output reg csz,
	output reg[3:0] f_timinit,
	
	output reg start2= 0,
	output reg[7:0] in2 = 0,
	output reg rdy2 = 0

);


always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_timinit <= 0;
		f_starti <= 0;
		f_tttim <= 0;
		
	end else
	begin
		f_timinit <= n_timinit;
		f_starti <= n_starti;
		f_tttim <= n_tttim;
		
	end
end


reg[2:0] f_tttim = 0;
reg[2:0] n_tttim = 0;

reg f_starti;
reg n_starti;


reg[3:0] n_timinit;

always@(*) begin
	start2 = 0;
	in2 = 0;
	rdy2 = 0;
	csz = 0;
	
	n_timinit = f_timinit;
	n_starti = f_starti;
	n_tttim = f_tttim;
	
	
	if(n_init)begin
		n_timinit = 1;
		n_tttim = 0;
		start2 = 1;
		in2 = 8'hFF;
		csz = 1;
	end
	
	if(f_timinit != 0)begin
			csz = 1;
			if(ready) begin
				n_starti = 1;
				n_tttim = 1;
			end
			
			if(f_tttim == 7)begin
				if(f_timinit == 10)begin
				
					n_timinit = 0;
					rdy2 = 1;
					n_tttim = 0;
					
				end else
				begin
					start2 = 1;
					in2 = 8'hFF;
					n_tttim = 0;
					
					n_timinit = f_timinit + 1;
				end
			end else if(f_tttim != 0) n_tttim = f_tttim + 1;
		end
	
end

endmodule

module saverx(
	input clk,
	input rst,
	
	input[31:0] arg,
	input sta,
	input sta40,
	input ready,
	
	output reg start3= 0,
	output reg[7:0] in3 = 0,
	output reg rdy3 = 0

);




reg f_startsave;
reg n_startsave;

always@(posedge clk or posedge rst)
	if(rst) begin
		f_startsave <= 0;
		end
	else begin
		f_startsave <= n_startsave;
		end
always@(*) begin

	n_startsave = f_startsave;
	
	start3= 0;
	in3 = 0;
	rdy3 = 0;
	
	if((sta && sta40))begin
		n_startsave = 1;
		start3 = 1;
		in3 = arg;
	end
	
	
	if(f_startsave && ready)begin
		rdy3 = 1;
		n_startsave = 0;
	end
end

endmodule

module close(
	input clk,
	input rst,
	
	input closex,
	
	input ready,
	
	input[7:0] out,
	
	output reg start4,
	output reg[7:0] in4,
	
	output reg rdy4
);

reg f_start;
reg n_start;

reg[3:0] f_tim;
reg[3:0] n_tim;

always@(posedge clk or posedge rst)
	if(rst) begin
		f_start <= 0;
		f_tim <= 0;
		end
	else begin
		f_start <= n_start;
		f_tim <= n_tim;
		end
always@(*)begin
	n_start = f_start;
	n_tim = f_tim;
	
	start4 = 0;
	in4 = 0;
	rdy4 = 0;
	
	if(closex)begin
		n_start = 1;
		
		in4 = 8'hFF;
		start4 = 1;
		n_tim = 1;
		
	end
	
	
	
	if(f_start)begin
		if(ready)begin
		
			if(f_tim != 0) n_tim = f_tim + 1;
			
			if(out == 8'hFF && f_tim == 0) begin
				n_start = 0;
				rdy4 = 1;
				end else
			begin
				in4 = 8'hFF;
				start4 = 1;
			end
			
		end
	end
	
	
end



endmodule

module starter(
	input clk,
	input rst,
	
	input [5:0] cmd,
	input [31:0] arg,
	input [6:0] crc,
	input sta,
	input sta40,
	input readit,
	
	input n_init,
	input f_startsave,
	
	input[3:0] f_timinit,
	
	output reg[4:0] p_tim,
	output reg[2:0] p_ttim,

	output reg[5:0] f_cmd,
	output reg[31:0] f_arg,
	output reg[6:0] f_crc,
	
	
	output reg f_answ40,
	output reg f_c


);

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_cmd <= 0;
		f_arg <= 0;
		f_crc <= 0;
		f_answ40 <= 0;
		f_c <= 0;
	end else
	begin
		f_cmd <= n_cmd;
		f_arg <= n_arg;
		f_crc <= n_crc;
		f_answ40 <= n_answ40;
		f_c <= n_c;
	end
end


reg [5:0] n_cmd;
reg [31:0] n_arg;
reg [6:0] n_crc;

reg n_answ40;
reg n_c;

always@(*)begin
	
	p_tim = 31;
	p_ttim = 7;
	
	n_cmd = f_cmd;
	n_arg = f_arg;
	n_crc = f_crc;
	
	n_answ40 = f_answ40;
	
	n_c = f_c;

	
	if(n_init)begin
		p_tim = 0;
		p_ttim = 0;
		
		n_c = 0;
		n_answ40 = 0;
		
		n_cmd = 0;
		n_arg = 0;
		n_crc = 0;
	end
	
	if( ((sta && (~sta40)) || (sta40 && (~sta))) && f_timinit == 0)begin
	
		if(crc == 7'h7F) p_tim = 16;
		else p_tim = 1;
		
		p_ttim = 0;
		
		n_answ40 = sta40;
		
		n_c = readit;
		
		n_cmd = cmd;
		n_arg = arg;
		n_crc = crc;
		
	end
	
	if(f_startsave || f_timinit != 0)begin
		p_tim = 0;
		p_ttim = 0;
	end
end

endmodule

module sender(
	input clk,
	input rst,
	
	input[5:0] f_cmd,
	input[31:0] f_arg,
	input[6:0] f_crc,
	input f_c,
	input f_answ40,
	
	input[4:0] p_tim,
	input[2:0] p_ttim,

	input ready,
	input[7:0] into,
	
	output reg rdyread_in,
	
	output reg start1 = 0,
	output reg[7:0] in1 = 0,
	output reg rdy1 = 0

);

reg[4:0] f_tim = 0;
reg[4:0] tim = 0;

reg[2:0] f_ttim = 0;
reg[2:0] ttim = 0;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_tim <= 0;
		f_ttim <= 0;
	
	end else
	begin
		f_tim <= tim;
		f_ttim <= ttim;
		
	end
end

always@(*) begin	
	tim = f_tim;
	in1 = 0;
	start1 = 0;
	ttim = f_ttim;
	rdy1 = 0;
	
	rdyread_in = 0;
	
	if(f_ttim != 0)begin
		ttim = f_ttim - 1;
		
	end
	
	
	if(p_tim != 31) tim = p_tim;
	if(p_ttim != 7) ttim = p_ttim;
		
		case(f_tim)
			1: begin
					if(f_ttim == 0) ttim = 7;
					if(f_ttim == 1) tim = 2;
				end
			2: begin
				if(f_c) in1 = 8'hFF;
				else in1 = {2'b01,f_cmd};
				
				start1 = 1;
				tim = 3;
			end
			3: begin
					if(ready) ttim = 7;
					if(f_ttim == 1) tim = 4;
				end
			4:begin
				in1 = f_arg[31:24];
				start1 = 1;
				tim = 5;
			end
			5: begin
					if(ready) ttim = 7;
					if(f_ttim == 1) tim =6;
				end
			6:begin
				in1 = f_arg[23:16];
				start1 = 1;
				tim = 7;
			end
			7: begin
					if(ready) ttim = 7;
					if(f_ttim == 1) tim = 8;
				end
			8:begin
				in1 = f_arg[15:8];
				start1 = 1;
				tim =9;
			end 
			9: begin
					if(ready) ttim = 7;
					if(f_ttim == 1) tim = 10;
				end
			10:begin
				in1 = f_arg[7:0];
				start1 = 1;
				tim = 11;
			end
			11: begin
					if(ready) ttim = 7;
					if(f_ttim == 1) tim = 12;
				end
			12:begin
				if(f_c) in1 = 8'hFF;
				else in1 = {f_crc,1'b1};
				start1 = 1;
				tim = 13;
			end
			13: begin
					if(ready) ttim = 7;
					if(f_ttim == 1) tim = 14;
				end
			14:begin
				in1 = 8'd255;
				start1 = 1;
				tim = 15;
			end
			15: begin
					if(ready) ttim = 7;
					if(f_ttim == 1) tim = 16;
				end
			16:begin
				in1 = 8'd255;
				start1 = 1;
				tim = 17;
				
			end
			17: begin
					if(ready) begin
						ttim = 7;
						rdyread_in = 1;
						end
						
					if(f_ttim == 1) begin
					
						if(f_answ40)
							if(into == 8'hFE) tim = 26;
							else tim = 18;
						
						else begin
							tim = 0;
							rdy1 = 1;
							end
							
						ttim = 0;
						
					end
					end
			18:begin
				in1 = 8'd255;
				start1 = 1;
				tim = 19;
				
			end
			19: begin
					if(ready) begin
						ttim = 7;
						rdyread_in = 1;
						end
					if(f_ttim == 1) begin
						if(into == 8'hFE) tim = 26;
						else tim = 20;
						end
				end
			20:begin
				in1 = 8'd255;
				start1 = 1;
				tim = 21;
				
			end
			21: begin
					if(ready) begin
						ttim = 7;
						rdyread_in = 1;
						end
					if(f_ttim == 1) begin
						if(into == 8'hFE) tim = 26;
						else tim = 22;
						end
				end
			22:begin
				in1 = 8'd255;
				start1 = 1;
				tim = 23;
				
			end
			23: begin
					if(ready) begin
						
						ttim = 7;
						rdyread_in = 1;
						end
					if(f_ttim == 1) begin 
						if(into == 8'hFE) tim = 26;
						else tim = 24;
						end
				end
			24:begin
				in1 = 8'd255;
				start1 = 1;
				tim = 25;
				
			end

			25: begin
					if(ready) begin
						tim = 26;
						rdyread_in = 1;
						end
				end
			26: begin
						rdy1 =1;
						tim = 0;
					end
		endcase
end

endmodule
