class fifo_rd_driver extends uvm_driver#(fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)));
	`uvm_component_utils(fifo_rd_driver)

	virtual fifo_rd_if#(.DATA_WIDTH((DATA_WIDTH_P))) vif;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(virtual fifo_rd_if#(.DATA_WIDTH((DATA_WIDTH_P))))::get(this, "", "rd_vif_agt", vif)) begin
			`uvm_fatal("NOVIF", "No rd vif for driver found in db");
		end
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)) tr;

		vif.re <= 0;
		@(posedge vif.rst_n);

		forever begin
			seq_item_port.get_next_item(tr);
			
			if (tr.rd_en && !tr.empty) begin
				vif.re <= 1;
			end else begin
				vif.re <= 0;
			end

			@(posedge vif.clk);

			vif.re <= 0;

			seq_item_port.item_done();
		end
	endtask: run_phase
endclass: fifo_rd_driver
