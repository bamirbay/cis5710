`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

  // TODO: your code here

  wire [31:0] connected_dividend [0:32];
  wire [31:0] connected_remainder[0:32];
  wire [31:0] connected_quotient [0:32];

  // connect the first iteration
  assign connected_dividend[0]  = i_dividend;
  assign connected_remainder[0] = 32'b0;  // initialize remainder to 0
  assign connected_quotient[0]  = 32'b0;  // initialize quotient to 0

  genvar i;

  generate
    for (i = 0; i < 32; i = i + 1) begin
      divu_1iter d (
          .i_dividend (connected_dividend[i]),
          .i_divisor  (i_divisor),
          .i_remainder(connected_remainder[i]),
          .i_quotient (connected_quotient[i]),
          .o_dividend (connected_dividend[i+1]),
          .o_remainder(connected_remainder[i+1]),
          .o_quotient (connected_quotient[i+1])
      );
    end
  endgenerate

  assign o_remainder = connected_remainder[32];
  assign o_quotient  = connected_quotient[32];


endmodule


module divu_1iter (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    input  wire [31:0] i_remainder,
    input  wire [31:0] i_quotient,
    output wire [31:0] o_dividend,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
  /*
    for (int i = 0; i < 32; i++) {
        remainder = (remainder << 1) | ((dividend >> 31) & 0x1);
        if (remainder < divisor) {
            quotient = (quotient << 1);
        } else {
            quotient = (quotient << 1) | 0x1;
            remainder = remainder - divisor;
        }
        dividend = dividend << 1;
    }
    */

  // TODO: your code here

  wire [31:0] new_remainder = (i_remainder << 1) | ((i_dividend >> 31) & 32'h1);
  wire [31:0] new_quotient = (i_quotient << 1);
  wire [31:0] sub_output = new_remainder - i_divisor;
  wire comp_output = new_remainder < i_divisor;

  assign o_remainder = comp_output ? new_remainder : sub_output;
  assign o_quotient  = comp_output ? new_quotient : new_quotient | 32'h1;
  assign o_dividend  = i_dividend << 1;

endmodule
