class fifo_wr_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_wr_monitor)

	virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)) vif;
	uvm_analysis_port #(fifo_wr_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P))) wr_mon_ap;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		wr_mon_ap = new("wr_mon_ap", this);

		if (!uvm_config_db#(virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)))::get(this, "", "wr_vif_agt", vif)) begin
			`uvm_error(get_type_name(), "Didn't get handle to virtual interface wr_if!");
		end
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		fifo_wr_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)) tr;

		@(negedge vif.rst_n);
		@(posedge vif.rst_n);

		forever begin
			@(posedge vif.clk && vif.rst_n);
			if (vif.we) begin
				tr = fifo_wr_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P))::type_id::create("tr");
				tr.wr_en = vif.we;
				tr.wrdata = vif.wrdata;
				tr.full = vif.full;

				wr_mon_ap.write(tr);
			end
		end
	endtask: run_phase
endclass: fifo_wr_monitor
