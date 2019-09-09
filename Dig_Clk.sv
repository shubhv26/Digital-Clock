module Dig_Clk (input logic clk,rst,
					 output logic  LEDR,
					 output logic HEX00,HEX01,HEX02,HEX03,HEX04,HEX05,HEX06,
					 output logic HEX10,HEX11,HEX12,HEX13,HEX14,HEX15,HEX16,
					 output logic HEX20,HEX21,HEX22,HEX23,HEX24,HEX25,HEX26,HEX27,
					 output logic HEX30,HEX31,HEX32,HEX33,HEX34,HEX35,HEX36,
					 output logic HEX40,HEX41,HEX42,HEX43,HEX44,HEX45,HEX46,HEX47,
					 output logic HEX50,HEX51,HEX52,HEX53,HEX54,HEX55,HEX56);


reg [4:0] sec1,sec2;  // sec1 is unit place and sec2 is tenth place: eg 60 secs
reg [4:0] min1,min2;
reg [4:0] hr1,hr2;
reg [6:0] count0,count1,count3,count5;
reg [7:0] count2,count4;

reg [26:0] cycle; // for 1 sec counter : fpga clock= 50Mhz
assign LEDR=rst;					 

always_ff@(posedge clk)
begin	
if(!rst)begin      // RESET STATE : ALL '0'
	cycle<=27'b0;
	sec1<=4'b0;
	sec2<=4'b0;
	min1<=4'b0;
	min2<=4'b0;
	 hr1<=4'b0;
	 hr2<=4'b0;end
	
