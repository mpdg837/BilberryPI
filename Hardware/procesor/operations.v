module controller(
	
	input clk,
	input rst,
	
	input work,
	input brk,
	
	input[4:0] exe,
	input[1:0] ereg1,
	input[1:0] ereg2,
	input[15:0] edata,
	
	output reg hlt,
	
	output reg[15:0] cmprarg,
	
	output reg[1:0] areg1,
	output reg[1:0] areg2,
	
	output reg[15:0] dataALU,
	
	output reg[3:0] mOperALU,
	
	output reg sALU,
	
	
	output reg[1:0] regOut,
	output reg outA,
	output reg outB,
	
	output reg sOUT,
	
	
	output reg sCOU,
	
	output reg[1:0] creg1,
	output reg[1:0] creg2,
	
	output reg[3:0] mOperCOU,
	output reg[14:0] dataAddr,
	
	
	output reg sMUL,
	output reg[1:0] mOperMUL,

	output reg[1:0] mreg1,
	output reg[1:0] mreg2,
	
	

	output reg sSTA,
	output reg pop,
	output reg push,

	output reg[1:0] streg1,
	
	
	output reg[15:0] RAMdata,
	output reg[1:0] mOperRAM,
	output reg[1:0] regRAM,
	output reg[1:0] regRAM2,
	output reg sRAM,
	
	output reg inselin,
	
	
	output reg rstTim,
	output reg saveTim,
	
	output status,
	
	output reg mulmode,
	output reg aeq,
	
	output reg prst,
	
	output reg[1:0] cmprNum1,
	output reg[1:0] cmprNum2,
	
	
	output reg cmprStart,
	
	output reg sBank,
	output reg[1:0] sAddrBank,
	
	output reg save,
	output reg read,
	
	output reg[3:0] stackArg
);

reg n_sBank;

reg[15:0] n_cmprarg;

reg[1:0] n_sAddrBank;

reg[1:0] n_areg1;
reg[1:0] n_areg2;
	
reg[15:0] n_dataALU;
	
reg[3:0] n_mOperALU;
	
reg n_sALU;
	
	
reg[1:0] n_regOut;
reg n_outA;
reg n_outB;
	
reg n_sCOU;
	
reg[1:0] n_creg1;
reg[1:0] n_creg2;
	
reg n_sOUT;

reg[3:0] n_mOperCOU;
reg[14:0] n_dataAddr;
reg[14:0] n_addr;

reg f_sel;
reg n_sel;

reg n_sMUL;
reg[1:0] n_mOperMUL;

reg[1:0] n_mreg1;
reg[1:0] n_mreg2;


reg n_sSTA;
reg n_pop;
reg n_push;

reg[1:0] n_streg1;

reg[15:0] n_RAMdata;
reg[1:0] n_mOperRAM;
reg[1:0] n_regRAM;
reg[1:0] n_regRAM2;
reg n_sRAM;

reg f_hlt;

reg n_rstTim;
reg n_saveTim;
	
reg n_inselin;
	
reg n_mulmode;

reg n_aeq;

reg[1:0] n_cmprNum1;
reg[1:0] n_cmprNum2;

reg n_save;
reg n_read;

reg[3:0] n_stackArg;

reg n_cmprStart;
// Rozkazy procesora
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

