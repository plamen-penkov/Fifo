module checker #(
    parameter ADDRESS_WIDTH = 5
) (
    input  logic clk,
    input  logic rst_n,
    input  logic wr_en,
    input  logic rd_en,
    input  logic full,
    input  logic empty,

    output logic expected_full,
    output logic expected_empty
);

    localparam int FIFO_DEPTH = 2 ** ADDRESS_WIDTH;

    // Need to represent 0 through FIFO_DEPTH
    logic [ADDRESS_WIDTH:0] transactions;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            transactions <= '0;
        end
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: transactions <= transactions + 1'b1;
                2'b01: transactions <= transactions - 1'b1;
                default: transactions <= transactions;
            endcase
        end
    end

    always_comb begin
        expected_empty = (transactions == 0);
        expected_full  = (transactions == FIFO_DEPTH);
    end

    always @(posedge clk) begin
        if (expected_empty != empty) begin
            $display(
                "EMPTY mismatch @%0t: DUT=%b EXPECTED=%b transactions=%0d",
                $time, empty, expected_empty, transactions
            );
        end

        if (expected_full != full) begin
            $display(
                "FULL mismatch @%0t: DUT=%b EXPECTED=%b transactions=%0d",
                $time, full, expected_full, transactions
            );
        end
    end

endmodule