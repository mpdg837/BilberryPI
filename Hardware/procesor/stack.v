
module stack(
	input clk,
	input rst,
	
	input clr,
	
	input[3:0] arg,
	input s,
	
	input pop,
	input push,
	
	input readIt,
	
	output reg wstackAddr,
	output reg[15:0] stackAddr,
	
	output reg stackoverflow
);

reg[8:0] f_stackAddr[15:0];
reg[8:0] n_stackAddr[15:0];

reg f_popmem;
reg popmem;

reg[3:0] f_location;
reg[3:0] n_location;

integer n = 0;

always@(posedge clk or posedge rst) begin
	if(rst) f_popmem <= 0;
	else f_popmem <= popmem;
end

always@(posedge clk or posedge rst) begin
	for(n=0;n<16;n=n+1)
		if(rst) f_stackAddr[n] <= 0;
		else f_stackAddr[n] <= n_stackAddr[n];
end

always@(posedge clk or posedge rst) begin
	if(rst) f_location <= 0;
	else f_location <= n_location;
end

always@(*)begin
	
	stackAddr = 0;
	
	stackoverflow = 0;
	wstackAddr = 0;
	n_location = f_location;
	
	for(n=0;n<16;n=n+1)
		n_stackAddr[n] = f_stackAddr[n];
	
	popmem = f_popmem;
	
	if(clr)
		n_stackAddr[f_location] = 0;
		
	if(s)
		if(push) begin
			
			if(f_stackAddr[arg] == 511) stackoverflow = 1;
			else n_stackAddr[arg] = f_stackAddr[arg] + 1;
			
			n_location = arg;
			wstackAddr = 1;
			popmem = 0;
			
		end else if(pop) begin
			
			n_location = arg;
			wstackAddr = 1;
			popmem = 1;
		
		end
	
	if(f_popmem)
		if(readIt) begin
			
			if(f_stackAddr[f_location] == 0) stackoverflow = 1;
			else n_stackAddr[f_location] = f_stackAddr[f_location] - 1;
			
			popmem = 0;
			end
	
	case(n_location)
		0:  stackAddr = {7'h23,n_stackAddr[0]};
		1:  stackAddr = {7'h22,n_stackAddr[1]};
		2:  stackAddr = {7'h21,n_stackAddr[2]};
		3:  stackAddr = {7'h20,n_stackAddr[3]};
		4:  stackAddr = {7'h1f,n_stackAddr[4]};
		5:  stackAddr = {7'h1e,n_stackAddr[5]};
		6:  stackAddr = {7'h1d,n_stackAddr[6]};
		7:  stackAddr = {7'h1c,n_stackAddr[7]};
		8:  stackAddr = {7'h1b,n_stackAddr[8]};
		9:  stackAddr = {7'h1a,n_stackAddr[9]};
		10: stackAddr = {7'h19,n_stackAddr[10]};
		11: stackAddr = {7'h18,n_stackAddr[11]};
		12: stackAddr = {7'h17,n_stackAddr[12]};
		13: stackAddr = {7'h16,n_stackAddr[13]};
		14: stackAddr = {7'h15,n_stackAddr[14]};
		15: stackAddr = {7'h14,n_stackAddr[15]};
		endcase
end

endmodule
