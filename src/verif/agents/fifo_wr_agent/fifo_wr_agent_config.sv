class fifo_wr_agent_config extends uvm_object;
    `uvm_object_utils(fifo_wr_agent_config)

    virtual fifo_wr_if#(32) vif;

    function new(string name = "wr_agt_cfg");
        super.new(name);
    endfunction
endclass