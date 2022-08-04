
module RAMController(
	input clk,
	input rst,
	input inter,
	
	output reg[7:0] progoffset,
	input[1:0] ereg1,
	input[1:0] ereg2,
	
	input[15:0] edata,
	input[1:0] mOper,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,
	
	input s,
	
	
	input[7:0] stackAddr,
	input wStackAddr,
	
	output reg[15:0] toRAM,
	output reg[15:0] RAMaddr,
	output reg w
);

localparam NOP = 2'd0;
localparam RAM = 2'd1;
localparam URAM = 2'd2;
localparam SAVE = 2'd3;

reg[7:0] offset;
reg[7:0] n_offset;

reg[7:0] n_progoffset;

reg[15:0] n_toRAM;

reg[15:0] RAMaddrn;
reg[15:0] RAMaddri;

reg[15:0] n_RAMaddrn;
reg[15:0] n_RAMaddri;

wire[15:0] num1;

reg n_w;


demul4 dm5(.mreg(ereg1),
				.s_sreg1(sreg1),
				.s_sreg2(sreg2),
				.s_sreg3(sreg3),
				.s_sreg4(sreg4),
					
				.num(num1)
);

reg f_off;
reg n_off;

always@(posedge clk or posedge rst)
	if(rst) f_off <= 0;
	else f_off <= n_off;

always@(posedge clk or posedge rst)
	if(rst) begin
		offset <= 0;
		progoffset <= 0;
		end
	else begin
		offset <= n_offset;
		progoffset <= n_progoffset;
		end


always@(posedge clk or posedge rst)
	if(rst) RAMaddri <= 0;
	else RAMaddri <= n_RAMaddri;

always@(posedge clk or posedge rst)
	if(rst) RAMaddrn <= 0;
	else RAMaddrn <= n_RAMaddrn;
	
always@(posedge clk or posedge rst)begin
	if(rst) begin
		toRAM <= 0;
	
	end
	else begin
		toRAM <= n_toRAM;
	
	end
end


always@(posedge clk or posedge rst)begin
	if(rst) begin
	
		w <= 0;
	end
	else begin
	
		w <= n_w;
	end
end


always@(*)begin
	n_toRAM = 0;

	if(s)begin
		case(mOper)
			
			SAVE: begin
					if(edata == 0) n_toRAM = num1;
					else n_toRAM = edata; 
				
			end
			
			default:;
		endcase
	
	end else
	begin
		n_toRAM = 0;
	
	
	end
end

always@(*)begin
	n_w = 0;
	
	if(s)begin
		case(mOper)
			
			SAVE: begin
					n_w = 1;
			end
			
			default:;
		endcase
	
	end else
	begin
		n_w = 0;
	
	end
end
always@(*)begin
	n_RAMaddri = RAMaddri;
	n_RAMaddrn = RAMaddrn;
	n_off = f_off;
	
	n_offset = offset;
	n_progoffset = progoffset;
	
	if(wStackAddr)
		if(inter) n_RAMaddri = {8'b00010011,stackAddr};
		else n_RAMaddrn = {8'b00010011,stackAddr};
	else if(s)begin
		
		case(mOper)
			NOP: ;
			RAM: begin
					if(inter) n_RAMaddri = edata[15:0];
					else begin
						case(ereg2)
							0: begin
								n_RAMaddrn = edata[15:0];
								n_off = 0;
								end
							1: n_offset = {edata[7:0]};
							2: n_offset = {edata[5:0],2'b0};
							3: n_progoffset = {edata[7:0]};
						endcase
					end
						
			end
			URAM: begin
					if(inter) n_RAMaddri = {num1[15:0]};
					else begin
						case(ereg2)
							0: begin
								n_RAMaddrn = num1[15:0];
								n_off = 1;
								end
							1: n_offset = {num1[7:0]};
							2: n_offset = {num1[5:0],2'b0};
							3: n_progoffset = {num1[7:0]};
						endcase
					end
						
			end
			default:;
		endcase
	
	end 
	
end

always@(*)
	if(wStackAddr) RAMaddr <= RAMaddrn;
	else if(inter) RAMaddr <= RAMaddri;
	else if(f_off) RAMaddr <= RAMaddrn + {offset,5'b0};
	else RAMaddr <= RAMaddrn;
endmodule
