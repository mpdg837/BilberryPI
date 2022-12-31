
module RAMController(
	input clk,
	input rst,
	input inter,
	
	output[7:0] progoffset = 0,
	input[1:0] ereg1,
	input[1:0] ereg2,
	
	input[15:0] edata,
	input[1:0] mOper,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,
	
	input s,
	
	
	input[15:0] stackAddr,
	input wStackAddr,
	
	output reg[15:0] toRAM,
	output reg[15:0] RAMaddr,
	output reg w
);

localparam NOP = 2'd0;
localparam RAM = 2'd1;
localparam URAM = 2'd2;
localparam SAVE = 2'd3;



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
	
	if(s)begin
		
		case(mOper)
			NOP: ;
			RAM: begin
					if(inter) n_RAMaddri = {3'b0,edata[13:0]};
					else begin
						n_RAMaddrn = {3'b0,edata[13:0]};
					end
						
			end
			URAM: begin
					if(inter) n_RAMaddri = {3'b0,num1[13:0]};
					else begin
						n_RAMaddrn = {3'b0,num1[13:0]};
								
					end
						
			end
			default:;
		endcase
	
	end 
	if(wStackAddr)
		n_RAMaddrn = {stackAddr};
end

always@(*)
	if(inter) RAMaddr <= RAMaddri;
	else RAMaddr <= RAMaddrn;
endmodule
