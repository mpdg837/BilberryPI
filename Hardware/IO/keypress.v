module keyrst(
	input mode,
	input in,
	
	input clk,
	input rst,
	
	output press,
	output spress,
	output rspress
);

reg[10:0] lic = 0;
reg[10:0] nlic = 0;
reg snd = 1'b1;
reg nsnd = 1'b1;

reg switch = 1'b1;
reg nswitch = 1'b1;

always@ ( posedge clk or posedge rst)begin
	if(rst) begin
		snd <= 0;
		lic <= 0;
		switch <= 0;
	end else
	begin
		snd <= nsnd;
		lic <= nlic;
		switch <= nswitch;
	end
end

always@ ( * )begin
	// Pompka przycisku
	nsnd = snd;
	nlic = 0;
	nswitch = switch;
	
	if(in) begin
		
		if(nlic[10:7] < 4'd7) begin
			nlic = lic + 1;
		end
	
		if(nlic[10:7] > 4'd6) begin
			if( ~snd ) begin
				nswitch = ~switch;
			end
		
			nsnd = 1; 
			
		end
	
	end else
	begin
		if(nlic[10:7] > 0) begin
			nlic = lic - 1;
		end
		
		if(nlic[10:7] < 4'd2) begin
			nsnd = 0;
		end
		
	end
	
	
	if(~mode) begin
		nswitch = nsnd;
	end
end

assign rspress = snd;
assign press = switch;
assign spress = in;

endmodule

module key(
	input mode,
	input in,
	
	input clk,
	input rst,
	
	output press,
	output spress,
	output rspress
);

reg[31:0] lic = 0;
reg[31:0] nlic = 0;
reg snd = 1'b1;
reg nsnd = 1'b1;

reg switch = 1'b1;
reg nswitch = 1'b1;

always@ ( posedge clk )begin
	
	if(rst) begin
		snd <= 0;
		lic <= 0;
		switch <= 0;
	end else
	begin
		snd <= nsnd;
		lic <= nlic;
		switch <= nswitch;
	end
end

always@ ( * )begin
	// Pompka przycisku
	nsnd = snd;
	nlic = 0;
	nswitch = switch;
	
	if(in) begin
		
		if(nlic[31:28] < 4'd15) begin
			nlic = lic + 1;
		end
	
		if(nlic[31:28] > 4'd12) begin
			if( ~snd ) begin
				nswitch = ~switch;
			end
		
			nsnd = 1; 
			
		end
	
	end else
	begin
		if(nlic[31:28] > 0) begin
			nlic = lic - 1;
		end
		
		if(nlic[31:28] < 4'd8) begin
			nsnd = 0;
		end
		
	end
	
	
	if(~mode) begin
		nswitch = nsnd;
	end
end

assign rspress = snd;
assign press = switch;
assign spress = in;

endmodule


