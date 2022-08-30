
module comparer(
	input clk,
	input rst,
	
	input inter,
	
	input start,
	input[1:0] num1,
	input[1:0] num2,
	
	input[15:0] arg,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,
	
	output reg lt,
	output reg gt,
	output reg eq
	
);

reg signed[15:0] snum1;
reg signed[15:0] snum2;

reg signed[15:0] sarg;

reg nnlt;
reg nngt;
reg nneq;

reg nlt;
reg ngt;
reg neq;

reg ilt;
reg igt;
reg ieq;

reg iilt;
reg iigt;
reg iieq;

always@(*)
	sarg <= $signed(arg);

always@(*)
	case(num1)
		0: snum1 = $signed(sreg1);
		1: snum1 = $signed(sreg2);
		2: snum1 = $signed(sreg3);
		3: snum1 = $signed(sreg4);
	endcase
	
always@(*)
	case(num2)
		0: snum2 = $signed(sreg1);
		1: snum2 = $signed(sreg2);
		2: snum2 = $signed(sreg3);
		3: snum2 = $signed(sreg4);
	endcase
	
always@(posedge clk or posedge rst)begin
	if(rst)begin
		
		neq <= 0;
		ieq <= 0;
	end else
	begin
		neq <= nneq;
		ieq <= iieq;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		ngt <= 0;
		igt <= 0;
	end else
	begin
		ngt <= nngt;
		igt <= iigt;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		nlt <= 0;
		ilt <= 0;
		
	end else
	begin
		nlt <= nnlt;
		ilt <= iilt;
	end
end

always@(*)begin
	nngt = ngt;
	iigt = igt;
	
	if(start)
		if(num1 == num2)
			if(snum1 > sarg) 
				if(inter) iigt = 1;
				else nngt = 1;
			else 
				if(inter) iigt = 0;
				else nngt = 0;
		else 
			if(snum1 > snum2) 
				if(inter) iigt = 1;
				else nngt = 1;
			else 
				if(inter) iigt = 0;
				else nngt = 0;
end


always@(*)begin
	nnlt = nlt;
	iilt = ilt;
	
	if(start)
		if(num1 == num2)
			if(snum1 < sarg) 
				if(inter) iilt = 1;
				else nnlt = 1;
			else 
				if(inter) iilt = 0;
				else nnlt = 0;
		else
			if(snum1 < snum2) 
				if(inter) iilt = 1;
				else nnlt = 1;
			else 
				if(inter) iilt = 0;
				else nnlt = 0;
		
end


always@(*)begin

	nneq = neq;
	iieq = ieq;
	
	if(start)
		if(num1 == num2)
			if(snum1 == sarg) 
				if(inter) iieq = 1;
				else nneq = 1;
			else 
				if(inter) iieq = 0;
				else nneq = 0;
		else
			if(snum1 == snum2) 
				if(inter) iieq = 1;
				else nneq = 1;
			else 
				if(inter) iieq = 0;
				else nneq = 0;
	
end
		
always@(*)begin
	lt = inter ? ilt : nlt;
	gt = inter ? igt : ngt;
	eq = inter ? ieq : neq;
end
		
endmodule
