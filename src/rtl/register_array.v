module register_array#(
	parameter ADDRESS_WIDTH = 3,
	parameter DATA_WIDTH = 8
)(
	input wire clk,

	input wire we0,
	input wire[ADDRESS_WIDTH-1:0] addr0,
	input wire[DATA_WIDTH-1:0] wdata0,
	output reg[DATA_WIDTH-1:0] rdata0,

	input wire we1,
	input wire[ADDRESS_WIDTH-1:0] addr1,
	input wire[DATA_WIDTH-1:0] wdata1,
	output reg[DATA_WIDTH-1:0] rdata1
);
	localparam MEMORY_DEPTH = 2 ** ADDRESS_WIDTH;

	reg[DATA_WIDTH-1:0] memory[0:MEMORY_DEPTH-1];
	// reg[DATA_WIDTH-1:0] memory[MEMORY_DEPTH];

	// one port for writing and one port for reading
	// if trying to read and write from the same address show the last valid output

	generate
		genvar i;
		for (i = 0; i < MEMORY_DEPTH; i = i + 1) begin
			always @(posedge clk) begin
				if (we0) begin
					if (i == addr0) begin
						memory[i] <= wdata0;
					end
				end
			end	
		end
	endgenerate
	always @(posedge clk) begin
		// if (!we0) begin
			rdata1 <= memory[addr1];
		// end else begin
		// 	rdata1 = 0;
		// end
	end
endmodule
