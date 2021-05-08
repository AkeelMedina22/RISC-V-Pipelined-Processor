
module ThreebyOneMux
  (
    input[63:0] a,
    input[63:0] b,
    input[63:0] c,
    input [1:0] sel,
    output reg [63:0] out
  );
  always @(*)
    begin
      case(sel[1:0])
        2'b00: out = a;
        2'b01: out = b;
        2'b10: out = c;
      endcase
    end
endmodule