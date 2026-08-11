module fifo #(
    parameter ADDRESS_WIDTH = 3,
    parameter DATA_WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire we,
    input wire re,
    input wire [DATA_WIDTH - 1 : 0] wrdata,
    output reg [DATA_WIDTH - 1 : 0] rddata,
    output reg full,
    output reg empty
);

    /*
    wrptr and rdptr are 1 bit bigger than the addresses

    full when wrptr MSB != rdptr MSB and wrptr ADDR == rdptr ADDR
    full = no write
    
    empty when wrptr == rdptr
    empty = no read

    on write increase wrptr
    on read increase rdptr

    write when we = 1 and not full
    read when re = 1 and not empty
    */
    
    reg [ADDRESS_WIDTH : 0] wrptr;
    reg [ADDRESS_WIDTH : 0] rdptr;

    always @ (posedge clk) begin
        if (~rst_n) begin
            wrptr <= 0;
        end else begin
            if (we && !full) begin 
                wrptr <= wrptr + 1'b1;
            end
        end
    end

    always @ (posedge clk) begin
        if (~rst_n) begin
            rdptr <= 0;
        end else begin
            if (re && !empty) begin
                rdptr <= rdptr + 1'b1;
            end
        end
    end

    always @ (*) begin    
        if (wrptr == rdptr) begin
            empty = 1'b1;
        end else begin
            empty = 1'b0;
        end
    end

    always @ (*) begin
        if (wrptr[ADDRESS_WIDTH] != rdptr[ADDRESS_WIDTH] && wrptr[ADDRESS_WIDTH - 1 : 0] == rdptr[ADDRESS_WIDTH - 1 : 0]) begin
            full = 1'b1;
        end else begin
            full = 1'b0;
        end
    end


    wire [DATA_WIDTH - 1 : 0] rdata0_not_used;
    wire [DATA_WIDTH - 1 : 0] wdata1_not_used;
    wire const_zero;
    assign const_zero = 1'b0;

    register_array #(
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) my_memory(
        .clk(clk),
        .we0(we && !full),
        .addr0(wrptr[ADDRESS_WIDTH-1:0]),
        .wdata0(wrdata),
        .rdata0(rdata0_not_used),
        .we1(const_zero),
        .addr1(rdptr[ADDRESS_WIDTH-1:0]),
        .wdata1(wdata1_not_used),
        .rdata1(rddata)
    );
    
    // dual_port_sync_memory #(
    //     .ADDRESS_WIDTH(ADDRESS_WIDTH),
    //     .DATA_WIDTH(DATA_WIDTH)
    // ) my_memory(
    //     .clk(clk),
    //     .we0(we && !full),
    //     .addr0(wrptr[ADDRESS_WIDTH-1:0]),
    //     .wdata0(wrdata),
    //     .rdata0(rdata0_not_used),
    //     .we1(const_zero),
    //     .addr1(rdptr[ADDRESS_WIDTH-1:0]),
    //     .wdata1(wdata1_not_used),
    //     .rdata1(rddata)
    // );
endmodule
