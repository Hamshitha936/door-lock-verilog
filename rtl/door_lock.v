module door_lock(
    input clk,
    input reset,
    input [3:0] password,
    output reg door_unlock
);

parameter CORRECT_PASSWORD = 4'b1010;

always @(posedge clk or posedge reset)
begin
    if (reset)
        door_unlock <= 0;
    else if (password == CORRECT_PASSWORD)
        door_unlock <= 1;
    else
        door_unlock <= 0;
end

endmodule