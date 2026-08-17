class fifo_wr_agent extends uvm_agent;
	`uvm_component_utils(fifo_wr_agent)
	
	fifo_wr_monitor wr_mon;
	fifo_wr_driver wr_drv;
	fifo_wr_sequencer wr_seqr;

	fifo_wr_agent_config cfg;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		wr_mon = fifo_wr_monitor::type_id::create("wr_mon", this);
		wr_drv = fifo_wr_driver::type_id::create("wr_drv", this);
		wr_seqr = fifo_wr_sequencer::type_id::create("wr_seqr", this);

		if (!uvm_config_db#(fifo_wr_agent_config)::get(this, "", "wr_agt_cfg", cfg)) begin
			`uvm_fatal("NOCFG","No wr agent config")
		end

		uvm_config_db#(virtual fifo_wr_if#(.DATA_WIDTH((DATA_WIDTH_P))))::set(this, "wr_mon", "wr_vif_agt", cfg.vif);
		uvm_config_db#(virtual fifo_wr_if#(.DATA_WIDTH((DATA_WIDTH_P))))::set(this, "wr_drv", "wr_vif_agt", cfg.vif);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		wr_drv.seq_item_port.connect(wr_seqr.seq_item_export);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask: run_phase
endclass: fifo_wr_agent
