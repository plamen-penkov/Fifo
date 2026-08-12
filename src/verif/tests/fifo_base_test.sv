class fifo_base_test extends uvm_test;
	`uvm_component_utils(fifo_base_test)

	fifo_rd_agent_config rd_agt_cfg;
    fifo_wr_agent_config wr_agt_cfg;

	fifo_env_config env_cfg;	

	fifo_env env;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		wr_agt_cfg = fifo_wr_agent_config::type_id::create("wr_agt_cfg");
		rd_agt_cfg = fifo_rd_agent_config::type_id::create("rd_agt_cfg");
		env_cfg = fifo_env_config::type_id::create("env_cfg");
		
		if (!uvm_config_db#(virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH)))::get(this, "fifo_base_test", "wr_vif", wr_agt_cfg.vif)) begin
			`uvm_fatal("NOVIF", "No wr vif found in db");
		end
		
		if (!uvm_config_db#(virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH)))::get(this, "fifo_base_test", "rd_vif", rd_agt_cfg.vif)) begin
			`uvm_fatal("NOVIF", "No rd vif found in db");
		end

		env_cfg.rd_agt_cfg = rd_agt_cfg;
		env_cfg.wr_agt_cfg = wr_agt_cfg;

		uvm_config_db#(fifo_env_config)::set(this, "my_fifo_env", "env_cfg", env_cfg);
		
		env = fifo_env::type_id::create("my_fifo_env", this);
	endfunction

	virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);
	endtask
endclass: fifo_base_test
