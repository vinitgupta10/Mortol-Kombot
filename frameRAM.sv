/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameRAM
(
//		input [4:0] data_In,
		input [15:0] read_address,
		input Clk,

		output logic [1:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [1:0] mem [0:36000];

initial
begin
	 $readmemh("output_files/Text1.txt", mem);
end


always_ff @ (posedge Clk) begin
//	if (we)
//		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule
