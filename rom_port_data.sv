module rom_port_data(input 				CLK, Reset_h, in_air, move_right, move_left, crouch, kick, punch, dir, p_hit, p_lose,
							input [4:0]			count,
							input logic [2:0] run_state,
							input logic [9:0] drawxsig, drawysig, boxxsig, boxysig, boxsizex,
							output	logic [15:0] rom_add
							);
logic [15:0] add, bigadd;


always_ff @ (posedge CLK)
begin
if (Reset_h)
	begin
		rom_add <= 15'b0;
	end
//else if (p_lose && count < 50 && count != 9'b0)
//	rom_add <= 27648 + bigadd;
else if (p_lose)
	begin
//		rom_add <= add;
		if (dir == 1'b0)
			rom_add <= 30976 + ((drawxsig - boxxsig)/2 + (drawysig - boxysig)/2 * 64);
		else
			rom_add <= 30976 + (63 - (drawxsig - boxxsig)/2 + (drawysig - boxysig)/2 * 64);
	end
else if (p_hit)
	rom_add <= 25600 + add;
else if (in_air == 1'b1 && !move_right && !move_left)
	rom_add <= 2048 + add;

else if (in_air == 1'b1)		//air_move	
	rom_add <= 16896 + add;

else if (crouch == 1'b1)		// box_on not needed?		else if (box_on && crouch == 1'b1)
	rom_add <= 4096 + add;
else if (run_state == 3'b001)
	if (boxsizex == 64)
		rom_add <= 6144 + add;
	else
		rom_add <= 13568 + bigadd;
else if (run_state == 3'b010)
	rom_add <= 8192 + add;
else if (run_state == 3'b011)
	rom_add <= 10240 + bigadd;
else if (run_state == 3'b100)
	rom_add <= 13568 + bigadd;
else if (kick)
	rom_add <= 18944 + bigadd;
else if (punch)
	rom_add <= 22272 + bigadd;
else if (in_air == 1'b0 && crouch == 1'b0 && run_state == 3'b000 && !kick)
	if (boxsizex == 64)
		rom_add <= add;
//	else
//27648
//30976
//		rom_add <= rom_add;		//tmp_fix
end

always_comb
begin
	add = ((drawxsig - boxxsig)/2 + (drawysig - boxysig)/2 * 32);
	bigadd = ((drawxsig - boxxsig)/2 + (drawysig - boxysig)/2 * 52);
	
	if (dir == 1'b1)
	begin
		add = (31 - (drawxsig - boxxsig)/2) + (drawysig - boxysig)/2 * 32;
		bigadd = (51 - (drawxsig - boxxsig)/2) + (drawysig - boxysig)/2 * 52;
	end
end

endmodule
