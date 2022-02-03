`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:32 01/18/2022 
// Design Name: 
// Module Name:    tiktakgame 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tiktakgame(
input [1:0]a,b,c,d,
input clk,resetn,player1,player2,
output reg p1,p2,ilg1,ilg2,nospace
    );

reg [1:0]block[0:2][0:2];
reg [1:0]cur_s,nex_s;
parameter idle = 2'b00,play1 = 2'b01,play2 = 2'b10,gameover = 2'b11;
reg [1:0]i,j;
reg [3:0]countreg,countnex;

always @(posedge clk) 
begin : initialization
if(~resetn)
begin
cur_s <= idle;
countreg <= 4'b0000; 
end
else
begin
cur_s <= nex_s;
countreg <= countnex;
end
end

always @(cur_s,a,b,c,d,player1,player2)
begin : FSM
p1 = 0;
p2 = 0;
ilg1 = 0;
ilg2 = 0;
countnex = countreg;
//nex_s = cur_s;
case(cur_s)
idle:begin
	for(i = 0;i<3;i=i+1)
	begin
		for(j = 0;j<3;j=j+1)
			block[i][j] = 2'b00;
	end
	nex_s = play1;
	end
play1:begin
	if(player1)
	begin
		if(block[a][b] == 2'b00)
		begin
			block[a][b] = 2'b01;
			countnex = countreg + 4'b0001;
			nex_s = play2;
		end
		else if(block[a][b] == 2'b10 || block[a][b] == 2'b01)
		begin
			nex_s = idle;
			ilg1 = 1;
		end
	end
	else if(countreg == 4'h8)
		begin
			nex_s = gameover; 
		end
	else if({block[0][0],block[1][0],block[2][0]} == 6'b010101 || 
		{block[0][0],block[0][1],block[0][2]} == 6'b010101 || 
		{block[0][1],block[1][1],block[2][1]} == 6'b010101 || 
		{block[0][2],block[1][2],block[2][0]} == 6'b010101  ||
		{block[1][0],block[1][1],block[1][2]} == 6'b010101  ||
		{block[2][0],block[2][1],block[2][2]} == 6'b010101  ||
		{block[0][2],block[1][1],block[2][0]} == 6'b010101  ||
		{block[0][0],block[1][1],block[2][0]} == 6'b010101 )
		begin
			p1 = 1;
			nex_s = idle;
		end
	else
		nex_s = play1;
		end
play2:begin
	if(player2)
	begin
			if(block[c][d] == 2'b00)
			begin
			block[c][d] = 2'b10;
			nex_s = play1;
			countnex = countreg + 4'b0001;
			end
		else if(block[c][d] == 2'b10 || block[c][d] == 2'b01)
		begin
			nex_s = idle;
			ilg2 = 1;
		end
	end
		else if({block[0][0],block[1][0],block[2][0]} == 6'b101010 || 
		{block[0][0],block[0][1],block[0][2]} == 6'b101010 || 
		{block[0][1],block[1][1],block[2][1]} == 6'b101010|| 
		{block[0][2],block[1][2],block[2][0]} == 6'b101010  ||
		{block[1][0],block[1][1],block[1][2]} == 6'b101010  ||
		{block[2][0],block[2][1],block[2][2]} == 6'b101010  ||
		{block[0][2],block[1][1],block[2][0]} == 6'b101010  ||
		{block[0][0],block[1][1],block[2][0]} == 6'b101010 )
		begin
			p2 = 1;
			nex_s = idle;
		end
		else if(countreg == 4'h8)
		begin
			nex_s = gameover;
		end
		else
			nex_s = play2;
		end
gameover:begin
			nospace = 1; 
			end
endcase
end



endmodule
