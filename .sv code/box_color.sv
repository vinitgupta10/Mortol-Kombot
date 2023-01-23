module box_color ( input        [9:0] PosX, PosY, DrawX, DrawY, SizeX, SizeY,
						 input 				  Blank, in_air, crouch, back,
						 input 		  [1:0] rom_out,
						 input		  [9:0] redposx, greenposx, barposy, redsizex, greensizex, barsizey,
						 input		  [2:0] game_mode,
						 input			CLK, Reset, irout, p1_lose, p2_lose, ir2out,
						 output logic [7:0] Red, Green, Blue,
						 output logic box1_on, box2_on,
						 input		  [1:0] txtout,
						 input 		  [9:0] p2_PosX, p2_PosY, p2_SizeX, p2_SizeY,
						 input 		  [1:0] p2_rom_out,
						 input		  [9:0] p2_redposx, p2_greenposx, p2_barposy, p2_redsizex, p2_greensizex, p2_barsizey
						 );
				 
logic red_healthbar_on, green_healthbar_on, p2_red_on, p2_green_on;
logic [9:0] p2_redpx, p2_greenpx;
logic slow_clock, slower_clock, slower_1, slower_2, slower_3, slowest;
assign p2_redpx = p2_redposx + 380;
assign p2_greenpx = p2_greenposx + 380;

always_ff @ (posedge Reset or posedge CLK )
begin
	if (Reset)
		slow_clock <= 1'b0;
	else
		slow_clock <= ~ (slow_clock);
end

always_ff @ (posedge Reset or posedge slow_clock )
begin
	if (Reset)
		slower_clock <= 1'b0;
	else
		slower_clock <= ~ (slower_clock);
end

always_ff @ (posedge Reset or posedge slower_clock )
begin
	if (Reset)
		slower_1 <= 1'b0;
	else
		slower_1 <= ~ (slower_1);
end

always_ff @ (posedge Reset or posedge slower_1 )
begin
	if (Reset)
		slower_2 <= 1'b0;
	else
		slower_2 <= ~ (slower_2);
end
always_ff @ (posedge Reset or posedge slower_2 )
begin
	if (Reset)
		slower_3 <= 1'b0;
	else
		slower_3 <= ~ (slower_3);
end
always_ff @ (posedge Reset or posedge slower_3 )
begin
	if (Reset)
		slowest <= 1'b0;
	else
		slowest <= ~ (slowest);
end

always_comb 
begin
	if (DrawX > redposx && (DrawX - redposx) < (redsizex) && (DrawY - barposy) <= barsizey) 
		red_healthbar_on = 1'b1;
	else
		red_healthbar_on = 1'b0;
	
	if (DrawX > redposx && (DrawX - greenposx) < (greensizex) && (DrawY - barposy) <= barsizey)
		green_healthbar_on = 1'b1;
	else
		green_healthbar_on = 1'b0;

	if (DrawX > p2_redpx && (DrawX - p2_redpx) < (p2_redsizex) && (DrawY - p2_barposy) <= p2_barsizey) 
		p2_red_on = 1'b1;
	else
		p2_red_on = 1'b0;
	
	if (DrawX > p2_redpx && (DrawX - p2_greenpx) < (p2_greensizex) && (DrawY - p2_barposy) <= p2_barsizey)
		p2_green_on = 1'b1;
	else
		p2_green_on = 1'b0;
	
end

always_comb 
begin
if (DrawX > PosX && (DrawX - PosX) < SizeX && (DrawY - PosY) <= SizeY) 
	box1_on = 1'b1;
else
	box1_on = 1'b0;
end	

always_comb 
begin
if (DrawX > p2_PosX && (DrawX - p2_PosX) < p2_SizeX && (DrawY - p2_PosY) <= p2_SizeY) 
	box2_on = 1'b1;
else
	box2_on = 1'b0;
end	

		
always_comb
begin

