class fifo_rd_sequencer extends uvm_sequencer #(fifo_rd_transaction_item);
	`uvm_component_utils(fifo_rd_sequencer)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info (get_name(), $sformatf("Hello from read sequencer build phase!"), UVM_HIGH)
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info (get_name(), $sformatf("Hello from read sequencer connect phase!"), UVM_HIGH)
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info (get_name(), $sformatf("Hello from read sequencer run phase!"), UVM_HIGH)
	endtask: run_phase
endclass: fifo_rd_sequencer
