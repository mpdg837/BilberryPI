module crc7spi(
	input clk,
	input rst,
	
	input[39:0] in, 
	input start,
	
	output reg[6:0] out,
	output reg rdy
	
);

reg f_started;
reg started;

reg[5:0] f_count;
reg[5:0] count;

reg[39:0] f_mem;
reg[39:0] mem;

reg[6:0] f_crc;
reg[6:0] crc;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_mem <= 0;
		f_crc <= 0;
		f_started <= 0;
		f_count <= 0;
	end else
	begin
		f_count <= count;
		f_mem <= mem;
		f_crc <= crc;
		f_started <= started;
	end
end

reg inv;

always@(*)begin
	
	rdy = 0;
	inv = 0;
	out = 0;
	
	crc = f_crc;
	started = f_started;
	mem = f_mem;
	count = f_count;
	
	if(start) begin
		started = 1;
		mem = in;
		count = 0;
		crc = 0;
	end
	
	if(f_started)begin
		count = f_count + 1;
		
		inv = f_mem[39] ^ f_crc[6];
		
		mem = {f_mem[38:0],1'b0};
		
		crc[6] = f_crc[5];
		crc[5] = f_crc[4];
		crc[4] = f_crc[3];
		crc[3] = f_crc[2] ^ inv;
		crc[2] = f_crc[1];
		crc[1] = f_crc[0];
		crc[0] = inv;
		
 		if(f_count == 40)begin
			rdy = 1;
			started = 0;
			out = f_crc;
		end
	end
end



endmodule
