module p1_health(input logic Reset, frame_clk, punch, kick, p_hit,
					  input logic [7:0] keycode,
					  input [2:0] game_mode,
					  output lose,
					  output [9:0] redposx, greenposx, barposy, redsizex, greensizex, barsizey/*,
					  output logic [2:0] p1_health_stat*/);

	
enum logic [4:0] {h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, h22, h23} State, Next_State;

logic [4:0] tmp_stat;

always_ff @ (posedge Reset or posedge frame_clk )
begin
if (Reset)
	begin
		State <= h23;
//		p1_health_stat <= 3'b111;
	end
else
	begin
		State <= Next_State;
//		p1_health_stat <= tmp_stat;
	end
end

always_comb
begin
	lose = 1'b0;
	Next_State = State;
	unique case (State)
		h23: if (p_hit)
					Next_State = h22;
		h22: if (p_hit)
					Next_State = h21;			
		h21: if (p_hit)
					Next_State = h20;
		h20: if (p_hit)
					Next_State = h19;
		h19: if (p_hit)
					Next_State = h18;
		h18: if (p_hit)
					Next_State = h17;
		h17: if (p_hit)
					Next_State = h16;
		h16: if (p_hit)
					Next_State = h15;
		h15: if (p_hit)
					Next_State = h14;
		h14: if (p_hit)
					Next_State = h13;
		h13: if (p_hit)
					Next_State = h12;
		h12: if (p_hit)
					Next_State = h11;
		h11: if (p_hit)
					Next_State = h10;
		h10: if (p_hit)
					Next_State = h9;
		h9: if (p_hit)
					Next_State = h8;
		h8: if (p_hit)
					Next_State = h7;
		h7: if (p_hit)
					Next_State = h6;
		h6: if (p_hit)
					Next_State = h5;
		h5: if (p_hit)
					Next_State = h4;
		h4: if (p_hit)
					Next_State = h3;
		h3: if (p_hit)
					Next_State = h2;
		h2: if (p_hit)
					Next_State = h1;
		h1: if (p_hit)
					Next_State = h0;
		h0: if (keycode == 8'h15)
					Next_State = h23;
		default: Next_State = h23;
	endcase
	
	case (State)
		h23: tmp_stat = 5'b11111;
		h22: tmp_stat = 5'b11110;
		h21: tmp_stat = 5'b11101;
		h20: tmp_stat = 5'b11100;
		h19: tmp_stat = 5'b11011;
		h18: tmp_stat = 5'b11010;
		h17: tmp_stat = 5'b11001;
		h16: tmp_stat = 5'b11000;
		h15: tmp_stat = 5'b10111;
		h14: tmp_stat = 5'b10110;
		h13: tmp_stat = 5'b10101;
		h12: tmp_stat = 5'b10100;
		h11: tmp_stat = 5'b10011;
		h10: tmp_stat = 5'b10010;
		h9: tmp_stat = 5'b10001;
		h8: tmp_stat = 5'b10000;
		h7: tmp_stat = 5'b00111;
		h6: tmp_stat = 5'b00110;
		h5: tmp_stat = 5'b00101;
		h4: tmp_stat = 5'b00100;
		h3: tmp_stat = 5'b00011;
		h2: tmp_stat = 5'b00010;
		h1: tmp_stat = 5'b00001;
		h0: 
			begin
				lose = 1'b1;
				tmp_stat = 5'b00000;
			end
		default: tmp_stat = 5'b11111;
	endcase
end


// Draw Bar
always_ff @ (posedge Reset or posedge frame_clk )
begin
if (Reset)
	begin
		redposx <= 50;
		greenposx <= 190;
		barposy <= 50;
		redsizex <= 140;
		greensizex <= 0;
		barsizey <= 10;
	end
else
	begin
		greenposx <= gpx;
		redsizex <= rsx;
		greensizex <= gsx;
	end
end
logic [9:0] gpx, rsx, gsx;
always_comb
begin
	case (tmp_stat)
		5'b11111:
			begin
				gpx = 190;
				rsx = 140;
				gsx = 0;
			end
		5'b11110:
			begin
				gpx = 185;
				rsx = 135;
				gsx = 5;
			end
		5'b11101:
			begin
				gpx = 180;
				rsx = 130;
				gsx = 10;
			end
		5'b11100:
			begin
				gpx = 175;
				rsx = 125;
				gsx = 15;
			end
		5'b11011:
			begin
				gpx = 170;
				rsx = 120;
				gsx = 20;
			end
		5'b11010:
			begin
				gpx = 165;
				rsx = 115;
				gsx = 25;
			end
		5'b11001:
			begin
				gpx = 160;
				rsx = 110;
				gsx = 30;
			end
		5'b11000:
			begin
				gpx = 155;
				rsx = 105;
				gsx = 35;
			end
		5'b10111:
			begin
				gpx = 150;
				rsx = 100;
				gsx = 40;
			end
		5'b10110:
			begin
				gpx = 145;
				rsx = 95;
				gsx = 45;
			end
		5'b10101:
			begin
				gpx = 140;
				rsx = 90;
				gsx = 50;
			end
		5'b10100:
			begin
				gpx = 135;
				rsx = 85;
				gsx = 55;
			end
		5'b10011:
			begin
				gpx = 130;
				rsx = 80;
				gsx = 60;
			end
		5'b10010:
			begin
				gpx = 125;
				rsx = 75;
				gsx = 65;
			end
		5'b10001:
			begin
				gpx = 120;
				rsx = 70;
				gsx = 70;
			end
		5'b10000:
			begin
				gpx = 110;
				rsx = 60;
				gsx = 80;
			end
		5'b00111:
			begin
				gpx = 100;
				rsx = 50;
				gsx = 90;
			end
		5'b00110:
			begin
				gpx = 90;
				rsx = 40;
				gsx = 100;
			end
		5'b00101:
			begin
				gpx = 80;
				rsx = 30;
				gsx = 110;
			end
		5'b00100:
			begin
				gpx = 70;
				rsx = 20;
				gsx = 120;
			end
		5'b00011:
			begin
				gpx = 65;
				rsx = 15;
				gsx = 125;
			end
		5'b00010:
			begin
				gpx = 60;
				rsx = 10;
				gsx = 130;
			end
		5'b00001:
			begin
				gpx = 55;
				rsx = 5;
				gsx = 135;
			end
		5'b00000:
			begin
				gpx = 50;
				rsx = 0;
				gsx = 140;
			end
	endcase
end

endmodule
