module receiverbuffer(
	input clk,
	input dclk,
	input rst,
	
	input[7:0] in,
	input readed,
	
	output reg[7:0] n_in,
	output reg n_readed
);

reg f_started = 0;
reg n_started = 0;

reg[7:0] nn_in;
reg nn_readed;

reg nreaded;
reg[7:0] nin;
always@(posedge dclk or posedge rst)
	if(rst) begin
		nreaded <= 0;
		nin <= 0;
		end
	else begin
		nreaded <= readed;
		nin <= in;
		end
		
always@(posedge clk or posedge rst)
	if(rst) f_started <= 0;
	else f_started <= n_started;
	
always@(*)begin
	n_started = nreaded;
	
	nn_in = 0;
	nn_readed = 0;
	
	if(~f_started && nreaded)begin
		nn_in = nin;
		nn_readed = nreaded;
	end
	
end

always@(posedge clk or posedge rst)
	begin
		if(rst) begin
			n_in <= 0;
			n_readed <= 0;
		end
		else begin
			n_in <= nn_in;
			n_readed <= nn_readed;
		end
	end

endmodule


module receiver(
	input clk,
	input dclk,
	input rst,
	
	input reset,
		
	input readed,
	input[7:0] in,
	
	input gets,
	output reg rdy,
	output reg[7:0] out
);

localparam LENM = 8;

wire[7:0] n_in;
wire n_readed;

receiverbuffer rb(
	.clk(clk),
	.dclk(dclk),
	.rst(rst),
	
	.in(in),
	.readed(readed),
	
	.n_in(n_in),
	.n_readed(n_readed)
);

reg[7:0] f_memory[LENM - 1:0];
reg[7:0] n_memory[LENM - 1:0];

reg[7:0] f_out;

integer n;
integer p;

always@(posedge clk or posedge rst)
	if(rst)
		f_out <= 0;
	else
		f_out <= out;
		
always@(posedge clk or posedge rst)
	if(rst)
		for(n=0;n<LENM;n = n + 1) f_memory[n] <= 0; 
	else
		for(n=0;n<LENM;n = n + 1) f_memory[n] <= n_memory[n]; 
		

always@(*)begin
	
	out = f_out;
	rdy = 0;
	
	for(p=0;p<LENM;p = p + 1) n_memory[p] = f_memory[p]; 
	
	if(reset) 
		for(p=0;p<LENM;p = p + 1) n_memory[p] = 0;
	
	if(n_readed) begin
		n_memory[0] = n_in; 
		
		for(p=0;p<LENM - 1;p = p + 1)begin
			n_memory[p+1] = f_memory[p]; 
		end
	end
	
	if(gets) begin
		out = f_memory[LENM - 1];
		rdy = 1;
		
		for(p=0;p<LENM - 1;p = p + 1)begin
			n_memory[p+1] = f_memory[p];  
		end
	end
	
	
end



endmodule
