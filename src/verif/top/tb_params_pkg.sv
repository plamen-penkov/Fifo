package tb_params_pkg;
    import uvm_pkg::*;

    `ifndef FIFO_DATA_WIDTH
        `define FIFO_DATA_WIDTH 32
    `endif

    `ifndef FIFO_ADDRESS_WIDTH
        `define FIFO_ADDRESS_WIDTH 5
    `endif

    // Assign macro values to package parameters
    parameter int DATA_WIDTH = `FIFO_DATA_WIDTH;
    parameter int ADDRESS_WIDTH = `FIFO_ADDRESS_WIDTH;
    
endpackage: tb_params_pkg