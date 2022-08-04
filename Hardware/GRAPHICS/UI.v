module uiController(
	input clk,
	
	input[9:0] CounterX,
	input[8:0] CounterY,
	
	input we,
	input[10:0] addr,
	input[1:0] din,
	
	output reg[4:0] tex
);


reg[1:0] memory[2047:0];

reg[11:0] n;

initial begin
	for(n=0;n<2048;n = n + 1) begin
		memory[n] = 0;
		end
end


always@(posedge clk)begin
	
	if(we)
		memory[addr] <= din;
		
	tex <= memory[{CounterX[9:4],CounterY[8:4]}];
	end

endmodule
