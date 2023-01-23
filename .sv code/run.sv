module run(input logic Reset, frame_clk, move_right, move_left,
			  input [7:0] keycode,
			  output [2:0] run_state);

enum logic [7:0] {r0, r1, r2, r3, r4, r5, 
						r_1, r_2, r_3, r_4, r_5, r_6, r_7, r_8, r_9, r_10, 
						r_11, r_12, r_13, r_14, r_15, r_16, r_17, r_18, r_19, r_20,
						r_21, r_22, r_23, r_24, r_25, r_26, r_27, r_28, r_29, r_30,
						r_31, r_32, r_33, r_34, r_35, r_36, r_37, r_38, r_39, r_40} State, Next_State;
logic [2:0] run_s;
//logic slow_clock, slower_clock, slowest_clock;


always_ff @ (posedge Reset or posedge frame_clk )
begin
	if (Reset)
	begin
		State <= r0;
		run_state <= 3'b0;
	end
	else if ((move_right && keycode == 8'h07)  || (move_left && keycode == 8'h04))
	begin
		State <= Next_State;
		run_state <= run_s;
	end
	else
	begin
		State <= r0;
		run_state <= 3'b0;
	end
end

always_comb
begin
	Next_State = State;
	unique case (State)
		r0:	if (keycode == 8'h07 || keycode == 8'h04)
					Next_State = r1;

		r1:	Next_State = r_1;

		r_1:	Next_State = r_2;
		r_2:	Next_State = r_3;
		r_3:	Next_State = r_4;
		r_4:	Next_State = r_5;
		r_5:	Next_State = r_6;
		r_6:	Next_State = r_7;
		r_7:	Next_State = r_8;
		r_8:	Next_State = r_9;
		r_9:	Next_State = r_10;

		r_10:	Next_State = r2;
		r2:	Next_State = r_11;

		r_11:	Next_State = r_12;
		r_12:	Next_State = r_13;
		r_13:	Next_State = r_14;
		r_14:	Next_State = r_15;
		r_15:	Next_State = r_16;
		r_16:	Next_State = r_17;
		r_17:	Next_State = r_18;
		r_18:	Next_State = r_19;
		r_19:	Next_State = r_20;
		
		r_20: Next_State = r3;
		r3:	Next_State = r_21;
		
		r_21:	Next_State = r_22;
		r_22:	Next_State = r_23;
		r_23:	Next_State = r_24;
		r_24:	Next_State = r_25;
		r_25:	Next_State = r_26;
		r_26:	Next_State = r_27;
		r_27:	Next_State = r_28;
		r_28:	Next_State = r_29;
		r_29:	Next_State = r_30;
		
		
		r_30: Next_State = r4;
		r4:	Next_State = r_31;
		
		r_31:	Next_State = r_32;
		r_32:	Next_State = r_33;
		r_33:	Next_State = r_34;
		r_34:	Next_State = r_35;
		r_35:	Next_State = r_36;
		r_36:	Next_State = r_37;
		r_37:	Next_State = r_38;
		r_38:	Next_State = r_39;
		r_39:	Next_State = r_40;
		r_40:	Next_State = r1;

		default: Next_State = r0;
	endcase

	case (State)
		r0:	run_s = 3'b000;
		r1, r_1, r_2, r_3, r_4, r_5, r_6, r_7, r_8, r_9, r_10:	run_s = 3'b001;
		r2, r_11, r_12, r_13, r_14, r_15, r_16, r_17, r_18, r_19, r_20:	run_s = 3'b010;
		r3, r_21, r_22, r_23, r_24, r_25, r_26, r_27, r_28, r_29, r_30:	run_s = 3'b011;
		r4, r_31, r_32, r_33, r_34, r_35, r_36, r_37, r_38, r_39, r_40:	run_s = 3'b100;
		
		default: run_s = 3'b000;
	endcase
end

//		r41_: Next_State = r41_1;
//		r41_1: Next_State = r41_2;
//		r41_2: Next_State = r41_3;
//		r41_3: Next_State = r41_4;
//		r41_4: Next_State = r41_5;
//		r41_5: Next_State = r41_6;
//		r41_6: Next_State = r41_7;
//		r41_7: Next_State = r41_8;
//		r41_8: Next_State = r41_9;
//		r41_9: Next_State = r41_10;
//		r41_10: Next_State = r42_;
//		
//		r42_: Next_State = r42_1;
//		r42_1: Next_State = r42_2;
//		r42_2: Next_State = r42_3;
//		r42_3: Next_State = r42_4;
//		r42_4: Next_State = r42_5;
//		r42_5: Next_State = r42_6;
//		r42_6: Next_State = r42_7;
//		r42_7: Next_State = r42_8;
//		r42_8: Next_State = r42_9;
//		r42_9: Next_State = r42_10;
//		r42_10: Next_State = r4;


//always_ff @ (posedge Reset or posedge frame_clk )
//begin
//	if (Reset)
//		slow_clock <= 1'b0;
//	else
//		slow_clock <= ~ (slow_clock);
//end
//
//always_ff @ (posedge Reset or posedge slow_clock )
//begin
//	if (Reset)
//		slower_clock <= 1'b0;
//	else
//		slower_clock <= ~ (slower_clock);
//end
//
//always_ff @ (posedge Reset or posedge slower_clock )
//begin
//	if (Reset)
//		slowest_clock <= 1'b0;
//	else
//		slowest_clock <= ~ (slowest_clock);
//end

endmodule
