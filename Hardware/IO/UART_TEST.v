module UART_TEST(
	input clk,
	input rst,
	
	input[7:0] in,
	input send,
	
	output reg [7:0] out,
	output rdy,
	
	output tx,
	input rx
);

reg[7:0] data = 0;
reg[7:0] f_data;

reg start;
wire busy;
wire rdyx;

reg[2:0] tim = 0;
reg[2:0] f_tim = 0;

reg[2:0] etim = 0;
reg[2:0] f_etim = 0;

wire[7:0] outdata;

reg rdy1;
reg rdy2;

always@(posedge clk or posedge rst)
	if(rst) f_etim <= 0;
	else f_etim = etim;
	
always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim = tim;

always@(posedge clk or posedge rst)
	if(rst) f_data <= 0;
	else f_data = data;
	
always@(*)begin
	
	tim = f_tim;
	
	rdy1 = 0;
	data = f_data;
	start = 0;
	
	case(f_tim)
		0:	if(send) begin
				data = in;
				start = 1;
				tim = 1;
			end
		1: begin
				data = 0;
				start =0;
				tim = 2;
			end
		2: begin
				data = 0;
				
				if(~busy) tim = 3;
				
				end
		3: begin
				tim = 0;
				rdy1 = 1;
				start = 1;
			end
	endcase
end

always@(*)begin
	rdy2 = 0;
	out = 0;
	
	etim = f_etim;
	
	case(f_etim)
		0:	if(rdyx) begin
				out = outdata;
				rdy2 = 1;
				etim = 1;
			end
		1: begin
				etim = 2;
			end
		2: begin
				etim = 3;
				end
		3: begin
				etim = 0;
			end
	endcase
end


assign rdy = rdy1 | rdy2;
async_transmitter at(.clk(clk),
						   .TxD_start(start),
							.TxD_data(data),
							.TxD(tx),
							.TxD_busy(busy)
);

async_receiver ar(.clk(clk),
						.RxD(rx),
						.RxD_data_ready(rdyx),
						.RxD_data(outdata)
);


endmodule

