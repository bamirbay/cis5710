`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1 (
    input  wire a,
    b,
    output wire g,
    p
);
  assign g = a & b;
  assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4 (
    input wire [3:0] gin,
    pin,
    input wire cin,
    output wire gout,
    pout,
    output wire [2:0] cout
);
  assign cout[0] = gin[0] | (pin[0] & cin);
  assign cout[1] = gin[1] | (pin[1] & gin[0]) | (&pin[1:0] & cin);
  assign cout[2] = gin[2] | (pin[2] & gin[1]) | (&pin[2:1] & gin[0]) | (&pin[2:0] & cin);

  assign gout = gin[3] | (pin[3] & gin[2]) | (&pin[3:2] & gin[1]) | (&pin[3:1] & gin[0]);
  assign pout = (&pin);
endmodule

/** Same as gp4 but for an 8-bit window instead */
module gp8 (
    input wire [7:0] gin,
    pin,
    input wire cin,
    output wire gout,
    pout,
    output wire [6:0] cout
);
  assign cout[0] = gin[0] | (pin[0] & cin);
  assign cout[1] = gin[1] | (pin[1] & gin[0]) | (&pin[1:0] & cin);
  assign cout[2] = gin[2] | (pin[2] & gin[1]) | (&pin[2:1] & gin[0]) | (&pin[2:0] & cin);
  assign cout[3] = gin[3] | (pin[3] & gin[2]) | (&pin[3:2] & gin[1]) | (&pin[3:1] & gin[0])
  | (&pin[3:0] & cin);
  assign cout[4] = gin[4] | (pin[4] & gin[3]) | (&pin[4:3] & gin[2]) | (&pin[4:2] & gin[1])
  | (&pin[4:1] & gin[0]) | (&pin[4:0] & cin);
  assign cout[5] = gin[5] | (pin[5] & gin[4]) | (&pin[5:4] & gin[3]) | (&pin[5:3] & gin[2])
  | (&pin[5:2] & gin[1]) | (&pin[5:1] & gin[0]) | (&pin[5:0] & cin);
  assign cout[6] = gin[6] | (pin[6] & gin[5]) | (&pin[6:5] & gin[4]) | (&pin[6:4] & gin[3])
  | (&pin[6:3] & gin[2]) | (&pin[6:2] & gin[1]) | (&pin[6:1] & gin[0]) | (&pin[6:0] & cin);

  assign gout = gin[7] | (pin[7] & gin[6]) | (&pin[7:6] & gin[5]) | (&pin[7:5] & gin[4])
  | (&pin[7:4] & gin[3]) | (&pin[7:3] & gin[2]) | (&pin[7:2] & gin[1]) | (&pin[7:1] & gin[0]);
  assign pout = &pin;
endmodule

module cla (
    input  wire [31:0] a,
    b,
    input  wire        cin,
    output wire [31:0] sum
);

  // TODO: your code here

endmodule
