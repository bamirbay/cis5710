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

// Parametrized generate/propagate module
module gp #(
    parameter N = 4
)  // Set default parameter N to 4
(
    input wire [N-1:0] gin,
    pin,  // Adjust gin and pin according to N
    input wire cin,
    output wire gout,
    pout,
    output wire [N-2:0] cout  // Adjust cout size based on N
);

  assign pout = &pin;
  assign gout = gin[N-1] | (gin[N-2] & pin[N-1]);  // Start of dynamic gout assignment

  // Dynamically generate parts of the gout assignment based on N
  genvar i;
  generate
    for (i = N - 3; i >= 0; i = i - 1) begin : gout_loop
      if (i == 0) begin : gout_if  // Handle lowest bit separately
        assign gout = gout | (gin[i] & &pin[N-1:1]);
      end else begin : gout_else
        assign gout = gout | (gin[i] & &pin[N-1:i+1]);
      end
    end
  endgenerate

  // cout[0] remains the same as it does not depend on N
  assign cout[0] = gin[0] | (pin[0] & cin);

  // Dynamically generate cout assignments based on N
  generate
    for (i = 1; i < N - 1; i = i + 1) begin : cout_loop
      if (i == 1) begin : cout_if
        assign cout[i] = gin[i] | (pin[i] & gin[i-1]) | (&pin[i:0] & cin);
      end else begin : cout_else
        // Add more conditions as N increases
        assign cout[i] = gin[i] | (pin[i] & gin[i-1]) | (&pin[i:i-1] & gin[i-2]) | (&pin[i:0] & cin);
      end
    end
  endgenerate

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

  assign pout = &pin;
  assign gout = gin[3] | (gin[2] & pin[3]) | (gin[1] & &pin[3:2]) | (gin[0] & &pin[3:1]);

  assign cout[0] = gin[0] | (pin[0] & cin);
  assign cout[1] = gin[1] | (pin[1] & gin[0]) | (&pin[1:0] & cin);
  assign cout[2] = gin[2] | (pin[2] & gin[1]) | (&pin[2:1] & gin[0]) | (&pin[2:0] & cin);

  // gp #(4) gp4_inst (
  //    .gin(gin), 
  //    .pin(pin), 
  //    .cin(cin), 
  //    .gout(gout), 
  //    .pout(pout), 
  //    .cout(cout)
  // );

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

  // gp #(8) gp8_inst (
  //    .gin(gin), 
  //    .pin(pin), 
  //    .cin(cin), 
  //    .gout(gout), 
  //    .pout(pout), 
  //    .cout(cout)
  // );

endmodule

module cla (
    input  wire [31:0] a,
    b,
    input  wire        cin,
    output wire [31:0] sum
);

  wire [31:0] g, p;
  wire [31:0] c;

  assign c[0] = cin;

  wire gout, pout;

  wire [3:0] internal_gout, internal_pout;
  wire [2:0] internal_cin;

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin  // Create gp1 leaves
      gp1 gp1_leaf (
          .a(a[i]),
          .b(b[i]),
          .g(g[i]),
          .p(p[i])
      );
    end
  endgenerate

  gp8 gp8_block1 (
      .gin (g[7:0]),
      .pin (p[7:0]),
      .cin (cin),
      .gout(internal_gout[0]),
      .pout(internal_pout[0]),
      .cout(c[7:1])
  );

  assign internal_cin[0] = internal_gout[0] | (internal_pout[0] & cin);
  assign c[8] = internal_cin[0];

  gp8 gp8_block2 (
      .gin (g[15:8]),
      .pin (p[15:8]),
      .cin (internal_cin[0]),
      .gout(internal_gout[1]),
      .pout(internal_pout[1]),
      .cout(c[15:9])
  );

  assign internal_cin[1] = internal_gout[1] | (internal_pout[1] & (internal_gout[0] | (internal_pout[0] & cin)));
  assign c[16] = internal_cin[1];

  gp8 gp8_block3 (
      .gin (g[23:16]),
      .pin (p[23:16]),
      .cin (internal_cin[1]),
      .gout(internal_gout[2]),
      .pout(internal_pout[2]),
      .cout(c[23:17])
  );

  assign internal_cin[2] = internal_gout[2] | (internal_pout[2] & (internal_gout[1] | (internal_pout[1] & (internal_gout[0] | (internal_pout[0] & cin)))));
  assign c[24] = internal_cin[2];

  gp8 gp8_block4 (
      .gin (g[31:24]),
      .pin (p[31:24]),
      .cin (internal_cin[2]),
      .gout(internal_gout[3]),
      .pout(internal_pout[3]),
      .cout(c[31:25])
  );

  wire [2:0] cout;

  gp4 gp4_root (
      .gin (internal_gout),
      .pin (internal_pout),
      .cin (cin),
      .gout(gout),
      .pout(pout),
      .cout(cout)
  );

  assign sum = a ^ b ^ c;

endmodule
