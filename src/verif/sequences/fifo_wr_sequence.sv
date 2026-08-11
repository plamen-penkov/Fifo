class fifo_wr_sequence extends uvm_sequence#(fifo_wr_transaction_item#());
    `uvm_object_utils(fifo_wr_sequence)
    int valid_transactions;
    int wr_en_dist;
    int fifo_depth;
    fifo_wr_transaction_item#() tr;

    function new(string name = "fifo_wr_sequence");
        super.new(name);
        valid_transactions = 0;
        wr_en_dist = 50;
        fifo_depth = 8;
    endfunction

    virtual task body();
        forever begin
            tr = fifo_wr_transaction_item#()::type_id::create("tr");
            tr.wr_en_dist = wr_en_dist;
            start_item(tr);

            assert (tr.randomize());
            // else `uvm_error("RANDOM ERROR", "Write transaction could not be randomized.");

            finish_item(tr);
            if (tr.wr_en) valid_transactions++;
            if (fifo_depth == valid_transactions) break;

        end
    endtask
endclass