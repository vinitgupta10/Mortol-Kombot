//module player2()
//
//Avalon read, write stuff
//
//copy box
//
//if (signal x = true) assume keycode x is up
module player2 (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
//	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
//	output logic hs, vs						// VGA HS/VS
//	output [9:0]  p2_PosX, p2_PosY, p2_SizeX, p2_SizeY,
//	output logic p2_in_air, p2_crouch, p2_move_right, p2_move_left, p2_dir, p2_kick, p2_punch,
//	output [2:0] p2_run_state
	output [7:0] gen_keycode, 
	output [2:0] game_mode
);

//p2interface p2i(.*);

//logic hs,vs;

//vga_controller vgap2(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), 
//						 .blank(blank), .sync(), .DrawX(dx), .DrawY(dy));
				 
logic [31:0] LOCAL_REG [4]; // Registers
//put other local variables here
//logic WAIT;
logic [31:0] wdata;
//logic [10:0] sprite_addr;
//logic [7:0]	fdata;
//logic [9:0] dx, dy;
//logic sprite_on;
//logic [4:0] regval;
//logic [3:0] red_, green_, blue_;
//logic invbit;
//logic pixel_clk, blank;
//logic [11:0] ram_addr;
//logic [31:0] dataout;
//Declare submodules..e.g. VGA controller, ROMS, etc
//logic frame_clk;
//assign frame_clk = vs;

// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) begin
	if (RESET)
		begin
			for (int i = 0; i < 4; i++)
				LOCAL_REG[AVL_ADDR] <= 32'b0;
		end
	else if (AVL_WRITE)
		begin
			LOCAL_REG[AVL_ADDR] <= wdata;
		end
	else if (AVL_READ)
		begin
			AVL_READDATA <= LOCAL_REG[AVL_ADDR];
		end
end

always_comb begin
		unique case(AVL_BYTE_EN)
			4'b1111 : wdata = AVL_WRITEDATA;
			4'b1100 : wdata = {AVL_WRITEDATA[31:16], LOCAL_REG[AVL_ADDR][15:0]};
			4'b0011 : wdata = {LOCAL_REG[AVL_ADDR][31:16], AVL_WRITEDATA[15:0]};
			4'b1000 : wdata = {AVL_WRITEDATA[31:24], LOCAL_REG[AVL_ADDR][23:0]};
			4'b0100 : wdata = {LOCAL_REG[AVL_ADDR][31:24], AVL_WRITEDATA[23:16], LOCAL_REG[AVL_ADDR][15:0]};
			4'b0010 : wdata = {LOCAL_REG[AVL_ADDR][31:16], AVL_WRITEDATA[15:8], LOCAL_REG[AVL_ADDR][7:0]};
			4'b0001 : wdata = {LOCAL_REG[AVL_ADDR][31:8], AVL_WRITEDATA[7:0]};
			default : wdata = LOCAL_REG[AVL_ADDR];
		endcase
