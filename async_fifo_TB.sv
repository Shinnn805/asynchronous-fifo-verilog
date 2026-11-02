`timescale 1ns/1ps

module tb;

parameter DATA_WIDTH = 8;
parameter DEPTH      = 8;


reg wclk;
reg rclk;
reg wrst_n;
reg rrst_n;

reg w_en;
reg r_en;

reg [DATA_WIDTH-1:0] data_in;

wire [DATA_WIDTH-1:0] data_out;
wire full;
wire empty;

reg [DATA_WIDTH-1:0] expected_mem [0:255];

integer wr_idx;
integer rd_idx;

integer pass;
integer fail;

reg [DATA_WIDTH-1:0] expected_data;


asynchronous_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)
dut(
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);


//write clock
initial begin
    wclk = 0;
    forever #10 wclk = ~wclk;
end

//read clock

initial begin
    rclk = 0;
    forever #35 rclk = ~rclk;
end

// Reset

initial begin

    wrst_n = 0;
    rrst_n = 0;

    w_en = 0;
    r_en = 0;

    data_in = 0;

    wr_idx = 0;
    rd_idx = 0;

    pass = 0;
    fail = 0;

    #100;

    wrst_n = 1;
    rrst_n = 1;

end

// Write Task

task fifo_write;

input [DATA_WIDTH-1:0] data;

begin

    @(negedge wclk);

    if(!full)
    begin
        data_in = data;
        w_en = 1;
    end

    @(posedge wclk);

    expected_mem[wr_idx] = data;
    wr_idx = wr_idx + 1;

    @(negedge wclk);
    w_en = 0;

end

endtask

// Read Task

task fifo_read;

begin

    @(negedge rclk);

    if(!empty)
        r_en = 1;

    @(posedge rclk);

    @(negedge rclk);
    r_en = 0;

    @(posedge rclk);

    expected_data = expected_mem[rd_idx];
    rd_idx = rd_idx + 1;

    #1;

    if(data_out == expected_data)
    begin
        $display("[%0t] PASS Expected=%0h Received=%0h",
                 $time, expected_data, data_out);
        pass = pass + 1;
    end
    else
    begin
        $display("[%0t] FAIL Expected=%0h Received=%0h",
                 $time, expected_data, data_out);
        fail = fail + 1;
    end

end

endtask

// Test Sequence

integer i;

initial begin

    wait(wrst_n);

//write 8 values
    for(i=0;i<8;i=i+1)
        fifo_write(i+8'h10);

    #200;

//read 8 values
    for(i=0;i<8;i=i+1)
        fifo_read();

    #500;

//summary
    $display("");
    $display("==============================");
    $display("PASS = %0d",pass);
    $display("FAIL = %0d",fail);
    $display("==============================");

    $finish;

end

initial begin

$monitor("T=%0t W_EN=%b R_EN=%b FULL=%b EMPTY=%b DIN=%h DOUT=%h",
          $time,w_en,r_en,full,empty,data_in,data_out);

end

endmodule


parameter DATA_WIDTH = 8;
parameter DEPTH      = 8;


reg wclk;
reg rclk;
reg wrst_n;
reg rrst_n;

reg w_en;
reg r_en;

reg [DATA_WIDTH-1:0] data_in;

wire [DATA_WIDTH-1:0] data_out;
wire full;
wire empty;


reg [DATA_WIDTH-1:0] expected_mem [0:255];

integer wr_idx;
integer rd_idx;

integer pass;
integer fail;

reg [DATA_WIDTH-1:0] expected_data;


asynchronous_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)
dut(
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);


initial begin
    wclk = 0;
    forever #10 wclk = ~wclk;
end



initial begin
    rclk = 0;
    forever #35 rclk = ~rclk;
end


//reset
initial begin

    wrst_n = 0;
    rrst_n = 0;

    w_en = 0;
    r_en = 0;

    data_in = 0;

    wr_idx = 0;
    rd_idx = 0;

    pass = 0;
    fail = 0;

    #100;

    wrst_n = 1;
    rrst_n = 1;

end

//write task
task fifo_write;

input [DATA_WIDTH-1:0] data;

begin

    @(negedge wclk);

    if(!full)
    begin
        data_in = data;
        w_en = 1;
    end

    @(posedge wclk);

    expected_mem[wr_idx] = data;
    wr_idx = wr_idx + 1;

    @(negedge wclk);
    w_en = 0;

end

endtask

//read task
task fifo_read;

begin

    @(negedge rclk);

    if(!empty)
        r_en = 1;

    @(posedge rclk);

    @(negedge rclk);
    r_en = 0;

    // Wait for synchronous RAM output
    @(posedge rclk);

    expected_data = expected_mem[rd_idx];
    rd_idx = rd_idx + 1;

    #1;

    if(data_out == expected_data)
    begin
        $display("[%0t] PASS Expected=%0h Received=%0h",
                 $time, expected_data, data_out);
        pass = pass + 1;
    end
    else
    begin
        $display("[%0t] FAIL Expected=%0h Received=%0h",
                 $time, expected_data, data_out);
        fail = fail + 1;
    end

end

endtask


integer i;

initial begin

    wait(wrst_n);


    for(i=0;i<8;i=i+1)
        fifo_write(i+8'h10);

    #200;


    for(i=0;i<8;i=i+1)
        fifo_read();

    #500;


    $display("");
    $display("==============================");
    $display("PASS = %0d",pass);
    $display("FAIL = %0d",fail);
    $display("==============================");

    $finish;

end


initial begin

$monitor("T=%0t W_EN=%b R_EN=%b FULL=%b EMPTY=%b DIN=%h DOUT=%h",
          $time,w_en,r_en,full,empty,data_in,data_out);

end

endmodule
