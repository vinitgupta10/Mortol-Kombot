//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module project (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	
	logic [7:0] Red, Blue, Green;
	logic [31:0] keycodes;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	project_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(k0),
		.keycode1_export(k1),
		.keycode2_export(k2),
		.keycode3_export(k3),
		
		.output_gen_keycode(ai_p2movements),
		.output_game_mode(game_mode)
//		.vga_port_red (VGA_R),
//		.vga_port_green (VGA_G),
//		.vga_port_blue (VGA_B),
//		.vga_port_hs (VGA_HS),
//		.vga_port_vs (VGA_VS)
		
	 );
logic [7:0] k1, k2, k3, k0;
logic [9:0] drawxsig, drawysig, boxxsig, boxysig, boxsizex, boxsizey;
logic [15:0] rom_add, back_add;
logic [1:0] rom_out;
logic [2:0] run_state;
logic box_on, in_air, crouch, move_left, move_right, dir, kick, punch, pno, p2_hit, p1_hit;
logic [9:0] p2_redposx, p2_greenposx, p2_barposy, p2_redsizex, p2_greensizex, p2_barsizey;
logic [9:0] redposx, greenposx, barposy, redsizex, greensizex, barsizey;
logic back;
logic [2:0] game_mode;
//always_ff @ (posedge Reset or posedge frame_clk )
//begin
//	if (Reset)
//		slow_clock <= 1'b0;
//	else
//		slow_clock <= ~ (slow_clock);
//end

assign keycodes = {k3, k2, k1, k0};

vga_controller vga1(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .DrawX(drawxsig), .DrawY(drawysig), .blank(blank));

//ball b1(.Reset(Reset_h), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig), .keycode(keycode));		// CLK?

