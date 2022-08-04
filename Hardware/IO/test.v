module RTC(
	input clk,
	
	input dclk,
	
	input rst,
	
	input start,
	input[23:0] in,
	
	output reg[3:0] led,
	
	output reg rdy,
	output reg[23:0] out
);

reg f_start;
reg n_start;

reg[15:0] f_tim;
reg[15:0] n_tim;

reg[15:0] n_ttim;

reg[3:0] n_led;
reg[3:0] f_led;


reg[23:0] f_out;


localparam RUN = 8'd1;
localparam STOP = 8'd2;
localparam SET = 8'd3;
localparam GET = 8'd4;

localparam ON = 8'd5;
localparam OFF = 8'd6;

always@(posedge dclk or posedge rst)
	if(rst) f_start <= 0;
	else f_start <= n_start;
	
always@(posedge clk or posedge rst)
	if(rst) f_led <= 0;
	else f_led <= n_led;

always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;

always@(posedge dclk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
	
	
always@(*)begin
	n_start = f_start;
	out = f_out;
	n_led = f_led;
	
	out = 0;
	rdy = 0;
	
	if(start) begin
		case(in[23:16])
			RUN: n_start = 1;
			STOP: n_start = 0;
			GET: begin
					out = {GET,n_ttim};
					rdy = 1;
					end
			ON:case(in[1:0])
					0: n_led = {f_led[3:1],1'b1};
					1: n_led = {f_led[3:2],1'b1,f_led[0]};
					2: n_led = {f_led[3],1'b1,f_led[1:0]};
					3: n_led = {1'b1,f_led[2:0]};
					default:;
				endcase
				
			OFF:case(in[1:0])
					0: n_led = {f_led[3:1],1'b0};
					1: n_led = {f_led[3:2],1'b0,f_led[0]};
					2: n_led = {f_led[3],1'b0,f_led[1:0]};
					3: n_led = {1'b0,f_led[2:0]};
					default:;
				endcase
			default:;
		endcase
	end
	
	led = ~f_led;
	
end

always@(posedge clk)begin
	n_ttim <= f_tim;
end

always@(*) begin
	n_tim = f_tim;
		
	if(f_start)begin
		n_tim = f_tim + 1;
	end 
	
	if(start) begin
		case(in[23:16])
			SET: n_tim = in[15:0];
			default:;
		endcase
	end
	
end



endmodule
