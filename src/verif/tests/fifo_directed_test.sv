class fifo_directed_test extends fifo_base_test;
    `uvm_component_utils(fifo_directed_test)

    function new(string name = "fifo_directed_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    fifo_wr_sequence wr_seq;
    fifo_rd_sequence rd_seq;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        wr_seq = fifo_wr_sequence::type_id::create("wr_seq", this);
        rd_seq = fifo_rd_sequence::type_id::create("rd_seq", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);
        for(int i = 0; i <= 1; i++) begin
            case (i)
                0: begin
                    wr_seq.wr_en_dist = 100;
                    rd_seq.rd_en_dist = 1;
                end
                1: begin
                    wr_seq.wr_en_dist = 1;
                    rd_seq.rd_en_dist = 100;
                end
            endcase
            fork
                wr_seq.start(env.wr_agt.wr_seqr);
                rd_seq.start(env.rd_agt.rd_seqr);
            join
        end
        phase.drop_objection(this);
    endtask
endclass