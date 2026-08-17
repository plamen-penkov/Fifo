class fifo_rd_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_rd_monitor)

	virtual fifo_rd_if#(.DATA_WIDTH((DATA_WIDTH_P))) vif;
	uvm_analysis_port #(fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P))) rd_mon_ap;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		rd_mon_ap = new("rd_mon_ap", this);

		if (!uvm_config_db#(virtual fifo_rd_if#(.DATA_WIDTH((DATA_WIDTH_P))))::get(this, "", "rd_vif_agt", vif)) begin
			`uvm_fatal("NOVIF", "No rd vif for monitor found in db");
		end
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)) tr;

		@(negedge vif.rst_n) begin
			vif.re_delay <= 0;
			vif.empty_delay <= 0;
		end
		@(posedge vif.rst_n);
		
		forever begin
			@(posedge vif.clk && vif.rst_n);
			if (vif.re_delay && !vif.empty_delay) begin
				tr = fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P))::type_id::create("tr");
				tr.rd_en = vif.re_delay;
				tr.rddata = vif.rddata;
				tr.empty = vif.empty_delay;

				rd_mon_ap.write(tr);
			end
			vif.re_delay <= vif.re;
			vif.empty_delay <= vif.empty;
		end
	endtask: run_phase
endclass: fifo_rd_monitor