always@(posedge clk or posedge rst)begin
	if(rst) begin
		areg1 <= 0;
		areg2 <= 0;
		dataALU <= 0;
		mOperALU <= 0;
		sALU <= 0;
		
		regOut <= 0;
		outA <= 0;
		outB <= 0;
		sCOU <= 0;
		
		creg1 <= 0;
		creg2 <= 0;
		
		mOperCOU <= 0;
		dataAddr <= 0;
	
		
		sOUT <= 0;
		
		f_sel <= 0;
		
		sMUL <= 0;
		mOperMUL <= 0;

		mreg1 <= 0;
		mreg2 <= 0;
		
		sSTA <=0;
		pop <=0;
		push<=0;

		streg1<=0;
		
		RAMdata <= 0;
		mOperRAM <= 0;
		regRAM <= 0;
		regRAM2 <= 0;
		sRAM <= 0;
		
		inselin <= 0;
		
		rstTim <= 0;
		saveTim <= 0;
		
		hlt <= 0;
		mulmode <= 0;
		aeq <= 0;
		
		cmprNum1 <= 0;
		cmprNum2 <= 0;
		
		cmprStart <= 0;
		
		sAddrBank <= 0;
		sBank <= 0;
		
		cmprarg <= 0;
		
		stackArg <= 0;
	end else
	begin
	
		stackArg <= n_stackArg;
		
		areg1 <= n_areg1;
		areg2 <= n_areg2;
		dataALU <= n_dataALU;
		mOperALU <= n_mOperALU;
		sALU <= n_sALU;
		
		regOut <= n_regOut;
		outA <= n_outA;
		outB <= n_outB;
		sCOU <= n_sCOU;
		
		creg1 <= n_creg1;
		creg2 <= n_creg2;
		
		mOperCOU <= n_mOperCOU;
		dataAddr <= n_dataAddr;

		
		sOUT <= n_sOUT;
		
		
		sMUL <= n_sMUL;
		mOperMUL <= n_mOperMUL;

		mreg1 <= n_mreg1;
		mreg2 <= n_mreg2;
		
		
		f_sel <= n_sel;
		
		sSTA <= n_sSTA;
		pop <= n_pop;
		push <= n_push;

		streg1 <= n_streg1;
		
		RAMdata <= n_RAMdata;
		mOperRAM <= n_mOperRAM;
		regRAM <= n_regRAM;
		regRAM2 <= n_regRAM2;
		sRAM <= n_sRAM;
		
		inselin <= n_inselin;
		
		rstTim <= n_rstTim;
		saveTim <= n_saveTim;
		
		hlt = f_hlt;
		
		mulmode <= n_mulmode;
		aeq <= n_aeq;
		
		cmprNum1 <= n_cmprNum1;
		cmprNum2 <= n_cmprNum2;
		
		cmprStart <= n_cmprStart;
		
		sAddrBank <= n_sAddrBank;
		sBank <= n_sBank;
		
		save <= n_save;
		read <= n_read;
		
		cmprarg <= n_cmprarg;
	end
end

