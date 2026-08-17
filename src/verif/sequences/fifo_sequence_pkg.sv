package fifo_sequence_pkg;
    import uvm_pkg::*;
    import tb_params_pkg::*;
    import fifo_wr_agent_pkg::*;
    import fifo_rd_agent_pkg::*;
    `include "fifo_wr_sequence.sv";
    `include "fifo_rd_sequence.sv";
endpackage