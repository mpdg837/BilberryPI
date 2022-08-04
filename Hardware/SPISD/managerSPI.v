module managerSD(
	input clk,
	input rst,
	
	input[23:0] in,
	input start,
	
	output reg rdy,
	output reg[23:0] out,
	
	
	output reg[5:0] cmd,
	output reg[31:0] arg,
	
	output reg startprep,
	output reg start40prep,
	output reg startreadit,
	output reg startnocrc,
	
	output reg startinit,
	
	output reg startstream,
	input[7:0] outputstream
);

reg[7:0] f_mem;
reg[7:0] n_mem;

reg f_read;
reg n_read;

reg startread;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_mem <= 0;
		f_read <= 0;
		end
	else begin
		f_mem <= n_mem;
		f_read <= n_read;
		end
end

always@(*)begin
	n_mem = f_mem;
	n_read = f_read;
	
	if(startread) n_read = 1;
	
	if(f_read)begin
		n_mem = outputstream;
		n_read = 0;
	end
end

always@(*)begin
	cmd = 0;
	arg = 0;
	
	startprep = 0;
	start40prep = 0;
	startreadit = 0;
	startnocrc = 0;
	
	startinit = 0;
	
	startread = 0;
	
end



endmodule
