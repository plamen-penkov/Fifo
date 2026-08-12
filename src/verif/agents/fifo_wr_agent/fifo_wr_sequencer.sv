class fifo_wr_sequencer extends uvm_sequencer #(fifo_wr_transaction_item#());
	`uvm_component_utils(fifo_wr_sequencer)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask: run_phase
endclass: fifo_wr_sequencer
