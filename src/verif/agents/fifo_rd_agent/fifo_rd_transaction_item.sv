class fifo_rd_transaction_item #(
	parameter DATA_WIDTH = 32
) extends uvm_sequence_item;
	rand bit rd_en;
	bit [DATA_WIDTH-1:0] rddata;
	bit empty;
	int rd_en_dist;
	
	`uvm_object_utils_begin(fifo_rd_transaction_item#(DATA_WIDTH))
		`uvm_field_int(rd_en, UVM_ALL_ON)
		`uvm_field_int(rddata, UVM_ALL_ON)
		`uvm_field_int(empty, UVM_ALL_ON)
		`uvm_field_int(rd_en_dist, UVM_ALL_ON)
	`uvm_object_utils_end

	function new (string name = "fifo_rd_transaction_item");
		super.new(name);
	endfunction

	constraint rd_en_c_dist {
		rd_en dist {
			0 := 100 - rd_en_dist,
			1 := rd_en_dist
		};
	}

	function void post_randomize();
		if (rd_en_dist < 0 || 100 < rd_en_dist) begin
			`uvm_fatal(get_name(), "Dist variable is not in range 0 - 100")
		end
	endfunction
endclass: fifo_rd_transaction_item
