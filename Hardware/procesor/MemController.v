module memCont(
	input clk,
	input rst,
	output reg brk,
	
	// Memory
	input[31:0] toCPU,
	
	output reg[14:0] addr,
	output reg[31:0] fromCPU,
	output reg wRAM,
	
	
	input readrdy,
	input saverdy,

	output reg readstart,
	
	// RAM
	
	input[15:0] RAMaddr,
	input[15:0] toRAM,
	input w,
	
	output reg[15:0] fromRAM,
	
	
	// Program
	
	input[14:0] addrPro,
	output reg[24:0] dataProg,
	
	// CPU
	
	output reg work,
	output reg canRead
);
localparam NOP = 5'd0; // O
localparam SET = 5'd1; // O
localparam IN = 5'd2; // O
localparam OUT = 5'd3; // O
localparam INC = 5'd4; // O
localparam JMP = 5'd5; // O
localparam SAVE = 5'd6;
localparam RAM = 5'd7;
localparam TIM = 5'd8;
localparam URAM = 5'd9;
localparam NOT = 5'd10; // O
localparam ADD = 5'd11; // O
localparam SUB = 5'd12; // O
localparam AND = 5'd13; // O
localparam EOR = 5'd14; // O
localparam MOL = 5'd15; // O
localparam MOR = 5'd16; // O
localparam XOR = 5'd17; // O
localparam JEQ = 5'd18; // O
localparam RES = 5'd19; // O
localparam JGT = 5'd20; // O
localparam JLT = 5'd21; // O
localparam DEC = 5'd22; // O
localparam CMP = 5'd23; // O
localparam READ = 5'd24; // O

localparam MOV = 5'd25; // O

localparam POP = 5'd26; // O
localparam PUSH = 5'd27; // O

localparam MUL = 5'd28; // O
localparam DIV = 5'd29; // O
localparam CALL = 5'd30; // O
localparam RET = 5'd31; // O


localparam idle = 4'd0;
localparam getPro = 4'd1;
localparam savPro = 4'd2;
localparam getMem = 4'd3;
localparam savMem = 4'd4;
localparam init = 4'd5;
localparam loadPro = 4'd6;
localparam loadRAM = 4'd7;
localparam saveRAM = 4'd8;
localparam workMe = 4'd9;


reg[3:0] n_stat;
reg[3:0] f_stat;

reg[15:0] n_fromRAM;
reg[24:0] n_dataProg;

reg[31:0] f_saveBlock;
reg[31:0] n_saveBlock;

reg[24:0] bufferProg;
reg[24:0] f_bufferProg;

reg[31:0] bufferMem;
reg[31:0] f_bufferMem;

always@(posedge clk or posedge rst)
	if(rst) f_bufferMem <= 0;
	else f_bufferMem <= bufferMem;
	
always@(posedge clk or posedge rst)
	if(rst) f_bufferProg <= 0;
	else f_bufferProg <= bufferProg;
	
always@(posedge clk or posedge rst)
	if(rst) f_brk <= 0;
	else f_brk <= brk;
	
always@(posedge clk or posedge rst)
	if(rst) n_fromRAM <= 0;
	else n_fromRAM <= fromRAM;


always@(posedge clk or posedge rst)
	if(rst) n_dataProg <= 0;
	else n_dataProg <= dataProg;
	
always@(posedge clk or posedge rst)
	if(rst) f_stat <= 0;	
	else f_stat <= n_stat;

	
always@(posedge clk or posedge rst)
	if(rst) f_saveBlock <= 0;
	else f_saveBlock <= n_saveBlock;

always@(*)begin
	n_stat = f_stat;
	
	case(f_stat)
		idle: n_stat = getPro;
		getPro: n_stat = savPro;
		savPro: if(readrdy) 
						if(toCPU[24:20] == 5'd24 || toCPU[24:20] == 5'd6) n_stat = getMem;
						else n_stat = loadPro;
		getMem: n_stat = savMem;
		savMem: if(readrdy)n_stat = loadPro;

		loadPro: n_stat = workMe;
		workMe: n_stat = loadRAM;
					
		loadRAM: if(dataProg[24:20] == SAVE || dataProg[24:20] == MOL || dataProg[24:20] == MOR) n_stat = saveRAM;
				else  n_stat = idle;

		saveRAM: if(saverdy) n_stat = getPro;
		
		
	endcase
end

reg f_brk;

always@(*)begin
	
	addr = 0;
	fromCPU = 0;
	wRAM = 0;
	
	fromRAM = n_fromRAM;
	dataProg = n_dataProg;

	work = 0;
	
	readstart = 0;
	
	n_saveBlock = f_saveBlock;
	
	bufferProg = f_bufferProg;
	bufferMem = f_bufferMem;
	
	brk = f_brk;
	canRead = 0;
	
	case(f_stat)
		idle: begin
					brk = 1;
					end
		getPro: begin
					brk = 1;
					addr = addrPro;
					readstart = 1;
					end
		savPro: if(readrdy) bufferProg = toCPU[24:0];
		
		getMem: begin
					addr = {RAMaddr[15:1]};
					readstart = 1;
					end
		savMem: if(readrdy) bufferMem = toCPU;

		
		loadPro: begin
					
					brk = 0;
					dataProg = f_bufferProg;
					end
		workMe: begin
				canRead = 1;
				work = 1;
				
				case(RAMaddr[0])
					0: fromRAM = f_bufferMem[15:0];
					1: fromRAM = f_bufferMem[31:16];
						
				endcase
			
			end
		loadRAM: begin
			
			work = 1;
		end
		
		saveRAM: begin
			
			addr = {RAMaddr[15:1]}; 
			wRAM = w;
			case(RAMaddr[0])
				0: fromCPU = {f_bufferMem[31:16],toRAM};
				1: fromCPU = {toRAM,f_bufferMem[15:0]};
			endcase
		end
		default:;
	endcase
end

endmodule
