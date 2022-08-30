

module outputX(
	input clk,
	input rst,
	
	input inter,
	
	input[1:0] reg1,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,
	
	input outA,
	input outB,
	
	input s,
	
	output[15:0] out1,
	output[15:0] out2
);
reg[15:0] n_out1a;
reg[15:0] n_out1b;
reg[15:0] n_out2;

reg[15:0] s_out1a;
reg[15:0] s_out1b;
reg[15:0] s_out2;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		s_out1a <= 0;

	end else
	begin
		s_out1a <= n_out1a;
	end
end


always@(posedge clk or posedge rst)begin
	if(rst)begin
		s_out1b <= 0;

	end else
	begin
		s_out1b <= n_out1b;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		s_out2 <= 0;
	end else
	begin
		s_out2 <= n_out2;
	end
end

always@(*)begin
	n_out2 = 0;
	
	if(s & outB) begin
			case(reg1)
				0: n_out2 = sreg1;
				1: n_out2 = sreg2;
				2: n_out2 = sreg3;
				3: n_out2 = sreg4;
			endcase
		
	
	end
end

always@(*)begin
	n_out1a = s_out1a;
	n_out1b = s_out1b;
	
	if(s & outA) begin
			case(reg1)
				0: n_out1a = sreg1;
				1: n_out1a = sreg2;
				2: n_out1a = sreg3;
				3: n_out1a = sreg4;
			endcase
	end
end

reg ns;

always@(posedge clk)
	ns <= s;

bit16Buf buf1(
	.clk(clk),
	.s(ns),
	.in(s_out1a),
	.out(out1)
);


bit16Buf buf2(
	.clk(clk),
	.s(ns),
	.in(s_out2),
	.out(out2)
);

endmodule

module bit16Buf(
	input clk,
	
	input s,
	
	input[15:0] in,
	output reg[15:0] out
);

always@(posedge clk)
	if(s) out <= in;
	else out <= 0;
endmodule
