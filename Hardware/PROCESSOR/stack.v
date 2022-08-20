
module stack(
	input clk,
	input rst,
	
	input clr,
	
	input[1:0] arg,
	input s,
	
	input pop,
	input push,
	
	input readIt,
	
	output reg wstackAddr,
	output reg[15:0] stackAddr,
	
	output reg stackoverflow
);

reg[7:0] f_stackAddr[3:0];
reg[7:0] n_stackAddr[3:0];

reg f_popmem;
reg popmem;

reg[1:0] f_location;
reg[1:0] n_location;

integer n = 0;

always@(posedge clk or posedge rst) begin
	if(rst) f_popmem <= 0;
	else f_popmem <= popmem;
end

always@(posedge clk or posedge rst) begin
	for(n=0;n<4;n=n+1)
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
	
	for(n=0;n<4;n=n+1)
		n_stackAddr[n] = f_stackAddr[n];
	
	popmem = f_popmem;
	
	if(clr)
		n_stackAddr[f_location] = 0;
		
	if(s)
		if(push) begin
			
			if(f_stackAddr[arg] == 255) stackoverflow = 1;
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
		0: stackAddr = {8'b00101011,n_stackAddr[0]};
		1: stackAddr = {8'b00101010,n_stackAddr[1]};
		2: stackAddr = {8'b00101001,n_stackAddr[2]};
		3: stackAddr = {8'b00101000,n_stackAddr[3]};
		endcase
end

endmodule
