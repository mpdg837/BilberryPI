
module przycisk(
	input in,
	input clk,
	
	output reg sig
);

reg[17:0] lic = 18'b0;
reg[17:0] nlic = 18'b0;
reg snd = 1'b1;
reg nsnd = 1'b1;

reg switch = 1'b1;
reg nswitch = 1'b1;

always@ ( posedge clk )begin
	
	lic <= nlic;

end

always@ ( * )begin
	// Pompka przycisku

	nlic = 8'd0;
	sig = 0;
	
	if(in) begin
		
		if(nlic < 18'd25000) begin
			nlic = lic + 1;
		end
	
		if(nlic == 18'd24000) begin
			
		
			sig = 1; 
			
		end
	
	end else
	begin
		if(nlic > 0) begin
			nlic = lic - 1;
		end
		
		
	end
	
end


endmodule
