/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  textROM
(
//		input [4:0] data_In,
		input [13:0] read_address,
		input Clk,

		output logic [1:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [1:0] mem [0:10000];

initial
begin
	 $readmemh("ROM_data/text.txt", mem);
end


always_ff @ (posedge Clk) begin
//	if (we)
//		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule
