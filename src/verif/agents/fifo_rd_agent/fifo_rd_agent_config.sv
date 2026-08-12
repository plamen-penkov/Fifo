class fifo_rd_agent_config extends uvm_object;
    `uvm_object_utils(fifo_rd_agent_config)

    virtual fifo_rd_if#(.DATA_WIDTH((DATA_WIDTH))) vif;

    function new(string name = "rd_agt_cfg");
        super.new(name);
    endfunction
endclass