end
assign gen_keycode = LOCAL_REG[0][7:0];
assign game_mode = LOCAL_REG[0][10:8];
//logic [9:0] curX, curY, disy, p2_x_motion, p2_y_motion;
//logic maxh, ground, jump, tmp_reset;
//
//
//logic [7:0] gen_keycode;
//assign gen_keycode = LOCAL_REG[0][7:0];
//
//run rp2(.Reset(RESET), .frame_clk(frame_clk), .move_right(p2_move_right), .move_left(p2_move_left), 
//		 .keycode(gen_keycode), .run_state(p2_run_state));
//
//always_ff @ (posedge RESET or posedge frame_clk)
//begin
//	if (RESET)
//		p2_SizeX <= 64;
//	else if ((p2_run_state == 3'b011 || p2_run_state == 3'b100 || p2_kick || p2_punch) && !p2_in_air)
//		p2_SizeX <= 104;
//	else
//		p2_SizeX <= 64;
//end
//		 
//always_ff @ (posedge Reset or posedge frame_clk )
//    begin: Move_Ball
//		  if (RESET)
//        begin 
//            p2_x_motion <= 10'd0;
//				p2_y_motion <= 10'd0;
//				curX <= 50;
//				curY <= 291;
//				jump <= 1'b0;
//				maxh <= 1'b0;
//				ground <= 1'b1;
//				p2_in_air <= 1'b0;
//				p2_crouch <= 1'b0;
//				p2_move_right <= 1'b0;
//				p2_move_left <= 1'b0;
//				p2_dir <= 1'b0;
//				p2_punch <= 1'b0;
//				p2_SizeY <= 128;
//        end
//		  
//		  else if (tmp_reset) 
//		  begin 
//            p2_x_motion <= 10'd0;
//				p2_y_motion <= 10'd0;
//				curX <= 50;
//				curY <= 291;
//				jump <= 1'b0;
//				maxh <= 1'b0;
//				ground <= 1'b1;
//				p2_in_air <= 1'b0;
//				p2_crouch <= 1'b0;
//				p2_punch <= 1'b0;
//				tmp_reset <= 1'b0; // ?
//        end
//			
//		  else
//		  begin
//
//				if (curY <= 103)
//						maxh <= 1'b1;
//				case (gen_keycode)
//					8'h1A : 		// W
//					begin
//						p2_y_motion <= -5;
//						p2_in_air <= 1'b1;
//						jump <= 1'b1;
//					end
//					
//					8'h16 :		// S
//					begin
////						if (!jump)
//						p2_crouch <= 1'b1;
//					end
//					
//					8'h07 :		// D
//					begin
//						if (curX + 3 < 550)
//						begin
//							p2_x_motion <= 3;
//							p2_move_right <= 1'b1;
//							p2_move_left <= 1'b0;
//							p2_dir <= 1'b0;
//						end
//					end
//					
//					8'h04 :		// A
//					begin
//						if (curX - 3 > 53)
//						begin
//							p2_x_motion <= -3;
//							p2_move_left <= 1'b1;
//							p2_move_right <= 1'b0;
//							p2_dir <= 1'b1;
//						end
//					end
//					
//					8'h15 :		//RESET (R)
//					begin
//						tmp_reset = 1'b1;
//					end
//					
//					8'h0E : 		// K
//					begin
//						p2_kick <= 1'b1;
//					end
//					
//					8'h13	:		// P
//					begin
//						p2_punch <= 1'b1;
//					end
//
//					default: ;
//
//				endcase
//				if (maxh)
//				begin
//					p2_y_motion <= 5;
//					jump <= 1'b0;
//				end
//				if (curY + 5 == 291 && jump == 1'b0)		//359
//					begin
//						p2_y_motion <= 0;
//						p2_in_air <= 1'b0;
//						maxh <= 1'b0;
//					end
//
//				if (p2_crouch && gen_keycode != 8'h16)
//					p2_crouch <= 1'b0;
//				
//				if (p2_move_right && (curX + 3 >= 550 || gen_keycode != 8'h07))
//				begin
//					p2_x_motion <= 0;
//					p2_move_right <= 1'b0;
//				end
//
//				if (p2_move_left && (curX - 3 <= 50 || gen_keycode != 8'h04))
//				begin
//					p2_x_motion <= 0;
//					p2_move_left <= 1'b0;
//				end
//				
//				if (p2_kick && gen_keycode != 8'h0E)
//				begin
//					p2_kick <= 1'b0;
////					kickoff <= 1'b1;
//				end
//				if (p2_punch && gen_keycode != 8'h13)
//					p2_punch <= 1'b0;
////				if (run_state == 3'b011 || run_state == 3'b100 || p2_kick)
////					SizeX <= 104;
////				else
////					SizeX <= 64;
//				curX <= curX + p2_x_motion;
//				curY <= curY + p2_y_motion;
//			end
//				
//		end
//
//assign p2_PosX = curX;
//assign p2_PosY = curY;

endmodule
