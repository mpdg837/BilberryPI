

module BRAMI32
#(
	parameter blocks = 14
)(
	input[14:0] addr,
	input[31:0] din,
	input clk,rst,we,
	output[31:0] out,
	
	input startReadRAM,
	
	output readRdyRAM = 1,
	output saveRdyRAM =1
	
);

BRAM #(blocks) ram1(
	.addr(addr),
	.din(din),
	.clk(clk),
	.rst(rst),
	.we(we),
	
	
	.out(out)
	
	
	
);

	
assign readRdyRAM = 1;
assign saveRdyRAM = 1;
	
endmodule

module BRAM
#(
	parameter blocks = 14
)(
	input[14:0] addr,
	input[31:0] din,
	input clk,rst,we,
	output reg[31:0] out,
	
	input startReadRAM,
	
	output reg readRdyRAM,
	output reg saveRdyRAM
	
);

wire[14:0] raddr = addr[11:0];

reg[31:0] memory[blocks * 256 - 1:0];
reg[31:0] dout_r;

integer n;

initial begin 
	for(n=0;n< blocks * 256 - 1;n = n + 1) begin
		memory[n] = 0;
		end
end


wire[14:0] iraddr = addr[11:0];


always@(posedge clk) begin

	if(we) memory[iraddr[14:0]] <= din;
	out <= memory[iraddr[14:0]];
	
	readRdyRAM <= 1;
	saveRdyRAM <= 1;
end	



endmodule

