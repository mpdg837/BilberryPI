module keyboard(
	input clk,
	input rst,
		
	input ps2clk,
	input ps2data,
	
	output irq,
	output[31:0] out
);

wire rdy;
wire[7:0] outK;

Keyde kD(.clk(clk),
			
			.rst(rst),
			
			.ps2_clk(ps2clk),
			.ps2_data(ps2data), 
			
			.out(outK)
);

keyController kC(.clk(clk),
					  .rst(rst),
					  .irq(irq),
					  
					  .in(outK),
					  
						.out(out)
);


endmodule

module keyController(
	input clk,
	input rst,
	
	input[7:0] in,
	
	output reg irq,
	
	output reg[31:0] out
);

reg[31:0] f_out;
reg[7:0] mem;
reg[7:0] f_mem;

reg[3:0] tim;
reg[3:0] f_tim;

always@(posedge clk or posedge rst)
	if(rst) f_mem <= 0;
	else f_mem <= mem;

	
always@(posedge clk or posedge rst)
	if(rst) f_tim <= 0;
	else f_tim <= tim;


	
always@(posedge clk or posedge rst)
	if(rst) f_out <= 0;
	else f_out <= out;

reg decy;

always@(*)begin
	out = f_out;
	irq = 0;
	mem = f_mem;
	
	tim = f_tim;
	
	if(f_tim == 0) begin
		
		if(in != f_mem)begin
					irq = 1;
					out = {8'd2,8'b0,8'b0,in};
					mem = in;
					
				end
		
		
		tim = 15;
	end
	
	if(tim!=0)begin
		tim = f_tim - 1;
	end
end

endmodule

module Keyde (
  input clk,
  input rst,
  
  input ps2_data,
  input ps2_clk,
  
  output reg [7:0] out
);


parameter idle    = 2'b01;
parameter receive = 2'b10;
parameter ready   = 2'b11;


reg [1:0]  state=idle;
reg [15:0] rxtimeout=16'b0000000000000000;
reg [10:0] rxregister=11'b11111111111;
reg [1:0]  datasr=2'b11;
reg [1:0]  clksr=2'b11;
reg [7:0]  rxdata;


reg datafetched;
reg rxactive;
reg dataready;


always @(posedge clk ) 
begin 
  if(datafetched==1)
    out <=rxdata;
end  
  
always @(posedge clk ) 
begin 
	if(rst)begin
			state=idle;
			rxtimeout=16'b0000000000000000;
			rxregister=11'b11111111111;
			datasr=2'b11;
			clksr=2'b11;
			rxdata = 0;
	end else 
	begin
		  rxtimeout<=rxtimeout+1;
		  datasr <= {datasr[0],ps2_data};
		  clksr  <= {clksr[0],ps2_clk};


		  if(clksr==2'b10)
			 rxregister<= {datasr[1],rxregister[10:1]};


		  case (state) 
			 idle: 
			 begin
				rxregister <=11'b11111111111;
				rxactive   <=0;
				dataready  <=0;
				rxtimeout  <=16'b0000000000000000;
				if(datasr[1]==0 && clksr[1]==1)
				begin
				  state<=receive;
				  rxactive<=1;
				end   
			 end
			 
			 receive:
			 begin
				if(rxtimeout==50000)
				  state<=idle;
				else if(rxregister[0]==0)
				begin
				  dataready<=1;
				  rxdata<=rxregister[8:1];
				  state<=ready;
				  datafetched<=1;
				end
			 end
			 
			 ready: 
			 begin
				if(datafetched==1)
				begin
				  state     <=idle;
				  dataready <=0;
				  rxactive  <=0;
				end  
			 end  
		  endcase
	end
end 
endmodule
