class fifo_write_read_test extends fifo_base_test;
    `uvm_component_utils(fifo_write_read_test)

    function new(string name = "fifo_write_read_test", uvm_component parent);
        super.new(name, parent);
    endfunction 

    int fifo_depth;
    fifo_wr_sequence wr_seq;
    fifo_rd_sequence rd_seq;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(int)::get(this, "", "fifo_depth", fifo_depth)) begin
            fifo_depth = 3;
        end
        wr_seq = fifo_wr_sequence::type_id::create("fifo_wr_sequence");
        rd_seq = fifo_rd_sequence::type_id::create("fifo_rd_sequence");
        
        wr_seq.fifo_depth = this.fifo_depth;
        rd_seq.fifo_depth = this.fifo_depth;

        if($value$plusargs("wr_en_dist=%d", wr_seq.wr_en_dist)) begin
            `uvm_info("INFO", "Using plus args wr_en_dist", UVM_LOW)
        end else begin
            `uvm_info("INFO", "Using default wr_en_dist of 80/20", UVM_LOW)
            this.wr_seq.wr_en_dist = 80;
        end

        if($value$plusargs("rd_en_dist=%d", rd_seq.rd_en_dist)) begin
            `uvm_info("INFO", "Using plus args rd_en_dist", UVM_LOW)
        end else begin
            `uvm_info("INFO", "Using default rd_en_dist of 80/20", UVM_LOW)
            this.rd_seq.rd_en_dist = 80;
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info (get_name(), $sformatf ("Hello from write-read test run phase!"), UVM_HIGH)

        phase.raise_objection(this);
        fork
            wr_seq.start(env.wr_agt.wr_seqr);
            rd_seq.start(env.rd_agt.rd_seqr);
        join
        phase.drop_objection(this);
    endtask
endclass