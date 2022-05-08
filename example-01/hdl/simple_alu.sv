
`default_nettype none

module simple_alu (
    input  wire         clk,
    input  wire         reset_n,

    input  wire  [7:0]  a,
    input  wire  [7:0]  b,
    input  wire         op, // 0 = add, 1 = sub
    input  wire         in_vld,

    output logic [7:0]  q,
    output logic        out_vld
);


always_ff @(posedge clk) begin: proc_q
    if (!reset_n) begin
        q       <= 'd0;
        out_vld <= 1'b0;
    end else begin

        out_vld <= in_vld;

        case (op)
            1'b0: q <= a + b;
            1'b1: q <= a - b;
        endcase
    end
end

endmodule

`default_nettype wire
