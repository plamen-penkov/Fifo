class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    `uvm_analysis_imp_decl(_WR)
    `uvm_analysis_imp_decl(_RD)

    uvm_analysis_imp_WR#(fifo_wr_transaction_item, fifo_scoreboard) wr_ap_imp;
    uvm_analysis_imp_RD#(fifo_rd_transaction_item, fifo_scoreboard) rd_ap_imp;

    logic [31:0] tr_data[$];
    int wr_count;
    int rd_count;

    function new(string name = "fifo_scoreboard", uvm_component parent);
        super.new(name, parent);
        wr_count = 0;
        rd_count = 0;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        wr_ap_imp = new("wr_ap_imp", this);
        rd_ap_imp = new("rd_ap_imp", this);
    endfunction: build_phase

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(get_type_name(), $sformatf("Write transaction count: %d", wr_count), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf("Read transaction count: %d", rd_count), UVM_NONE)
    endfunction

    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);

        if(rd_count) begin
            `uvm_info(get_type_name(), "There was atleast 1 valid read transaction", UVM_NONE)
        end
    endfunction
    
    function void write_WR(fifo_wr_transaction_item tr);
        `uvm_info("SCB", $sformatf("transaction write data: %h", tr.wrdata), UVM_LOW)
        wr_count++;
        tr_data.push_back(tr.wrdata);
    endfunction
    
    logic [31:0] data;
    function void write_RD(fifo_rd_transaction_item tr);
        `uvm_info("SCB", $sformatf("transaction read data: %h", tr.rddata), UVM_LOW)
        rd_count++;
        data = tr_data.pop_front();
        if (tr.rddata != data) begin
            `uvm_error(get_type_name(), $sformatf("Mismatch. Expected: %h DUT: %h", data, tr.rddata))
        end
    endfunction
endclass