module Alu64
  (
    input [63:0] a,b,
    input [3:0] ALuop,
    output reg [63:0] Result,
    output reg zero
    
  );
  
  always @(*)
    begin
      case (ALuop)
        4'b0000: Result = a & b;
        4'b0001: Result = a | b;
        4'b0010: Result = a + b;
        4'b0110: Result = a - b;
        4'b1100: Result = ~(a | b); //nor
      endcase
      if (Result == 0)
        zero = 1;
      else
        zero = 0;
    end
endmodule