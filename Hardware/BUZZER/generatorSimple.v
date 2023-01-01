
module DMACollect(

	input clk,
	input rst,
	
	// DMA In1
	input startDMA1,
	input[15:0] addrDMA1,
	
	output reg[15:0] fromMemDMA1,
	output reg rdyDMA1,

	// DMA In2
	input startDMA2,
	input[15:0] addrDMA2,
	
	output reg[15:0] fromMemDMA2,
	output reg rdyDMA2,
	
	// DMA In3
	input startDMA3,
	input[15:0] addrDMA3,
	
	output reg[15:0] fromMemDMA3,
	output reg rdyDMA3,
	
	// DMA Out
	output reg startDMA,
	output reg[15:0] addrDMA,
	
	input[15:0] fromMemDMA,
	input rdyDMA
);


reg[3:0] f_stat;
reg[3:0] n_stat;

reg f_start1;
reg n_start1;

reg f_start2;
reg n_start2;

reg f_start3;
reg n_start3;

reg[15:0] f_addr1;
reg[15:0] n_addr1;

reg[15:0] f_addr2;
reg[15:0] n_addr2;

reg[15:0] f_addr3;
reg[15:0] n_addr3;

reg clear;

always@(posedge clk or posedge rst)
	if(rst) f_stat <= 0;
	else f_stat <= n_stat;
	
always@(posedge clk or posedge rst)
	if(rst)begin
		f_addr1 <= 0;
		f_addr2 <= 0;
		f_addr3 <= 0;
	end else
	begin
		f_addr1 <= n_addr1;
		f_addr2 <= n_addr2;
		f_addr3 <= n_addr3;
	end
	
always@(posedge clk or posedge rst)
	if(rst)begin
		f_start1 <= 0;
		f_start2 <= 0;
		f_start3 <= 0;
	end else
	begin
		f_start1 <= n_start1;
		f_start2 <= n_start2;
		f_start3 <= n_start3;
	end
	
always@(*)begin
	
	n_start1 = f_start1;
	n_start2 = f_start2;
	n_start3 = f_start3;

	n_addr1 = f_addr1;
	n_addr2 = f_addr2;
	n_addr3 = f_addr3;	
	
	
	if(startDMA1)begin
		n_addr1 = addrDMA1;
		n_start1 = 1;
	end
	
	if(startDMA2)begin
		n_addr2 = addrDMA2;
		n_start2 = 1;
	end
	
	if(startDMA3)begin
		n_addr3 = addrDMA3;
		n_start3 = 1;
	end
	
	if(clear)begin
		n_start1 = 0;
		n_start2 = 0;
		n_start3 = 0;
	end
	
end

always@(*)begin

	n_stat = f_stat;
	
	clear = 0;
	
	fromMemDMA1 = 0;
	rdyDMA1 = 0;
	
	fromMemDMA2 = 0;
	rdyDMA2 = 0;
	
	fromMemDMA3 = 0;
	rdyDMA3 = 0;
	
	startDMA = 0;
	addrDMA = 0;
	
	if(startDMA1 | startDMA2 | startDMA3) n_stat = 1;
	
	case(f_stat)
		1: if(f_start1)begin // Gen1
				addrDMA = f_addr1;
				startDMA = 1;
				
				n_stat = 2;
			end
			else n_stat = 3;
		2: if(rdyDMA)begin
				fromMemDMA1 = fromMemDMA;
				rdyDMA1 = 1;
				n_stat = 3;
			end
		3: if(f_start2)begin // Gen2
				addrDMA = f_addr2;
				startDMA = 1;
				
				n_stat = 4;
			end
			else n_stat = 5;
		4: if(rdyDMA)begin
				fromMemDMA2 = fromMemDMA;
				rdyDMA2 = 1;
				n_stat = 5;
			end
		5: if(f_start3)begin // Gen3
				addrDMA = f_addr3;
				startDMA = 1;
				
				n_stat = 6;
			end
			else n_stat = 7;
		6: if(rdyDMA)begin
				fromMemDMA3 = fromMemDMA;
				rdyDMA3 = 1;
				n_stat = 7;
			end
		7: begin
			clear = 1;
			n_stat = 0;
		end
		default:;
	endcase
end

endmodule


module soundGenSimple(
	input clk,
	input rst,
	
	input freq,
	
	// SampleGen
	
	input startSample,
	input[15:0] addrSample,
	input stopSample,
	input[15:0] speedSample,
	input[2:0] volume,
	input loopSample,
	
	// DMA
	output reg startDMA,
	output reg[15:0] addrDMA,
	
	input[15:0] fromMemDMA,
	input rdyDMA,
	
	// Sound
	output reg[15:0] out,
	output reg start
	
);

reg[23:0] f_addrMem;
reg[23:0] n_addrMem;

reg[7:0] f_buffer;
reg[7:0] n_buffer;

reg[7:0] f_buffernow;
reg[7:0] n_buffernow;

reg[23:0] f_addr;
reg[23:0] n_addr;

reg[1:0] f_s;
reg[1:0] n_s;

reg f_full;
reg n_full;

always@(posedge clk or posedge rst)
	if(rst) f_full <= 0;
	else f_full <= n_full;
	
always@(posedge clk or posedge rst)
	if(rst) f_addrMem <= 0;
	else f_addrMem <= n_addrMem;
	
always@(posedge clk or posedge rst)
	if(rst) f_s <= 0;
	else f_s <= n_s;

always@(posedge clk or posedge rst)
	if(rst) f_addr <= 0;
	else f_addr <= n_addr;
	
always@(posedge clk or posedge rst)
	if(rst) f_buffer <= 0;
	else f_buffer <= n_buffer;

always@(posedge clk or posedge rst)
	if(rst) f_buffernow <= 0;
	else f_buffernow <= n_buffernow;
	
always@(*)begin
	
	n_addr = f_addr;
	n_addrMem = f_addrMem;
	
	n_s = f_s;
	
	n_buffer = f_buffer;
	n_buffernow = f_buffernow;
	
	n_full = f_full;
	
	startDMA = 0;
	addrDMA = 0;
	
	out = 0;
	start = 0;
	
	if(startSample)begin
		n_s = 1;
		n_addr = {addrSample[14:0],9'b0};
		n_addrMem = {addrSample[14:0],9'b0};
	end
	
	if(stopSample) n_s = 0;
	
	if(freq)begin
		case(volume)
			0: out = {f_buffernow,8'b0};
			1: out = {f_buffernow,7'b0};
			2: out = {f_buffernow,6'b0};
			3: out = {f_buffernow,5'b0};
			4: out = {f_buffernow,4'b0};
			5: out = {f_buffernow,3'b0};
			6: out = {f_buffernow,2'b0};
			7: out = {f_buffernow,1'b0};
			default:;
		endcase
		
		start = 1;
		
		n_buffernow = f_buffer;
	end
		
	case(f_s)
		1:if(freq)begin
				addrDMA = f_addr[23:9];
				startDMA = 1;
				n_s = 2;
			end
		2: if(rdyDMA)begin
				
				n_full = (fromMemDMA == 16'hFFFF);
				if(~n_full)
					case(f_addr[8])
						0: n_buffer = {fromMemDMA[7:0]};
						1: n_buffer = {fromMemDMA[15:8]};
					endcase
					
					
				n_s = 3;
			end
		3: begin
		
			if(f_full) begin
				if(loopSample) begin
					 n_addr = f_addrMem;
					 n_s = 1;
				end
				else n_s = 0;
				
				end
			else begin
				n_addr = f_addr + speedSample;
				n_s = 1;
			end

		end
		
		default:;
	endcase
	
end
	
endmodule


