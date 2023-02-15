module RTC(
	input clk,

	
	input rst,
	
	input start,
	input[23:0] in,
	
	output reg[1:0] sel,
	
	output reg[3:0] led,
	
	output reg rdy,
	output reg[23:0] out,
	
	output reg[15:0] gpio_out,
	input[15:0] gpio_in,
	
	output reg wrst,
	
	// UART
	
	output reg send,
	output reg[7:0] out1,
	
	input rdy1,
	input[7:0] in1
);

reg[15:0] b_gpio_out;
reg[15:0] b_gpio_in;

always@(posedge clk)
	gpio_out <= b_gpio_out;
	
always@(posedge clk)
	b_gpio_in <= gpio_in;
	
reg f_start;
reg n_start;


reg[3:0] n_led;
reg[3:0] f_led;

reg[1:0] f_sel;

reg[23:0] f_out;

reg[15:0] f_gpio_out;

localparam RST = 8'd1;

localparam ON = 8'd5;
localparam OFF = 8'd6;

localparam GPIOOUT = 8'd7;
localparam GPIOIN = 8'd8;

localparam UARTSEND = 8'd9;
localparam UARTSEL = 8'd10;

	
always@(posedge clk or posedge rst)
	if(rst) f_gpio_out <= 0;
	else f_gpio_out <= b_gpio_out;
	

	
always@(posedge clk or posedge rst)
	if(rst) f_led <= 0;
	else f_led <= n_led;

always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;

	
always@(*)begin
	out = f_out;
	n_led = f_led;
	
	b_gpio_out = f_gpio_out;
	
	out = 0;
	rdy = 0;
	
	send = 0;
	out1 = 0;
	
	wrst = 0;
	
	if(start) begin
		case(in[23:16])
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
	
			RST: wrst = 1;
			
			default:;
		endcase
	end
	led = ~f_led;
	
end



endmodule