else if(cycle==27'd50000000)
begin
	cycle<=0;
 if(hr2<2)
	begin
	if(hr1<9)
		begin
		if(min2<5)
			begin
			if(min1<9)
				begin
					if(sec2<5)
						begin
						if(sec1<9)
							sec1<=sec1+1;
						else begin
							sec1<=0;
							if(sec2<5)
								sec2<=sec2+1;
								end
						 end
		
					else if(sec2==5)       // counter from 50-59 secs
					begin
						if(sec1<9)
							sec1<=sec1+1;
						else begin
							sec1<=0;
							sec2<=0;
							min1<=min1+1;end
					end	
				end
			else begin// else of min1
				min1<=0;
				min2<=min2+1;end
			end // end of min2	
		else if(min2==5)
			begin
				if(min1<9)
					min1<=min1+1;
				else begin
						min2<=0;
						min1<=0;
						hr1<=hr1+1;end
			 end
		 end //end of hr1 if
	else begin
		hr1<=0;
		hr2<=hr2+1;end

  end // end of hr2 if
 else if(hr2==2)
 begin
	if(hr1<4)
		hr1<=hr1+1;
	else begin
		hr1<=0;
		hr2<=0;end
 end
 
end
else
	cycle<=cycle+1;

end


always@(*)
begin
case(sec1) //COMMON ANODE
4'b0000 :  count0 = 7'b0000001; 
4'b0001 :  count0 = 7'b1001111; 
4'b0010 :  count0 = 7'b0010010; //2
4'b0011 :  count0 = 7'b0000110; //3
4'b0100 :  count0 = 7'b1001100; //4
4'b0101 :  count0 = 7'b0100100; //5  
4'b0110 :  count0 = 7'b0100000; //6
4'b0111 :  count0 = 7'b0001111; //7
4'b1000 :  count0 = 7'b0000000; //8
4'b1001 :  count0 = 7'b0000100; //9
default :  count0 = 7'b0000001 ; //0
endcase

case(sec2)
4'b0000 :  count1 = 7'b0000001; 
4'b0001 :  count1 = 7'b1001111; 
4'b0010 :  count1 = 7'b0010010; //2
4'b0011 :  count1 = 7'b0000110; //3
4'b0100 :  count1 = 7'b1001100; //4
4'b0101 :  count1 = 7'b0100100; //5  
4'b0110 :  count1 = 7'b0100000; //6
4'b0111 :  count1 = 7'b0001111; //7
4'b1000 :  count1 = 7'b0000000; //8
4'b1001 :  count1 = 7'b0000100; //9
default :  count1 = 7'b0000001 ; //0
endcase

case(min1) //include decimal point: eg 2.60--> 2 mins 60 secs...LSB--> DP value low
4'b0000 :  count2 = 8'b00000010; //0.
4'b0001 :  count2 = 8'b10011110; //1.
4'b0010 :  count2 = 8'b00100100; //2.
4'b0011 :  count2 = 8'b00001100; //3.
4'b0100 :  count2 = 8'b10011000; //4.
4'b0101 :  count2 = 8'b01001000; //5. 
4'b0110 :  count2 = 8'b01000000; //6.
4'b0111 :  count2 = 8'b00011110; //7.
4'b1000 :  count2 = 8'b00000000; //8.
4'b1001 :  count2 = 8'b00001000; //9.
default :  count2 = 8'b00000010; //0.
endcase

case(min2)
4'b0000 :  count3 = 7'b0000001; 
4'b0001 :  count3 = 7'b1001111; 
4'b0010 :  count3 = 7'b0010010; //2
4'b0011 :  count3 = 7'b0000110; //3
4'b0100 :  count3 = 7'b1001100; //4
4'b0101 :  count3 = 7'b0100100; //5  
4'b0110 :  count3 = 7'b0100000; //6
4'b0111 :  count3 = 7'b0001111; //7
4'b1000 :  count3 = 7'b0000000; //8
4'b1001 :  count3 = 7'b0000100; //9
default :  count3 = 7'b0000001 ; //0
endcase

case(hr1) //include decimal point
4'b0000 :  count4 = 8'b00000010; //0.
4'b0001 :  count4 = 8'b10011110; //1.
4'b0010 :  count4 = 8'b00100100; //2.
4'b0011 :  count4 = 8'b00001100; //3.
4'b0100 :  count4 = 8'b10011000; //4.
4'b0101 :  count4 = 8'b01001000; //5. 
4'b0110 :  count4 = 8'b01000000; //6.
4'b0111 :  count4 = 8'b00011110; //7.
4'b1000 :  count4 = 8'b00000000; //8.
4'b1001 :  count4 = 8'b00001000; //9.
default :  count4 = 8'b00000010; //0.
endcase

case(hr2)
4'b0000 :  count5 = 7'b0000001; 
4'b0001 :  count5 = 7'b1001111; 
4'b0010 :  count5 = 7'b0010010; //2
4'b0011 :  count5 = 7'b0000110; //3
4'b0100 :  count5 = 7'b1001100; //4
4'b0101 :  count5 = 7'b0100100; //5  
4'b0110 :  count5 = 7'b0100000; //6
4'b0111 :  count5 = 7'b0001111; //7
4'b1000 :  count5 = 7'b0000000; //8
4'b1001 :  count5 = 7'b0000100; //9
default :  count5 = 7'b0000001 ; //0
endcase
end

assign HEX00 = count0[6]; //C14     HEX0 MEANS FIRST DISPLAY, 
assign HEX01 = count0[5]; //E15    AND HEX00 MEANS ZERO-TH PIN OF FIRST DISPLAY (BELOW)
assign HEX02 = count0[4]; //C15                 0
assign HEX03 = count0[3];//C16                  __
assign HEX04 = count0[2];//E16                5|6 |1
assign HEX05 = count0[1];//D17                  --
assign HEX06 = count0[0];//C17                4|  |2
                         //                     -- 
assign HEX10 = count1[6]; //C18                 3
assign HEX11 = count1[5]; //D18
assign HEX12 = count1[4]; //E18
assign HEX13 = count1[3];// B16
assign HEX14 = count1[2];//A17
assign HEX15 = count1[1];//A18
assign HEX16 = count1[0];//B17

assign HEX20 = count2[7]; //B20               
assign HEX21 = count2[6]; //A20
assign HEX22 = count2[5]; //B19
assign HEX23 = count2[4];// A21
assign HEX24 = count2[3];// B21
assign HEX25 = count2[2];// C22
assign HEX26 = count2[1];// B22
assign HEX27 = count2[0];// A19

assign HEX30 = count3[6]; //F21                 
assign HEX31 = count3[5]; //E22
assign HEX32 = count3[4]; //E21
assign HEX33 = count3[3];// C19
assign HEX34 = count3[2];// C20
assign HEX35 = count3[1];// D19
assign HEX36 = count3[0];// E17

assign HEX40 = count4[7]; //F18               
assign HEX41 = count4[6]; //E20
assign HEX42 = count4[5]; //E19
assign HEX43 = count4[4];// J18
assign HEX44 = count4[3];// H19
assign HEX45 = count4[2];// F19
assign HEX46 = count4[1];// F20
assign HEX47 = count4[0];// F17

assign HEX50 = count5[6]; //J20                 
assign HEX51 = count5[5]; //K20
assign HEX52 = count5[4]; //L18
assign HEX53 = count5[3];// N18
assign HEX54 = count5[2];// M20
assign HEX55 = count5[1];// N19
assign HEX56 = count5[0];// N20
endmodule
