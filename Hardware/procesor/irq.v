
module interCont(
	input clk,
	input rst,
	
	input eirq,
	input[2:0] irq,
	
	output reg irq1,
	output reg irq2,
	output reg irq3
);

localparam LEN = 14;

reg started;
reg f_started;

reg[2:0] f_irqm[LEN-1:0];
reg[2:0] n_irqm[LEN-1:0];

reg[2:0] imem;
integer n = 0;

reg[2:0] f_irq;

always@(posedge clk or posedge rst) begin
	if(rst) f_irq <= 0;
	else f_irq <= irq;
end

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
	
	imem = f_irqm[0];
	irq1 = imem[0];
	irq2 = imem[1];
	irq3 = imem[2];
	
	
	if(eirq)begin
		
		
		n_irqm[0] = f_irqm[1];
		n_irqm[1] = f_irqm[2];
		n_irqm[2] = f_irqm[3];
		n_irqm[3] = f_irqm[4];
		n_irqm[4] = f_irqm[5];
		n_irqm[5] = f_irqm[6];
		n_irqm[6] = f_irqm[7];
		n_irqm[7] = f_irqm[8];
		n_irqm[8] = f_irqm[9];
		n_irqm[9] = f_irqm[10];
		n_irqm[10] = f_irqm[11];
		n_irqm[11] = 0;
		
	
			if(f_irqm[1] == 0) n_irqm[0] = f_irq; 
			else if(f_irqm[2] == 0) n_irqm[1] = f_irq; 
			else if(f_irqm[3] == 0) n_irqm[2] = f_irq; 
			else if(f_irqm[4] == 0) n_irqm[3] = f_irq; 
			else if(f_irqm[5] == 0) n_irqm[4] = f_irq; 
			else if(f_irqm[6] == 0) n_irqm[5] = f_irq; 
			else if(f_irqm[7] == 0) n_irqm[6] = f_irq; 
			else if(f_irqm[8] == 0) n_irqm[7] = f_irq; 
			else if(f_irqm[9] == 0) n_irqm[8] = f_irq; 
			else if(f_irqm[10] == 0) n_irqm[9] = f_irq; 
			else if(f_irqm[11] == 0) n_irqm[10] = f_irq;
			else n_irqm[11] = f_irq;
		
		
	end else
	begin
			if(f_irqm[0] == 0) n_irqm[0] = f_irq; 
			else if(f_irqm[1] == 0) n_irqm[1] = f_irq; 
			else if(f_irqm[2] == 0) n_irqm[2] = f_irq; 
			else if(f_irqm[3] == 0) n_irqm[3] = f_irq; 
			else if(f_irqm[4] == 0) n_irqm[4] = f_irq; 
			else if(f_irqm[5] == 0) n_irqm[5] = f_irq; 
			else if(f_irqm[6] == 0) n_irqm[6] = f_irq; 
			else if(f_irqm[7] == 0) n_irqm[7] = f_irq; 
			else if(f_irqm[8] == 0) n_irqm[8] = f_irq; 
			else if(f_irqm[9] == 0) n_irqm[9] = f_irq; 
			else if(f_irqm[10] == 0) n_irqm[10] = f_irq; 
			else if(f_irqm[11] == 0) n_irqm[11] = f_irq;
		
		
		
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
		
		if(irq1) s_r1 = 1;
		if(irq2) s_r2 = 1;
		if(irq3) s_r3 = 1;
		if(irq4) s_r4 = 1;
		if(irq5) s_r5 = 1;
		if(irq6) s_r6 = 1;
		if(irq7) s_r7 = 1;
			

end

always@(*)begin

		irq = 0;
		
		case(f_t)
			0: irq = 0;
			1: if(f_r1) irq = 3'd1;
			2: if(f_r2) irq = 3'd2;
			3: if(f_r3) irq = 3'd3;
			4: if(f_r4) irq = 3'd4;
			5: if(f_r5) irq = 3'd5;
			6: if(f_r6) irq = 3'd6;
			7: if(f_r7) irq = 3'd7;
			default:;
		endcase
end


endmodule

