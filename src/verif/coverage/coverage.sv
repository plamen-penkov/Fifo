class coverage extends uvm_component;
    `uvm_component_utils(coverage);

    virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)) wr_if;
    virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)) rd_if;
    
    int we0_full0_count;
    int we0_full1_count;
    int we1_full0_count;
    int we1_full1_count;

    int re0_empty0_count;
    int re0_empty1_count;
    int re1_empty0_count;
    int re1_empty1_count;

    int we1_re1_full0_empty0_count;

    int we1_re1_full0_empty1_exist;
    int we1_re1_full1_empty0_exist;

    int went_full;
    int went_empty_after_full;
    
    covergroup cg_coverage;
        cp_we:      coverpoint wr_if.we;
        cp_re:      coverpoint rd_if.re;
        cp_wrdata:  coverpoint wr_if.wrdata;
        cp_rddata:  coverpoint rd_if.rddata;
        cp_full:    coverpoint wr_if.full;
        cp_empty:   coverpoint rd_if.empty;

        cp_we0_full0: coverpoint we0_full0_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        cp_we0_full1: coverpoint we0_full1_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }
        
        cp_we1_full0: coverpoint we1_full0_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        cp_we1_full1: coverpoint we1_full1_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        cp_re0_empty0: coverpoint re0_empty0_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        cp_re0_empty1: coverpoint re0_empty1_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        cp_re1_empty0: coverpoint re1_empty0_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        cp_re1_empty1: coverpoint re1_empty1_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        // Coverpoint to check if we try to read and write simultaneously while the FIFO is not full or empty
        cp_we1_re1_full0_empty0: coverpoint we1_re1_full0_empty0_count {
            bins b4 = {4};
            bins b8 = {8};
            bins b16 = {16};
            bins b32 = {32};
        }

        // Coverpoint to check if we try to read and write simultaneously while the FIFO is empty
        cp_we1_re_1_full0_empty1: coverpoint we1_re1_full0_empty1_exist {
            bins b1 = {1};
        }

        // Coverpoint to check if we try to read and write simultaneously while the FIFO is full
        cp_we1_re_1_full1_empty0: coverpoint we1_re1_full1_empty0_exist {
            bins b1 = {1};
        }
        
        cp_we_transitions: coverpoint wr_if.we {
            bins b1 = (1 => 1 => 1 => 0);
            bins b2 = (1 => 1 => 0 => 1);
            bins b3 = (1 => 0 => 1 => 1);
            bins b4 = (0 => 1 => 1 => 1);
        }

        cp_re_transitions: coverpoint rd_if.re {
            bins b1 = (1 => 1 => 1 => 0);
            bins b2 = (1 => 1 => 0 => 1);
            bins b3 = (1 => 0 => 1 => 1);
            bins b4 = (0 => 1 => 1 => 1);
        }

        cp_empty_after_full: coverpoint went_empty_after_full{
            bins b1 = {1};
        }
    endgroup

    function new(string name = "coverage", uvm_component parent);
        super.new(name, parent);
        cg_coverage = new();

        we1_full0_count = 0;
        we1_full1_count = 0;
        we0_full0_count = 0;
        we0_full1_count = 0;

        re0_empty0_count = 0;
        re0_empty1_count = 0;
        re1_empty0_count = 0;
        re1_empty1_count = 0;

        we1_re1_full0_empty0_count = 0;

        we1_re1_full0_empty1_exist = 0;
        we1_re1_full1_empty0_exist = 0;

        went_full = 0;
        went_empty_after_full = 0;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual fifo_wr_if#(.DATA_WIDTH(DATA_WIDTH_P)))::get(this, "", "wr_vif", wr_if)) begin
			`uvm_fatal("NOVIF", "No wr vif found in db");
		end
		
		if (!uvm_config_db#(virtual fifo_rd_if#(.DATA_WIDTH(DATA_WIDTH_P)))::get(this, "", "rd_vif", rd_if)) begin
			`uvm_fatal("NOVIF", "No rd vif found in db");
		end        
    endfunction

    bit[1:0] we_full;
    bit[1:0] re_empty;
    bit[3:0] we_re_full_empty;
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(posedge wr_if.clk);
            if (wr_if.rst_n) cg_coverage.sample();

            // Check for all write enable and full cominations to happen N cycles in a row
            we_full = {wr_if.we, wr_if.full};
            case (we_full)
                2'b00: begin
                    we0_full0_count++;
                    we0_full1_count = 0;
                    we1_full0_count = 0;
                    we1_full1_count = 0;
                end
                2'b01: begin
                    we0_full0_count = 0;
                    we0_full1_count++;
                    we1_full0_count = 0;
                    we1_full1_count = 0;
                end 
                2'b10: begin
                    we0_full0_count = 0;
                    we0_full1_count = 0;
                    we1_full0_count++;
                    we1_full1_count = 0;
                end
                2'b11: begin
                    we0_full0_count = 0;
                    we0_full1_count = 0;
                    we1_full0_count = 0;
                    we1_full1_count++;
                end
            endcase

            // Check for all read enable and empty cominations to happen N cycles in a row
            re_empty = {rd_if.re, rd_if.empty};
            case (re_empty)
                2'b00: begin
                    re0_empty0_count++;
                    re0_empty1_count = 0;
                    re1_empty0_count = 0;
                    re1_empty1_count = 0;
                end
                2'b01: begin
                    re0_empty0_count = 0;
                    re0_empty1_count++;
                    re1_empty0_count = 0;
                    re1_empty1_count = 0;
                end 
                2'b10: begin
                    re0_empty0_count = 0;
                    re0_empty1_count = 0;
                    re1_empty0_count++;
                    re1_empty1_count = 0;
                end
                2'b11: begin
                    re0_empty0_count = 0;
                    re0_empty1_count = 0;
                    re1_empty0_count = 0;
                    re1_empty1_count++;
                end
            endcase

            we_re_full_empty = {wr_if.we, rd_if.re, wr_if.full, rd_if.empty};
            case (we_re_full_empty)
                // Check for a simultaneous read and write without the FIFO being full or empty
                4'b1100: we1_re1_full0_empty0_count++;
                // Check for a simultaneous read and write while the FIFO is empty
                4'b1101: we1_re1_full0_empty1_exist++;
                // Check for a simultaneous read and write while the FIFO is full
                4'b1110: we1_re1_full1_empty0_exist++;
            endcase

            if (wr_if.full) went_full = 1;

            if (went_full && rd_if.empty) went_empty_after_full = 1;
        end
    endtask
endclass