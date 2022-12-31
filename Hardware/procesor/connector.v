
module connector(
	input clk,
	input rst,
	
	input[15:0] out1,
	input[15:0] out2,
	
	output reg[31:0] out
);

reg[31:0] b_out;

always@(*)begin
	b_out = out;
	
	if(out2 != 0) b_out = {out2,out1};
	else b_out = 0;
	
end

always@(posedge clk or posedge rst)begin
	
	if(rst) out <= 0;
	else out <=  b_out;

end


endmodule

module innector(
	input clk,
	input rst,
	
	input[31:0] in,
	output reg[15:0] out1,
	output reg[15:0] out2
);

reg[15:0] r_out1;
reg[15:0] r_out2;

always@(posedge clk or posedge rst)begin
	if(rst) out1 <= 0;
	else out1 <= r_out1;
end

always@(posedge clk or posedge rst)begin
	if(rst) out2 <= 0;
	else out2 <= r_out2;
end


always@(*)begin
	r_out1 = out1;
	
	if(in[31]) begin
		r_out1 = in[31:16];
	end
end

always@(*)begin
	r_out2 = out2;
	
	if(in[31]) begin
		r_out2 = in[15:0];
	end
end

endmodule
