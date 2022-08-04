module divider(
	input clk,
	input start,
	input rst,
	
	input mode,
	
	input[15:0] num1,
	input[15:0] num2,
	
	output reg work,
	output reg rdy,
	output reg[15:0] result
);

reg[2:0] f_status;
reg[2:0] n_status;

reg[15:0] f_num1;
reg[15:0] n_num1;

reg[15:0] f_num2;
reg[15:0] n_num2;

reg[15:0] f_cnt;
reg[15:0] n_cnt;

reg f_m;
reg n_m;

reg[15:0] f_result;
reg f_work;

localparam idle = 3'd0;
localparam check = 3'd1;
localparam sub = 3'd2;
localparam fin = 3'd3;
localparam div0 = 3'd4;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_result <= 0;
		f_work <= 0;
		f_status <= 0;
		
		f_num1 <= 0;
		f_num2 <= 0;
		f_cnt <= 0;
		f_m <= 0;
	end else
	begin
		f_status <= n_status;
		f_work <= work;
		f_result <= result;
		
		f_num1 <= n_num1;
		f_num2 <= n_num2;
		f_cnt <= n_cnt;
		f_m <= n_m;
	end
end

always@(*)begin
	n_status = f_status;
	
	case(f_status)
		idle: if(start) n_status = div0; 
				else n_status = idle;
		div0: if(f_num2 == 0) n_status = fin;
				else n_status = check;
		check: if(f_num1 < f_num2) n_status = fin;
				 else n_status = sub;
		sub: n_status = check; 
		fin: n_status = idle;
		default:;
	endcase	
	
end

	
always@(*)begin
	work = f_work;
	result = f_result;
		
	n_num1 = f_num1;
	n_num2 = f_num2;
	
	n_cnt = f_cnt;
	
	
	rdy = 0;
	
	n_m = f_m;
	
	case(f_status)
		idle: if(start) begin
					work = 1;
					n_num1 = num1;
					n_num2 = num2;
					n_cnt = 0;
					result = 0;
					n_m = mode;
				end 
		div0: if(f_num2 == 0) begin
					
					n_cnt = 16'hFFFF;
					
					end
		check:;
		sub:begin
				n_num1 = f_num1 - f_num2;
				n_cnt = f_cnt + 1;
				end
		fin: begin
				rdy = 1;
					if(f_m) result = f_num1;
					else result = f_cnt;
				work = 0;
				end
		default:;
	endcase	
	
end

endmodule
