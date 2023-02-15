
module interCont(
	input clk,
	input rst,
	
	input eirq,
	input[2:0] irq,
	
	output reg irq1,
	output reg irq2,
	output reg irq3
);

localparam LEN = 34;

reg started;
reg f_started;

reg[2:0] f_irqm[LEN-1:0];
reg[2:0] n_irqm[LEN-1:0];

reg[2:0] imem;
integer n = 0;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		for(n = 0; n < LEN; n = n + 1) f_irqm[n] <= 0;
		f_started <= 0;
	end else
	begin
		for(n = 0; n < LEN; n = n + 1) f_irqm[n] <= n_irqm[n];
		f_started <= started;
	end
end

always@(*)begin
	for(n = 0; n < LEN; n = n + 1) n_irqm[n] = f_irqm[n];
	
	started = f_started;
	
	imem = 0;
	
	irq1 = 0;
	irq2 = 0;
	irq3 = 0;
	

	if(eirq | (~f_started))begin
	
		if(f_irqm[0] == 0)begin
			if(irq==0) started = 0;
			else started = 1;
		
			irq1 = irq[0];
			irq2 = irq[1];
			irq3 = irq[2];
			
		end else
		begin
			if(f_irqm[1]==0) started = 0;
			else started = 1;
			
			imem = f_irqm[0];
			
			irq1 = imem[0];
			irq2 = imem[1];
			irq3 = imem[2];
		end
		
		
		for(n = 0; n < LEN - 1; n = n + 1) n_irqm[n] = f_irqm[n + 1];
		n_irqm[LEN - 1] = 0;
		
		if(irq != 0)begin
			
			if(f_irqm[0] == 0) n_irqm[0] = 0;
			else
				begin: LooperAdd
					for(n = 1; n < LEN; n = n + 1) begin
						if(f_irqm[n] == 0 ) begin	
							n_irqm[n - 1] = irq;
							
							disable LooperAdd;
						end
					end
				end
		end 
		
	end else
		begin
			if(irq != 0)begin
			
				begin: LooperAdd1
					for(n = 1; n < LEN; n = n + 1) begin
						if(f_irqm[n] == 0 ) begin	
							n_irqm[n] = irq;
							
							disable LooperAdd1;
						end

					end
				end
				
			end 
		end
	
	
end

endmodule



module irqcollector(
	input clk,
	input rst,
	
	input irq1,
	input irq2,
	input irq3,
	input irq4,
	input irq5,
	input irq6,
	input irq7,
	
	output reg[2:0] irq
	
);

reg s_r0;
reg s_r1;
reg s_r2;
reg s_r3;
reg s_r4;
reg s_r5;
reg s_r6;
reg s_r7;

reg f_r0;
reg f_r1;
reg f_r2;
reg f_r3;
reg f_r4;
reg f_r5;
reg f_r6;
reg f_r7;

reg[2:0] f_t;
reg[2:0] n_t;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		f_r0 <= 0;
		f_r1 <= 0;
		f_r2 <= 0;
		f_r3 <= 0;
		f_r4 <= 0;
		f_r5 <= 0;
		f_r6 <= 0;
		f_r7 <= 0;
		
		f_t <= 0;
	end else
	begin
		f_r0 <= s_r0;
		f_r1 <= s_r1;
		f_r2 <= s_r2;
		f_r3 <= s_r3;
		f_r4 <= s_r4;
		f_r5 <= s_r5;
		f_r6 <= s_r6;
		f_r7 <= s_r7;
		
		f_t <= n_t;
	end
		
end

always@(*) n_t = f_t + 1;

always@(*)begin
		s_r0 = f_r0;
		s_r1 = f_r1;
		s_r2 = f_r2;
		s_r3 = f_r3;
		s_r4 = f_r4;
		s_r5 = f_r5;
		s_r6 = f_r6;
		s_r7 = f_r7;
	
		if(irq1) s_r1 = 1;
		if(irq2) s_r2 = 1;
		if(irq3) s_r3 = 1;
		if(irq4) s_r4 = 1;
		if(irq5) s_r5 = 1;
		if(irq6) s_r6 = 1;
		if(irq7) s_r7 = 1;
			
		case(f_t)
			1: s_r1 = 0;
			2: s_r2 = 0;
			3: s_r3 = 0;
			4: s_r4 = 0;
			5: s_r5 = 0;
			6: s_r6 = 0;
			7: s_r7 = 0;
			default:;
		endcase
end

always@(*)begin

		irq = 0;
		
		case(f_t)
			0: irq = 0;
			1: if(irq1)begin
					irq = 3'd1;
				end else
				begin
					if(f_r1) irq = 3'd1;
				end
			2: if(irq2)begin
					irq = 3'd2;
				end else
				begin
					if(f_r2) irq = 3'd2;
				end
			3: if(irq3)begin
					irq = 3'd3;
				end else
				begin
					if(f_r3) irq = 3'd3;
				end
			4: if(irq4)begin
					irq = 3'd4;
				end else
				begin
					if(f_r4) irq = 3'd4;
				end
			5: if(irq5)begin
					irq = 3'd5;
				end else
				begin
					if(f_r5) irq = 3'd5;
				end
			6: if(irq6)begin
					irq = 3'd6;
				end else
				begin
					if(f_r6) irq = 3'd6;
				end
			7: if(irq7)begin
					irq = 3'd7;
				end else
				begin
					if(f_r7) irq = 3'd7;
				end
			default:;
		endcase
end


endmodule

