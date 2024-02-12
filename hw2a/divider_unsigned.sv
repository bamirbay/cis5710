/* INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
  logic [31:0] quotient[33], remainder[33], dividend[33];

  assign quotient[0] = 0;
  assign remainder[0] = 0;
  assign dividend[0] = i_dividend;

  genvar i;

  generate
    for (i = 0; i < 32; i = i + 1) begin
      divu_1iter f (
          .i_dividend (dividend[i]),
          .i_divisor  (i_divisor),
          .i_remainder(remainder[i]),
          .i_quotient (quotient[i]),
          .o_dividend (dividend[i + 1]),
          .o_remainder(remainder[i + 1]),
          .o_quotient (quotient[i + 1])
      );
    end
  endgenerate

  assign o_remainder = remainder[32];
  assign o_quotient  = quotient[32];
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
  logic [31:0] remainder, quotient, dividend;
  always_comb begin
    remainder = (i_remainder << 1) | ((i_dividend >> 31) & 32'b1);
    quotient  = i_quotient;
    dividend  = i_dividend;

    if (remainder < i_divisor) begin
      quotient = quotient << 1;
    end else begin
      quotient  = (quotient << 1) | 32'b1;
      remainder = remainder - i_divisor;
    end

    dividend = dividend << 1;
  end

  assign o_dividend  = dividend;
  assign o_remainder = remainder;
  assign o_quotient  = quotient;

endmodule
