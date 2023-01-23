module box ( input Reset, frame_clk, pno,
					output [2:0] run_state,
					input [31:0] keycodes,
               output [9:0]  PosX, PosY, SizeX, SizeY,
					output logic in_air, crouch, move_right, move_left, dir, kick, punch, 
					input hit, p_lose,
					input [8:0] count,
					input [2:0] game_mode,
					input [9:0] other_PosX, other_PosY, other_SizeX, other_SizeY, other_dir,
					input p2_in_air, p2_punch, p2_kick, p2_crouch,
					input [2:0] p2_run_state,
					output p2_hit);

logic [7:0] keycode;

logic [9:0] curX, curY, disy, x_motion, y_motion;
//enum logic [2:0] {t1,t2,t3,t4} State, Next_state ;
logic maxh, ground, jump, tmp_reset;
logic [9:0] tmp_sizex;
//logic [5:0] ti_me;
//logic [2:0] run_state;
//assign SizeX = 64;
//assign SizeY = 128;
logic knockback;
run r1(.Reset(Reset), .frame_clk(frame_clk), .move_right(move_right), .move_left(move_left), 
		 .keycode(keycode), .run_state(run_state));

key_code assi(.*);
		 
always_comb// @ (posedge Reset or posedge frame_clk)
begin

	if (p_lose)
		tmp_sizex <= 128;

	else if ((run_state == 3'b011 || run_state == 3'b100 || kick || punch) && !in_air)
		tmp_sizex <= 104;

	else
		tmp_sizex <= 64;
end
		 
