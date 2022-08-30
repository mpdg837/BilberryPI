	module KERNAL(
       input clk,
       input[11:0] addr,
       output reg[31:0] out
);

wire[31:0] out1;
wire[31:0] out2;
wire[31:0] out3;

ROM1 r1(.clk(clk),
     .addr(addr),
     .out(out1)
);

ROM2 r2(.clk(clk),
     .addr(addr+1024),
     .out(out2)
);

reg[1:0] bufstat;

always@(posedge clk)begin
	bufstat <= addr[10:9];
end

always@(*)begin
	case(bufstat)
		0: out= out1;
		1: out= out1;
		2: out= out2;
		3: out= out2;
	endcase
end

endmodule

module ROM1(
       input clk,
       input[11:0] addr,
       output reg[31:0] out
);

reg[31:0] memory[1023:0];

integer n=0;

initial begin
	$readmemh("./software/bios.hex", memory);
	
end

always@(posedge clk)
	out <= memory[addr[9:0]];
	
endmodule

module ROM2(
       input clk,
       input[7:0] addr,
       output reg[31:0] out
);

reg[31:0] memory[255:0];

initial begin
	$readmemh("./software/charset.hex", memory);
end

always@(posedge clk)
	out <= memory[addr[7:0]];

	
endmodule


