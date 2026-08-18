class fifo_rd_sequence extends uvm_sequence#(fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)));
    `uvm_object_utils(fifo_rd_sequence)
    int valid_transactions;
    int rd_en_dist;
    int fifo_depth;
    fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P)) tr;

    function new(string name = "fifo_rd_sequence");
        super.new(name);
        valid_transactions = 0;
        rd_en_dist = 50;
        fifo_depth = 8;
    endfunction

    virtual task body();
        repeat(READ_COUNT_P) begin
            tr = fifo_rd_transaction_item#(.DATA_WIDTH(DATA_WIDTH_P))::type_id::create("tr");
            tr.rd_en_dist = rd_en_dist;
            start_item(tr);

            assert (tr.randomize());
            // else `uvm_error("RANDOM ERROR", "Write transaction could not be randomized.");

            finish_item(tr);
            if (tr.rd_en) valid_transactions++;
        end
    endtask
endclass