always@(*)begin
		n_cmprarg = cmprarg;
		
		n_stackArg = 0;
		
		n_areg1 = areg1;
		n_areg2 = areg2;
		n_dataALU = dataALU;
		n_mOperALU =0;
		n_sALU = 0;
		
		n_regOut = 0;
		n_outA = outA;
		n_outB = outB;
		
		n_sOUT = 0;
		
		n_aeq = aeq;
		
		n_creg1 = creg1;
		n_creg2 = creg2;
		
		n_mOperCOU = 0;
		n_dataAddr = dataAddr;

		
		n_sCOU = 0;
		
		
		n_sMUL = 0;
		n_mOperMUL = 0;

		n_mreg1 = mreg1;
		n_mreg2 = mreg2;
		
		n_sSTA = 0;
		n_pop = 0;
		n_push = 0;

		n_streg1 = streg1;
		
		n_RAMdata = RAMdata;
		n_mOperRAM = 0;
		n_regRAM = regRAM;
		n_regRAM2 = regRAM2;
		n_sRAM = 0;
		
		n_inselin = 0;
		
		n_rstTim = 0;
		n_saveTim = 0;
		
		n_mulmode = 0;
		
		f_hlt = hlt;
		
		prst = 0;
		
		n_cmprStart = 0;
		n_cmprNum1 = 0;
		n_cmprNum2 = 0;
		
		n_sAddrBank = 0;
		n_sBank = 0;
		
		n_save = 0;
		n_read = 0;
		if(~brk)
			if(work) begin
			
			f_hlt = 0;
			
			case(exe)
				NOP:begin
						// Next
						
						n_mOperCOU = 4'd6;
						n_dataAddr = 0;
						
						case(ereg1)
							
							2'b10: f_hlt = 1;
							2'b01: prst = 1;
							2'b11: begin
										n_sAddrBank = {edata[1],edata[0]};
										n_sBank = 1;
									end
							default:;
						endcase
						
						n_creg1 = 0;
						n_creg2 = 0;
						
						n_sCOU = 1;
					end
				SET: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd13;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
					
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				IN: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd14;
					n_sALU = 1;
					
					if(edata == 0) n_inselin = 0;
					else n_inselin = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				OUT: begin
					n_regOut = ereg1;
					n_outA = 0;
					n_outB = 0;
					
					if(edata == 0) n_outA = 1;
					else n_outB = 1;
					
					n_sOUT = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				
				INC: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd12;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				DEC: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd11;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
					
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				JMP: begin
					
					n_mOperCOU = 4'd5;
					n_dataAddr = edata;
					
					n_creg1 = ereg1;
					n_creg2 = ereg2;
					
					
					n_sCOU = 1;
				end
				NOT: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd10;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				ADD: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd1;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
					
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				SUB: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd2;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
					
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				AND: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd3;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
					n_addr = 0;
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				EOR: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd4;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
			
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				MUL:begin
					n_sMUL = 2'd1;
					n_mOperMUL = 2'd1;

					n_mreg1 = ereg1;
					n_mreg2 = ereg2;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
			
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				
					n_mulmode = edata[0];
				end
			
				DIV:begin
					n_sMUL = 2'd1;
					n_mOperMUL = 2'd2;

					n_mreg1 = ereg1;
					n_mreg2 = ereg2;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
			
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					
					n_mulmode = edata[0];
					
				end
				RES:begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd5;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					
				
					end
				MOL: begin
					n_sMUL = 2'd1;
					n_mOperMUL = 2'd0;

					n_mreg1 = ereg1;
					n_mreg2 = ereg2;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
			
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				
					n_mulmode = edata[0];
				end
				MOR: begin
					n_sMUL = 2'd1;
					n_mOperMUL = 2'd3;

					n_mreg1 = ereg1;
					n_mreg2 = ereg2;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
			
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				
					n_mulmode = edata[0];
				end
				
				XOR: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = edata;
					n_mOperALU = 4'd9;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				JEQ: begin
				
					n_mOperCOU = 4'd1;
					n_dataAddr = edata;
		
					n_aeq = ereg1[1];
		
					n_creg1 = ereg1;
					n_creg2 = ereg2;
					
					n_aeq = 0;
					n_sCOU = 1;
				end
				JGT: begin
				
					n_mOperCOU = 4'd2;
					n_dataAddr = edata;
		
					
					n_creg1 = ereg1;
					n_creg2 = ereg2;
					
					n_aeq = ereg1[1];
					n_sCOU = 1;
				end
				JLT: begin
				
					n_mOperCOU = 4'd3;
					n_dataAddr = edata;
		
					
					n_creg1 = ereg1;
					n_creg2 = ereg2;
					
					n_aeq = ereg1[1];
					
					n_sCOU = 1;
				end
				CMP: begin
					n_cmprarg = edata;
					
					n_cmprNum1 = ereg1;
					n_cmprNum2 = ereg2;
					
					n_cmprStart = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
				CALL: begin
				
					n_mOperCOU = 4'd7;
					n_dataAddr = edata;
		
					n_aeq = ereg1[1];
					
					n_creg1 = ereg1;
					n_creg2 = ereg2;
					
					n_sCOU = 1;
				end
				RET: begin
				
					n_mOperCOU = 4'd8;
					n_dataAddr = edata;
		
					n_aeq = ereg1[1];
					
					n_creg1 = ereg1;
					n_creg2 = ereg2;
					
					n_sCOU = 1;
				end
				
				READ: begin
					n_read = 0;
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = 0;
					n_mOperALU = 4'd6;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					end
				MOV: begin
					n_areg1 = ereg1;
					n_areg2 = ereg2;
					n_dataALU = 0;
					n_mOperALU = 4'd15;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					end
				default:;
				PUSH:begin
					n_sSTA = 1;
					n_pop = 0;
					n_push = 1;

					n_streg1 = {ereg2,ereg1};
					
					n_stackArg = {ereg2,ereg1};
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					end
				POP:begin
				
					n_stackArg = {ereg2,ereg1};
				
					n_sSTA = 1;
					n_pop = 1;
					n_push = 0;

					n_streg1 = {ereg2,ereg1};
					
					// ALU
					
					n_areg1 = ereg1;
					n_areg2 = 0;
					n_dataALU = 0;
					n_mOperALU = 4'd0;
					n_sALU = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					
					end
				RAM:begin
					n_RAMdata = edata[15:0];
					n_mOperRAM = 1;
					n_regRAM = ereg1;
					n_regRAM2 = ereg2;
					n_sRAM = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					
					end
				URAM:begin
					n_RAMdata = edata[15:0];
					n_mOperRAM = 2;
					n_regRAM = ereg1;
					n_regRAM2 = ereg2;
					n_sRAM = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					
					end
				SAVE:begin
					
					n_save = 1;
					n_RAMdata = edata[15:0];
					n_mOperRAM = 3;
					n_regRAM = ereg1;
					n_sRAM = 1;
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
					end
				TIM: begin
					if(edata == 1) begin
						n_rstTim = 1;
						n_saveTim = 0;
					end else
					begin
					
						n_areg1 = ereg1;
						n_areg2 = ereg2;
						n_dataALU = edata;
						n_sALU = 1;
					
						n_rstTim = 0;
						n_saveTim = 1;
						
						
					end
					
					// Next
					
					n_mOperCOU = 4'd6;
					n_dataAddr = 0;
				
					
					n_creg1 = 0;
					n_creg2 = 0;
					
					n_sCOU = 1;
				end
			endcase
	end
end

assign status = n_sel;

endmodule
