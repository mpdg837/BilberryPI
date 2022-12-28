
module shar(
	input[15:0] in,
	input[3:0] arg,
	output[15:0] out
);

assign out = in >> {13'b0,arg};

endmodule

module shal(
	input[15:0] in,
	input[3:0] arg,
	output[15:0] out
);

assign out = in << {13'b0,arg};

endmodule
module shifter(
	input clk,
	input rst,
	
	input[15:0] num1,
	input[2:0] num2,
	
	input s,
	input[1:0] mOper,
	
	output reg shabrk,
	
	output reg[15:0] shiftreg,
	output reg save
);

reg[15:0] n_shiftreg;
reg n_save;

always@(*)begin
	n_save = 0;
	n_shiftreg = 0;
	shabrk = 0;
	
	if(s)begin
		case(mOper)
			2'b00: begin
				n_shiftreg = num1 << (num2 + 1);
				n_save = 1;
			end
			2'b11: begin
				n_shiftreg = num1 >> (num2 + 1);
				n_save = 1;
			end
		endcase
	end
	
	
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		shiftreg <= 0;
		save <= 0;
	end
	else begin
		shiftreg <= n_shiftreg;
		save <= n_save;
	end
end

endmodule


module muldivB(

	input overflow,
	input clk,
	input rst,
	
	input gaddr,
	input[15:0] addr,
	
	input s,
	
	input inter,

	input[1:0] mOper,
	
	input[1:0] mreg1,
	input[1:0] mreg2,
	
	input[15:0] s_sreg1,
	input[15:0] s_sreg2,
	input[15:0] s_sreg3,
	input[15:0] s_sreg4,
	
	input mode,
	
	input ceer,
	
	output[15:0] muldiv,
	output divbrk,
	output bsha,
	
	output divbyzero
	
);

wire[15:0] num1;
wire[15:0] num2;

wire doDiv;
wire doMul;

wire f_m;
wire n_m;

wire[15:0] divRes;
wire[15:0] mulRes;

wire mwork;
wire rdy;
wire mrdy;

wire mmulbrk;
wire mdivbrk;

wire[15:0] shiftres;
wire sshi;

wire shabrk;

shifter shi(
	.clk(clk),
	.rst(rst),
	
	.num1(num1),
	.num2(num2),
	
	.s(s),
	.mOper(mOper),
	
	.shabrk(shabrk),
	
	.shiftreg(shiftres),
	.save(sshi)
);
wire ss;




divider dvd(.clk(clk),
				.start(doDiv),
				.rst(rst),
				
				.num1(num1),
				.num2(num2),
	
				.work(mdivbrk),
				.result(divRes),
				.rdy(rdy),
				
				.mode(n_m)
);

multiplier mu(.clk(clk),
				  .rst(rst),
				  .start(doMul),
				
				  .mode(n_m),
				
				  .num1(num1),
				  .num2(num2),
	
				  .result(mulRes),
				  .rdy(mrdy),
				  .work(mmulbrk)
	
);



demul4 dm1(.mreg(mreg1),
				.s_sreg1(s_sreg1),
				.s_sreg2(s_sreg2),
				.s_sreg3(s_sreg3),
				.s_sreg4(s_sreg4),
					
				.num(num1)
);

demul4 dm2(.mreg(mreg2),
				.s_sreg1(s_sreg1),
				.s_sreg2(s_sreg2),
				.s_sreg3(s_sreg3),
				.s_sreg4(s_sreg4),
					
				.num(num2)
);

collectMulDiv cMD(.mmulbrk(mmulbrk | shabrk),
						.mdivbrk(mdivbrk),
							
						.divbrk(divbrk)
);


manMul mMul(.clk(clk),
				.rst(rst),
				.mode(mode),
				
				.s(s),
				.mrdy(mrdy),
				.rdy(rdy),
				.mOper(mOper),

				.doDiv(doDiv),
				.doMul(doMul),
				.n_m(n_m),
				
				.divbyzero(divbyzero),
				.num2(num2)
);


bus buss(.clk(clk),
			.rst(rst),
	
			.s(s),
	
			.os(ss)
);
wire[15:0] excp=0;

regExtra reEx(.clk(clk),
				  .rst(rst),
	
					.gaddr(gaddr),
					.addr(addr),
				
				  .mOper(mOper),
					.inter(inter),
					
				  .shiftres(shiftres),
				  .shiftsave(sshi),
				
				  .mrdy(mrdy),
				  .rdy(rdy),
				  
				  .mulRes(mulRes),
				  .divRes(divRes),
				 
				
				  .muldiv(muldiv),
				  
				  .s(s)
				  
	
);

endmodule

module regExtra(
	input clk,
	input rst,
	input inter,
	
	input[1:0] mOper,
	
	input[15:0] shiftres,
	input shiftsave,
	
	input mrdy,
	input rdy,
	
	input[15:0] mulRes,
	input[15:0] divRes,
	
	input gaddr,
	input[15:0] addr,
	
	input s,

	output reg[15:0] muldiv
	
);



reg[15:0] n_muldiv;
reg[15:0] mmuldiv;

reg[15:0] b_muldiv;

reg[15:0] ni_muldiv;
reg[15:0] i_muldiv;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		n_muldiv <=0;
	end
	else begin
		n_muldiv <= muldiv;
		
	end
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		ni_muldiv <=0;
	end
	else begin
		ni_muldiv <= i_muldiv;
		
	end
end


always@(*)begin
	
	muldiv = n_muldiv;
	i_muldiv = ni_muldiv;

		if(gaddr) muldiv = addr;
		if(shiftsave) muldiv = shiftres;
		if(mrdy) muldiv = mulRes;
		else if(rdy) muldiv = divRes;
end

	
endmodule

module shaColl(
	input[2:0] arg,
	input[15:0] in1,
	input[15:0] in2,
	input[15:0] in3,
	input[15:0] in4,
	input[15:0] in5,
	input[15:0] in6,
	input[15:0] in7,
	input[15:0] in8,
	
	output reg[15:0] out
);

always@(*)
	case(arg)
		0: out <= in1;
		1: out <= in2;
		2: out <= in3;
		3: out <= in4;
		4: out <= in5;
		5: out <= in6;
		6: out <= in7;
		7: out <= in8;
		default: out <= in1;
	endcase
	
endmodule

module exceptCollector(
	input clk,
	input rst,
	input inter,
	
	input clr,
	
	input divbyzero,
	input stackoverflow,
	input overflow,
	
	output reg[15:0] excp,
	
	output reg expirq
);

reg[15:0] n_excp;
reg[15:0] n_eexcp;

reg[15:0] f_out;
reg[15:0] f_oout;

always@(posedge clk or posedge rst)begin
	if(rst) f_out <= 0;
	else f_out <= n_excp;
end

always@(posedge clk or posedge rst)begin
	if(rst) f_oout <= 0;
	else f_oout <= n_eexcp;
end

always@(*)begin
	n_excp = f_out;
	n_eexcp = f_oout;
	
	if(inter)begin
		if(divbyzero) n_eexcp = 16'd1;
		if(stackoverflow) n_eexcp = 16'd2;
		if(overflow) n_eexcp = 16'd3;
		if(clr) n_eexcp = 0;
	end else
	begin
		if(divbyzero) n_excp = 16'd1;
		if(stackoverflow) n_excp = 16'd2;
		if(overflow) n_excp = 16'd3;
		if(clr) n_excp = 0;	
	end
	
end

always@(*)
	excp <= inter ? n_eexcp : n_excp;

endmodule

module bus(
	input clk,
	input rst,
	
	input s,
	
	output reg os
);

reg f_os;

always@(posedge clk or posedge rst)begin
	if(rst) os <= 0;
	else os <= f_os;
end

always@(*)begin
	f_os <= s;
end

endmodule

module buff7(
	input clk,
	input rst,
	
	input[15:0] in,
	
	output reg[15:0] out
);

reg[15:0] f_out;

always@(posedge clk or posedge rst)begin
	if(rst) out <= 0;
	else out <= f_out;
end

always@(*)begin
	f_out = in;
	
end

endmodule

module manMul(
	input clk,
	input rst,
	input mode,
	
	input s,
	input mrdy,
	input rdy,
	input[1:0] mOper,
	input[15:0] num2,
	
	output reg doDiv,
	output reg doMul,
	output reg n_m,
	
	output reg divbyzero
);



reg f_m;


always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_m <= 0;
	end
	else begin
		f_m <= n_m;
	end
end



always@(*)begin
	
	divbyzero = 0;
	doDiv = 0;
	doMul = 0;
	
	n_m = f_m;
	
	if(~(mrdy | rdy) && s)
		case(mOper) 
			2'b01: begin
					
					n_m = mode;
					doMul = 1;
				end
			2'b10: begin
					if(num2 == 0) divbyzero = 1;
					n_m = mode;
					doDiv = 1;
				end
			default:;
		endcase
end

endmodule


module collectMulDiv(
	
	input mmulbrk,
	input mdivbrk,
	
	output divbrk
);

assign divbrk = mmulbrk | mdivbrk;

endmodule

module demul4(
	input[1:0] mreg,
	input[15:0] s_sreg1,
	input[15:0] s_sreg2,
	input[15:0] s_sreg3,
	input[15:0] s_sreg4,
	
	output reg[15:0] num
);

always@(*)begin
	case(mreg)
		0: num = s_sreg1;
		1: num = s_sreg2;
		2: num = s_sreg3;
		3: num = s_sreg4;
	endcase
end


endmodule
