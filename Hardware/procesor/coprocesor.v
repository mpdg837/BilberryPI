module coprocesor(
	input clk,
	input rst,
	
	// config
	
	input[1:0] devaddrin,
	input[1:0] devaddrout,
	// to bus
	input[31:0] in,
	output reg[31:0] out,
	
	// to module
	
	input mrdy,
	input nirdy,
	input[23:0] mout,
	
	output reg[23:0] min,
	output reg mstart,
	
	
	output reg irq
	
);

reg[31:0] n_out;
reg n_irq;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		out <= 0;
	end
	else begin
		out <= n_out;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst) irq <= 0;
	else irq <= n_irq;
end

always@(*)begin
	min = 0;
	n_out = out;
	mstart = 0;
	n_irq = 0;
	
	if(in[31:30] == devaddrin) begin
	
		mstart = 1;
		min = in[23:0];
	end 
	
	if(mrdy || nirdy) begin
		//	POST
		n_out = {1'b1 , devaddrout, 5'b0,mout};
		if(mrdy) n_irq = 1;
	end
	
end

endmodule
