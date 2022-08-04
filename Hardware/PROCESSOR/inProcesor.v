
module bufexcp(
	input clk,
	input rst,
	input[15:0] in,
	
	output reg[15:0] out
);

always@(posedge clk or posedge rst)
	if(rst) out <= 0;
	else out <= in;
	

endmodule
module inselector(
	input clk,
	input rst,
	
	input insel,
	input[15:0] insIn1,
	input[15:0] insIn2,
	
	input saveExcp,
	input[15:0] timeIn,
	
	output reg[15:0] insIn
);

reg[15:0] f_insIn;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_insIn <= 0;
	end else
	begin
		f_insIn <= insIn;
	end
end

always@(*) begin

	insIn = f_insIn;
	
	if(insel) insIn = insIn2;
	else insIn = insIn1;
end

endmodule

module bufferIn(
	input clk,
	input rst,
	input[15:0] in,
	
	output reg[15:0] insIn
	
);


always@(posedge clk or posedge rst)
	if(rst) insIn <=0 ;
	else insIn <= in;



endmodule
