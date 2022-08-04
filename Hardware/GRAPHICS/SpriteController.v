module SpriteSaver(
	input clk,
	
	input[9:0] CounterX,
	
	input start,
	input[23:0] command,
	
	output reg[4:0] addrSpriteProp,
	output reg sel,
	input [31:0] fromRAM,
	
	output reg wSpriteProp1,
	output reg[4:0] addrSpritePropSave1,
	output reg[31:0] prop1,
	
	output reg wSpriteProp2,
	output reg [4:0] addrSpritePropSave2,
	output reg [31:0] prop2,
	
	output reg wOut1,
	output reg[8:0] addrOut1,
	output reg[15:0] out1,
	
	output reg wOut2,
	output reg[8:0] addrOut2,
	output reg[15:0] out2,
	
	output rdy
);

reg rdy1;
reg rdy2;

reg[31:0] sreg1;
reg[31:0] f_sreg1;

reg[31:0] sreg2;
reg[31:0] f_sreg2;

reg[4:0] numSprite;
reg[4:0] f_numSprite;

reg[4:0] numtex;
reg[4:0] f_numtex;

reg[3:0] numY1;
reg[3:0] f_numY1;

reg[3:0] numY2;
reg[3:0] f_numY2;

reg[2:0] waitForProp;
reg[2:0] f_waitForProp;

reg[23:0] f_com;
reg[23:0] com;

always@(posedge clk)begin
	f_sreg1 <= sreg1;
	f_sreg2 <= sreg2;
	f_numSprite <= numSprite;
	f_waitForProp <= waitForProp;
	
	f_numtex <= numtex;
	f_numY1 <= numY1;
	f_numY2 <= numY2;
	f_com <= com;
end

always@(*)begin

	wOut1 = 0;
	addrOut1 = 0;
	out1 = 0;
	
	wOut2 = 0;
	addrOut2 = 0;
	out2 = 0;
	
	rdy2 = 0;
	
	numtex = f_numtex;
	
	numY1 = f_numY1;
	numY2 = f_numY2;
	
	if(start)
		case(command[20:16])
			5'd16: begin
				numtex = command[4:0];
				rdy2 = 1;
			end
			5'd17: begin
				numY1 = command[3:0];
				rdy2 = 1;
			end
			5'd18: begin
				wOut1 = 1;
				addrOut1 = {numtex,numY1};
				out1 = command[15:0];
				
				rdy2 = 1;
			end
			5'd19: begin
				numY2 = command[3:0];
				rdy2 = 1;
			end
			5'd20: begin
				wOut2 = 1;
				addrOut2 = {numtex,numY2};
				out2 = command[15:0];
				
				rdy2 = 1;
			end
		endcase
	
	
end

always@(*)begin
	sreg1 = f_sreg1;
	sreg2 = f_sreg2;
	
	numSprite = f_numSprite;
	waitForProp = f_waitForProp;
	
	com = f_com;
	
	addrSpriteProp =0;
	sel = 0;
	
	wSpriteProp1 = 0;
	addrSpritePropSave1 = 0;
	prop1 = 0;
	
	wSpriteProp2 = 0;
	addrSpritePropSave2 = 0;
	prop2 = 0;
	
	rdy1 = 0;
	
	if(start)begin
		// Zapisywanie polecenia
		com = command;
	end
	
	
	if(CounterX[9:6] != 0)begin
		if((f_waitForProp == 0)) begin
		
			case(f_com[20:16])
				5'd21: begin
					// GET SPRITE PROP
					waitForProp = 1;
					numSprite = command[4:0];
					end
				5'd22: begin
					// SET SPRITE POSX
					
					wSpriteProp1 = 1;
					addrSpritePropSave1 = f_numSprite;
					prop1 = {f_com[8:0],sreg1[22:0]};
					sreg1 = {f_com[8:0],sreg1[22:0]};
					 
					rdy1 = 1;
					end
				5'd23: begin
					// SET SPRITE POSY
					
					wSpriteProp1 = 1;
					addrSpritePropSave1 = f_numSprite;
					prop1 = {sreg1[31:23],f_com[7:0],sreg1[14:0]};
					sreg1 = {sreg1[31:23],f_com[7:0],sreg1[14:0]};
					 
					rdy1 = 1;
					end
				5'd24: begin
					// SET SPRITE SCLX
					
					wSpriteProp1 = 1;
					addrSpritePropSave1 = f_numSprite;
					prop1 = {sreg1[31:15],f_com[3:0],sreg1[10:0]};
					sreg1 = {sreg1[31:15],f_com[3:0],sreg1[10:0]};
					 
					rdy1 = 1;
					end
				5'd25: begin
					// SET SPRITE SCLY
					
					wSpriteProp1 = 1;
					addrSpritePropSave1 = f_numSprite;
					prop1 = {sreg1[31:11],f_com[3:0],sreg1[6:0]};
					sreg1 = {sreg1[31:11],f_com[3:0],sreg1[6:0]};
					 
					rdy1 = 1;
					end
				5'd26: begin
					// SET SPRITE ROT
					
					wSpriteProp1 = 1;
					addrSpritePropSave1 = f_numSprite;
					prop1 = {sreg1[31:7],f_com[1:0],sreg1[4:0]};
					sreg1 = {sreg1[31:7],f_com[1:0],sreg1[4:0]};
					 
					rdy1 = 1;
					end
				5'd27: begin
					// SET SPRITE TEX
					
					wSpriteProp2 = 1;
					addrSpritePropSave2 = f_numSprite;
					prop2 = {f_com[5:0],sreg2[25:0]};
					sreg2 = {f_com[5:0],sreg2[25:0]};
					 
					rdy1 = 1;
					
					end
				5'd28: begin
					// SET SPRITE COL2
					
					wSpriteProp2 = 1;
					addrSpritePropSave2 = f_numSprite;
					prop2 = {sreg2[31:21],f_com[4:0],sreg2[15:0]};
					sreg2 = {sreg2[31:21],f_com[4:0],sreg2[15:0]};
					 
					rdy1 = 1;
					
					end
				5'd29: begin
					// SET SPRITE COL3
					
					wSpriteProp2 = 1;
					addrSpritePropSave2 = f_numSprite;
					prop2 = {sreg2[31:16],f_com[4:0],sreg2[10:0]};
					sreg2 = {sreg2[31:16],f_com[4:0],sreg2[10:0]};
					 
					rdy1 = 1;
					
					end
				5'd30: begin
					// SET SPRITE COL4
					
					wSpriteProp2 = 1;
					addrSpritePropSave2 = f_numSprite;
					prop2 = {sreg2[31:11],f_com[4:0],sreg2[5:0]};
					sreg2 = {sreg2[31:11],f_com[4:0],sreg2[5:0]};
					 
					rdy1 = 1;
					
					end
			endcase
			
			// Kasowanie wczytanego polecenia
			com = 0;
			
		end
		
		// Ladowanie danych spritea
		if(f_waitForProp!=0) begin
			case(f_waitForProp)
				1: begin
				
					// Ladowanie 1 lini szczegolow
					addrSpriteProp = {f_numSprite,3'd0};
					sel = 1;
					
					waitForProp = 2;
				end
				2: begin
					// Ladowanie 2 lini szczegolow
					addrSpriteProp = {f_numSprite,3'd1};
					sel = 1;
					
					sreg1 = fromRAM;
					waitForProp = 3;
				end
				3: begin
					// Zakonczenie
					sreg2 = fromRAM;
					waitForProp = 0;
					rdy1 = 1;
				end
			
				default:;
			endcase
		end
	end
end

assign rdy = rdy1 | rdy2;

endmodule
