class fifo_wr_driver extends uvm_driver #(fifo_wr_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)));
	`uvm_component_utils(fifo_wr_driver)

	virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)) vif;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if (!uvm_config_db#(virtual fifo_wr_if#(.DATA_WIDTH((DATA_WIDTH_P))))::get(this, "", "wr_vif_agt", vif)) begin
			`uvm_fatal("NOVIF", "No wr vif for driver found in db");
		end
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		fifo_wr_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)) tr;

		@(negedge vif.rst_n) begin
			vif.we <= 0;
		end
	
		@(posedge vif.rst_n);

		forever begin
			seq_item_port.get_next_item(tr);

			@(posedge vif.clk && vif.rst_n);

			if (!tr.wr_en) begin
				@(posedge vif.clk);
				vif.we <= 0;
			end else begin
				@(posedge vif.clk);
				vif.we <= 1;
				vif.wrdata <= tr.wrdata;
			end
			seq_item_port.item_done();
		end
	endtask: run_phase
endclass: fifo_wr_driver
