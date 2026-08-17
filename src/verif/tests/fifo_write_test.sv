class fifo_write_test extends fifo_base_test;
    `uvm_component_utils(fifo_write_test)

    fifo_wr_sequence seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        seq = fifo_wr_sequence::type_id::create("fifo_wr_sequence");
        if (!uvm_config_db#(int)::get(this, "", "fifo_depth", seq.fifo_depth)) begin
            seq.fifo_depth = 8;
        end

        if($value$plusargs("wr_en_dist=%d", seq.wr_en_dist)) begin
            `uvm_info("INFO", "Using plus args wr_en_dist", UVM_LOW)
        end else begin
            `uvm_info("INFO", "Using default wr_en_dist of 50/50", UVM_LOW)
            seq.wr_en_dist = 50;
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        seq.start(env.wr_agt.wr_seqr);
        phase.drop_objection(this);
    endtask
endclass