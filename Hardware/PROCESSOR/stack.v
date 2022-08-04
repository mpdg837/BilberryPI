
module stack(
	input clk,
	input rst,
	
	input s,
	
	input pop,
	input push,
	
	input readIt,
	
	output reg wstackAddr,
	output reg[7:0] stackAddr,
	
	output reg stackoverflow
);

reg[7:0] f_stackAddr;
reg f_popmem;
reg popmem;

always@(posedge clk or posedge rst) begin
	if(rst) f_popmem <= 0;
	else f_popmem <= popmem;
end

always@(posedge clk or posedge rst) begin
	if(rst) f_stackAddr <= 0;
	else f_stackAddr <= stackAddr;
end

always@(*)begin
	stackoverflow = 0;
	wstackAddr = 0;
	
	stackAddr = f_stackAddr;
	
	popmem = f_popmem;
	
	if(s)
		if(push) begin
			
			if(f_stackAddr == 255) stackoverflow = 1;
			else stackAddr = f_stackAddr + 1;
			
			wstackAddr = 1;
			popmem = 0;
			
		end else if(pop) begin
			
			wstackAddr = 1;
			popmem = 1;
		
		end
	
	if(f_popmem)
		if(readIt) begin
		
			if(f_stackAddr == 0) stackoverflow = 1;
			else stackAddr = f_stackAddr - 1;
			
			popmem = 0;
			end
	
end

endmodule
