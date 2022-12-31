

module registers(
	input clk,
	input rst,
	
	input save,
	input[1:0] bank,
	
	input[15:0] f_sreg1,
	input[15:0] f_sreg2,
	input[15:0] f_sreg3,
	input[15:0] f_sreg4,
	
	output[15:0] sreg1,
	output[15:0] sreg2,
	output[15:0] sreg3,
	output[15:0] sreg4
);



singleregister r1(.clk(clk),
						.rst(rst),
						.save(save),
						
						.f_reg(f_sreg1),
			
						.s_reg(sreg1)
);

singleregister r2(.clk(clk),
						.rst(rst),
	
						.f_reg(f_sreg2),
						.save(save),
						
						.s_reg(sreg2)
);

register r3(.bank(bank),
		
				.clk(clk),
				.rst(rst),
	
				.f_reg(f_sreg3),
				.save(save),
				
				.s_reg(sreg3)
);

register r4(.bank(bank),
		
				.clk(clk),
				.rst(rst),
	
				.f_reg(f_sreg4),
				.save(save),
				
				.s_reg(sreg4)
);

endmodule




module singleregister(
	input save,
	input clk,
	input rst,
	
	input[15:0] f_reg,
	
	output[15:0] s_reg
);

wire[15:0] s_reg1;


