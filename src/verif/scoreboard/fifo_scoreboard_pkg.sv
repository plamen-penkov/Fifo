package fifo_scoreboard_pkg;
    import uvm_pkg::*;
    import tb_params_pkg::DATA_WIDTH;
    `include "uvm_macros.svh"
    import fifo_wr_agent_pkg::fifo_wr_transaction_item;
    import fifo_rd_agent_pkg::fifo_rd_transaction_item;
    `include "fifo_scoreboard.sv";
endpackage