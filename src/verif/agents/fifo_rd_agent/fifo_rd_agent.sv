class fifo_rd_agent extends uvm_agent;
	`uvm_component_utils(fifo_rd_agent)
	
	fifo_rd_monitor rd_mon;
	fifo_rd_driver rd_drv;
	fifo_rd_sequencer rd_seqr;

	fifo_rd_agent_config cfg;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		rd_mon = fifo_rd_monitor::type_id::create("rd_mon", this);
		rd_drv = fifo_rd_driver::type_id::create("rd_drv", this);
		rd_seqr = fifo_rd_sequencer::type_id::create("rd_seqr", this);

		if (!uvm_config_db#(fifo_rd_agent_config)::get(this, "", "rd_agt_cfg", cfg)) begin
			`uvm_fatal("NOVIF","No rd agent config")
		end

		uvm_config_db#(virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)))::set(this, "rd_mon", "rd_vif_agt", cfg.vif);
		uvm_config_db#(virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)))::set(this, "rd_drv", "rd_vif_agt", cfg.vif);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask: run_phase
endclass: fifo_rd_agent
