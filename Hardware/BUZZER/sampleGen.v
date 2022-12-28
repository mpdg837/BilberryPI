
module generatorSam(
	input clk,
	input rst,
	
	input freq,
	
	// SampleGen
	input[15:0] addrGen,
	input[15:0] speedGen,
	input stopGen,
	input startGen,
	input loopSample,
	
	// DMA
	output reg[15:0] addrDMA,
	output reg startDMA,
	
	input[15:0] inDMA,
	input rdyDMA,
	
	output reg [15:0] toSaveDMA,
	output reg wDMA,

	//	Output
	
	output reg[15:0] out,
	output reg start
);

localparam IDLE = 3'd0;
localparam INIT = 3'd1;
localparam READ = 3'd2;
localparam GENERATE = 3'd3;
reg f_loop;
reg n_loop;

always@(posedge clk or posedge rst)
	if(rst) f_loop <= 0;
	else f_loop <= n_loop;


reg[7:0] f_sampl;
reg[7:0] n_sampl;

reg[16:0] f_startsampladdr;
reg[16:0] n_startsampladdr;

always@(posedge clk or posedge rst)
	if(rst) begin
		f_sampl <= 0;
		f_startsampladdr <= 0;
		end
	else begin
		f_sampl <= n_sampl;
		f_startsampladdr <= n_startsampladdr;
		end
reg[2:0] f_status;
reg[2:0] n_status;

always@(posedge clk or posedge rst)
	if(rst) f_status <= 0;
	else f_status <= n_status;
	

reg[16:0] f_speed = 0;
reg[16:0] n_speed = 0;

always@(posedge clk or posedge rst)
	if(rst) f_speed <= 0;
	else f_speed <= n_speed;
	
reg[16:0] f_addr;
reg[16:0] n_addr;

always@(posedge clk or posedge rst)
	if(rst) f_addr <= 0;
	else f_addr <= n_addr;

reg[15:0] f_out;
	
always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;
	
always@(*)begin
	out = f_out;
	start = 0;
	
	n_speed = f_speed;
	
	n_addr = f_addr;
	n_startsampladdr = f_startsampladdr;
	
	n_status = f_status;
	n_sampl = f_sampl;
	
	
	n_loop = f_loop;
	
	addrDMA = 0;
	startDMA = 0;
	
	toSaveDMA = 0; 
	wDMA = 0;
	
	if(startGen)begin
		if(addrGen != 0) begin
			n_addr = {addrGen,1'b0};
			n_startsampladdr = {addrGen,1'b0};
			n_loop = 0;
		
		end
		
		n_speed = {speedGen};
		
	end
	
	if(loopSample)begin
		n_loop = 1;
	end
	
	if(stopGen)begin
		n_addr = 0;
		n_speed = 0;
	end
	
	if(freq)begin
		n_status = INIT;
	end
	
	case(f_status)
		INIT: begin
			addrDMA = f_addr[16:1];
			startDMA = 1;
			
			n_status = READ;
		end
		READ: begin
			if(rdyDMA)begin
				
				if(f_addr[0]) n_sampl = inDMA[15:8];
				else n_sampl = inDMA[7:0];
				
				n_status = GENERATE;
			end
		end
		GENERATE: begin
			if(f_sampl != 8'hFF)begin
				out = {f_sampl,8'b0};
				start = 1;
				
				n_addr = f_addr + 1;
			end else begin
				if(f_loop)begin
					n_addr = f_startsampladdr;
				end
				
			end
			
			n_status = IDLE;
		end
		
		default:;
	endcase
	
end

endmodule
