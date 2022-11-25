/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  instructionsROM
(
//		input [4:0] data_In,
		input [14:0] read_address,
		input Clk,

		output logic data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic mem [0:15000];

initial
begin
	 $readmemh("instructions.txt", mem);
end


always_ff @ (posedge Clk) begin
//	if (we)
//		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule