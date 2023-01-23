// OLD FILES = Box.sv
//module box ( input Reset, frame_clk,
//					input [7:0] keycode,
//               output [9:0]  PosX, PosY, SizeX, SizeY,
//					output logic in_air);
//
//
//logic [9:0] curX, curY, disy, x_motion, y_motion;
//enum logic [2:0] {t1,t2,t3,t4} State, Next_state ;
//logic maxh, ground, jump;
//logic [5:0] ti_me;
//assign SizeX = 64;
//assign SizeY = 128;
//
////always_ff @ (posedge frame_clk)
////	begin: _time_
//////		if (Reset)
//////			begin
////////			tinc <= 1'b0;
//////			State <= t1;
//////			end
//////		else 
//////			State <= Next_state;
////		if (tstart)
////			ti_me <= ti_me + frame_clk;
////		else 
////			begin
////				ti_me <= 6'b0;
//////				y_motion <= 0;
////			end
////	end
////
////always_comb
////begin
////	Next_state = State;
////	
////	unique case (State)
////		t1: if (tstart)
////				Next_state = t2;
////		t2:	Next_state = t3;
////		t3:	Next_state = t4;
////		t4: Next_state = t1;
////		default : Next_state = t1;
////	endcase
////	tinc = 1'b0;
////	case (State)
////		t4:	tinc = 1'b1;
////		t1:	tinc = 1'b0;
////		t2, t3 :;
////		default :;
////	endcase
////	
////end
//
//
//always_ff @ (posedge Reset or posedge frame_clk )
//    begin: Move_Ball
//		  if (Reset)
//        begin 
//            x_motion <= 10'd0;
//				y_motion <= 10'd0;
//				curX <= 50;
//				curY <= 291;		//359
////				tstart <= 1'b0;
//				jump <= 1'b0;
//				maxh <= 1'b0;
//				ground <= 1'b1;
//				in_air <= 1'b0;
//        end
//			
//		  else
//		  begin
//
//				if (curY <= 103)		// 239
//						maxh <= 1'b1;
////				if (curY == 291)		//359
////						ground <= 1'b1;
//				case (keycode)
//					8'h1A : 
//					begin				//UP
////						if (!maxh && ground)
////						begin
////						if (!maxh)
//						y_motion <= -5;
//						in_air <= 1'b1;
//						jump <= 1'b1;
////						else
////							y_motion <= 1;
////							ground <= 1'b0;
////							if (curY + SizeY >= 370)
////								maxh <= 1'b1;
////						end
////						else if (maxh && !ground)
////						begin
//							
////							maxh <= 1'b0;
////						end
////						disy <= 50 * ti_me[5:3] - frame_clk * 10 * ti_me[5:3] * ti_me[5:3];
//					end
//					8'h07 :
//					begin
//						curY <= 450;
//						y_motion <= 5;
////						disy <= 0;
//					end
//					default: ;
//				endcase
//				if (maxh)
//				begin
//					y_motion <= 5;
//					jump <= 1'b0;
//				end
//				if (curY + 5 == 291 && jump == 1'b0)		//359
//					begin
//						y_motion <= 0;
////						ground <= 1'b0;
//						in_air <= 1'b0;
//						maxh <= 1'b0;
//					end
////				if (curY < 291)
////					in_air <= 1'b1;
////				else
////					in_air <= 1'b0;
//				curX <= curX + x_motion;
//				curY <= curY + y_motion;
//			end
//				
//		end
//
//assign PosX = curX;
//assign PosY = curY;
//
//endmodule



// NEW
//module box_color ( input        [9:0] PosX, PosY, DrawX, DrawY, SizeX, SizeY,
//						 input Blank, in_air,
//						 input [1:0] rom_out,
//				 output logic [7:0]  Red, Green, Blue,
//				 output logic box_on, crouch	);
//				 
//		
////		logic box_on;
//
//always_comb 
//begin
//if ((DrawX - PosX) <= SizeX && (DrawY - PosY) <= SizeY) 
//	box_on = 1'b1;
//else
//	box_on = 1'b0;
//end	
//		
//		
//always_comb
//begin
//
//if (Blank) 
//	begin
//
//	if (box_on)
//		begin
//		
////		if (in_air)
//			case(rom_out)
//				2'b00:
//					begin
//						Red = 8'h00;
//						Green = 8'h00;
//						Blue = 8'hFF;
//					end
//				2'b01:
//					begin
//						Red = 8'h00;
//						Green = 8'h00;
//						Blue = 8'h00;
//					end
//				2'b10:
//					begin
//						Red = 8'hA6;
//						Green = 8'hA6;
//						Blue = 8'h38;
//					end
//				2'b11:
//					begin
//						Red = 8'hFF;
//						Green = 8'hFF;
//						Blue = 8'hFF;
//					end
//				default: ;
//			endcase
////		else if (crouch)
////			case(scor)
////				2'b00:
////					begin
////						Red = 8'h00;
////						Green = 8'h00;
////						Blue = 8'hFF;
////					end
////				2'b01:
////					begin
////						Red = 8'h00;
////						Green = 8'h00;
////						Blue = 8'h00;
////					end
////				2'b10:
////					begin
////						Red = 8'hA6;
////						Green = 8'hA6;
////						Blue = 8'h38;
////					end
////				2'b11:
////					begin
////						Red = 8'hFF;
////						Green = 8'hFF;
////						Blue = 8'hFF;
////					end
////				default: ;
////			endcase
////		else
//////		if (!in_air && !crouch)
////			case(scor)
////				2'b00:
////					begin
////						Red = 8'h00;
////						Green = 8'h00;
////						Blue = 8'hFF;
////					end
////				2'b01:
////					begin
////						Red = 8'h00;
////						Green = 8'h00;
////						Blue = 8'h00;
////					end
////				2'b10:
////					begin
////						Red = 8'hA6;
////						Green = 8'hA6;
////						Blue = 8'h38;
////					end
////				2'b11:
////					begin
////						Red = 8'hFF;
////						Green = 8'hFF;
////						Blue = 8'hFF;
////					end
////				default: ;
////			endcase
//		end
//
//	else if (DrawY > 419)
//		begin
//			Red = 8'h00;
//			Green = 8'hFF;
//			Blue = 8'h00;
//		end
//	else
//		begin
//			Red = 8'h00;
//			Green = 8'h00;
//			Blue = 8'hFF;
//		end
//
//	end
//
//
//else
//	begin
//		Red = 8'h00;
//		Green = 8'h00;
//		Blue = 8'h00;
//	end
//end
//
//endmodule


