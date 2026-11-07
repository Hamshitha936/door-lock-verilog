module tb_door_lock;

reg clk;
reg reset;
reg [3:0] password;
wire door_unlock;
integer i;
integer pass_count;
integer fail_count;

door_lock uut(
    .clk(clk),
    .reset(reset),
    .password(password),
    .door_unlock(door_unlock)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_door_lock);

    pass_count = 0;
    fail_count = 0;

    // Test 1: reset holds the door locked
    reset = 1;
    password = 4'b1010;
    #12;
    if (door_unlock === 1'b0) pass_count = pass_count + 1;
    else begin fail_count = fail_count + 1; $display("FAIL: reset"); end

    reset = 0;

    // Test 2: try all 16 passwords, only 1010 may unlock
    for (i = 0; i < 16; i = i + 1) begin
        password = i[3:0];
        @(posedge clk);
        #1;
        if (door_unlock === (password == 4'b1010)) begin
            pass_count = pass_count + 1;
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: password=%b door_unlock=%b", password, door_unlock);
        end
    end

    // Test 3: reset while unlocked must lock the door
    password = 4'b1010;
    @(posedge clk);
    #1;
    reset = 1;
    #1;
    if (door_unlock === 1'b0) pass_count = pass_count + 1;
    else begin fail_count = fail_count + 1; $display("FAIL: reset while unlocked"); end

    $display("DONE: %0d checks passed, %0d failed", pass_count, fail_count);
    $finish;
end

endmodule