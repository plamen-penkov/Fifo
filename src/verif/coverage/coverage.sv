class coverage extends uvm_component;
    `uvm_component_utils(coverage);

    virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)) wr_if;
    virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)) rd_if;
    
    covergroup cg_coverage;
        coverpoint wr_if.we;
        coverpoint rd_if.re;
        coverpoint wr_if.wrdata;
        coverpoint rd_if.rddata;
        coverpoint wr_if.full;
        coverpoint rd_if.empty;
    endgroup

    function new(string name = "coverage", uvm_component parent);
        super.new(name, parent);
        cg_coverage = new();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)))::get(this, "", "wr_vif", wr_if)) begin
			`uvm_fatal("NOVIF", "No wr vif found in db");
		end
		
		if (!uvm_config_db#(virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)))::get(this, "", "rd_vif", rd_if)) begin
			`uvm_fatal("NOVIF", "No rd vif found in db");
		end        
    endfunction

    virtual task run_phase(uvm_phase phase );
        super.run_phase(phase);
        forever begin
            @(posedge wr_if.clk);
            if (wr_if.rst_n) cg_coverage.sample();
        end
    endtask
endclass