if (Blank) 
begin
	if (game_mode == 3'b000)
	begin
		if (DrawX > 120 && DrawY >= 140 && DrawX <= 520 && DrawY <= 196 && txtout != 2'b00 && slowest == 1'b1)
		begin
			case(txtout)
				2'b00:
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'hFF;
					end
				2'b01:
					begin
						Red = 8'hCE;
						Green = 8'h6F;
						Blue = 8'h3B;
					end
				2'b10:
					begin
						Red = 8'hE9;
						Green = 8'h9F;
						Blue = 8'h23;
					end
				2'b11:
					begin
						Red = 8'hFD;
						Green = 8'hCD;
						Blue = 8'h03;
					end
				default: ;
			endcase
		end
		else if (DrawX > 155 && DrawY > 300 && DrawX <= 485 && DrawY <= 340 && irout != 1'b1)
		begin
			case(irout)
				1:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				0:
				begin
					Red = 8'hFF;
					Green = 8'hFF;
					Blue = 8'hFF;
				end
				default: ;
			endcase
		end
		else
		begin
			case(back)
				1:
				begin
					Red = 8'hC8;
					Green = 8'h4D;
					Blue = 8'h0C;
				end
				0:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
			endcase
		end
	end
	else
	begin
		if (red_healthbar_on)
			begin
				Red = 8'h00;
				Green = 8'hFF;
				Blue = 8'h00;
			end
		else if (green_healthbar_on)
			begin
				Red = 8'hFF;
				Green = 8'h00;
				Blue = 8'h00;
			end
		else if (p2_red_on)
			begin
				Red = 8'h00;
				Green = 8'hFF;
				Blue = 8'h00;
			end
		else if (p2_green_on)
			begin
				Red = 8'hFF;
				Green = 8'h00;
				Blue = 8'h00;
			end
		else if ((p1_lose || p2_lose) && DrawX > 200 && DrawY > 200 && DrawX <= 420 && DrawY <= 235 && ir2out != 1'b1)
		begin
			case(ir2out)
				1:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				0:
				begin
					Red = 8'hFF;
					Green = 8'hFF;
					Blue = 8'hFF;
				end
				default: ;
			endcase
		end
		else if (((DrawX > 50 && DrawY > 34 && DrawX <= 150 && DrawY <= 48) 
				|| (!p1_lose && p2_lose && DrawX > 185 && DrawY > 200 && DrawX <= 285 && DrawY <= 214))/* && irout != 1'b1*/)
		begin
			case(irout)
				1:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				0:
				begin
					Red = 8'hE9;
					Green = 8'h9F;
					Blue = 8'h23;
				end
				default: ;
			endcase
		end
		else if (((DrawX > 430 && DrawY > 34 && DrawX <= 530 && DrawY <= 48) 
				|| (p1_lose && !p2_lose && DrawX > 185 && DrawY > 200 && DrawX <= 285 && DrawY <= 214))/* && irout != 1'b1*/)
		begin
			case(irout)
				1:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				0:
				begin
					Red = 8'h00;
					Green = 8'hFE;
					Blue = 8'hFE;
				end
				default: ;
			endcase
		end
		else if (box1_on && rom_out != 2'b00)
			case(rom_out)
				2'b00:
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'hFF;
					end
				2'b01:
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'h00;
					end
				2'b10:
					begin
						Red = 8'hA6;
						Green = 8'hA6;
						Blue = 8'h38;
					end
				2'b11:
					begin
						Red = 8'hFF;
						Green = 8'hFF;
						Blue = 8'hFF;
					end
				default: ;
			endcase
	
		else if (box2_on && p2_rom_out != 2'b00)
			case(p2_rom_out)
				2'b00:
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'hFF;
					end
				2'b01:
					begin
						Red = 8'h00;
						Green = 8'h00;
						Blue = 8'h00;
					end
				2'b10:
					begin
						Red = 8'h00;
						Green = 8'hFF;
						Blue = 8'hFF;
					end
				2'b11:
					begin
						Red = 8'hFF;
						Green = 8'hFF;
						Blue = 8'hFF;
					end
				default: ;
			endcase

		else if (DrawY >= 384 && DrawY <= 386)
			begin
				Red = 8'h69;
				Green = 8'h69;
				Blue = 8'h69;
			end
		else if (DrawY > 384)
			begin
				if (DrawX - (DrawY - 384) <= 80 || (DrawX > 540 && (DrawX - 540) >= (DrawY - 384)))
					begin
						Red = 8'h69;
						Green = 8'h69;
						Blue = 8'h69;
					end
				else
					begin
						Red = 8'h80;
						Green = 8'h80;
						Blue = 8'h80;
					end
			end
		else
			case(back)
				1:
				begin
					Red = 8'hC8;
					Green = 8'h4D;
					Blue = 8'h0C;
				end
				0:
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
			endcase
	end
end

else
begin
		Red = 8'h00;
		Green = 8'h00;
		Blue = 8'h00;
end
end

endmodule
