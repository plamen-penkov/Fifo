import uvm_pkg::*;
import tb_params_pkg::*;
module tb_top();
	logic clk, rst_n, expected_full, expected_empty;
	
	initial begin
		clk = 0;
	end
	
	always #5 clk = ~clk;

	initial begin
		rst_n = 1;
		@(posedge clk);
		rst_n = 0;
		repeat (2) @(posedge clk);
		rst_n = 1;
	end

	fifo_wr_if #(.DATA_WIDTH(DATA_WIDTH_P)) wr_if(clk, rst_n);
	fifo_rd_if #(.DATA_WIDTH(DATA_WIDTH_P)) rd_if(clk, rst_n);

	initial begin
		uvm_config_db #(int)::set(null, "", "fifo_depth", 2 ** ADDRESS_WIDTH_P);

		uvm_config_db #(virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)))::set(null, "", "wr_vif", wr_if);
		uvm_config_db #(virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)))::set(null, "", "rd_vif", rd_if);

		`uvm_info("TB_TOP", $sformatf("FIFO DEPTH: %d", (2 ** ADDRESS_WIDTH_P)), UVM_LOW)

		run_test("fifo_directed_test_2");
	end

	fifo #(
		.DATA_WIDTH(DATA_WIDTH_P),
		.ADDRESS_WIDTH(ADDRESS_WIDTH_P)
	) fifo_instance (
		.clk(clk),
		.rst_n(rst_n),
		.we(wr_if.we),
		.re(rd_if.re),
		.wrdata(wr_if.wrdata),
		.rddata(rd_if.rddata),
		.full(wr_if.full),
		.empty(rd_if.empty)
	);

	checker #(
		.ADDRESS_WIDTH(ADDRESS_WIDTH_P)
	) my_checker (
		.clk(clk),
		.rst_n(rst_n),
		.wr_en(wr_if.we),
		.rd_en(rd_if.re),
		.full(wr_if.full),
		.empty(rd_if.empty),
		.expected_empty(expected_empty),
		.expected_full(expected_full)
	);
endmodule
