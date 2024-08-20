module top_module (
    input clk,
    input reset,
    output [9:0] q);

logic recycle;

always_ff @ (posedge clk) begin
    if (reset) begin
        q  <= 10'b0;
        recycle <= 1'b0;
    end else begin

        if (recycle) begin
            q  <= 10'b0;
            recycle <= 0;
        end else begin
            q <= 10'(q + 1); // explicit truncate to avoid Quartus warning
        end

        if (q==998) begin
            recycle <= 1;
        end
    end    
end
endmodule