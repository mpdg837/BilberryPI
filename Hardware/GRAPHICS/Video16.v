module Video16(
	input clk,
	input rst,
	
	output irq,
		
	input[31:0] in,
	input start,

	
	output R,
	output G,
	output B,
	
	output hsync,
	output vsync

	
);


wire[23:0] outG;
wire stG;
connectorGraphics cGA(.clk(clk),
							 .rst(rst),
							 
							 .in(in),
							 .devaddr(2'd2),
	
							 .out(outG),
							 .start(stG)
);

G10k graphics(.clk(clk),
				  .rst(rst),
	
				  .in(outG),
				  .start(stG),
					
				  .irq(irq),
				  
				  .R(R),
				  .G(G),
				  .B(B),
						
				  .hsync(hsync),
				  .vsync(vsync)
	
);

wire[31:0] inx;
wire startx;


tester tes(.clk(clk),

		 .start(startx),
		 .in(inx)
	

);
endmodule

module connectorGraphics(
	input clk,
	input rst,
	
	input[31:0] in,
	input[1:0] devaddr,
	
	output reg[23:0] out,
	output reg start
);


always@(posedge clk)begin
	if(rst)begin
		out <= 0;
		start <= 0;
	end
	else if(in[31:30] == devaddr) begin
		out <= in[23:0];
		start <= 1;
		end
	else begin
		out <= 0;
		start <= 0;
		end
end

endmodule

module tester(
	input clk,

	output reg start,
	output reg[23:0] in
	

);


localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg[7:0] f_t =0;
reg[7:0] t =0;

always@(posedge clk)begin
	f_t <= t;
end

always@(*)begin
	if (t != 250) t = f_t + 1;

	start = 1;
	in = 0;
	
	case(f_t)
		1: in <= {8'd1,16'd0};
		2: in <= {8'd2,16'd0};
		// Palety
		3: in <= {8'd3,16'd0};
		4: in <= {8'd4,6'b0,5'd0,5'd13};
		5: in <= {8'd5,6'b0,5'd18,5'd17};
		
		6: in <= {8'd3,16'd1};
		7: in <= {8'd4,6'b0,5'd0,5'd4};
		8: in <= {8'd5,6'b0,5'd18,5'd19};
		
		9: in <= {8'd3,16'd15};
		10: in <= {8'd4,6'b1,5'd0,5'd13};
		11: in <= {8'd5,6'b0,5'd20,5'd21};
		// tekstura
		
		12: in <= {8'd6,8'b0,8'd1};
		13: in <= {8'd7,8'b0,5'b0,3'd0};
		14: in <= {8'd9,{A,A,A,A,A,A,A,A}};
		15: in <= {8'd8,{A,A,A,A,A,A,A,A}};
		16: in <= {8'd7,8'b0,5'b0,3'd1};
		17: in <= {8'd9,{A,A,B,B,B,A,A,A}};
		18: in <= {8'd8,{A,A,B,B,B,A,A,A}};
		19: in <= {8'd7,8'b0,5'b0,3'd2};
		20: in <= {8'd9,{A,A,B,A,A,B,A,A}};
		21: in <= {8'd8,{A,A,B,A,A,B,A,A}};
		22: in <= {8'd7,8'b0,5'b0,3'd3};
		23: in <= {8'd9,{A,A,B,A,A,B,A,A}};
		24: in <= {8'd8,{A,A,B,A,A,B,A,A}};
		25: in <= {8'd7,8'b0,5'b0,3'd4};
		26: in <= {8'd9,{A,A,B,B,B,A,A,A}};
		27: in <= {8'd8,{A,A,B,B,B,A,A,A}};
		28: in <= {8'd7,8'b0,5'b0,3'd5};
		29: in <= {8'd9,{A,A,B,A,A,B,A,A}};
		30: in <= {8'd8,{A,A,B,A,A,B,A,A}};
		31: in <= {8'd7,8'b0,5'b0,3'd6};
		32: in <= {8'd9,{A,A,B,B,B,A,A,A}};
		33: in <= {8'd8,{A,A,B,B,B,A,A,A}};
		35: in <= {8'd7,8'b0,5'b0,3'd7};
		36: in <= {8'd9,{A,A,A,A,A,A,A,A}};
		37: in <= {8'd8,{A,A,A,A,A,A,A,A}};
		
		// blok
		
		38: in <= {8'd10,16'd50};
		39: in <= {8'd11,16'd50};
		40: in <= {8'd12,16'd1};
		41: in <= {8'd13,16'd1};
		
		// UI
		
		42: in <= {8'd10,16'd40};
		43: in <= {8'd11,16'd40};
		44: in <= {8'd14,16'd1};
		
		// UITEX
		
		45: in <= {8'd15,16'd1};
		46: in <= {8'd16,8'b0,5'b0,3'd0};
		47: in <= {8'd17,{A,A,A,A,A,A,A,A}};
		48: in <= {8'd16,8'b0,5'b0,3'd1};
		49: in <= {8'd17,{A,B,B,B,B,A,A,A}};
		50: in <= {8'd16,8'b0,5'b0,3'd2};
		51: in <= {8'd17,{A,B,A,A,A,B,A,A}};
		52: in <= {8'd16,8'b0,5'b0,3'd3};
		53: in <= {8'd17,{A,B,A,A,A,B,A,A}};
		54: in <= {8'd16,8'b0,5'b0,3'd4};
		55: in <= {8'd17,{A,B,B,B,B,A,A,A}};
		56: in <= {8'd16,8'b0,5'b0,3'd5};
		57: in <= {8'd17,{A,B,A,A,A,B,A,A}};
		58: in <= {8'd16,8'b0,5'b0,3'd6};
		59: in <= {8'd17,{A,B,B,B,B,A,A,A}};
		60: in <= {8'd16,8'b0,5'b0,3'd7};
		61: in <= {8'd17,{A,A,A,A,A,A,A,A}};
		
		// SPRITETEX
		
		62: in <= {8'd18,16'd8};
		63: in <= {8'd19,8'b0,4'b0,4'd0};
		64: in <= {8'd20,{B,B,B,A,A,A,A,A}};  65: in <= {8'd21,{A,A,A,A,A,B,B,B}};
		66: in <= {8'd19,8'b0,4'b0,4'd1};
		67: in <= {8'd20,{B,C,A,A,A,A,A,A}};  68: in <= {8'd21,{A,A,A,A,A,A,C,B}};
		69: in <= {8'd19,8'b0,4'b0,4'd2};
		70: in <= {8'd20,{B,A,A,A,A,A,A,A}};  71: in <= {8'd21,{A,A,A,A,A,A,A,B}};
		72: in <= {8'd19,8'b0,4'b0,4'd3};
		73: in <= {8'd20,{A,A,A,A,A,A,A,A}};  74: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		75: in <= {8'd19,8'b0,4'b0,4'd4};
		76: in <= {8'd20,{A,A,A,A,A,A,A,A}};  77: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		78: in <= {8'd19,8'b0,4'b0,4'd5};
		79: in <= {8'd20,{A,A,A,A,A,A,A,A}};  80: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		81: in <= {8'd19,8'b0,4'b0,4'd6};
		82: in <= {8'd20,{A,A,A,A,A,A,A,A}};  83: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		84: in <= {8'd19,8'b0,4'b0,4'd7};
		85: in <= {8'd20,{A,A,A,A,A,A,A,A}};  86: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		87: in <= {8'd19,8'b0,4'b0,4'd8};
		88: in <= {8'd20,{A,A,A,A,A,A,A,A}};  89: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		90: in <= {8'd19,8'b0,4'b0,4'd9};
		91: in <= {8'd20,{A,A,A,A,A,A,A,A}};  92: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		93: in <= {8'd19,8'b0,4'b0,4'd10};
		94: in <= {8'd20,{A,A,A,A,A,A,A,A}};  95: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		96: in <= {8'd19,8'b0,4'b0,4'd11};
		97: in <= {8'd20,{A,A,A,A,A,A,A,A}};  98: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		99: in <= {8'd19,8'b0,4'b0,4'd12};
		100:in <= {8'd20,{A,A,A,A,A,A,A,A}}; 101: in <= {8'd21,{A,A,A,A,A,A,A,A}};
		102:in <= {8'd19,8'b0,4'b0,4'd13};
		103:in <= {8'd20,{B,A,A,A,A,A,A,A}}; 104: in <= {8'd21,{A,A,A,A,A,A,A,B}};
		105:in <= {8'd19,8'b0,4'b0,4'd14};
		106:in <= {8'd20,{B,C,A,A,A,A,A,A}}; 107: in <= {8'd21,{A,A,A,A,A,A,C,B}};
		108:in <= {8'd19,8'b0,4'b0,4'd15};
		109:in <= {8'd20,{B,B,B,A,A,A,A,A}}; 110: in <= {8'd21,{A,A,A,A,A,B,B,B}};

		111: in <= {8'd22,16'd0};
		112: in <= {8'd23,16'd100};
			
		113: in <= {8'd24,16'd100};
		114: in <= {8'd25,16'd14};
		115: in <= {8'd26,16'd8};
		116: in <= {8'd27,16'b1};
		118: in <= {8'd28,16'b1};
		119: in <= {8'd30,16'd8};
		120: in <= {8'd31,16'd13};
		121: in <= {8'd32,16'd0};
		122: in <= {8'd33,16'd17};
		123: in <= {8'd33,16'd18};
		
		default: begin
			start = 0;
		
		end
	endcase
end

endmodule