always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
		  if (Reset)
        begin
				if (pno == 1'b0)
				begin
					x_motion <= 10'd0;
					y_motion <= 10'd0;
					curX <= 50;
					curY <= 291;
					jump <= 1'b0;
					maxh <= 1'b0;
					ground <= 1'b1;
					in_air <= 1'b0;
					crouch <= 1'b0;
					move_right <= 1'b0;
					move_left <= 1'b0;
					dir <= 1'b0;
					SizeX <= 64;
					punch <= 1'b0;
					SizeY <= 128;
					p2_hit <= 1'b0;
					knockback <= 1'b0;
				end
				else
				begin
					x_motion <= 10'd0;
					y_motion <= 10'd0;
					curX <= 555;
					curY <= 291;
					jump <= 1'b0;
					maxh <= 1'b0;
					ground <= 1'b1;
					in_air <= 1'b0;
					crouch <= 1'b0;
					move_right <= 1'b0;
					move_left <= 1'b0;
					dir <= 1'b1;
					SizeX <= 64;
					punch <= 1'b0;
					SizeY <= 128;
					p2_hit <= 1'b0;
					knockback <= 1'b0;
				end
        end
		  
		  else if (tmp_reset) 
		  begin 
            x_motion <= 10'd0;
				y_motion <= 10'd0;
				curX <= 50;
				curY <= 291;
				jump <= 1'b0;
				maxh <= 1'b0;
				ground <= 1'b1;
				in_air <= 1'b0;
				crouch <= 1'b0;
				punch <= 1'b0;
				tmp_reset <= 1'b0; // ?
				SizeX <= 64;
        end
		  else if (keycodes[7:0] == 8'h15)
				tmp_reset = 1'b0;
		  else
		  if ((game_mode == 3'b001 || game_mode == 3'b010))
		  begin
				SizeX <= tmp_sizex;
				if (!p_lose)
				begin
					if (hit)
						knockback <= 1'b1;
					p2_hit <= 1'b0;
					if (curY <= 103)
							maxh <= 1'b1;
					case (keycode)
						8'h1A : 		// W		26
						begin
							y_motion <= -5;
							in_air <= 1'b1;
							jump <= 1'b1;
						end
						
						8'h16 :		// S		22
						begin
	//						if (!jump)
							crouch <= 1'b1;
						end
						
						8'h07 :		// D		07
						begin
							if ((curX + 3 < 550 && curX >= other_PosX + other_SizeX) 
							|| (curX + 3 < 550 && curX + SizeX < other_PosX && curX + 3 + SizeX < other_PosX) 
							|| (curX + 3 < 550 && in_air))
							begin
								x_motion <= 3;
								move_right <= 1'b1;
								move_left <= 1'b0;
								dir <= 1'b0;
							end
						end
						
						8'h04 :		// A		04
						begin
							if ((curX - 3 > 53 && curX + SizeX <= other_PosX) 
							|| (curX - 3 > 53 && curX > other_PosX + other_SizeX && curX - 3 > other_PosX + other_SizeX)
							|| (curX - 3 > 53 && in_air))
							begin
								x_motion <= -3;
								move_left <= 1'b1;
								move_right <= 1'b0;
								dir <= 1'b1;
							end
						end
						
	//					8'h15 :		//RESET (R)
	//					begin
	//						tmp_reset = 1'b1;
	//					end
						
						8'h0E : 		// K		14
						begin
							if (!in_air)
							begin
								kick <= 1'b1;
								if (dir == 1'b1)
									curX <= curX - 52;
							end
						end
						
						8'h13	:		// P		19
						begin
							if (!in_air)
							begin
								punch <= 1'b1;
								if (dir == 1'b1)
									curX <= curX - 52;
							end
						end

						default: ;

					endcase
					if (maxh)
					begin
						y_motion <= 5;
						jump <= 1'b0;
					end
					if (curY + 5 == 291 && jump == 1'b0)		//359
						begin
							y_motion <= 0;
							in_air <= 1'b0;
							maxh <= 1'b0;
						end

					if (crouch && keycode != 8'h16)
						crouch <= 1'b0;
					
					if (move_right && (curX + 3 >= 550 || keycode != 8'h07))
						begin
							x_motion <= 0;
							move_right <= 1'b0;
						end
					else if (move_right && (curX + 3 + SizeX >= other_PosX && curX + SizeX <= other_PosX) && !in_air)		//
						begin																						//
							x_motion <= 0;																		//
							move_right <= 1'b0;																//
						end

					if (move_left && (curX - 3 <= 50 || keycode != 8'h04))
						begin
							x_motion <= 0;
							move_left <= 1'b0;
						end
					else if (move_left && (curX - 3 <= other_PosX + other_SizeX && curX >= other_PosX + other_SizeX) && !in_air)
						begin
							x_motion <= 0;
							move_left <= 1'b0;
						end
					
					if (kick && keycode != 8'h0E)
					begin
						kick <= 1'b0;
	//					kickoff <= 1'b1;
	//					if (dir == 1'b1)
	//						curX <= curX + 32;
					end
					if (punch && keycode != 8'h13)
					begin
						punch <= 1'b0;
	//					if (dir == 1'b1)
	//						curX <= curX + 32;
					end
	//				if (run_state == 3'b011 || run_state == 3'b100 || kick)
	//					SizeX <= 104;
	//				else
	//					SizeX <= 64;
					curX <= curX + x_motion;
					curY <= curY + y_motion;
					
					if (curX < other_PosX && curX + SizeX > other_PosX && !p2_in_air && (other_SizeX == 64 || p2_punch || p2_kick))
						begin
							if ((run_state != 3'b000 || SizeX == 64 || hit) && !jump && curY+SizeY >= other_PosY)
								if (curX <= 547)
									curX <= other_PosX - SizeX;
								else
									curX <= other_PosX + other_SizeX;
						end
					else if (curX > other_PosX && curX < other_PosX + other_SizeX && !p2_in_air && (other_SizeX == 64 || p2_punch || p2_kick))
						begin
							if ((run_state != 3'b000 || SizeX == 64 || hit) && !jump && curY+SizeY >= other_PosY)
								if (curX >= 50)
									curX <= other_PosX + other_SizeX;
								else
									curX <= other_PosX - SizeX;
						end
					
					if (curY <= other_PosY + other_SizeY && !p2_crouch
	//				&& ~(p2_punch && punch) && ~(p2_kick && kick)
					&& ((curX < other_PosX && curX + SizeX >= other_PosX && dir == 1'b0) 
					|| (curX > other_PosX &&  curX <= other_PosX + other_SizeX && dir == 1'b1)))
						begin
							if (punch || kick)
								p2_hit <= 1'b1;
						end

					if (knockback && !in_air && curX - 3 > 50 && curX + 3 < 550)			// unless this_player is hit, this_player should not receive knockback
						begin
							if (dir == 1'b0)
								curX <= curX - 3;
							else
								curX <= curX + 3;
							knockback <= 1'b0;
						end
					if (curX < other_PosX && run_state == 3'b000)
						dir <= 1'b0;
					else if (run_state == 3'b000)
						dir <= 1'b1;
				end
			end
		end


assign PosX = curX;
assign PosY = curY;

endmodule
