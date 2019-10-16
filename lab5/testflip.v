// T flip flop; if t is not set, q remains the same
// if t is set at next posedge of clock, q will flip.
// q is the output signal
module tflipf(input clk, input clr, input t, output reg q);
    always @(posedge clk, negedge clr) begin
        if (~clr)
            q <= 0;
        else
            q <= t ^ q;
    end
endmodule

