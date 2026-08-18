package tb_params_pkg;
    import uvm_pkg::*;

    `ifndef FIFO_DATA_WIDTH
        `define FIFO_DATA_WIDTH 4
    `endif

    `ifndef FIFO_ADDRESS_WIDTH
        `define FIFO_ADDRESS_WIDTH 4
    `endif

    `ifndef WRITE_COUNT
        `define WRITE_COUNT 1000
    `endif

    `ifndef READ_COUNT
        `define READ_COUNT 100
    `endif

    // Assign macro values to package parameters
    parameter int DATA_WIDTH_P = `FIFO_DATA_WIDTH;
    parameter int ADDRESS_WIDTH_P = `FIFO_ADDRESS_WIDTH;
    parameter int WRITE_COUNT_P = `WRITE_COUNT;
    parameter int READ_COUNT_P = `READ_COUNT;
    
endpackage: tb_params_pkg