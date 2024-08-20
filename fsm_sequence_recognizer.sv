/*
Build a finite-state machine that searches for the sequence 1101 in an input bit stream.
When the sequence is found, it should set start_shifting to 1, forever, until reset.
Getting stuck in the final state is intended to model going to other states in a bigger FSM 
that is not yet implemented.
*/

module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);

typedef enum  {RESET, SCAN, SHIFT} state_t;
logic [3:0] collection;


// state machine
state_t state, next_state;
always_ff @ (posedge clk) begin
    if (reset) begin
        state <= RESET;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state) 
    RESET: begin
        next_state          <= SCAN;
    end

    SCAN: begin
        if (collection == 4'b1101) begin
            next_state      <= SHIFT;
        end else begin
            next_state      <= SCAN;
        end
    end

    SHIFT: begin
        next_state          <= SHIFT;
    end
    endcase
end


// shift register
always_ff @ (posedge clk) begin
    if (reset) begin
        collection <= 4'b0;
    end else begin
        collection <= collection << 1;
        collection[0] <= data;
    end
end

// output control
always_comb begin
    if (state == SCAN & (collection == 4'b1101)) begin
        start_shifting  <= 1'b1;
    end else if (state == SHIFT) begin
        start_shifting  <= 1'b1;
    end else begin
        start_shifting  <= 1'b0;
    end
end

endmodule
