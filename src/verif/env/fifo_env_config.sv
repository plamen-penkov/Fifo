class fifo_env_config extends uvm_object;
    `uvm_object_utils(fifo_env_config)

    fifo_rd_agent_config rd_agt_cfg;
    fifo_wr_agent_config wr_agt_cfg;

    function new(string name = "env_cfg");
        super.new(name);
    endfunction
endclass