box p1(.Reset(Reset_h), .frame_clk(VGA_VS), .PosX(boxxsig), .PosY(boxysig), .SizeX(boxsizex), 
		.SizeY(boxsizey), .keycodes(keycodes), .in_air(in_air), .crouch(crouch), .move_right(move_right), 
		.move_left(move_left), .dir(dir), .kick(kick), .run_state(run_state), .punch(punch), .pno(1'b0),
		.hit(p1_hit), .game_mode(game_mode), .count(count), .p_lose(p1_lose), 
		.other_PosX(p2_boxxsig), .other_PosY(p2_boxysig), .other_SizeX(p2_boxsizex), .other_SizeY(p2_boysizex), .other_dir(p2_dir), 
		.p2_in_air(p2_in_air), .p2_punch(p2_punch), .p2_kick(p2_kick), .p2_run_state(p2_run_state), .p2_hit(p2_hit), .p2_crouch(p2_crouch));

box_color bc(.Red(Red), .Green(Green), .Blue(Blue), .Blank(blank), .PosX(boxxsig), .PosY(boxysig), 
				.DrawX(drawxsig), .DrawY(drawysig), .SizeX(boxsizex), .SizeY(boxsizey), .rom_out(rom_out),
				.box1_on(box_on), .box2_on(p2_box_on), .in_air(in_air), .crouch(crouch), .back(back), .*, 
				.p2_PosX(p2_boxxsig), .p2_PosY(p2_boxysig), .p2_SizeX(p2_boxsizex), .p2_SizeY(p2_boxsizey), .p2_rom_out(p2_rom_out), 
				.game_mode(game_mode), .txtout(txtout), .CLK(VGA_VS), .Reset(Reset_h), .irout(irout), .p1_lose(p1_lose),
				.p2_lose(p2_lose), .ir2out(ir2out));

p_health p1h(.Reset(Reset_h), .frame_clk(VGA_VS), .p_hit(p1_hit), .lose(p1_lose), .keycode(k0), .*);

logic p1_lose, p2_lose;
logic [31:0] p2_key;
logic [7:0]	ai_p2movements;
logic [9:0] p2_boxxsig, p2_boxysig, p2_boxsizex, p2_boxsizey;
logic [15:0] p2_rom_add, p2_add;
logic [1:0] p2_rom_out, txtout;
logic [2:0] p2_run_state;
logic p2_box_on, p2_in_air, p2_crouch, p2_move_left, p2_move_right, p2_dir, p2_kick, p2_punch, p2_pno;

always_comb
begin
	p2_key = 32'b0;
	if (game_mode == 3'b001)
		p2_key = {24'b0, ai_p2movements};
	else if (game_mode == 3'b010)
		p2_key = keycodes;
end

box p2(.Reset(Reset_h), .frame_clk(VGA_VS), .PosX(p2_boxxsig), .PosY(p2_boxysig), .SizeX(p2_boxsizex), 
		.SizeY(p2_boxsizey), .keycodes(p2_key), .in_air(p2_in_air), .crouch(p2_crouch), .move_right(p2_move_right), 
		.move_left(p2_move_left), .dir(p2_dir), .kick(p2_kick), .run_state(p2_run_state), .punch(p2_punch), .pno(1'b1),
		.hit(p2_hit), .game_mode(game_mode), .count(count), .p_lose(p2_lose), 
		.other_PosX(boxxsig), .other_PosY(boxysig), .other_SizeX(boxsizex), .other_SizeY(boxsizey), .other_dir(dir), 
		.p2_in_air(in_air), .p2_punch(punch), .p2_kick(kick), .p2_run_state(run_state), .p2_hit(p1_hit), .p2_crouch(crouch));

rom_port_data p2_data(.CLK(MAX10_CLK1_50), .Reset_h(Reset_h), .in_air(p2_in_air), .move_right(p2_move_right), 
							 .move_left(p2_move_left), .crouch(p2_crouch), .kick(p2_kick), .punch(p2_punch), .run_state(p2_run_state),
							 .drawxsig(drawxsig), .drawysig(drawysig), .boxxsig(p2_boxxsig), .boxysig(p2_boxysig), .boxsizex(p2_boxsizex),
							 .rom_add(p2_rom_add), .dir(p2_dir), .p_hit(p2_hit), .p_lose(p2_lose), .count(count));

playerROM p2_read(.read_address(p2_rom_add), .Clk(MAX10_CLK1_50), .data_Out(p2_rom_out));

p_health p2h(.Reset(Reset_h), .frame_clk(VGA_VS), .p_hit(p2_hit), .punch(p2_punch), .kick(p2_kick),
				  .redposx(p2_redposx), .greenposx(p2_greenposx), .barposy(p2_barposy), .game_mode(game_mode),
				  .redsizex(p2_redsizex), .greensizex(p2_greensizex), .barsizey(p2_barsizey), .lose(p2_lose), .keycode(keycodes[7:0]));

always_ff @ (posedge MAX10_CLK1_50)
begin
	if (Reset_h)
	begin
		back_add <= 15'b0;
	end
	else
		back_add <= ((drawxsig)%128 + ((drawysig%128)*128));
end

always_ff @ (posedge MAX10_CLK1_50)
begin
	if (Reset_h)
	begin
		txtadd <= 14'b0;
	end
	else //if (title)
		txtadd <= (drawxsig - 120)/2 + ((drawysig - 140)/2)*200;
end

always_ff @ (posedge MAX10_CLK1_50)
begin
	if (Reset_h)
	begin
		iradd <= 15'b0;
		iradd <= 15'b0;
	end
	else if (game_mode == 2'b00)
		iradd <= (drawxsig - 155)/2 + ((drawysig - 300)/2)*165;
	else if (drawxsig < 300)
		iradd <= 3300 + (drawxsig - 50) + ((drawysig - 34))*100;
	else if (drawxsig >= 300)
		iradd <= 4700 + (drawxsig - 430) + ((drawysig - 34))*100;
	
	if (!p1_lose && p2_lose && drawysig > 150)
		iradd <= 3300 + (drawxsig - 185) + ((drawysig - 200))*100;
	else if (p1_lose && !p2_lose && drawysig > 150)
		iradd <= 4700 + (drawxsig - 185) + ((drawysig - 200))*100;

	if (p1_lose && !p2_lose)	// 220 * 35
		ir2add <= 6100 + (drawxsig - 200) + ((drawysig - 200))*220;
	else if (!p1_lose && p2_lose)
		ir2add <= 6100 + (drawxsig - 200) + ((drawysig - 200))*220;
end
logic irout;
rom_port_data p1_data(.CLK(MAX10_CLK1_50), .p_hit(p1_hit), .p_lose(p1_lose), .count(count), .*);

playerROM p1_read(.read_address(rom_add), .Clk(MAX10_CLK1_50), .data_Out(rom_out));		//increasing size by 4 times

backgroundROM jram(.read_address(back_add), .Clk(MAX10_CLK1_50), .data_Out(back));		//increasing size by 4 times

logic [13:0] txtadd;
logic [14:0] iradd, ir2add;
textROM trom(.read_address(txtadd), .Clk(MAX10_CLK1_50), .data_Out(txtout));

instructionsROM irom(.read_address(iradd), .Clk(MAX10_CLK1_50), .data_Out(irout));
instructionsROM irom2(.read_address(ir2add), .Clk(MAX10_CLK1_50), .data_Out(ir2out));
logic [8:0] count;
//crouRAM 
// x = 64 to 128, y = 174 to 430
//always_ff @ (posedge VGA_VS)
//begin
//	if (Reset_h)
//		count <= 9'b0;
//	if ((p1_lose || p2_lose) && count < 50)
//		count <= count + 1;
//	else if (keycodes[7:0] == 8'h15)
//		begin
//		count <= 9'h000;
////		if (!p1_lose && !p2_lose)
////			count <= count + 1;
//		end
//end
//color_mapper cm(.*, .BallX(ballxsig), .BallY(ballysig), .DrawX(drawxsig), .DrawY(drawysig), .Ball_size(ballsizesig));
//instantiate a vga_controller, ball, and color_mapper here with the ports.


endmodule