subreg sr1(.clk(clk),
			  .rst(rst),
			  .setBank(1'b0),
			  .bank(0),
			  
			  .save(save),
			  .f_reg(f_reg),

			  .s_reg1(s_reg)
);


endmodule

module register(
	input[1:0] bank,
	
	input save,
	input clk,
	input rst,
	
	input[15:0] f_reg,
	
	output[15:0] s_reg
);

wire[15:0] s_reg1;
wire[15:0] s_reg2;


subreg sr1(.clk(clk),
			  .rst(rst),
			  .setBank(1'b0),
			  .bank(bank[0]),
			  
			  .save(save),
			  .f_reg(f_reg),

			  .s_reg1(s_reg1)
);

subreg sr2(.clk(clk),
			  .rst(rst),
			  .setBank(1'b1),
			  .bank(bank[0]),
	
			  .f_reg(f_reg),
				
			  .save(save),
			  .s_reg1(s_reg2)
);


collectsubreg csr(.bank(bank[1]),
	
						.sreg1(s_reg1),
						.sreg2(s_reg2),
						

						.sreg(s_reg)
);

endmodule

module collectsubreg(
	input bank,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,


	output reg[15:0] sreg
);

always@(*)begin

	
	case(bank)
		0: sreg <= sreg1;
		1: sreg <= sreg2;
	endcase
end

endmodule


module subreg(
	input clk,
	input rst,
	
	input save,
	
	input setBank,
	input bank,
	
	input[15:0] f_reg,
	
	output reg[15:0] s_reg1
);

reg[15:0] f_reg1;


always@(posedge clk or posedge rst)begin
	if(rst) s_reg1 <= 0;
	else s_reg1 <= f_reg1;
end


always@(*)begin
	f_reg1 = s_reg1;
	if(bank == setBank && save) f_reg1 = f_reg;
end


endmodule

module alu(
	input clk,
	input rst,
	
	input[15:0] fromRAM,
	input[15:0] fstack,
	
	input[15:0] fexp,
	input sexp,
	
	input s,
	
	input[15:0] in,
	
	input[1:0] reg1,
	input[1:0] reg2,
	
	input[15:0] data,
	
	input[3:0] mOper,
	
	input[15:0] muldiv,
	
	output[15:0] ssreg1,
	output[15:0] ssreg2,
	output[15:0] ssreg3,
	output[15:0] ssreg4,
	
	input[1:0] bank,
	
	output overflow,
	
	output readIt
);

wire save;
wire block;

wire[15:0] sreg1;
wire[15:0] sreg2;
wire[15:0] sreg3;
wire[15:0] sreg4;
	
wire[15:0] f_sreg1;
wire[15:0] f_sreg2;
wire[15:0] f_sreg3;
wire[15:0] f_sreg4;

wire over;

registers regs(  .bank(0),
					  .clk(clk),
					  .rst(rst),
					  .save(save),
					  
					  .f_sreg1(f_sreg1),
					  .f_sreg2(f_sreg2),
					  .f_sreg3(f_sreg3),
					  .f_sreg4(f_sreg4),
					  
					  .sreg1(sreg1),
					  .sreg2(sreg2),
					  .sreg3(sreg3),
					  .sreg4(sreg4)
);

wire[15:0] num1;
wire[15:0] num2;

selector sel(.ireg1(sreg1),
			.ireg2(sreg2),
			.ireg3(sreg3),
			.ireg4(sreg4),
	
			.reg1(reg1),
			.reg2(reg2),
	
			.num1(num1),
			.num2(num2)
);

wire[15:0] result;

basicALU cmp(

			.in(in),
			
			.fromRAM(fromRAM),
		   .num1(num1),
		   .num2(num2),
		   .muldiv(muldiv),
		  
		  .operation(mOper),
		  
		  .save(save),
		  .arg(data),
	
		  .result(result),
		  
		  .fexp(fexp),
		  .sexp(sexp),
		  
		  .overflow(over),
		  
		  .block(block),
		  
		  .readIt(readIt)

);

saver sav(.result(result),
			 .reg1(reg1),
	
			.ireg1(sreg1),
			.ireg2(sreg2),
			.ireg3(sreg3),
			.ireg4(sreg4),
	
			.oreg1(f_sreg1),
			.oreg2(f_sreg2),
			.oreg3(f_sreg3),
			.oreg4(f_sreg4),
			
			.s(s)
);


assign ssreg1 = sreg1;
assign ssreg2 = sreg2;
assign ssreg3 = sreg3;
assign ssreg4 = sreg4;

assign overflow = over;

endmodule

module saver(
	
	input s,
	input[15:0] result,
	
	input[1:0] reg1,
	
	input[15:0] ireg1,
	input[15:0] ireg2,
	input[15:0] ireg3,
	input[15:0] ireg4,
	
	output reg[15:0] oreg1,
	output reg[15:0] oreg2,
	output reg[15:0] oreg3,
	output reg[15:0] oreg4
);


always@(*)begin
	if(s && reg1 == 0) oreg1 = result;
	else oreg1 = ireg1;
end


always@(*)begin
	if(s && reg1 == 1) oreg2 <= result;
	else oreg2 <= ireg2;
end



always@(*)begin
	if(s && reg1 == 2) oreg3 <= result;
	else oreg3 <= ireg3;
end



always@(*)begin
	
	if(s && reg1 == 3) oreg4 <= result;
	else oreg4 <= ireg4;
	
end


endmodule


module selector(
	input[15:0] ireg1,
	input[15:0] ireg2,
	input[15:0] ireg3,
	input[15:0] ireg4,
	
	input[1:0] reg1,
	input[1:0] reg2,
	
	output reg[15:0] num1,
	output reg[15:0] num2
);

always@(*)begin
	case(reg1) 
		0: num1 = ireg1;
		1: num1 = ireg2;
		2: num1 = ireg3;
		3: num1 = ireg4;
		default:;
	endcase
end

always@(*)begin
	case(reg2) 
		0: num2 = ireg1;
		1: num2 = ireg2;
		2: num2 = ireg3;
		3: num2 = ireg4;
		default:;
	endcase
	
end

endmodule


module basicALU(

	input[15:0] in,
	
	input[15:0] fexp,
	input sexp,
	
	input[15:0] fromRAM,
	input[15:0] muldiv,
	
	input[15:0] num1,
	input[15:0] num2,
	
	input[3:0] operation,
	
	input[15:0] arg,
	
	output reg[15:0] result,
	output reg overflow,
	output reg block,
	
	output reg save,
	
	output reg readIt
);

wire[16:0] addreg;
wire[15:0] subreg;
wire[15:0] andreg;
wire[15:0] orreg;
wire[15:0] xorreg;

wire[15:0] shlreg;
wire[15:0] shrreg;


wire[15:0] decreg;
wire[16:0] increg;
wire[15:0] muldivreg;

wire[15:0] setreg;
wire[15:0] nullreg;
wire[15:0] notreg;

localparam POP = 4'd0;
localparam ADD = 4'd1;
localparam SUB = 4'd2;
localparam AND = 4'd3;
localparam OR  = 4'd4;
localparam RES = 4'd5;

localparam READ = 4'd6;

localparam SHL = 4'd7;
localparam SHR = 4'd8;
localparam XOR = 4'd9;
localparam NOT = 4'd10;
localparam DEC = 4'd11;
localparam INC = 4'd12;
localparam SET = 4'd13;
localparam IN = 4'd14;
localparam MOV = 4'd15;

wire[15:0] num22 = ((arg == 0) ? num2 : arg);
assign addreg = {num1} + num22;
assign subreg = {num1} - num22;
assign andreg = num1 & num22;
assign orreg = num1 | num22;
assign xorreg = num1 ^ num22;
	
assign decreg = {num1} - 1;
assign increg = {num1} + 1;
assign muldivreg = muldiv;

assign nullreg = num1;
assign notreg = ~(num1);
	
assign shlreg = 0;
assign shrreg = 0;

wire overflowadd = (addreg[16]);
wire overflowsub = (num1[15] & ~subreg[15]);
wire overflowinc = (increg[16]);
wire overflowdec = (num1[15] & ~decreg[15]);

always@(*)
	if(sexp) begin
		result <= fexp;
		overflow <= 0; 
		block <= 1;
		save <= 1;
		readIt <=0;
	end else
		case(operation)
	
			ADD: begin
			
					result <= (addreg[15:0]);
					
					overflow <= overflowadd;
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			SUB: begin
					result <= (subreg[15:0]);
					
					overflow <= (overflowsub); 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			AND: begin
					result <= andreg;
					overflow <= 0; 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			OR:  begin
					result <= orreg;
					overflow <= 0; 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			XOR: begin
					result <= xorreg;
					overflow <= 0; 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			NOT: begin
					result <= notreg;
					overflow <= 0; 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			
			SHL: begin
					result <= shlreg;
					overflow <= 0; 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			SHR: begin
					result <= shrreg; 
					overflow <= 0; 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			DEC: begin
					
					result <= decreg[15:0];
					
					overflow <= (overflowdec); 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			INC: begin
			
					result <= increg[15:0];
					
					overflow <= (overflowinc); 
					block <= 0;
					save <= 1;
					readIt <=0;
					end
			RES: begin
					result <= muldivreg;
					overflow <= 0; 
					block <= 1;
					save <= 1;
					readIt <=0;
					end
			SET: begin
					result <= arg;
					overflow <= 0;
					block <= 1;	
					save <= 1;
					readIt <=0;
					end
			READ: begin
					result <= fromRAM;
					overflow <= 0;
					block <= 1;	
					save <= 1;
					readIt <=1;
					end
			IN: begin
					result <= in;
					overflow <= 0; 
					block <= 1;
					save <= 1;
					readIt <=0;
					end
			MOV: begin
					result <= num2;
					overflow <= 0;
					block <= 1;	
					save <= 1;
					readIt <=0;
					end
			default: begin
						result <= nullreg;
						overflow <= 0;
						block <= 1;	
						save <= 0;
						readIt <=0;
						end
		endcase
	
endmodule
