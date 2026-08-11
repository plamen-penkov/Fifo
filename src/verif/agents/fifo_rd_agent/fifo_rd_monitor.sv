class fifo_rd_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_rd_monitor)

	virtual fifo_rd_if vif;
	uvm_analysis_port #(fifo_rd_transaction_item) rd_mon_ap;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info (get_name(), $sformatf("Hello from read monitor build phase!"), UVM_HIGH)

		rd_mon_ap = new("rd_mon_ap", this);

		if (!uvm_config_db#(virtual fifo_rd_if#(32))::get(this, "", "rd_vif_agt", vif)) begin
			`uvm_fatal("NOVIF", "No rd vif for monitor found in db");
		end
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info (get_name(), $sformatf("Hello from read monitor connect phase!"), UVM_HIGH)
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		fifo_rd_transaction_item#() tr;

		@(negedge vif.rst_n) begin
			vif.re_delay <= 0;
			vif.empty_delay <= 0;
		end
		@(posedge vif.rst_n);
		
		forever begin
			@(posedge vif.clk && vif.rst_n);
			if (vif.re_delay && !vif.empty_delay) begin
				tr = fifo_rd_transaction_item#()::type_id::create("tr");
				tr.rd_en = vif.re_delay;
				tr.rddata = vif.rddata;
				tr.empty = vif.empty_delay;

				rd_mon_ap.write(tr);
				`uvm_info(get_name(), $sformatf("\ntr.rd_en: %d\ntr.rddata: %h\ntr.empty: %d", tr.rd_en, tr.rddata, tr.empty), UVM_HIGH)
			end
			vif.re_delay <= vif.re;
			vif.empty_delay <= vif.empty;
		end
	endtask: run_phase
endclass: fifo_rd_monitor
