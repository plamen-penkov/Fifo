class fifo_wr_transaction_item #(
	parameter DATA_WIDTH = 32
) extends uvm_sequence_item;
	rand bit wr_en;
	rand bit [DATA_WIDTH-1:0] wrdata;
	bit full;
	int wr_en_dist;

	`uvm_object_utils_begin(fifo_wr_transaction_item#(DATA_WIDTH))
		`uvm_field_int(wr_en, UVM_ALL_ON)
		`uvm_field_int(wrdata, UVM_ALL_ON)
		`uvm_field_int(full, UVM_ALL_ON)
		`uvm_field_int(wr_en_dist, UVM_ALL_ON)
	`uvm_object_utils_end

	function new (string name = "fifo_wr_transaction_item");
		super.new(name);
	endfunction

	constraint wr_en_c_dist {
		wr_en dist {
			0 := 100 - wr_en_dist,
			1 := wr_en_dist
		};
	}

	function void pre_randomize();
		if (wr_en_dist < 0 || 100 < wr_en_dist) begin
			`uvm_fatal(get_name(), "Dist variable is not in range 0 - 100")
		end
	endfunction
endclass: fifo_wr_transaction_item
