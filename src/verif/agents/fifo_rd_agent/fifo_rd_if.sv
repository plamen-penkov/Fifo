interface fifo_rd_if #(
	parameter DATA_WIDTH = 32
) (
	input logic clk,
	input logic rst_n
);
	logic re;
	logic [DATA_WIDTH-1:0] rddata;
	logic empty;

	logic re_delay;
	logic empty_delay;
endinterface: fifo_rd_if
