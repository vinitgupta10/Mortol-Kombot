module key_code(input [31:0] keycodes, 
					 input pno,
					 input [2:0] game_mode,
					 output [7:0] keycode);
always_comb
begin
	keycode = 8'b0;
	if (game_mode == 3'b001)
	begin
		keycode = keycodes[7:0];
	end
	else if (game_mode == 3'b010)
	begin
		if (pno == 1'b0)
		begin
			if (keycodes[7:0] == 8'h1A
			||  keycodes[15:8] == 8'h1A
			||  keycodes[23:16] == 8'h1A		// 7:0 keycode, anything greater, secondary keycode
			||  keycodes[31:24] == 8'h1A)
				keycode = 8'h1A;
			else if (keycodes[7:0] == 8'h16
			||  keycodes[15:8] == 8'h16
			||  keycodes[23:16] == 8'h16
			||  keycodes[31:24] == 8'h16)
				keycode = 8'h16;
			else if (keycodes[7:0] == 8'h07
			||  keycodes[15:8] == 8'h07
			||  keycodes[23:16] == 8'h07
			||  keycodes[31:24] == 8'h07)
				keycode = 8'h07;
			else if (keycodes[7:0] == 8'h04
			||  keycodes[15:8] == 8'h04
			||  keycodes[23:16] == 8'h04
			||  keycodes[31:24] == 8'h04)
				keycode = 8'h04;
			else if (keycodes[7:0] == 8'h0E
			||  keycodes[15:8] == 8'h0E
			||  keycodes[23:16] == 8'h0E
			||  keycodes[31:24] == 8'h0E)
				keycode = 8'h0E;
			else if (keycodes[7:0] == 8'h13
			||  keycodes[15:8] == 8'h13
			||  keycodes[23:16] == 8'h13
			||  keycodes[31:24] == 8'h13)
				keycode = 8'h13;
		end
		else
		begin
			if (keycodes[7:0] == 8'h52
			||  keycodes[15:8] == 8'h52
			||  keycodes[23:16] == 8'h52
			||  keycodes[31:24] == 8'h52)
				keycode = 8'h1A;
			else if (keycodes[7:0] == 8'h51
			||  keycodes[15:8] == 8'h51
			||  keycodes[23:16] == 8'h51
			||  keycodes[31:24] == 8'h51)
				keycode = 8'h16;
			else if (keycodes[7:0] == 8'h4F
			||  keycodes[15:8] == 8'h4F
			||  keycodes[23:16] == 8'h4F
			||  keycodes[31:24] == 8'h4F)
				keycode = 8'h07;
			else if (keycodes[7:0] == 8'h50
			||  keycodes[15:8] == 8'h50
			||  keycodes[23:16] == 8'h50
			||  keycodes[31:24] == 8'h50)
				keycode = 8'h04;
			else if (keycodes[7:0] == 8'h37
			||  keycodes[15:8] == 8'h37
			||  keycodes[23:16] == 8'h37
			||  keycodes[31:24] == 8'h37)
				keycode = 8'h0E;
			else if (keycodes[7:0] == 8'h38
			||  keycodes[15:8] == 8'h38
			||  keycodes[23:16] == 8'h38
			||  keycodes[31:24] == 8'h38)
				keycode = 8'h13;
		end
	end
		
end

endmodule
