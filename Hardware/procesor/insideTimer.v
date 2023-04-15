
module div_input(
	input clk,
	input rst,
	output reg clkm
);

reg[16:0] f_licz;
reg[16:0] n_licz;
reg clka = 0;

always@(posedge clk or posedge rst)begin
	if(rst) begin
		clka <= 0;
	end 
	else begin
		clka <= clkm;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_licz <= 0;
	end 
	else begin
		f_licz <= n_licz;
	end
end

always@(*)begin
	n_licz = f_licz + 15'b1;
	clkm = 0;
	
	if(f_licz == 75000)begin
		n_licz = 0;
		clkm = 1;
	end
end

endmodule

module timer (
	input clk,
	input clkm,
	input mclk,
	input rst,
	
	output reg[15:0] out
);

reg[15:0] lic = 16'b0;
reg[15:0] nlic = 16'b0;


always@( posedge clkm or posedge rst )begin
	if(rst)begin
		lic <= 16'b0;
	end else
	begin
		lic <= nlic;
	end
end

always@(*) begin
	nlic = lic + 16'b1;
end

always@( posedge clk or posedge rst) begin
	if(rst)begin
		out <= 0;
	end else
	begin
		out <= lic;
	end
end

endmodule
