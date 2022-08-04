module multiplier(
	input clk,
	input rst,
	input start,
	
	input mode,
	
	input[15:0] num1,
	input[15:0] num2,
	
	output reg[15:0] result,
	output reg rdy,
	output reg work 
	
);

reg[2:0] f_status;
reg[2:0] n_status;

reg[31:0] f_b;
reg[31:0] n_b;

reg[15:0] f_a;
reg[15:0] n_a;

reg[31:0] f_acc;
reg[31:0] n_acc;

reg f_work;

reg[15:0] f_result;

reg[4:0] f_cnt;
reg[4:0] n_cnt;

reg f_m;
reg n_m;

localparam idle = 3'd0;
localparam check1 = 3'd1;
localparam inc = 3'd2;
localparam shift = 3'd3;
localparam check2 = 3'd4;
localparam fin = 3'd5;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_status <= 0;
		f_a <= 0;
		f_b <= 0;
		f_acc <= 0;
		f_work <= 0;
		f_cnt <= 0;
		f_m <= 0;
		f_result <= 0;
	end
	else begin
		f_cnt <= n_cnt;
		f_a <= n_a;
		f_b <= n_b;
		f_acc <= n_acc;
		f_status <= n_status;
		f_work <= work;
		f_m <= n_m;
		f_result <= result;
	end
end

always@(*)begin
	n_status = f_status;
	
	case(f_status)
		idle: if(start) n_status = check1;
				else n_status = idle;
		check1: if(f_a[0] == 1'd1) n_status = inc;
				  else n_status = shift;
		inc: n_status = shift;
		shift: n_status = check2;
		check2: if(f_cnt == 5'd16) n_status = fin;
				  else n_status = check1;
		fin: n_status = idle;
	endcase
end

always@(*)begin
	n_a = f_a;
	n_b = f_b;
	n_acc = f_acc;

	n_cnt = f_cnt;
	
	rdy = 0;
	work = f_work;
	result = f_result;
	
	n_m = f_m;
	
	case(f_status)
		idle: if(start) begin
					n_a = num1;
					n_b = {16'd0 , num2};
					n_acc = 0;
					work = 1;
					result = 0;
					n_cnt = 0;
					n_m = mode;
				end
		check1:;
		inc: n_acc = f_acc + f_b;
		shift: begin
					n_a = f_a >> 1;
					n_b = f_b << 1;
					n_cnt = f_cnt + 1;
				 end
		check2:;
		fin: begin
					rdy = 1;
						if(f_m) result = f_acc[31:16]; 
						else result = f_acc[15:0];
					work = 0;
			  end
	endcase
end

endmodule
