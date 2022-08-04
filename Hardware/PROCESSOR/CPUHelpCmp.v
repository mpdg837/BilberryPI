module fromMEM(
	input rdy,
	input[31:0] toCPU,
	output reg[31:0] totoCPU
);

always@(*) begin
	if(rdy) totoCPU <= toCPU;
	else totoCPU <= 0;
end

endmodule
module bufferIN(
	input clk,
	input rst,
	input rdyCmp,
	input[15:0] in,
	
	output reg[7:0] in1,
	output reg[7:0] in2
);

always@(posedge clk or posedge rst)begin
	if(rst) begin
		in1 <= 0;
		in2 <= 0;
	end
	else begin
		if(rdyCmp)begin
			in1 <= in[7:0];
			in2 <= in[15:8];
		end else
		begin
			in1 <= 0;
			in2 <= 0;
		end
	end
end

endmodule

module outMEM(
	input[11:0] addrMEM,
	
	output reg[2:0] addrCmp

);

always@(*)begin
	if(addrMEM[11:8] == 0) addrCmp <= 3'd2;
	else addrCmp <= 3'd3;
end

endmodule

