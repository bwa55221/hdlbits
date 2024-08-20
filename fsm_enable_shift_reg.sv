/*
As part of the FSM for controlling the shift register, 
we want the ability to enable the shift register for exactly 4 clock cycles whenever
the proper bit pattern is detected. We handle sequence detection in Exams/review2015_fsmseq,
so this portion of the FSM only handles enabling the shift register for 4 cycles.

Whenever the FSM is reset, assert shift_ena for 4 cycles, then 0 forever (until reset).
*/
module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);

typedef enum {RESET, ENABLE, WAIT} state_t;

state_t state, next_state;
logic [1:0] count;
logic reset_q, reset_rising_edge;

assign reset_rising_edge = ~reset_q & reset;

always_ff @ (posedge clk) begin

    reset_q <= reset;

    if (reset) begin
        state   <= RESET;
    end else begin
        state   <= next_state;
    end
end

always_comb begin
    case (state) 
    RESET: begin
        next_state <= ENABLE;
    end

    ENABLE: begin
        if (count == 2'b0) begin
            next_state <= WAIT;
        end else begin
            next_state <= ENABLE;
        end
    end

    WAIT: begin
        next_state <= WAIT;
    end

    endcase
end

// clock cycle counter
always_ff @ (posedge clk) begin
    if (reset) begin
        count           <= 2'b11;
    end else begin
        if (reset_rising_edge | (state == ENABLE)) begin
            count       <= count - 1'b1;
        end
    end
end

// output control
always_comb begin
    if (reset_rising_edge | next_state == ENABLE) begin
        shift_ena <= 1'b1;
    end else begin
        shift_ena <= 1'b0;
    end
end

endmodule