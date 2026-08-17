class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)
	
	fifo_wr_agent wr_agt;
	fifo_rd_agent rd_agt;

	fifo_rd_agent_config rd_agt_cfg;
	fifo_wr_agent_config wr_agt_cfg;
	fifo_env_config env_cfg;

	fifo_scoreboard scb;

	coverage cov;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		wr_agt = fifo_wr_agent::type_id::create("wr_agt", this);
		rd_agt = fifo_rd_agent::type_id::create("rd_agt", this);

		if (!uvm_config_db#(fifo_env_config)::get(this, "", "env_cfg", env_cfg)) begin
			`uvm_fatal("NOVIF", "no env config found in db")
		end

		uvm_config_db#(fifo_wr_agent_config)::set(this, "wr_agt", "wr_agt_cfg", env_cfg.wr_agt_cfg);
		uvm_config_db#(fifo_rd_agent_config)::set(this, "rd_agt", "rd_agt_cfg", env_cfg.rd_agt_cfg);

		cov = coverage::type_id::create("coverage", this);

		uvm_config_db #(virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)))::set(this, "coverage", "wr_vif", env_cfg.wr_agt_cfg.vif);
		uvm_config_db #(virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)))::set(this, "coverage", "rd_vif", env_cfg.rd_agt_cfg.vif);

		scb = fifo_scoreboard::type_id::create("scb", this);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		wr_agt.wr_mon.wr_mon_ap.connect(scb.wr_ap_imp);
		rd_agt.rd_mon.rd_mon_ap.connect(scb.rd_ap_imp);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask: run_phase
endclass: fifo_env
